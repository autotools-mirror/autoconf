## Process this file with automake to create Makefile.in. -*-Makefile-*-

## Makefile for Autoconf testsuite.
## Copyright 2000, 2001 Free Software Foundation, Inc.

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

SUITE_GENERATED = \
	aclang.at acc.at acfortran.at \
	acgeneral.at acstatus.at \
	acautoheader.at acautoupdate.at \
	acspecific.at acfunctions.at acheaders.at actypes.at \
	aclibs.at acprograms.at

SUITE = suite.at \
        m4sugar.at m4sh.at \
        base.at tools.at torture.at \
	compile.at \
	$(SUITE_GENERATED) \
	semantics.at \
	foreign.at

# We don't actually distribute the testsuite, since one only
# needs m4 to build it, m4 being required anyway to install Autoconf.
# atlocal.in is to be listed, since Automake doesn't see it...
EXTRA_DIST = README \
             atspecific.m4 aclocal.m4 \
             atlocal.in $(SUITE) mktests.sh

check-local: atconfig atlocal testsuite
	$(SHELL) testsuite

AUTOM4TE = autom4te_perllibdir='$(top_srcdir)/lib' ../bin/autom4te
testsuite: $(top_srcdir)/lib/m4sugar/m4sugar.m4 \
	   $(top_srcdir)/lib/m4sugar/m4sh.m4 \
           $(top_srcdir)/lib/autotest/autotest.m4 \
           $(top_srcdir)/lib/autotest/general.m4 \
	   atspecific.m4 \
           $(SUITE)
	$(AUTOM4TE) -I $(srcdir) -I $(top_srcdir)/lib \
	  autotest/autotest.m4 suite.at -o $@.tmp
	chmod +x $@.tmp
	mv $@.tmp $@


# The files which contains macro we check for syntax.  Don't use $(top_srcdir)
# here since below we explicitly `cd' to $srcdir.  As for the dependencies,
# thanks God for VPATH.  Hm...
MACRO_FILES = $(top_srcdir)/lib/autoconf/general.m4 \
              $(top_srcdir)/lib/autoconf/status.m4 \
              $(top_srcdir)/lib/autoconf/autoheader.m4 \
              $(top_srcdir)/lib/autoconf/autoupdate.m4 \
              $(top_srcdir)/lib/autoconf/specific.m4 \
              $(top_srcdir)/lib/autoconf/functions.m4 \
              $(top_srcdir)/lib/autoconf/lang.m4 \
              $(top_srcdir)/lib/autoconf/c.m4 \
              $(top_srcdir)/lib/autoconf/fortran.m4 \
              $(top_srcdir)/lib/autoconf/headers.m4 \
              $(top_srcdir)/lib/autoconf/libs.m4 \
              $(top_srcdir)/lib/autoconf/types.m4	\
              $(top_srcdir)/lib/autoconf/programs.m4

$(SUITE_GENERATED): mktests.sh $(MACRO_FILES)
	cd $(srcdir) && ./mktests.sh $(MACRO_FILES)

CLEANFILES = 				\
	debug-*.sh state-* at-* stderr stdout \
	script.s4g script.as script			\
	configure configure.in configure.ac config.status config.cache \
	config.log config.h.in config.hin config.h \
	config.guess config.sub install-sh	\
	expr					\
	libtool ltconfig ltmain.sh

DISTCLEANFILES = atconfig atlocal testsuite testsuite.log


## ------------------ ##
## Maintainer rules.  ##
## ------------------ ##

## maintainer-check ##

maintainer-check: maintainer-check-posix maintainer-check-c++

# The hairy heredoc is more robust than using echo.
expr:
	echo '#! $(SHELL)'            >expr
	echo 'result=`@EXPR@ "$$@"`' >>expr
	echo 'estatus=$$?'           >>expr
	echo 'cat <<EOF'             >>expr
	echo '$${result:-0}'         >>expr
	echo 'EOF'                   >>expr
	echo 'exit $$estatus'        >>expr
	chmod +x expr

# Try the test suite with more severe environments.
maintainer-check-posix: expr
	POSIXLY_CORRECTLY=yes make check
	rm expr

# Try using G++ as a C compiler.
maintainer-check-c++:
	CC=g++ make check

clean-local:
	-rm -rf autom4te.cache builddir inner
