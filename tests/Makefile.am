## Process this file with automake to create Makefile.in.

## Makefile for Autoconf testsuite.
## Copyright 2000 Free Software Foundation, Inc.

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

SUITE = suite.at \
        m4sugar.at m4sh.at \
        base.at tools.at semantics.at torture.at syntax.at update.at

# We don't actually distribute the testsuite, since one only
# needs m4 to build it, m4 being required anyway to install Autoconf.
EXTRA_DIST = README \
             atgeneral.m4 atspecific.m4 aclocal.m4 \
             $(SUITE) mktests.sh

check-local: atconfig testsuite
	$(SHELL) testsuite

testsuite: atgeneral.m4 atspecific.m4 $(SUITE)
	$(M4) -I $(srcdir) atspecific.m4 suite.at | \
          sed -e 's/[ 	]*$$//' | \
	  sed -e '/^$$/N;/\n$$/D' > $@-tmp
	chmod +x $@-tmp
	mv $@-tmp $@


# The files which contains macro we check for syntax.
MACRO_FILES = ../acgeneral.m4   ../acspecific.m4 \
              ../acfunctions.m4 ../aclang.m4

syntax.at: mktests.sh $(MACRO_FILES)
	cd $(srcdir) && ./mktests.sh $(MACRO_FILES)

update.at: mktests.sh $(MACRO_FILES)
	cd $(srcdir) && ./mktests.sh $(MACRO_FILES)

CLEANFILES = debug-*.sh macro configure configure.in config.status \
             config.cache config.log config.h.in config.h
DISTCLEANFILES = atconfig testsuite
