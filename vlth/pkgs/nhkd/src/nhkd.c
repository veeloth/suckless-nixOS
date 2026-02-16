#include <inttypes.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <X11/keysym.h>
#include <X11/XKBlib.h>
#include <X11/Xlib.h>
#include <X11/Xproto.h>


Display *dpy;
Window root;
int screen;
unsigned int numlockmask = 0;
unsigned int mouse_now_button = 0, mouse_now_state = 0;
uint32_t mouse_motion_counter = 0;
int (*xerrorxlib)(Display *, XErrorEvent *);


enum MouseInfo
{
    AppendMouseInfo,
    IgnoreMouseInfo,
};

struct MouseEvent
{
    int event_type;
    unsigned int modifier;
    unsigned int button;
    enum MouseInfo mouse_info;
    char *command;
};

struct KeyEvent
{
    int event_type;
    unsigned int modifier;
    KeySym keysym;
    char *command;
};


#include "config.h"


int
xerror(Display *dpy, XErrorEvent *ee)
{
    if ((ee->request_code == X_GrabButton && ee->error_code == BadAccess) ||
        (ee->request_code == X_GrabKey && ee->error_code == BadAccess))
        return 0;

    return xerrorxlib(dpy, ee);
}

void
spawn(char *command)
{
    if (debug_print_spawned_command)
        fprintf(stderr, "nhkd: spawn [%s]\n", command);

    if (fork() == 0)
    {
        if (fork() == 0)
        {
            close(ConnectionNumber(dpy));
            setsid();

            /* Quoting from "man 3p exec":
             *
             * "If the SIGCHLD signal is set to be ignored by the
             * calling process image, it is unspecified whether the
             * SIGCHLD signal is set to be ignored or to the default
             * action in the new process image."
             *
             * To avoid this undefined behaviour, we reset the handler
             * now. Yes, this has caused real issues, at least on some
             * systems (e.g., programs that we launched were expecting
             * to get SIGCHLD for other programs that *they* launched,
             * but those signals never happened, and so all kinds of
             * crazy stuff went down, like Python just assuming an exit
             * code of 0). */
            signal(SIGCHLD, SIG_DFL);

            execl("/bin/sh", "sh", "-c", command, (char *)NULL);
            exit(EXIT_FAILURE);
        }
        else
            exit(EXIT_SUCCESS);
    }
}

void
updatenumlockmask(void)
{
    size_t i, j, max_keypermod;
    XModifierKeymap *modmap;

    modmap = XGetModifierMapping(dpy);
    if (modmap == NULL || modmap->max_keypermod < 0)
        return;

    max_keypermod = modmap->max_keypermod;

    numlockmask = 0;
    for (i = 0; i < 8; i++)
    {
        for (j = 0; j < max_keypermod; j++)
        {
            if (modmap->modifiermap[i * max_keypermod + j] ==
                XKeysymToKeycode(dpy, XK_Num_Lock))
            {
                numlockmask = (1 << i);
            }
        }
    }
    XFreeModifiermap(modmap);
}

void
grabkeys(void)
{
    KeyCode code;
    size_t ia, im;
    unsigned int mousemask = ButtonPressMask | ButtonReleaseMask |
                             PointerMotionMask;

    XUngrabKey(dpy, AnyKey, AnyModifier, root);

    /* New scope to be able to create "modifiers" with updated
     * "numlockmask". */
    updatenumlockmask();
    {
        unsigned int modifiers[] = {
            0, LockMask, numlockmask, numlockmask | LockMask
        };

        for (ia = 0; ia < sizeof mouse_events / sizeof (struct MouseEvent); ia++)
        {
            for (im = 0; im < sizeof modifiers / sizeof modifiers[0]; im++)
            {
                XGrabButton(dpy, mouse_events[ia].button,
                            mouse_events[ia].modifier | modifiers[im], root,
                            False, mousemask, GrabModeAsync, GrabModeAsync,
                            None, None);
            }
        }

        for (ia = 0; ia < sizeof key_events / sizeof (struct KeyEvent); ia++)
        {
            if ((code = XKeysymToKeycode(dpy, key_events[ia].keysym)))
            {
                for (im = 0; im < sizeof modifiers / sizeof modifiers[0]; im++)
                {
                    XGrabKey(dpy, code, key_events[ia].modifier | modifiers[im],
                             root, True, GrabModeAsync, GrabModeAsync);
                }
            }
        }
    }
}

unsigned long
cleanmask(unsigned long mask)
{
    return mask & ~(numlockmask | LockMask) &
           (ShiftMask | ControlMask | Mod1Mask | Mod2Mask | Mod3Mask |
            Mod4Mask | Mod5Mask);
}

void
keyboard(XEvent *e)
{
    size_t ia;
    KeySym keysym;
    XKeyEvent *ev = &e->xkey;

    keysym = XkbKeycodeToKeysym(dpy, ev->keycode, 0, 0);
    for (ia = 0; ia < sizeof key_events / sizeof (struct KeyEvent); ia++)
    {
        if (key_events[ia].event_type == e->type &&
            key_events[ia].keysym == keysym &&
            cleanmask(key_events[ia].modifier) == cleanmask(ev->state))
        {
            spawn(key_events[ia].command);
        }
    }
}

void
mouse_button(XEvent *e)
{
    size_t ia;
    XButtonEvent *ev = &e->xbutton;
    int x, y;
    char cmd_buf[8192] = "", *cmd_use;

    mouse_now_button = ev->button;
    mouse_now_state = ev->state;
    mouse_motion_counter = 0;

    x = ev->x_root;
    y = ev->y_root;

    for (ia = 0; ia < sizeof mouse_events / sizeof (struct MouseEvent); ia++)
    {
        if (mouse_events[ia].event_type == e->type &&
            mouse_events[ia].button == mouse_now_button &&
            cleanmask(mouse_events[ia].modifier) == cleanmask(mouse_now_state))
        {
            if (mouse_events[ia].mouse_info == AppendMouseInfo)
            {
                snprintf(cmd_buf, sizeof cmd_buf, "%s %d %d %lu",
                         mouse_events[ia].command, x, y, ev->subwindow);
                cmd_use = cmd_buf;
            }
            else
                cmd_use = mouse_events[ia].command;
            spawn(cmd_use);
        }
    }
}

void
mouse_motion(XEvent *e)
{
    size_t ia;
    XMotionEvent *ev = &e->xmotion;
    int x, y;
    char cmd_buf[8192] = "", *cmd_use;

    x = ev->x_root;
    y = ev->y_root;
    mouse_motion_counter++;

    for (ia = 0; ia < sizeof mouse_events / sizeof (struct MouseEvent); ia++)
    {
        if (mouse_events[ia].event_type == e->type &&
            mouse_events[ia].button == mouse_now_button &&
            cleanmask(mouse_events[ia].modifier) == cleanmask(mouse_now_state))
        {
            if (mouse_events[ia].mouse_info == AppendMouseInfo)
            {
                snprintf(cmd_buf, sizeof cmd_buf, "%s %d %d %lu %"PRIu32,
                         mouse_events[ia].command,
                         x, y, ev->subwindow, mouse_motion_counter);
                cmd_use = cmd_buf;
            }
            else
                cmd_use = mouse_events[ia].command;
            spawn(cmd_use);
        }
    }
}

int
main(int argc, char **argv)
{
    int di = 0, xkbmajor = XkbMajorVersion, xkbminor = XkbMinorVersion;
    XEvent ev;

    (void)argc;
    (void)argv;

    signal(SIGCHLD, SIG_IGN);

    dpy = XOpenDisplay(NULL);
    if (!dpy)
    {
        fprintf(stderr, "nhkd: Cannot open display\n");
        exit(EXIT_FAILURE);
    }

    screen = DefaultScreen(dpy);
    root = RootWindow(dpy, screen);
    xerrorxlib = XSetErrorHandler(xerror);

    if (!XkbQueryExtension(dpy, &di, &di, &di, &xkbmajor, &xkbminor))
    {
        fprintf(stderr, "nhkd: XKB not available. Please report this! "
                        "What does your setup look like?\n");
        exit(EXIT_FAILURE);
    }

    grabkeys();

    for (;;)
    {
        XNextEvent(dpy, &ev);
        switch (ev.type)
        {
            case ButtonPress:
            case ButtonRelease:
                mouse_button(&ev);
                break;
            case MotionNotify:
                mouse_motion(&ev);
                break;
            case KeyPress:
            case KeyRelease:
                keyboard(&ev);
                break;
            case MappingNotify:
                grabkeys();
                break;
        }
    }
}
