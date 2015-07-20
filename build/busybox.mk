# ----------------------------------------------------------------------------
# Makefile for building tools
#
# Copyright 2015 FriendlyARM (http://www.arm9.net/)
#

PKG_VERSION			= 1.23.2
PKG_BASE			= busybox
PKG_NAME			= $(PKG_BASE)-$(PKG_VERSION)
PKG_CONFIG			= .$(PKG_BASE)_config

PREFIX				=
CROSS_COMPILE		= arm-linux-

F_SPKG_DIR		   ?= ../packages
F_CONFIG_DIR	   ?= ../configs

ifdef DESTDIR
DEST_FLAGS			= "CONFIG_PREFIX=$(DESTDIR)"
endif


all: build

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

$(PKG_NAME)/.config: $(PKG_NAME)
	$(SILENT)if [ ! -f $@ ]; then \
	  cp $(F_CONFIG_DIR)/busybox-rootfs.config $@; \
	  $(MAKE) -C $(PKG_NAME) oldconfig > /dev/null; \
	  echo "===> $(PKG_NAME) configed"; \
	fi

$(PKG_CONFIG): $(PKG_NAME)/.config
	$(SILENT)if [ ! -f $@ ]; then \
	  echo "# $(PKG_NAME) configured at "`date "+%F %T"` > $@; \
	fi

build: $(PKG_CONFIG)
	$(SILENT)$(MAKE) -C $(PKG_NAME) all
	@echo "===> $(PKG_NAME) built and ready to install"

install: build
	$(SILENT)$(MAKE) $(DEST_FLAGS) -C $(PKG_NAME) install
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

