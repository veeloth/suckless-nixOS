/* This file is an example. You must configure this yourself. */

bool debug_print_spawned_command = false;

struct MouseEvent mouse_events[] = {
};
struct KeyEvent key_events[] = {

    /* Applications */
    { KeyPress, Mod4Mask, XK_Print, "scrot -s -f -o \"/tmp/image.png\" && xclip -selection clipboard -t image/png -i /tmp/image.png" },
    { KeyPress, NULL, XK_Print, "scrot -o \"/tmp/fullscrot.png\" && xclip -selection clipboard -t image/png -i /tmp/fullscrot.png" },
};
