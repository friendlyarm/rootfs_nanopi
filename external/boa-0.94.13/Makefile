# ----------------------------------------------------------------------------
# Makefile for building tapp
#
# Copyright 2010 FriendlyARM (http://www.arm9.net/)
#

ifndef DESTDIR
DESTDIR			   ?= /tmp/FriendlyARM/nanopi/rootfs
endif

CFLAGS				= -Wall -O2
CC					= arm-linux-gcc
INSTALL				= install

TARGET				= src/boa


all: $(TARGET)

src/boa:
	$(MAKE) -C src


install: $(TARGET)
	$(INSTALL) $^ $(DESTDIR)/usr/sbin

clean distclean:
	$(MAKE) -C src clean
	rm -rf *.o $(TARGET)


# ----------------------------------------------------------------------------

.PHONY: $(PHONY) install clean distclean

# End of file
# vim: syntax=make

