#! /bin/sh

# Build some of the Autoconf test files.

# Copyright (C) 2000 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

dst=$1
shift
src="$@"

# filter_macros_list
# ------------------
# The test `syntax.m4' tries to run all the macros of Autoconf to check
# for syntax problems, etc.  Not all the macros can be run without argument,
# and some are already tested elsewhere.  EGREP_EXCLUDE must filter out
# the macros we don't want to test in syntax.m4.
#
# - AC_CANONICALIZE, AC_PREFIX_PROGRAM
#   Need an argument.
# - AC_CHECK decl, file, func, header, lib, member, prog, sizeof, type
#   Performed in the semantics tests.
# - AC_CONFIG
#   They fail when the source does not exist.
# - AC_INIT
#   AC_INIT includes all the AC_INIT macros.  Note that there is an
#   infinite m4 recursion if AC_INIT it used twice.
# - AC_LANG*
#   Heavily used by other macros.
# - AC_PATH_PROGS?, AC_F77_FUNC
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
filter_macros_list='^AC_ARG_VAR$
^AC_CANONICALIZE$
^AC_CHECK_(DECL|FILE|FUNC|HEADER|LIB|MEMBER|PROG|SIZEOF|TOOL|TYPE)S?$
^AC_CONFIG
^AC_F77_FUNC$
^AC_INIT
^AC_LANG
^AC_LINKER_OPTION$
^AC_LINK_FILES$
^AC_LIST_MEMBER_OF$
^AC_OUTPUT$
^AC_PATH_(TOOL|PROG)S?$
^AC_PREFIX_PROGRAM$
^AC_REPLACE_FUNCS$
^AC_SEARCH_LIBS$
^AC_TRY
^AC_.*_IFELSE$
^AC_FD_CC$
^(AC_(PROG_CC|C_CONST|C_INLINE|C_VOLATILE))$
^AC_(CYGWIN|CYGWIN32|EMXOS2|MING32|EXEEXT|OBJEXT)$
_AC_'

# filter_macros_egrep --
# Build a single egrep pattern out of filter_macros_list.
# Sed is used to get rid of the trailing `|' coming from the trailing
# `\n' from `echo'.
filter_macros_egrep=`echo "$filter_macros_list" | tr '
' '|' | sed 's/.$//'`


case $dst in
 *macros.m4)
    # Get the list of macros which are defined in Autoconf level.
    # Get rid of the macros we are not interested in.
    cat $src | \
      sed -ne 's/^A[CU]_DEFUN\(_ONCE\)\?(\[*\([a-zA-Z0-9_]*\).*$/\2/p' | \
      sort | uniq | egrep -v "$filter_macros_egrep" >defuns

    # Get the list of macros that are required: there is little interest
    # in testing them since they will be run but the guy who requires
    # them.
    cat $src | \
      sed -ne 's/dnl.*//;s/.*AC_REQUIRE(\[*\([a-zA-Z0-9_]*\).*$/\1/p' | \
      sort | uniq >requires

    # Filter out.
    for macro in `cat defuns`; do \
      if fgrep "$macro" requires >/dev/null 2>&1; then :; else \
    	echo "AT_CHECK_MACRO([$macro])" >>$dst-t; \
      fi; \
    done

    rm defuns requires
    mv $dst-t $dst
  ;;

  *)
    echo "$0: don't know how to do $src" >&2
    exit 1
esac

exit 0
