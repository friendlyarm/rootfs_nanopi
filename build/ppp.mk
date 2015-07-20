# ----------------------------------------------------------------------------
# Makefile for building tools
#
# Copyright 2010 FriendlyARM (http://www.arm9.net/)
#

PKG_VERSION			= 2.4.5
PKG_BASE			= ppp
PKG_NAME			= $(PKG_BASE)-$(PKG_VERSION)
PKG_CONFIG			= .$(PKG_BASE)_config

PREFIX				=
CROSS_COMPILE		= arm-linux-

ifndef DESTDIR
DESTDIR			   ?= /tmp/FriendlyARM/nanopi/rootfs
endif

F_SPKG_DIR		   ?= ../packages
F_CONFIG_DIR	   ?= ../configs


all: build

$(PKG_NAME):
	$(SILENT)for ext in .tar.gz .tar.bz2 .tgz .tar; do \
	  if [ -e "$(F_SPKG_DIR)/$(PKG_NAME)$${ext}" ]; then \
	    tar xf "$(F_SPKG_DIR)/$(PKG_NAME)$${ext}"; \
	    patch -g0 -F1 -f -b -p0 < $(F_SPKG_DIR)/ppp-2.4.5-r1.patch; \
	    patch -g0 -F1 -f -b -p0 < $(F_SPKG_DIR)/ppp-2.4.5-mf.patch; \
	    echo "===> $(PKG_NAME)$${ext} extracted and patched"; \
	  fi; \
	done
	$(SILENT)if [ ! -d $@ ]; then \
	  echo "Error: source package for '$@' not found"; \
	  exit 1; \
	fi

$(PKG_NAME)/Makefile: $(PKG_NAME)
	$(SILENT)if [ ! -f $@ ]; then \
	  cd $(PKG_NAME) && ./configure --prefix=; \
	  echo "===> $(PKG_NAME) configed"; \
	fi

$(PKG_CONFIG): $(PKG_NAME)/Makefile
	$(SILENT)if [ ! -f $@ ]; then \
	  echo "# $(PKG_NAME) configured at "`date "+%F %T"` > $@; \
	fi

build: $(PKG_CONFIG)
	$(SILENT)CC=${CROSS_COMPILE}gcc AR=${CROSS_COMPILE}ar LD=${CROSS_COMPILE}ld RAMLIB=${CROSS_COMPILE}ramlib $(MAKE) -C $(PKG_NAME) all
	@echo "===> $(PKG_NAME) built and ready to install"

install: build
	$(SILENT)$(MAKE) DESTDIR=$(DESTDIR)/usr -C $(PKG_NAME) install-bin
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

