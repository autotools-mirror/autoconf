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

bin_SCRIPTS = autom4te \
              autoconf autoheader autoreconf ifnames autoscan autoupdate

EXTRA_DIST = autoconf.in autoheader.in autoreconf.in autoupdate.in ifnames.in \
             autoscan.in autom4te.in \
	     autoconf.as

# Files that should be removed, but which Automake does not know.
CLEANFILES = $(bin_SCRIPTS)


## ------------- ##
## The scripts.  ##
## ------------- ##

edit = sed \
	-e 's,@SHELL\@,$(SHELL),g' \
	-e 's,@PERL\@,$(PERL),g' \
	-e 's,@bindir\@,$(bindir),g' \
	-e 's,@datadir\@,$(pkgdatadir),g' \
	-e 's,@prefix\@,$(prefix),g' \
	-e 's,@autoconf-name\@,'`echo autoconf | sed '$(transform)'`',g' \
	-e 's,@autoheader-name\@,'`echo autoheader | sed '$(transform)'`',g' \
	-e 's,@autom4te-name\@,'`echo autom4te | sed '$(transform)'`',g' \
	-e 's,@M4\@,$(M4),g' \
	-e 's,@AWK\@,$(AWK),g' \
	-e 's,@VERSION\@,$(VERSION),g' \
	-e 's,@PACKAGE_NAME\@,$(PACKAGE_NAME),g'

# autoconf is written in M4sh.
AUTOM4SH = $(top_builddir)/tests/autom4te --language M4sh
$(srcdir)/autoconf.in: $(srcdir)/autoconf.as $(m4sh_m4f_dependencies)
	$(AUTOM4SH) $(srcdir)/autoconf.as -o $@

## All the files below depend on Makefile so that they are rebuilt
## when the prefix etc. changes.
SUFFIXES = .in
autoconf autoheader autoreconf autoupdate ifnames autoscan autom4te: Makefile
.in:
	rm -f $@ $@.tmp
	$(edit) $< >$@.tmp
	chmod +x $@.tmp
	mv $@.tmp $@



## --------------- ##
## Building TAGS.  ##
## --------------- ##

TAGS_DEPENDENCIES = $(EXTRA_DIST)

letters = abcdefghijklmnopqrstuvwxyz
LETTERS = ABCDEFGHIJKLMNOPQRSTUVWXYZ
DIGITS = 0123456789
WORD_REGEXP = [$(LETTERS)$(letters)_][$(LETTERS)$(letters)$(DIGITS)_]*
ETAGS_PERL = --lang=perl \
  autoreconf.in autoupdate.in autoscan.in autom4te.in
ETAGS_SH = --lang=none --regex='/\($(WORD_REGEXP)\)=/\1/' \
  autoconf.in autoheader.in ifnames.in

ETAGS_ARGS = $(ETAGS_PERL) $(ETAGS_SH)
