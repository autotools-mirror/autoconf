## Process this file with automake to create Makefile.in -*-Makefile-*-

## Makefile for Autoconf.
## Copyright 2001 Free Software Foundation, Inc.

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

man_MANS = autoconf.1 autoreconf.1 autoheader.1 autoupdate.1 ifnames.1 \
autoscan.1 autom4te.1 config.guess.1 config.sub.1

man_aux = autoconf.x autoreconf.x autoheader.x autoupdate.x ifnames.x \
autoscan.x autom4te.x config.guess.x config.sub.x

EXTRA_DIST = $(man_MANS) $(man_aux) common.x
MAINTAINERCLEANFILES = $(man_MANS)

# Depend on configure.ac to get version number changes.
common_dep = $(top_srcdir)/configure.ac $(srcdir)/common.x
binsrcdir = $(top_srcdir)/bin
autoconf.1:   $(common_dep) $(srcdir)/autoconf.x   $(binsrcdir)/autoconf.in
autoheader.1: $(common_dep) $(srcdir)/autoheader.x $(binsrcdir)/autoheader.in
autom4te.1:   $(common_dep) $(srcdir)/autom4te.x   $(binsrcdir)/autom4te.in
autoreconf.1: $(common_dep) $(srcdir)/autoreconf.x $(binsrcdir)/autoreconf.in
autoscan.1:   $(common_dep) $(srcdir)/autoscan.x   $(binsrcdir)/autoscan.in
autoupdate.1: $(common_dep) $(srcdir)/autoupdate.x $(binsrcdir)/autoupdate.in
ifnames.1:    $(common_dep) $(srcdir)/ifnames.x    $(binsrcdir)/ifnames.in

# Independent from this package.
config.guess.1: $(srcdir)/config.guess.x  $(top_srcdir)/config/config.guess
config.sub.1:   $(srcdir)/config.sub.x    $(top_srcdir)/config/config.sub

SUFFIXES = .x .1

.x.1:
	test -f $(top_builddir)/bin/$* && prog=$(top_builddir)/bin/$*; \
	test -f $(top_srcdir)/config/$* && prog=$(top_srcdir)/config/$*; \
	if test -n "$$prog"; then \
	  echo "Updating man page $@"; \
	  autom4te_perllibdir="$(top_srcdir)/lib" \
	  $(HELP2MAN) \
	    --include=$(srcdir)/$*.x \
	    --include=$(srcdir)/common.x \
	    --output=$@ $$prog; \
	else \
	  echo "WARNING: The man page $@ cannot be updated yet."; \
	  echo "         Retry once the corresponding executable is built."; \
	fi
