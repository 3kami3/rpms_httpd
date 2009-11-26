# Makefile for source rpm: httpd
# $Id: Makefile,v 1.9 2007/10/15 18:52:20 notting Exp $
NAME := httpd
SPECFILE = $(firstword $(wildcard *.spec))
UPSTREAM_CHECKS = asc

define find-makefile-common
for d in common ../common ../../common ; do if [ -f $$d/Makefile.common ] ; then if [ -f $$d/CVS/Root -a -w $$d/Makefile.common ] ; then cd $$d ; cvs -Q update ; fi ; echo "$$d/Makefile.common" ; break ; fi ; done
endef

MAKEFILE_COMMON := $(shell $(find-makefile-common))

ifeq ($(MAKEFILE_COMMON),)
# attempt a checkout
define checkout-makefile-common
test -f CVS/Root && { cvs -Q -d $$(cat CVS/Root) checkout common && echo "common/Makefile.common" ; } || { echo "ERROR: I can't figure out how to checkout the 'common' module." ; exit -1 ; } >&2
endef

MAKEFILE_COMMON := $(shell $(checkout-makefile-common))
endif

include $(MAKEFILE_COMMON)

migration.html: migration.xml html.xsl
	xmlto -x html.xsl html-nochunks migration.xml

view-migration: migration.html
	gnome-moz-remote `pwd`/migration.html

