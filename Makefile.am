## Process this file with automake to create Makefile.in.

## Makefile for Autoconf.
## Copyright (C) 1999, 2000 Free Software Foundation, Inc.

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

SUBDIRS = . m4 man doc tests

SUFFIXES = .m4 .m4f .pl .sh
## There is currently no means with Automake not to run aclocal.
ACLOCAL_AMFLAGS = --version >/dev/null && touch aclocal.m4
WGET = wget

bin_SCRIPTS = autoconf autoheader autoreconf autoupdate ifnames @PERLSCRIPTS@
EXTRA_SCRIPTS = autoscan

# FIXME:
# s/distpackageDATA/dist_pkgdata_DATA/
# s/nodistpackageDATA/nodist_pkgdata_DATA/
# and adapt dependencies once we use a more recent Automake

distpkgdataDATA = \
acfunctions acheaders acidentifiers acmakevars acprograms \
libm4.m4 acgeneral.m4 acoldnames.m4 acspecific.m4 autoconf.m4 \
aclang.m4 acversion.m4

nodistpkgdataDATA = autoconf.m4f

pkgdata_DATA = $(distpkgdataDATA) $(nodistpkgdataDATA)

OLDCHANGELOGS = ChangeLog.0 ChangeLog.1
EXTRA_DIST = $(OLDCHANGELOGS) \
autoconf.sh autoheader.sh autoreconf.sh autoupdate.sh \
ifnames.sh autoscan.pl INSTALL.txt \
$(distpkgdataDATA)

# Files that should be removed, but which Automake does not know:
# the frozen files and the scripts.
CLEANFILES = autoconf.m4f \
             $(bin_SCRIPTS)

# INSTALL is a special case.  Automake seems to have a single name space
# for both targets and variables.  If we just use INSTALL, then the var
# $(INSTALL) is not defined, and the install target fails.

INSTALL.txt: $(top_srcdir)/doc/install.texi
	$(MAKEINFO) $< --no-headers --no-validate --no-split --output=$@

install-data-hook: INSTALL.txt
	@$(NORMAL_INSTALL)
	@list='INSTALL'; for p in $$list; do \
	  if test -f "$$p.txt"; then d= ; else d="$(srcdir)/"; fi; \
	  f="`echo $$p | sed -e 's|^.*/||'`"; \
	  echo " $(INSTALL_DATA) $$d$$p.txt $(DESTDIR)$(pkgdatadir)/$$f"; \
	  $(INSTALL_DATA) $$d$$p.txt $(DESTDIR)$(pkgdatadir)/$$f; \
	done

# The scripts.

editsh = sed \
	-e 's,@''datadir''@,$(pkgdatadir),g' \
	-e 's,@''M4''@,$(M4),g' \
	-e 's,@''AWK''@,$(AWK),g' \
	-e 's,@''SHELL''@,$(SHELL),g' \
	-e 's,@''VERSION''@,$(VERSION),g' \
	-e 's,@''PACKAGE''@,$(PACKAGE),g' \
	-e 's,@autoconf-name@,'`echo autoconf | sed '$(transform)'`',g' \
	-e 's,@autoheader-name@,'`echo autoheader | sed '$(transform)'`',g'

editpl = sed \
	-e 's,@''datadir''@,$(pkgdatadir),g' \
	-e 's,@''PERL''@,$(PERL),g' \
	-e 's,@''VERSION''@,$(VERSION),g' \
	-e 's,@''PACKAGE''@,$(PACKAGE),g'

.sh:
	rm -f $@ $@.tmp
	$(editsh) $< >$@.tmp
	chmod +x $@.tmp
	mv $@.tmp $@

.pl:
	rm -f $@ $@.tmp
	$(editpl) $< >$@.tmp
	chmod +x $@.tmp
	mv $@.tmp $@

.m4.m4f:
	$(M4) -I $(srcdir) $(srcdir)/$*.m4 --freeze-state=$*.m4f

common = libm4.m4 acgeneral.m4 acspecific.m4 acoldnames.m4 acversion.m4 \
         aclang.m4

autoconf.m4f: autoconf.m4 $(common)


wget-update:
	$(WGET) ftp://ftp.gnu.org/gnu/GNUinfo/standards.texi -O $(srcdir)/doc/standards.texi
	$(WGET) ftp://ftp.gnu.org/gnu/GNUinfo/make-stds.texi -O $(srcdir)/doc/make-stds.texi
	$(WGET) ftp://ftp.gnu.org/gnu/texinfo/texinfo.tex    -O $(srcdir)/doc/texinfo.tex
	$(WGET) ftp://ftp.gnu.org/gnu/config/config.guess    -O $(srcdir)/config.guess
	$(WGET) ftp://ftp.gnu.org/gnu/config/config.sub      -O $(srcdir)/config.sub
