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

SUBDIRS = . m4 man doc tests

SUFFIXES = .m4 .m4f
## There is currently no means with Automake not to run aclocal.
ACLOCAL_AMFLAGS = --version >/dev/null && touch aclocal.m4
WGET = wget

bin_SCRIPTS = autoconf autoheader autoreconf ifnames @PERLSCRIPTS@
EXTRA_SCRIPTS = autoscan autoupdate

# FIXME:
# s/distpackageDATA/dist_pkgdata_DATA/
# s/nodistpackageDATA/nodist_pkgdata_DATA/
# and adapt dependencies once we use a more recent Automake

m4sources =  m4sugar.m4 m4sh.m4  \
             autoconf.m4 \
             acgeneral.m4 acoldnames.m4 acspecific.m4 aclang.m4 acversion.m4 \
             acfunctions.m4 acheaders.m4 actypes.m4

distpkgdataDATA = acfunctions acheaders acidentifiers acmakevars acprograms \
                  $(m4sources)

nodistpkgdataDATA = autoconf.m4f

pkgdata_DATA = $(distpkgdataDATA) $(nodistpkgdataDATA)

EXTRA_DIST = ChangeLog.0 ChangeLog.1 \
             BUGS INSTALL.txt \
             acversion.m4.in \
             autoconf.sh autoheader.sh autoreconf.sh autoupdate.in ifnames.sh \
             autoscan.pl \
             $(distpkgdataDATA)

# Files that should be removed, but which Automake does not know:
# the frozen files and the scripts.
CLEANFILES = autoconf.m4f \
             $(bin_SCRIPTS)


## ------------------ ##
## Maintainer rules.  ##
## ------------------ ##

## acversion.m4.  ##

# - acversion.m4 needs to be updated only once, since it depends on
#   configure.in, not on the results of a 'configure' run.
# - It is guaranteed (with GNU Make) that when the version in configure.in
#   is changed, acversion.m4 is built only after the new version number is
#   propagated to the Makefile.  (Libtool uses the same guarantee.)

acversion.m4: $(srcdir)/acversion.m4.in $(srcdir)/configure.in
	sed 's,@VERSION\@,$(VERSION),g' $(srcdir)/acversion.m4.in >acversion.tm4
	mv acversion.tm4 $(srcdir)/acversion.m4

## INSTALL.  ##

# INSTALL is a special case.  Automake seems to have a single name space
# for both targets and variables.  If we just use INSTALL, then the var
# $(INSTALL) is not defined, and the install target fails.

INSTALL.txt: $(top_srcdir)/doc/install.texi
	$(MAKEINFO) $< --no-headers --no-validate --no-split --output=$@
	if test '$(srcdir)' != '.'; then cp $@ $(srcdir); rm -f $@; fi

MAINTAINERCLEANFILES = acversion.m4 INSTALL.txt


## maintainer-check ##

maintainer-check:
	cd tests && make maintainer-check

## ----------------------------------- ##
## Special installation instructions.  ##
## ----------------------------------- ##

install-data-hook: INSTALL.txt
	@$(NORMAL_INSTALL)
	@list='INSTALL'; for p in $$list; do \
	  if test -f "$$p.txt"; then d= ; else d="$(srcdir)/"; fi; \
	  f="`echo $$p | sed -e 's|^.*/||'`"; \
	  echo " $(INSTALL_DATA) $$d$$p.txt $(DESTDIR)$(pkgdatadir)/$$f"; \
	  $(INSTALL_DATA) $$d$$p.txt $(DESTDIR)$(pkgdatadir)/$$f; \
	done


## ------------- ##
## The scripts.  ##
## ------------- ##

edit = sed \
	-e 's,@SHELL\@,$(SHELL),g' \
	-e 's,@PERL\@,$(PERL),g' \
	-e 's,@datadir\@,$(pkgdatadir),g' \
	-e 's,@bindir\@,$(bindir),g' \
	-e 's,@autoconf-name\@,'`echo autoconf | sed '$(transform)'`',g' \
	-e 's,@autoheader-name\@,'`echo autoheader | sed '$(transform)'`',g' \
	-e 's,@M4\@,$(M4),g' \
	-e 's,@AWK\@,$(AWK),g' \
	-e 's,@VERSION\@,$(VERSION),g' \
	-e 's,@PACKAGE_NAME\@,$(PACKAGE_NAME),g'

## All the scripts below depend on configure.in so that they are rebuilt
## when the Autoconf version changes. Unfortunately, suffix rules cannot
## have additional dependencies, so we have to use explicit rules for
## every script.

autoconf: $(srcdir)/autoconf.sh $(srcdir)/configure.in
	rm -f autoconf autoconf.tmp
	$(edit) $(srcdir)/autoconf.sh >autoconf.tmp
	chmod +x autoconf.tmp
	mv autoconf.tmp autoconf

autoheader: $(srcdir)/autoheader.sh $(srcdir)/configure.in
	rm -f autoheader autoheader.tmp
	$(edit) $(srcdir)/autoheader.sh >autoheader.tmp
	chmod +x autoheader.tmp
	mv autoheader.tmp autoheader

autoreconf: $(srcdir)/autoreconf.sh $(srcdir)/configure.in
	rm -f autoreconf autoreconf.tmp
	$(edit) $(srcdir)/autoreconf.sh >autoreconf.tmp
	chmod +x autoreconf.tmp
	mv autoreconf.tmp autoreconf

autoupdate: $(srcdir)/autoupdate.in $(srcdir)/configure.in
	rm -f autoupdate autoupdate.tmp
	$(edit) $(srcdir)/autoupdate.in >autoupdate.tmp
	chmod +x autoupdate.tmp
	mv autoupdate.tmp autoupdate

ifnames: $(srcdir)/ifnames.sh $(srcdir)/configure.in
	rm -f ifnames ifnames.tmp
	$(edit) $(srcdir)/ifnames.sh >ifnames.tmp
	chmod +x ifnames.tmp
	mv ifnames.tmp ifnames

autoscan: $(srcdir)/autoscan.pl $(srcdir)/configure.in
	rm -f autoscan autoscan.tmp
	$(edit) $(srcdir)/autoscan.pl >autoscan.tmp
	chmod +x autoscan.tmp
	mv autoscan.tmp autoscan


## ------------------ ##
## The frozen files.  ##
## ------------------ ##


# When processing the file with diversion disabled, there must be no
# output but comments and empty lines.
# If freezing produces output, something went wrong: a bad `divert',
# or an improper paren etc.
# It may happen that the output does not end with a end of line, hence
# force an end of line when reporting errors.
.m4.m4f:
	$(M4) -I $(srcdir) $(srcdir)/$*.m4 -D divert | \
	  sed 's/#.*//;/^$$/d' >process.log
	if grep . process.log >/dev/null 2>&1; then \
	  echo "Processing $(srcdir)/$*.m4 produced output:" >&2; \
	  sed "s,^,$(srcdir)/$*.m4: ," < process.log >&2; \
	  echo >&2; \
	  exit 1; \
	else \
	  rm -f process.log; \
	fi
	$(M4) -I $(srcdir) $(srcdir)/$*.m4 --freeze-state=$*.m4f >freeze.log
	if grep . freeze.log >/dev/null 2>&1; then \
	  echo "Freezing $(srcdir)/$*.m4 produced output:" >&2; \
	  sed "s,^,$(srcdir)/$*.m4: ," < freeze.log >&2; \
	  echo >&2; \
	  exit 1; \
	else \
	  rm -f freeze.log; \
	fi

autoconf.m4f: $(m4sources)


## ---------- ##
## Updating.  ##
## ---------- ##

wget-update:
	$(WGET) ftp://ftp.gnu.org/gnu/GNUinfo/standards.texi -O $(srcdir)/doc/standards.texi
	$(WGET) ftp://ftp.gnu.org/gnu/GNUinfo/make-stds.texi -O $(srcdir)/doc/make-stds.texi
	$(WGET) ftp://ftp.gnu.org/gnu/texinfo/texinfo.tex    -O $(srcdir)/doc/texinfo.tex
	$(WGET) ftp://ftp.gnu.org/gnu/config/config.guess    -O $(srcdir)/config.guess
	$(WGET) ftp://ftp.gnu.org/gnu/config/config.sub      -O $(srcdir)/config.sub
