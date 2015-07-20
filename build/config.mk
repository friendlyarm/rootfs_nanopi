# ----------------------------------------------------------------------------
# Global configuration
#
# Copyright 2015 FriendlyARM (http://www.arm9.net/)
#

DESTDIR			   ?= /tmp/FriendlyARM/nanopi/rootfs
export DESTDIR


# Select linux version:
KERNEL_VERSION		= 4.1.2
export KERNEL_VERSION


# Packages to build
CONFIG_BASE_ROOTFS	= y
CONFIG_BUSYBUX		= y
CONFIG_NCURSES		= y
CONFIG_ALSA_LIBS	= y
CONFIG_ALSA_UTILS	= y
CONFIG_WIRELESS		= y
CONFIG_LIBNL3		= y
CONFIG_ZLIB			= y
CONFIG_OPENSSL		= y
CONFIG_OPENSSH		= y


# Prepare toolchain
CROSS_COMPILE		= arm-linux-
export CROSS_COMPILE


# ----------------------------------------------------------------------------
# End of file
# vim: syntax=make

