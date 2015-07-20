# ----------------------------------------------------------------------------
# Makefile for building rootfs
#
# Copyright 2015 FriendlyARM (http://www.arm9.net/)
#

F_TOP_DIR			= $(shell pwd)
F_SPKG_DIR			= $(F_TOP_DIR)/packages
F_CONFIG_DIR		= $(F_TOP_DIR)/configs
F_MAKE_DIR			= $(F_TOP_DIR)/build
ifndef F_OUT_DIR
F_OUT_DIR			= $(F_TOP_DIR)/out
endif
export F_TOP_DIR F_SPKG_DIR F_CONFIG_DIR F_OUT_DIR

# Do not:
# o  use make's built-in rules and variables
#    (this increases performance and avoids hard-to-debug behaviour);
# o  print "Entering directory ...";
MAKEFLAGS +=

# To put more focus on warnings, be less verbose as default
# Use 'make V=1' to see the full commands
SILENT=@
ECHO=echo
ifeq ("$(origin V)", "command line")
  F_BUILD_V	= $(V)
endif
ifndef F_BUILD_V
  F_BUILD_V	= 0
endif
ifeq ($(strip $(V)),1)
  SILENT=
  ECHO=:
endif
export SILENT ECHO F_BUILD_V

# ----------------------------------------------------------------------------
# Checking gcc version, it *MUST BE* 4.4.3

GCC_VERSION_A = $(shell arm-linux-gcc -dumpversion)
ifneq (4.4.3,$(GCC_VERSION_A))
$(warning *** arm-linux-gcc $(GCC_VERSION_A) is *NOT* supported, please)
$(warning *** switch it to "4.4.3" and try again.)
$(error stopping build)
endif

# ----------------------------------------------------------------------------
-include $(F_MAKE_DIR)/config.mk

# Rootfs package list
TARGET-$(CONFIG_BASE_ROOTFS)	+= basefs
TARGET-$(CONFIG_BUSYBUX)		+= busybox
TARGET-$(CONFIG_NCURSES)		+= ncurses
TARGET-$(CONFIG_ALSA_LIBS)		+= alsa-libs
TARGET-$(CONFIG_ALSA_UTILS)		+= alsa-utils
TARGET-$(CONFIG_LIBNL3)			+= libnl3
TARGET-$(CONFIG_ZLIB)			+= zlib
TARGET-$(CONFIG_OPENSSL)		+= openssl
TARGET-$(CONFIG_OPENSSH)		+= openssh
TARGET-$(CONFIG_WIRELESS)		+= wireless_tools
TARGET-y						+= external

TARGET-install	 	= $(patsubst %,%_install,$(TARGET-y))
PHONY			   += $(TARGET-y) $(TARGET-install)

# ----------------------------------------------------------------------------
PHONY			   += all
all: $(TARGET-y)
	@if [ -z $< ]; then \
	  echo "Warning: NO package to build, please check ../config.mk and try again."; \
	  exit 1; \
	fi

PHONY			   += __build_place
__build_place:
	@if [ ! -d $(F_OUT_DIR) ]; then mkdir -p $(F_OUT_DIR); fi


$(TARGET-y): __build_place
	$(SILENT)if [ -f $@/Makefile ]; then \
	  $(MAKE) -C $@; \
	else \
	  $(MAKE) -C $(F_OUT_DIR) -f $(F_MAKE_DIR)/$@.mk; \
	fi

alsa-utils: alsa-libs ncurses

openssh: zlib openssl

external: libnl3 openssl

busybox_install: basefs_install

$(filter-out busybox% basefs%, $(TARGET-install)): busybox_install

$(TARGET-install): __build_place
	$(SILENT)if [ -f $(subst _install$,,$@)/Makefile ]; then \
	  $(MAKE) -C $(subst _install$,,$@) install; \
	else \
	  $(MAKE) -C $(F_OUT_DIR) -f $(F_MAKE_DIR)/$(subst _install$,,$@).mk install; \
	fi


install: $(TARGET-install)
	@echo
	@echo '-------------------------------------------------------------------'
	@echo 'RootFS (core) successfully installed to:'
	@echo '   $(DESTDIR)'
	@echo
	@echo 'Copyright 2015 FriendlyARM (http://www.arm9.net/)'
	@echo

strip:
	@echo -n "Stripping $(DESTDIR)..."
	$(SILENT)cd $(DESTDIR) && ( \
	  find bin sbin usr/bin usr/lib usr/sbin usr/local -type f | \
	    xargs file | grep "ELF.*ARM.*not stripped" | cut -d: -f1 | \
	    xargs $(CROSS_COMPILE)strip > /dev/null 2>&1; \
	  find lib -maxdepth 1 -type f | \
	    xargs file | grep "ELF.*ARM.*not stripped" | cut -d: -f1 | \
	    xargs $(CROSS_COMPILE)strip > /dev/null 2>&1; \
	  exit 0; \
	)
	@echo "...done."


clean distclean:
	$(MAKE) -C external $@
	@if [ -d $(F_OUT_DIR) ]; then \
	  for __t in $(TARGET-y); do \
	    if [ -f $(F_MAKE_DIR)/$${__t}.mk ]; then \
	      $(MAKE) -C $(F_OUT_DIR) -f $(F_MAKE_DIR)/$${__t}.mk $@; \
	    fi; \
	  done \
	else \
	  echo "make: Nothing to be done for \`$@'."; \
	fi

__fa:
	@echo $(TARGET-y)

# ----------------------------------------------------------------------------

# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY) install clean distclean

# End of file
# vim: syntax=make

