dnl Driver and redefinitions of some Autoconf macros for autoheader.
dnl This file is part of Autoconf.
dnl Copyright (C) 1994 Free Software Foundation, Inc.
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2, or (at your option)
dnl any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software
dnl Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
dnl
dnl Written by Roland McGrath.
dnl
include(acgeneral.m4)dnl
builtin(include, acspecific.m4)dnl
builtin(include, acoldnames.m4)dnl
dnl
dnl These are the alternate definitions of the acgeneral.m4 macros we want to
dnl redefine.  They produce strings in the output marked with "@@@" so we can
dnl easily extract the information we want.  The `#' at the end of the first
dnl line of each definition seems to be necessary to prevent m4 from eating
dnl the newline, which makes the @@@ not always be at the beginning of a line.
dnl
define([AC_DEFINE],[#
@@@syms="$syms $1"@@@
])dnl
define([AC_DEFINE_UNQUOTED],[#
@@@syms="$syms $1"@@@
])dnl
define([AC_SIZEOF_TYPE],[#
@@@types="$types,$1"@@@
])dnl
define([AC_CHECK_FUNCS],[#
@@@funcs="$funcs $1"@@@
])dnl
define([AC_CHECK_HEADERS],[#
@@@headers="$headers $1"@@@
])dnl
define([AC_CONFIG_HEADER],[#
@@@config_h=$1@@@
])dnl
define([AC_CHECK_LIB], [#
changequote(/,/)dnl
define(/libname/, dnl
patsubst(patsubst($1, /lib\([^\.]*\)\.a/, /\1/), /-l/, //))dnl
changequote([,])dnl
  ifelse([$3], , [
@@@libs="$libs libname"@@@
], [
# If it was found, we do:
$3
# If it was not found, we do:
$4
])
])dnl
dnl
