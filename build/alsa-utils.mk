# ----------------------------------------------------------------------------
# Makefile for building tools
#
# Copyright 2010 FriendlyARM (http://www.arm9.net/)
#

PKG_VERSION			= 1.0.26
PKG_BASE			= alsa-utils
PKG_NAME			= $(PKG_BASE)-$(PKG_VERSION)
PKG_CONFIG			= .$(PKG_BASE)_config

PREFIX				=
CROSS_COMPILE		= arm-linux-

ifndef DESTDIR
DESTDIR			   ?= /tmp/FriendlyARM/nanopi/rootfs
endif

EXTLIB_DIR		   ?= /tmp/FriendlyARM/nanopi/libs

F_SPKG_DIR		   ?= ../packages
F_CONFIG_DIR	   ?= ../configs


all: build

$(PKG_NAME):
	$(SILENT)for ext in .tar.gz .tar.bz2 .tgz .tar; do \
	  if [ -e "$(F_SPKG_DIR)/$(PKG_NAME)$${ext}" ]; then \
	    tar xf "$(F_SPKG_DIR)/$(PKG_NAME)$${ext}"; \
	    echo "===> $(PKG_NAME)$${ext} extracted and patched"; \
	  fi; \
	done
	$(SILENT)if [ ! -d $@ ]; then \
	  echo "Error: source package for '$@' not found"; \
	  exit 1; \
	fi

$(PKG_NAME)/Makefile: $(PKG_NAME)
	$(SILENT)if [ ! -f $@ ]; then \
	  cd $(PKG_NAME) && CFLAGS="-I${EXTLIB_DIR}/usr/include" LDFLAGS="-L${EXTLIB_DIR}/usr/lib" NCURSES_LIBS="-lncurses" ncurses5_config=no ./configure --host=arm-linux --disable-nls --disable-rpath --disable-xmlto; \
	  echo "===> $(PKG_NAME) configed"; \
	fi

$(PKG_CONFIG): $(PKG_NAME)/Makefile
	$(SILENT)if [ ! -f $@ ]; then \
	  echo "# $(PKG_NAME) configured at "`date "+%F %T"` > $@; \
	fi

build: $(PKG_CONFIG)
	$(SILENT)$(MAKE) -C $(PKG_NAME) all
	@echo "===> $(PKG_NAME) built and ready to install"

install: build
	mkdir -p $(DESTDIR)/usr/bin
	cd $(PKG_NAME) && cp aplay/aplay alsamixer/alsamixer amixer/amixer $(DESTDIR)/usr/bin -af
	cd $(DESTDIR)/usr/bin && [ -f aplay ] && ln -sf aplay arecord
	mkdir -p $(DESTDIR)/usr/sbin
	cd $(PKG_NAME) && cp alsactl/alsactl $(DESTDIR)/usr/sbin -af
	@echo "===> $(PKG_NAME) installed"


clean:
	@if [ -d $(PKG_NAME) ]; then \
	  $(MAKE) -C $(PKG_NAME) clean; \
	else \
	  echo "make: Nothing to be done for \`clean'."; \
	fi

distclean:
	rm -rf $(PKG_CONFIG) $(PKG_NAME)


.PHONY: build install clean distclean

# End of file
# vim: syntax=make

