## Process this file with automake to create Makefile.in.

## Makefile for Autoconf.
## Copyright (C) 1999 Free Software Foundation, Inc.

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

AUTOMAKE_OPTIONS = check-news 1.4

SUBDIRS = . m4 man tests

MAKEINFO = makeinfo --no-split
TEXI2HTML = texi2html
SUFFIXES = .m4 .m4f .pl .sh
## There is currently no means with Automake not to run aclocal.
ACLOCAL_AMFLAGS = --version >/dev/null && touch aclocal.m4

bin_SCRIPTS = autoconf autoheader autoreconf autoupdate ifnames @PERLSCRIPTS@
EXTRA_SCRIPTS = autoscan

# FIXME:
# s/distpackageDATA/dist_pkgdata_DATA/
# s/nodistpackageDATA/nodist_pkgdata_DATA/
# and adapt dependencies once we use a more recent Automake

distpkgdataDATA = \
acfunctions acheaders acidentifiers acmakevars acprograms \
acgeneral.m4 acoldnames.m4 acspecific.m4 autoconf.m4 autoheader.m4

nodistpkgdataDATA = autoconf.m4f autoheader.m4f acversion.m4

pkgdata_DATA = $(distpkgdataDATA) $(nodistpkgdataDATA)

info_TEXINFOS = autoconf.texi standards.texi
autoconf_TEXINFOS = install.texi
standards_TEXINFOS = make-stds.texi

OLDCHANGELOGS = ChangeLog.0 ChangeLog.1
EXTRA_DIST = $(OLDCHANGELOGS) \
autoconf.sh autoheader.sh autoreconf.sh autoupdate.sh \
ifnames.sh autoscan.pl INSTALL.txt \
$(distpkgdataDATA)

# Files that should be removed, but which Automake does not know.
# There are texi2dvi files, frozen files, and the scripts.
CLEANFILES = autoconf.cvs autoconf.ev autoconf.evs autoconf.ma autoconf.mas \
autoconf.ov autoconf.ovs autoconf.m4f autoheader.m4f $(bin_SCRIPTS)

# INSTALL is a special case.  Automake seems to have a single name space
# for both targets and variables.  If we just use INSTALL, then the var
# $(INSTALL) is not defined, and the install target fails.

INSTALL.txt: install.texi
	$(MAKEINFO) -I$(srcdir) $< --no-headers --no-validate --output=$@

install-data-hook: INSTALL.txt
	@$(NORMAL_INSTALL)
	@list='INSTALL'; for p in $$list; do \
	  if test -f "$$p.txt"; then d= ; else d="$(srcdir)/"; fi; \
	  f="`echo $$p | sed -e 's|^.*/||'`"; \
	  echo " $(INSTALL_DATA) $$d$$p.txt $(DESTDIR)$(pkgdatadir)/$$f"; \
	  $(INSTALL_DATA) $$d$$p.txt $(DESTDIR)$(pkgdatadir)/$$f; \
	done

# The scripts.

editsh = sed -e 's,@''datadir''@,$(pkgdatadir),g' -e \
	's,@''M4''@,$(M4),g'  -e 's,@''AWK''@,$(AWK),g' \
	-e 's,@''SHELL''@,$(SHELL),g' \
	-e 's,@''VERSION''@,$(VERSION),g' -e 's,@''PACKAGE''@,$(PACKAGE),g'
editpl = sed -e 's,@''datadir''@,$(pkgdatadir),g' -e 's,@''PERL''@,$(PERL),g' \
	-e 's,@''VERSION''@,$(VERSION),g' -e 's,@''PACKAGE''@,$(PACKAGE),g'

.sh:
	rm -f $@ $@.tmp
	$(editsh) $< > $@.tmp && chmod +x $@.tmp && mv $@.tmp $@

.pl:
	rm -f $@ $@.tmp
	$(editpl) $< > $@.tmp && chmod +x $@.tmp && mv $@.tmp $@

.m4.m4f:
	@case `$(M4) --help </dev/null 2>&1` in \
	*reload-state*) echo freezing $*.m4; \
	  $(M4) -F $*.m4f -I${srcdir} ${srcdir}/$*.m4 ;; \
	*traditional*) ;; \
	*) echo Error: Autoconf requires GNU m4 1.1 or later; exit 1 ;; \
	esac

autoconf.m4f: autoconf.m4 acgeneral.m4 acspecific.m4 acoldnames.m4 acversion.m4
autoheader.m4f: autoheader.m4 acgeneral.m4 acspecific.m4 acoldnames.m4 acversion.m4


# The documentation

html: autoconf_1.html standards_1.html

autoconf_1.html: autoconf.texi install.texi
	$(TEXI2HTML) -split_chapter $(srcdir)/autoconf.texi

standards_1.html: standards.texi make-stds.texi
	$(TEXI2HTML) -split_chapter $(srcdir)/standards.texi
