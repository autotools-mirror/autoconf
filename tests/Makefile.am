## Process this file with automake to create Makefile.in.

## Makefile for Autoconf testsuite.
## Copyright (C) 2000 Free Software Foundation, Inc.

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

AUTOMAKE_OPTIONS = gnits

SUITE = syntax.m4 semantics.m4

# We don't actually distribute the testsuite, since one only
# needs m4 to build it, m4 being required anyway to install Autoconf.
EXTRA_DIST = atgeneral.m4 atspecific.m4 suite.m4 macros.m4 actest.m4 $(SUITE)

PERL = perl

all-local: atconfig testsuite

check-local: atconfig testsuite
	$(SHELL) testsuite

testsuite: atgeneral.m4 atspecific.m4 suite.m4 macros.m4 $(SUITE)
	m4 -I $(srcdir) atspecific.m4 suite.m4 | cat -s > $@-tmp
	chmod +x $@-tmp
	mv $@-tmp $@

macros.m4: $(top_srcdir)/acspecific.m4 $(srcdir)/Makefile.am
	cat $(top_srcdir)/acgeneral.m4 $(top_srcdir)/acspecific.m4 | \
	  sed -ne 's/^AC_DEFUN(\[*\([^],]*\).*/\1/p' | \
	  sort >defuns
# Get the list of macros that are required: there is little interest
# in testing them since they will be run but the guy who requires
# them.
	cat $(top_srcdir)/acgeneral.m4 $(top_srcdir)/acspecific.m4 | \
	  sed -ne 's/dnl.*//;s/.*AC_REQUIRE(\[*\([a-zA-Z0-9_]*\).*$$/\1/p' | \
	  sort | uniq >requires
	for macro in `cat defuns`; do \
	  if fgrep "$$macro" requires >/dev/null 2>&1; then :; else \
	    echo "TEST_MACRO([$$macro])" >>$@-t; \
	  fi; \
	done
	rm defuns requires
	mv $@-t $@

CLEANFILES = debug-*.sh macro configure configure.in config.status \
config.cache config.log config.h.in config.h
DISTCLEANFILES = atconfig testsuite
