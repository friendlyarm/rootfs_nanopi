# ----------------------------------------------------------------------------
# Makefile for building tools
#
# Copyright 2010 FriendlyARM (http://www.arm9.net/)
#

PKG_VERSION			= 29
PKG_BASE			= wireless_tools
PKG_NAME			= $(PKG_BASE).$(PKG_VERSION)
PKG_CONFIG			= .$(PKG_BASE)_config

PREFIX				= /usr
CROSS_COMPILE		= arm-linux-

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
	    echo "===> $(PKG_NAME)$${ext} extracted and patched"; \
	  fi; \
	done
	$(SILENT)if [ ! -d $@ ]; then \
	  echo "Error: source package for '$@' not found"; \
	  exit 1; \
	fi

$(PKG_NAME)/Makefile: $(PKG_NAME)
	$(SILENT)if [ ! -f $@ ]; then \
	  cd $(PKG_NAME) && ./configure --prefix=${PREFIX} --host=arm-linux --disable-python --with-gnu-ld; \
	  echo "===> $(PKG_NAME) configed"; \
	fi

$(PKG_CONFIG): $(PKG_NAME)/Makefile
	$(SILENT)if [ ! -f $@ ]; then \
	  echo "# $(PKG_NAME) configured at "`date "+%F %T"` > $@; \
	fi

build: $(PKG_CONFIG)
	cd $(PKG_NAME) && $(MAKE) PREFIX=/usr BUILD_STRIPPING='y' all
	@echo "===> $(PKG_NAME) built and ready to install"

install_lib: build

install: install_lib
	cd $(PKG_NAME) && $(MAKE) PREFIX=$(DESTDIR)/usr BUILD_STRIPPING='y' install-dynamic install-bin
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

