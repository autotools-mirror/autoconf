# This file is part of Autoconf.                           -*- Autoconf -*-
# Support old macros, and provide automated updates.
# Copyright (C) 1994, 1999 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.
#
# Written by David David MacKenzie.

## ---------------------------- ##
## General macros of autoconf.  ##
## ---------------------------- ##

define(AC_WARN, [indir([AC_MSG_WARN], $@)])
define(AC_ERROR, [indir([AC_MSG_ERROR], $@)])
AC_DEFUN(AC_FUNC_CHECK, [indir([AC_CHECK_FUNC], $@)])
AC_DEFUN(AC_HAVE_FUNCS, [indir([AC_CHECK_FUNCS], $@)])
AC_DEFUN(AC_HAVE_HEADERS, [indir([AC_CHECK_HEADERS], $@)])
AC_DEFUN(AC_HEADER_CHECK, [indir([AC_CHECK_HEADER], $@)])
AC_DEFUN(AC_HEADER_EGREP, [indir([AC_EGREP_HEADER], $@)])
AC_DEFUN(AC_PREFIX, [indir([AC_PREFIX_PROGRAM], $@)])
AC_DEFUN(AC_PROGRAMS_CHECK, [indir([AC_CHECK_PROGS], $@)])
AC_DEFUN(AC_PROGRAMS_PATH, [indir([AC_PATH_PROGS], $@)])
AC_DEFUN(AC_PROGRAM_CHECK, [indir([AC_CHECK_PROG], $@)])
AC_DEFUN(AC_PROGRAM_EGREP, [indir([AC_EGREP_CPP], $@)])
AC_DEFUN(AC_PROGRAM_PATH, [indir([AC_PATH_PROG], $@)])
AC_DEFUN(AC_SIZEOF_TYPE, [indir([AC_CHECK_SIZEOF], $@)])
AC_DEFUN(AC_TEST_CPP, [indir([AC_TRY_CPP], $@)])
AC_DEFUN(AC_TEST_PROGRAM, [indir([AC_TRY_RUN], $@)])



## ----------------------------- ##
## Specific macros of autoconf.  ##
## ----------------------------- ##

AC_DEFUN(AC_ALLOCA, [indir([AC_FUNC_ALLOCA])])
AC_DEFUN(AC_CHAR_UNSIGNED, [indir([AC_C_CHAR_UNSIGNED])])
AC_DEFUN(AC_CONST, [indir([AC_C_CONST])])
AC_DEFUN(AC_CROSS_CHECK, [indir([AC_C_CROSS])])
AC_DEFUN(AC_FIND_X, [indir([AC_PATH_X])])
AC_DEFUN(AC_FIND_XTRA, [indir([AC_PATH_XTRA])])
AC_DEFUN(AC_GCC_TRADITIONAL, [indir([AC_PROG_GCC_TRADITIONAL])])
AC_DEFUN(AC_GETGROUPS_T, [indir([AC_TYPE_GETGROUPS])])
AC_DEFUN(AC_GETLOADAVG, [indir([AC_FUNC_GETLOADAVG])])
AC_DEFUN(AC_INLINE, [indir([AC_C_INLINE])])
AC_DEFUN(AC_LN_S, [indir([AC_PROG_LN_S])])
AC_DEFUN(AC_LONG_DOUBLE, [indir([AC_C_LONG_DOUBLE])])
AC_DEFUN(AC_LONG_FILE_NAMES, [indir([AC_SYS_LONG_FILE_NAMES])])
AC_DEFUN(AC_MAJOR_HEADER, [indir([AC_HEADER_MAJOR])])
AC_DEFUN(AC_MINUS_C_MINUS_O, [indir([AC_PROG_CC_C_O])])
AC_DEFUN(AC_MMAP, [indir([AC_FUNC_MMAP])])
AC_DEFUN(AC_MODE_T, [indir([AC_TYPE_MODE_T])])
AC_DEFUN(AC_OFF_T, [indir([AC_TYPE_OFF_T])])
AC_DEFUN(AC_PID_T, [indir([AC_TYPE_PID_T])])
AC_DEFUN(AC_RESTARTABLE_SYSCALLS, [indir([AC_SYS_RESTARTABLE_SYSCALLS])])
AC_DEFUN(AC_RETSIGTYPE, [indir([AC_TYPE_SIGNAL])])
AC_DEFUN(AC_SETVBUF_REVERSED, [indir([AC_FUNC_SETVBUF_REVERSED])])
AC_DEFUN(AC_SET_MAKE, [indir([AC_PROG_MAKE_SET])])
AC_DEFUN(AC_SIZE_T, [indir([AC_TYPE_SIZE_T])])
AC_DEFUN(AC_STAT_MACROS_BROKEN, [indir([AC_HEADER_STAT])])
AC_DEFUN(AC_STDC_HEADERS, [indir([AC_HEADER_STDC])])
AC_DEFUN(AC_STRCOLL, [indir([AC_FUNC_STRCOLL])])
AC_DEFUN(AC_ST_BLKSIZE, [indir([AC_STRUCT_ST_BLKSIZE])])
AC_DEFUN(AC_ST_BLOCKS, [indir([AC_STRUCT_ST_BLOCKS])])
AC_DEFUN(AC_ST_RDEV, [indir([AC_STRUCT_ST_RDEV])])
AC_DEFUN(AC_SYS_SIGLIST_DECLARED, [indir([AC_DECL_SYS_SIGLIST])])
AC_DEFUN(AC_TIMEZONE, [indir([AC_STRUCT_TIMEZONE])])
AC_DEFUN(AC_TIME_WITH_SYS_TIME, [indir([AC_HEADER_TIME])])
AC_DEFUN(AC_UID_T, [indir([AC_TYPE_UID_T])])
AC_DEFUN(AC_UTIME_NULL, [indir([AC_FUNC_UTIME_NULL])])
AC_DEFUN(AC_VFORK, [indir([AC_FUNC_VFORK])])
AC_DEFUN(AC_VPRINTF, [indir([AC_FUNC_VPRINTF])])
AC_DEFUN(AC_WAIT3, [indir([AC_FUNC_WAIT3])])
AC_DEFUN(AC_WORDS_BIGENDIAN, [indir([AC_C_BIGENDIAN])])
AC_DEFUN(AC_YYTEXT_POINTER, [indir([AC_DECL_YYTEXT])])
AC_DEFUN(AM_CYGWIN32, [indir([AC_CYGWIN32])])
AC_DEFUN(AM_EXEEXT, [indir([AC_EXEEXT])])
AC_DEFUN(AM_FUNC_FNMATCH, [indir([AC_FUNC_FNMATCH])])
AC_DEFUN(AM_FUNC_MKTIME, [indir([AC_FUNC_MKTIME])])
# We cannot do this, because in libtool.m4 yet they provide
# this update.  Some solution is needed.
# AC_DEFUN(AM_PROG_LIBTOOL, [indir([AC_PROG_LIBTOOL])])
AC_DEFUN(AM_MINGW32, [indir([AC_MINGW32])])
AC_DEFUN(AM_PROG_INSTALL, [indir([AC_PROG_INSTALL])])
AC_DEFUN(fp_FUNC_FNMATCH, [indir([AC_FUNC_FNMATCH])])
