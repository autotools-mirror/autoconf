## Process this file with automake to create Makefile.in. -*-Makefile-*-

## Makefile for Autoconf.

## Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004 Free Software
## Foundation, Inc.

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

include ../lib/freeze.mk

bin_SCRIPTS = autom4te \
	      autoconf autoheader autoreconf ifnames autoscan autoupdate

EXTRA_DIST = autoconf.as autoheader.in autoreconf.in autoupdate.in ifnames.in \
	     autoscan.in autom4te.in

# Files that should be removed, but which Automake does not know.
MOSTLYCLEANFILES = $(bin_SCRIPTS) autoconf.in *.tmp


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
	-e 's,@PACKAGE_NAME\@,$(PACKAGE_NAME),g' \
	-e 's,@configure_input\@,Generated from $@.in; do not edit by hand.,g'

# autoconf is written in M4sh.
autoconf.in: $(srcdir)/autoconf.as $(m4sh_m4f_dependencies)
	$(MY_AUTOM4TE) --language M4sh --cache '' $(srcdir)/autoconf.as -o $@

## All the files below depend on Makefile so that they are rebuilt
## when the prefix etc. changes.  It took quite a while to have these
## rules correct, don't break them!
## Use chmod -w to prevent people from editing the wrong file by accident.
$(bin_SCRIPTS): Makefile
	rm -f $@ $@.tmp
	$(edit) $(srcdir)/$@.in >$@.tmp
	chmod +x $@.tmp
	chmod a-w $@.tmp
	mv $@.tmp $@

autoconf: $(srcdir)/autoconf.in
autoheader: $(srcdir)/autoheader.in
autom4te: $(srcdir)/autom4te.in
autoreconf: $(srcdir)/autoreconf.in
autoscan: $(srcdir)/autoscan.in
autoupdate: $(srcdir)/autoupdate.in
ifnames: $(srcdir)/ifnames.in


## --------------- ##
## Building TAGS.  ##
## --------------- ##

TAGS_DEPENDENCIES = $(EXTRA_DIST)

letters = abcdefghijklmnopqrstuvwxyz
LETTERS = ABCDEFGHIJKLMNOPQRSTUVWXYZ
DIGITS = 0123456789
WORD_REGEXP = [$(LETTERS)$(letters)_][$(LETTERS)$(letters)$(DIGITS)_]*
ETAGS_PERL = --lang=perl \
  autoheader.in autoreconf.in autoupdate.in autoscan.in autom4te.in \
  ifnames.in
ETAGS_SH = --lang=none --regex='/\($(WORD_REGEXP)\)=/\1/' \
  autoconf.in

ETAGS_ARGS = $(ETAGS_PERL) $(ETAGS_SH)
