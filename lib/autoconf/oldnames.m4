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
# Originally written by David J. MacKenzie.

## -------------- ##
## Presentation.  ##
## -------------- ##

# This file is in charge both of providing implementation of
# obsoleted macros, and to give autoupdate a means to update old
# files.


# Formerly, updating was performed by running `sed', but it was
# limited to just replacing the old names with newer names, nothing
# was possible when real glue code was needed.  One could think to
# extend the `sed' snippet with specialized code for complex macros.
# But this approach is of course full of flaws:

# a. the Autoconf maintainers have to write these snippets, which we
#    just don't want to,

# b. I really don't think you'll ever manage to handle the quoting of
#    m4 from sed.

# To satisfy a., let's remark that the code which implements the old
# features in term of the new feature is exactly the code which
# should replace the old code.

# To answer point b, as usual in the history of Autoconf, the answer,
# at least on the paper, is simple: m4 is the best tool to parse m4,
# so let's use m4.

# Therefore the specification is as follow:

#     I want to be able to tell Autoconf, well, m4, that the macro I
#     am currently defining is an obsolete macro (so that the user is
#     warned), which code is the code to use when running autoconf,
#     but that the very same code has to be used when running
#     autoupdate.  To summarize, the interface I want is
#     `AU_DEFUN(OLD-NAME, NEW-CODE)'.



# Now for the technical details.

# When running autoconf, except for the warning, AU_DEFUN is
# basically AC_DEFUN.

# When running autoupdate, we want *only* OLD-NAMEs to be expanded.
# This obviously means that acgeneral.m4 and acspecific.m4 must not
# be loaded.  Nonetheless, because we want to use a rich set of m4
# features, libm4.m4 is needed.  Please note that the fact that
# autoconf's macros are not loaded is positive on two points:

# - we do get an updated `configure.in', not a `configure'!

# - the old macros are replaced by *calls* to the new-macros, not the
#   body of the new macros, since their body is not defined!!!
#   (Whoa, that's really beautiful!).

# This first draft is quite functional, but there is a big flaw:
# obsolete macros that are quoted will not be updated (since m4 won't
# even try to expand them).  The solution is simple: we should just
# disable the quotes.  Well, not quite: libm4.m4 still needs to use
# quotes for some macros.  Well, in this case, when running in
# autoupdate code, each macro first reestablishes the quotes, expands
# itself, and disables the quotes.

# Thinking a bit more, you realize that in fact, people may use `define'
# `ifelse' etc. in their files, and you certainly don't want to process
# them.  Another example is `dnl': you don't want to remove the comments.
# You then realize you don't want exactly to import libm4: you want
# to specify when it is enabled (macros active), and disabled.
# libm4 provides m4_disable/m4_enable to this end.

# You're getting close to it.  Now remains one task: how to handle
# twofold definitions?

# Remember that the same AU_DEFUN must be understand in two different
# ways, the AC_ way, and the AU_ way.

# One first solution is to check whether acgeneral.m4 was loaded.
# But that's definitely not cute.  Another is simply to install
# `hooks', that is to say, to keep in some place m4 knows, late
# `define' to be triggered *only* in AU_ mode.

# You first think to design AU_DEFUN like this:

# 1. AC_DEFUN(OLD-NAME,
# 	      [Warn the user OLD-NAME is obsolete.
# 	       NEW-CODE])

# 2. Store for late AU_ binding([define(OLD_NAME,
# 				 [Reestablish the quotes.
# 				  NEW-CODE
# 				  Disable the quotes.])])

# but this will not work: NEW-CODE has probably $1, $2 etc. and these
# guys will be replaced with the argument of `Store for late AU_
# binding' when you call it.

# I don't think there is a means to avoid this using this technology
# (remember that $1 etc. are *always* expanded in m4).  You may also
# try to replace them with $[1] to preserve them for a later
# evaluation, but if `Store for late AU_ binding' is properly
# written, it will remain quoted till the end...

# You have to change technology.  Since the problem is that `$1'
# etc. should be `consumed' right away, one solution is to define now
# a second macro, `AU_OLD-NAME', and to install a hook than binds
# OLD-NAME to AU_OLD-NAME.  Then, autoupdate.m4 just need to run the
# hooks.  By the way, the same method is used in autoheader.





## ---------------------------- ##
## General macros of autoconf.  ##
## ---------------------------- ##

AU_DEFUN(AC_WARN, [AC_MSG_WARN($@)])
AU_DEFUN(AC_ERROR, [AC_MSG_ERROR($@)])
AU_DEFUN(AC_FUNC_CHECK, [AC_CHECK_FUNC($@)])
AU_DEFUN(AC_HAVE_FUNCS, [AC_CHECK_FUNCS($@)])
AU_DEFUN(AC_HAVE_HEADERS, [AC_CHECK_HEADERS($@)])
AU_DEFUN(AC_HEADER_CHECK, [AC_CHECK_HEADER($@)])
AU_DEFUN(AC_HEADER_EGREP, [AC_EGREP_HEADER($@)])
AU_DEFUN(AC_PREFIX, [AC_PREFIX_PROGRAM($@)])
AU_DEFUN(AC_PROGRAMS_CHECK, [AC_CHECK_PROGS($@)])
AU_DEFUN(AC_PROGRAMS_PATH, [AC_PATH_PROGS($@)])
AU_DEFUN(AC_PROGRAM_CHECK, [AC_CHECK_PROG($@)])
AU_DEFUN(AC_PROGRAM_EGREP, [AC_EGREP_CPP($@)])
AU_DEFUN(AC_PROGRAM_PATH, [AC_PATH_PROG($@)])
AU_DEFUN(AC_SIZEOF_TYPE, [AC_CHECK_SIZEOF($@)])
AU_DEFUN(AC_TEST_CPP, [AC_TRY_CPP($@)])
AU_DEFUN(AC_TEST_PROGRAM, [AC_TRY_RUN($@)])



## ----------------------------- ##
## Specific macros of autoconf.  ##
## ----------------------------- ##

AU_DEFUN(AC_ALLOCA, [AC_FUNC_ALLOCA])
AU_DEFUN(AC_CHAR_UNSIGNED, [AC_C_CHAR_UNSIGNED])
AU_DEFUN(AC_CONST, [AC_C_CONST])
AU_DEFUN(AC_CROSS_CHECK, [AC_C_CROSS])
AU_DEFUN(AC_FIND_X, [AC_PATH_X])
AU_DEFUN(AC_FIND_XTRA, [AC_PATH_XTRA])
AU_DEFUN(AC_GCC_TRADITIONAL, [AC_PROG_GCC_TRADITIONAL])
AU_DEFUN(AC_GETGROUPS_T, [AC_TYPE_GETGROUPS])
AU_DEFUN(AC_GETLOADAVG, [AC_FUNC_GETLOADAVG])
AU_DEFUN(AC_INLINE, [AC_C_INLINE])
AU_DEFUN(AC_LN_S, [AC_PROG_LN_S])
AU_DEFUN(AC_LONG_DOUBLE, [AC_C_LONG_DOUBLE])
AU_DEFUN(AC_LONG_FILE_NAMES, [AC_SYS_LONG_FILE_NAMES])
AU_DEFUN(AC_MAJOR_HEADER, [AC_HEADER_MAJOR])
AU_DEFUN(AC_MINUS_C_MINUS_O, [AC_PROG_CC_C_O])
AU_DEFUN(AC_MMAP, [AC_FUNC_MMAP])
AU_DEFUN(AC_MODE_T, [AC_TYPE_MODE_T])
AU_DEFUN(AC_OFF_T, [AC_TYPE_OFF_T])
AU_DEFUN(AC_PID_T, [AC_TYPE_PID_T])
AU_DEFUN(AC_RESTARTABLE_SYSCALLS, [AC_SYS_RESTARTABLE_SYSCALLS])
AU_DEFUN(AC_RETSIGTYPE, [AC_TYPE_SIGNAL])
AU_DEFUN(AC_SETVBUF_REVERSED, [AC_FUNC_SETVBUF_REVERSED])
AU_DEFUN(AC_SET_MAKE, [AC_PROG_MAKE_SET])
AU_DEFUN(AC_SIZE_T, [AC_TYPE_SIZE_T])
AU_DEFUN(AC_STAT_MACROS_BROKEN, [AC_HEADER_STAT])
AU_DEFUN(AC_STDC_HEADERS, [AC_HEADER_STDC])
AU_DEFUN(AC_STRCOLL, [AC_FUNC_STRCOLL])
AU_DEFUN(AC_ST_BLKSIZE, [AC_STRUCT_ST_BLKSIZE])
AU_DEFUN(AC_ST_BLOCKS, [AC_STRUCT_ST_BLOCKS])
AU_DEFUN(AC_ST_RDEV, [AC_STRUCT_ST_RDEV])
AU_DEFUN(AC_SYS_SIGLIST_DECLARED, [AC_DECL_SYS_SIGLIST])
AU_DEFUN(AC_TIMEZONE, [AC_STRUCT_TIMEZONE])
AU_DEFUN(AC_TIME_WITH_SYS_TIME, [AC_HEADER_TIME])
AU_DEFUN(AC_UID_T, [AC_TYPE_UID_T])
AU_DEFUN(AC_UTIME_NULL, [AC_FUNC_UTIME_NULL])
AU_DEFUN(AC_VFORK, [AC_FUNC_VFORK])
AU_DEFUN(AC_VPRINTF, [AC_FUNC_VPRINTF])
AU_DEFUN(AC_WAIT3, [AC_FUNC_WAIT3])
AU_DEFUN(AC_WORDS_BIGENDIAN, [AC_C_BIGENDIAN])
AU_DEFUN(AC_YYTEXT_POINTER, [AC_DECL_YYTEXT])
AU_DEFUN(AM_CYGWIN32, [AC_CYGWIN32])
AU_DEFUN(AM_EXEEXT, [AC_EXEEXT])
AU_DEFUN(AM_FUNC_FNMATCH, [AC_FUNC_FNMATCH])
AU_DEFUN(AM_FUNC_MKTIME, [AC_FUNC_MKTIME])
# We cannot do this, because in libtool.m4 yet they provide
# this update.  Some solution is needed.
# AU_DEFUN(AM_PROG_LIBTOOL, [AC_PROG_LIBTOOL])
AU_DEFUN(AM_MINGW32, [AC_MINGW32])
AU_DEFUN(AM_PROG_INSTALL, [AC_PROG_INSTALL])
AU_DEFUN(fp_FUNC_FNMATCH, [AC_FUNC_FNMATCH])
