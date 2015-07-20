# Makefile for installing files from toolchain

ifndef DESTDIR
DESTDIR			   ?= /tmp/FriendlyARM/nanopi/rootfs
endif

SRCDIR				= $(shell pwd)/nanopi


# We need toolchain, let's check it
TOOLCHAIN_SYSROOT	= $(shell arm-linux-gcc --print-sysroot)
TOOLCHAIN_VERSION	= $(shell arm-linux-gcc -dumpversion)

ifneq ($(TOOLCHAIN_VERSION),4.4.3)
$(warning arm-linux-gcc $(TOOLCHAIN_VERSION) is *NOT* well supported)
endif


SYSFILES_IN		   ?= sysfiles.in
SYSFILES			= $(shell cat $(SYSFILES_IN))

PLG_PERM			= $(shell grep '^plg' nanopi/etc/passwd | cut -d':' -f3,4)
ifeq ($(PLG_PERM),)
PLG_PERM			= "500:500"
endif

# CVS don't support EMPTY directory, so
# create it on install
EMPTY_DIR_LIST		= mnt \
					  proc \
					  sys \
					  tmp \
					  usr/local \
					  var/run \
					  root \
					  lib/modules

all:


$(DESTDIR):
	mkdir -p $@

empty_dir: $(DESTDIR)
	cd $(DESTDIR) && ( \
	  mkdir -p $(EMPTY_DIR_LIST); \
	)

special_file: empty_dir
	cd $(DESTDIR) && ( \
	  mkdir -p dev; \
	  test -e dev/console && rm -rf dev/console; \
	  mknod dev/console c 5 1; \
	)

install_predefined: empty_dir
	@if [ ! -d $(SRCDIR) ]; then \
	  echo "Error: pre-defined rootfs '$(SRCDIR)' not exist"; exit 1; \
	fi
	@echo "Installing the pre-defined rootfs..."
	cd $(SRCDIR) && tar -cf - * | tar -xf - -p --same-owner -C $(DESTDIR)
	@find $(DESTDIR) -type d -name CVS | xargs rm -rf

install_sysfiles: install_predefined
	@cd $(TOOLCHAIN_SYSROOT) && for f in $(SYSFILES); do \
	  if [ ! -e $${f} ]; then \
	    echo "Error: $${f} (defined in $(SYSFILES_IN)) not found"; exit 1; \
	  fi \
	done
	@echo "Install files from toolchain..."
	cd $(TOOLCHAIN_SYSROOT) && tar -cf - $(SYSFILES) | tar -xf - -C $(DESTDIR)

install_kmodules: kernel-modules.tgz empty_dir
	@echo "Installing kernel modules..."
	tar -C $(DESTDIR)/lib -zxf $<

populate_dest: install_predefined install_kmodules special_file
	@find $(DESTDIR) -type d | xargs chmod 755
	cd $(DESTDIR) && ( \
	  chown $(PLG_PERM) home/plg; \
	  chmod 1777 tmp; \
	  rm etc/mtab -rf && ln -s /proc/mounts etc/mtab; \
	)

install: populate_dest


clean:

distclean:


.PHONY: all install clean distclean \
		empty_dir special_file install_predefined install_sysfiles

# End of file
# vim: syntax=make

