## Process this file with automake to create Makefile.in. -*-Makefile-*-

## Makefile for Autoconf.
## Copyright (C) 1999, 2000, 2001, 2002 Free Software Foundation, Inc.

## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2, or (at your option)
## any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
## 02111-1307, USA.

AUTOMAKE_OPTIONS = check-news 1.6 dist-bzip2 readme-alpha

# bin/ and tests/ must be run first, as they build the tests executables
# (tests/autom4te etc.), that we happen to use here.
SUBDIRS = bin tests . lib config man doc

ACLOCAL_AMFLAGS = -I config

EXTRA_DIST = ChangeLog.0 ChangeLog.1 ChangeLog.2 \
             BUGS \
             GNUmakefile Makefile.maint

MAINTAINERCLEANFILES = COPYING INSTALL

## -------------------- ##
## Forwarding targets.  ##
## -------------------- ##

html pdf:
	cd doc && $(MAKE) $(AM_MAKEFLAGS) $@

.PHONY: html pdf


## --------- ##
## INSTALL.  ##
## --------- ##

pkgdata_DATA = INSTALL
MAKEINFO = @MAKEINFO@ --no-headers --no-validate --no-split
INSTALL: $(top_srcdir)/doc/install.texi
	$(MAKEINFO) $(top_srcdir)/doc/install.texi --output=$(srcdir)/INSTALL

maintainer-clean-local:
	-rm -rf autom4te.cache

## maintainer-check ##
maintainer-check: maintainer-check-tests
maintainer-check-tests:
	cd tests && make maintainer-check



## ---------------------------- ##
## Customizing Makefile.maint.  ##
## ---------------------------- ##

prev_version_file = $(srcdir)/config/prev-version.txt
move_if_change = $(srcdir)/config/move-if-change
release_archive_dir = releases

# Uploading betas.
hosts = alpha
alpha_host = alpha.gnu.org
alpha_url_dir = gnu/autoconf

# Files to update automatically.
wget_files = $(srcdir)/config/config.guess $(srcdir)/config/config.sub \
	     $(srcdir)/config/texinfo.tex \
	     $(srcdir)/doc/standards.texi $(srcdir)/doc/make-stds.texi
cvs_files = $(srcdir)/config/missing
