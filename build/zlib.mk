# ----------------------------------------------------------------------------
# Makefile for building libs
#
# Copyright 2015 FriendlyARM (http://www.arm9.net/)
#

PKG_VERSION			= 1.2.8
PKG_BASE			= zlib
PKG_NAME			= $(PKG_BASE)-$(PKG_VERSION)
PKG_CONFIG			= .$(PKG_BASE)_config

PREFIX				= /usr
CROSS_COMPILE	   ?= arm-linux-

ifndef DESTDIR
DESTDIR			   ?= /tmp/FriendlyARM/nanopi/rootfs
endif

EXTLIB_DIR		   ?= /tmp/FriendlyARM/nanopi/libs

F_SPKG_DIR		   ?= ../packages
F_CONFIG_DIR	   ?= ../configs


all: install_lib

$(PKG_NAME):
	$(SILENT)for ext in .tar.gz .tar.bz2 .tgz .tar; do \
	  if [ -e "$(F_SPKG_DIR)/$(PKG_NAME)$${ext}" ]; then \
	    tar xf "$(F_SPKG_DIR)/$(PKG_NAME)$${ext}"; \
	    echo "===> $(PKG_NAME)$${ext} extracted"; \
	  fi; \
	done
	$(SILENT)if [ ! -d $@ ]; then \
	  echo "Error: source package for '$@' not found"; \
	  exit 1; \
	fi

$(PKG_NAME)/zlib.pc: $(PKG_NAME)
	$(SILENT)if [ ! -f $@ ]; then \
	  cd $(PKG_NAME) && CC=$(CROSS_COMPILE)gcc AR=$(CROSS_COMPILE)ar CPP=$(CROSS_COMPILE)g++ RANLIB=$(CROSS_COMPILE)ranlib ./configure --prefix=${PREFIX}; \
	  echo "===> $(PKG_NAME) configed"; \
	fi

$(PKG_CONFIG): $(PKG_NAME)/zlib.pc
	$(SILENT)if [ ! -f $@ ]; then \
	  echo "# $(PKG_NAME) configured at "`date "+%F %T"` > $@; \
	fi

build: $(PKG_CONFIG)
	$(SILENT)$(MAKE) -C $(PKG_NAME) all
	@echo "===> $(PKG_NAME) built and ready to install"

install_lib: build
	$(SILENT)$(MAKE) -C $(PKG_NAME) DESTDIR=${EXTLIB_DIR} install

install: install_lib
	mkdir -p ${DESTDIR}
	cd $(EXTLIB_DIR) && tar cf - usr/lib/libz.so* | \
		tar xvf - -C ${DESTDIR}
	@echo "===> $(PKG_NAME) installed"


clean:
	@if [ -d $(PKG_NAME) ]; then \
	  $(MAKE) -C $(PKG_NAME) clean; \
	else \
	  echo "make: Nothing to be done for \`clean'."; \
	fi

distclean:
	rm -rf $(PKG_CONFIG) $(PKG_NAME)


.PHONY: build install install_lib clean distclean

# End of file
# vim: syntax=make

