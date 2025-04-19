CFLAGS += -std=c99 -Wall -Wextra -O2 `pkg-config --cflags x11`
LDLIBS += `pkg-config --libs x11`

INSTALL = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
datarootdir = $(prefix)/share
mandir = $(datarootdir)/man
man1dir = $(mandir)/man1

.PHONY: all clean install installdirs

all: nhkd

nhkd: nhkd.c config.h
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LDLIBS)

clean:
	rm -f nhkd

install: nhkd installdirs
	$(INSTALL_PROGRAM) nhkd $(DESTDIR)$(bindir)/nhkd
	$(INSTALL_DATA) nhkd.1 $(DESTDIR)$(man1dir)/nhkd.1

installdirs:
	mkdir -p $(DESTDIR)$(bindir) $(DESTDIR)$(man1dir)
