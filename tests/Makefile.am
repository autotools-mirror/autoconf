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

SUITE = torture.m4 semantics.m4 syntax.m4 base.m4 tools.m4

# We don't actually distribute the testsuite, since one only
# needs m4 to build it, m4 being required anyway to install Autoconf.
EXTRA_DIST = atgeneral.m4 atspecific.m4 suite.m4 macros.m4 aclocal.m4 $(SUITE)

PERL = perl

check-local: atconfig testsuite
	$(SHELL) testsuite

testsuite: atgeneral.m4 atspecific.m4 suite.m4 macros.m4 $(SUITE)
	$(M4) -I $(srcdir) atspecific.m4 suite.m4 | \
          sed -e 's/[ 	]*$$//' | \
	  sed -e '/^$$/N;/\n$$/D' > $@-tmp
	chmod +x $@-tmp
	mv $@-tmp $@



# FILTER_MACROS
# -------------
# The test `syntax.m4' tries to run all the macros of Autoconf to check
# for syntax problems, etc.  Not all the macros can be run without argument,
# and some are already tested elsewhere.  EGREP_EXCLUDE must filter out
# the macros we don't want to test in syntax.m4.
#
# - AC_CANONICALIZE
#   Needs an argument.
# - AC_CHECK decl, file, func, header, lib, member, prog, sizeof, type
#   Performed in the semantics tests.
# - AC_CONFIG
#   They fail when the source does not exist.
# - AC_INIT
#   AC_INIT includes all the AC_INIT macros.  Note that there is an
#   infinite m4 recursion if AC_INIT it used twice.
# - AC_LANG*
#   Heavily used by other macros.
# - AC_PATH_PROGS?
#   They produce `= val' because $1, the variable used to store the result,
#   is empty.
# - AC_TRY, AC_.*_IFELSE
#   Used in many places.
# - _AC_
#   Internal macros are used elsewhere.
# - AC_OUTPUT
#   Already tested by `AT_CHECK_MACRO'.
# - AC_FD_CC
#   Is a number.
# - AC_PROG_CC, AC_C_(CONST|INLINE|VOLATILE)
#   Checked in semantics.
# - AC_CYGWIN, AC_CYGWIN32, AC_EMXOS2, AC_MING32, AC_EXEEXT, AC_OBJEXT
#   AU defined to nothing.
#
# Multiple `-e' to egrep are not portable, so join all the patterns together.
# We use the fact that automake will replace all the `\\\n' with ` '.
FILTER_MACROS = egrep -v -e \
`echo '^AC_ARG_VAR$$\
^AC_CANONICALIZE$$\
^AC_CHECK_(DECL|FILE|FUNC|HEADER|LIB|MEMBER|PROG|SIZEOF|TOOL|TYPE)S?$$\
^AC_CONFIG\
^AC_INIT\
^AC_LANG\
^AC_LINKER_OPTION$$\
^AC_LINK_FILES$$\
^AC_LIST_MEMBER_OF$$\
^AC_OUTPUT$$\
^AC_PATH_(TOOL|PROG)S?$$\
^AC_REPLACE_FUNCS$$\
^AC_SEARCH_LIBS$$\
^AC_TRY\
^AC_.*_IFELSE$$\
^AC_FD_CC$$\
^(AC_(PROG_CC|C_CONST|C_INLINE|C_VOLATILE))$$\
^AC_(CYGWIN|CYGWIN32|EMXOS2|MING32|EXEEXT|OBJEXT)$$\
_AC_' | tr ' ' '|'`

# The files which contains macro we check for syntax.
MACRO_FILES = $(top_srcdir)/acgeneral.m4   $(top_srcdir)/acspecific.m4 \
              $(top_srcdir)/acfunctions.m4 $(top_srcdir)/aclang.m4

macros.m4: $(MACRO_FILES) $(srcdir)/Makefile.am
	cat $(MACRO_FILES) | \
	  sed -ne 's/^A[CU]_DEFUN(\[*\([a-zA-Z0-9_]*\).*$$/\1/p' | \
	  sort | uniq | $(FILTER_MACROS) >defuns
# Get the list of macros that are required: there is little interest
# in testing them since they will be run but the guy who requires
# them.
	cat $(MACRO_FILES) | \
	  sed -ne 's/dnl.*//;s/.*AC_REQUIRE(\[*\([a-zA-Z0-9_]*\).*$$/\1/p' | \
	  sort | uniq >requires
	for macro in `cat defuns`; do \
	  if fgrep "$$macro" requires >/dev/null 2>&1; then :; else \
	    echo "AT_CHECK_MACRO([$$macro])" >>$@-t; \
	  fi; \
	done
	rm defuns requires
	mv $@-t $@

CLEANFILES = debug-*.sh macro configure configure.in config.status \
config.cache config.log config.h.in config.h
DISTCLEANFILES = atconfig testsuite
