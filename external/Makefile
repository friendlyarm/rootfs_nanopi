# ----------------------------------------------------------------------------
# Makefile for building tapps
#
# Copyright 2015 FriendlyARM (http://www.arm9.net/)
#

ifndef DESTDIR
DESTDIR			   ?= /tmp/FriendlyARM/nanopi/rootfs
endif
export DESTDIR

F_CONFIG_DIR       ?= ../configs
WPAROOT             = wpa_supplicant-2.4

SUBDIRS				= \
					  boa-0.94.13 \
					  linux-ftpd-0.17 \
					  lrzsz-0.12.20 \
					  netkit-ftp-0.17 \
					  $(WPAROOT)/wpa_supplicant

TARGET				= subdirs

PHONY			   += $(TARGET) $(SUBDIRS) installdirs %.install %.clean


all: $(TARGET)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

$(WPAROOT)/wpa_supplicant: $(WPAROOT)/wpa_supplicant/.config

$(WPAROOT)/wpa_supplicant/.config: $(F_CONFIG_DIR)/wpa.config
	@cp $< $@


installdirs: 
	@mkdir -p $(DESTDIR)/bin
	@mkdir -p $(DESTDIR)/usr/bin
	@mkdir -p $(DESTDIR)/usr/sbin

lrzsz-0.12.20.install: installdirs lrzsz-0.12.20
	(cd $(patsubst %.install, %, $@) && ( \
	  cp src/lrz $(DESTDIR)/usr/bin/rz -af; \
	  cp src/lsz $(DESTDIR)/usr/bin/sz -af; \
	  cd $(DESTDIR)/usr/bin && ( \
	    rm -rf rb sb sx; \
	    ln rz rb; \
	    ln sz sb; \
	    ln sz sx; \
	  ); \
	))

$(WPAROOT)/wpa_supplicant.install:
	(cd $(patsubst %.install, %, $@) && ( \
	  cp wpa_supplicant $(DESTDIR)/usr/sbin/ -af; \
	  cp wpa_cli $(DESTDIR)/usr/sbin/ -af; \
	  cp wpa_passphrase $(DESTDIR)/usr/sbin/ -af; \
	))

%.install: installdirs linux-ftpd-0.17
	(cd $(patsubst %.install, %, $@) && $(MAKE) install)

%.clean:
	(cd $(patsubst %.clean, %, $@) && $(MAKE) clean)


install: $(patsubst %, %.install, $(SUBDIRS))
	@echo
	@echo '-------------------------------------------------------------------'
	@echo 'external successfully installed to:'
	@echo '   $(DESTDIR)'
	@echo
	@echo 'Copyright 2015 FriendlyARM (http://www.arm9.net/)'
	@echo

clean distclean: $(patsubst %, %.clean, $(SUBDIRS))


# ----------------------------------------------------------------------------

.PHONY: $(PHONY) install clean distclean

# End of file
# vim: syntax=make

