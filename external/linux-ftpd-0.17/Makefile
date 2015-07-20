# You can do "make SUB=blah" to make only a few, or edit here, or both
# You can also run make directly in the subdirs you want.

ifndef DESTDIR
DESTDIR			   ?= /tmp/FriendlyARM/nanopi/rootfs
endif

SUB =   support ftpd

%.build:
	(cd $(patsubst %.build, %, $@) && $(MAKE))

%.install:
	(cd $(patsubst %.install, %, $@) && $(MAKE) install)

%.install-bin:
	(cd $(patsubst %.install-bin, %, $@) && $(MAKE) INSTALLROOT=$(DESTDIR) install-bin)

%.clean:
	(cd $(patsubst %.clean, %, $@) && $(MAKE) clean)

all:     $(patsubst %, %.build, $(SUB))
install: $(patsubst %, %.install-bin, $(SUB))
clean:   $(patsubst %, %.clean, $(SUB))

distclean: clean
	rm -f MCONFIG
