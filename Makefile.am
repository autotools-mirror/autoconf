## Process this file with automake to create Makefile.in. -*-Makefile-*-

## Makefile for Autoconf.
## Copyright 1999, 2000, 2001 Free Software Foundation, Inc.

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

AUTOMAKE_OPTIONS = check-news 1.4 readme-alpha

SUBDIRS = . lib bin config m4 man doc tests

## There is currently no means with Automake not to run aclocal.
ACLOCAL_AMFLAGS = --version >/dev/null && touch aclocal.m4
WGET = wget

# FIXME:
# s/distpackageDATA/dist_pkgdata_DATA/
# s/nodistpackageDATA/nodist_pkgdata_DATA/
# and adapt dependencies once we use a more recent Automake

EXTRA_DIST = ChangeLog.0 ChangeLog.1 ChangeLog.2 \
             BUGS INSTALL.txt \
             GNUmakefile Makefile.maint


## ------------------ ##
## Maintainer rules.  ##
## ------------------ ##

## INSTALL.  ##

# INSTALL is a special case.  Automake seems to have a single name space
# for both targets and variables.  If we just use INSTALL, then the var
# $(INSTALL) is not defined, and the install target fails.
MAKEINFO = @MAKEINFO@ --no-headers --no-validate --no-split
INSTALL.txt: $(top_srcdir)/doc/install.texi
	$(MAKEINFO) $(top_srcdir)/doc/install.texi --output=$(srcdir)/INSTALL.txt
	cp $(srcdir)/INSTALL.txt $(srcdir)/INSTALL

MAINTAINERCLEANFILES = INSTALL.txt


## maintainer-check ##
maintainer-check: maintainer-check-tests
maintainer-check-tests:
	cd tests && make maintainer-check

## ----------------------------------- ##
## Special installation instructions.  ##
## ----------------------------------- ##

install-data-hook: INSTALL.txt
	@$(NORMAL_INSTALL)
	@list='INSTALL'; for p in $$list; do \
	  if test -f "$$p.txt"; then d= ; else d="$(srcdir)/"; fi; \
	  f=`echo $$p | sed -e 's,^.*/,,'`; \
	  $(mkinstalldirs) $(DESTDIR)$(pkgdatadir) ; \
	  echo " $(INSTALL_DATA) $$d$$p.txt $(DESTDIR)$(pkgdatadir)/$$f"; \
	  $(INSTALL_DATA) $$d$$p.txt $(DESTDIR)$(pkgdatadir)/$$f; \
	done


## ---------------------------- ##
## Customizing Makefile.maint.  ##
## ---------------------------- ##

prev_version_file = $(srcdir)/config/prev-version.txt
release_archive_dir = releases

# Uploading betas.
hosts = alpha
alpha_host = alpha.gnu.org
alpha_url_dir = gnu/autoconf

# Files to update automatically.
wget_files = $(srcdir)/config/config.guess $(srcdir)/config/config.sub \
	     $(srcdir)/config/texinfo.tex \
	     $(srcdir)/doc/standards.texi $(srcdir)/doc/make-stds.texi
