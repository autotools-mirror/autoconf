include(libm4.m4)#                                          -*- Autoconf -*-
# This file is part of Autoconf.
# Driver and redefinitions of some Autoconf macros for autoheader.
# Copyright (C) 1994, 1995, 1999 Free Software Foundation, Inc.
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
# Originally written by Roland McGrath.
#
# Do not sinclude acsite.m4 here, because it may not be installed
# yet when Autoconf is frozen.
# Do not sinclude ./aclocal.m4 here, to prevent it from being frozen.
m4_include(acversion.m4)
m4_include(acgeneral.m4)
m4_include(acspecific.m4)
m4_include(acoldnames.m4)


# AH_DEFUN(MACRO, VALUE)
# ----------------------
#
# Assign VALUE *and* the current value of MACRO to MACRO, in the
# namespace `autoheader'.  We enter the namespace `autoheader' when
# running autoheader.
#
# There are several motivations for not just defining to be equivalent to
# AUTOHEADER-NAME.
#
# Let autoconf::AC_FOO (abbreviated AC_FOO below) be
#   | AC_DEFINE(FOO, 1)
#   | AC_DEFINE(BAR, 1)
#   | AC_DEFINE(BAZ, 1, The value of BAZ.)
# Let autoheader::AC_FOO (abbreviated AH_FOO below) be
#   | AH_TEMPLATE(FOO, The value of FOO.)
#
# If we hook AC_FOO to be AH_FOO only, then only FOO will be templated.
# If we hook AC_FOO to expand in both the former AC_FOO and AH_FOO, then
# both FOO and BAZ are templated.
#
# Additionaly, if AC_FOO is hooked to AH_FOO only, then we loose track
# of the other AC_DEFINE, and the autoheader machinery (see the use of
# the shell variable SYMS in AC_TEMPLATE) won't be able to see that BAR
# is not templated at all.  Hooking AC_FOO on both its AC_ and AH_ faces
# makes sure we keep track of non templated DEFINEs.
#
#
# Finally, if AC_FOO requires a macro which AC_DEFINEs a symbol,
# then, if we used AH_FOO only, the required macro would not be
# expanded, thus its symbols would not be prototyped.
define(AH_DEFUN,
[m4_namespace_define(autoheader, [$1],
defn([$1])
[$2])])


# These are alternate definitions of some macros, which produce
# strings in the output marked with "@@@" so we can easily extract
# the information we want.  The `#' at the end of the first line of
# each definition seems to be necessary to prevent m4 from eating
# the newline, which makes the @@@ not always be at the beginning of
# a line.


# Autoheader is not the right program to complain about cross-compiling.
AH_DEFUN([AC_TRY_RUN],
[$2
$3
$4])


# AH_DEFINE(VARIABLE, [VALUE], [DESCRIPTION])
# -------------------------------------------
# When running autoheader, this macro replaces AC_DEFINE and
# AC_DEFINE_UNQUOTED.
#
# If DESCRIPTION is not given, then there is a risk that VARIABLE will
# not be properly templated.  To control later that it has been
# templated elsewhere, store VARIABLE in a shell growing string, SYMS.
AH_DEFUN([AH_DEFINE],
[ifval([$3],
       [AH_TEMPLATE([$1], [$3])],
       [#
dnl Ignore CPP macro arguments.
@@@syms="$syms patsubst($1, [(.*$])"@@@
])])

AH_DEFUN([AC_DEFINE],          [AH_DEFINE($@)])
AH_DEFUN([AC_DEFINE_UNQUOTED], [AH_DEFINE($@)])


# AH_TEMPLATE(KEY, DESCRIPTION)
# -----------------------------
# Issue an autoheader template for KEY, i.e., a comment composed
# of DESCRIPTION (properly wrapped), and then #undef KEY.
AH_DEFUN([AH_TEMPLATE],
[AH_VERBATIM([$1],
             m4_wrap([$2 */], [   ], [/* ])[
#undef $1])])


# AH_VERBATIM(KEY, TEMPLATE)
# --------------------------
# If KEY is direct (i.e., no indirection such as in KEY=$my_func which may
# occur if there is AC_CHECK_FUNCS($my_func)), issue an autoheader TEMPLATE
# associated to the KEY.  Otherwise, do nothing.
# TEMPLATE is output as is, with no formating.
AH_DEFUN([AH_VERBATIM],
[AC_VAR_IF_INDIR([$1],,
[#
@@@
ac_verbatim_$1="\
_AC_SH_QUOTE([$2])"
@@@
])])

# FIXME: To be rigorous, this should not be systematic: depending
# upon the arguments of AC_CHECK_LIB, we might not AC_DEFINE.
AH_DEFUN([AC_CHECK_LIB],
[AH_TEMPLATE(AC_TR_CPP(HAVE_LIB$1),
             [Define if you have the `]$1[' library (-l]$1[).])
# Success
$3
# Failure
$4])

AH_DEFUN([AH_CHECK_HEADERS],
[AC_FOREACH([AC_Header], [$1],
  [AH_TEMPLATE(AC_TR_CPP(HAVE_[]AC_Header),
               [Define if you have the <]AC_Header[> header file.])
   # Success
   $2
   # Failure
   $3])])

AH_DEFUN([AC_CHECK_HEADERS], [AH_CHECK_HEADERS($@)])
AH_DEFUN([AC_CHECK_HEADERS_DIRENT], [AH_CHECK_HEADERS($@)])

AH_DEFUN([AC_CHECK_DECLS],
[m4_foreach([AC_Symbol], [$1],
  [AH_TEMPLATE(AC_TR_CPP([NEED_]AC_Symbol[_DECL]),
               [Define if you need the declaration of `]AC_Symbol['.])
   # Success
   $2
   # Failure
   $3])])


AH_DEFUN([AC_CHECK_FUNCS],
[AC_FOREACH([AC_Func], [$1],
  [AH_TEMPLATE(AC_TR_CPP(HAVE_[]AC_Func),
               [Define if you have the `]AC_Func[' function.])
   # Success
   $2
   # Failure
   $3])
])

AH_DEFUN([AC_CHECK_SIZEOF],
[AH_TEMPLATE(AC_TR_CPP(SIZEOF_$1),
             [The number of bytes in a `]$1['.])])


AH_DEFUN([AC_PROG_LEX],
[AC_CHECK_LIB(fl)
AC_CHECK_LIB(l)])


AH_DEFUN([AC_CHECK_MEMBERS],
[m4_foreach([AC_Member], [$1],
  [pushdef(AC_Member_Aggregate, [patsubst(AC_Member, [\.[^.]*])])
   pushdef(AC_Member_Member,    [patsubst(AC_Member, [.*\.])])
   AH_TEMPLATE(AC_TR_CPP(HAVE_[]AC_Member),
               [Define if `]AC_Member_Member[' is member of]
               [`]AC_Member_Aggregate['.])
   popdef([AC_Member_Member])
   popdef([AC_Member_Aggregate])
   # Success
   $2
   # Failure
   $3])
])


# AC_CHECK_TYPE(TYPE, SUBTITUTE)
# ------------------------------
AH_DEFUN([AC_CHECK_TYPE],
[AH_TEMPLATE([$1], [Define to `$2' if <sys/types.h> does not define.])])


# AC_FUNC_ALLOCA
# --------------
AH_DEFUN([AC_FUNC_ALLOCA],
[AH_VERBATIM([STACK_DIRECTION],
[/* If using the C implementation of alloca, define if you know the
   direction of stack growth for your system; otherwise it will be
   automatically deduced at run-time.
        STACK_DIRECTION > 0 => grows toward higher addresses
        STACK_DIRECTION < 0 => grows toward lower addresses
        STACK_DIRECTION = 0 => direction of growth unknown */
#undef STACK_DIRECTION])
])dnl AH_FUNC_ALLOCA


# AH_CHECK_TYPES((TYPES, ...))
# ----------------------------
AH_DEFUN([AC_CHECK_TYPES],
[m4_foreach([AC_Type], [$1],
  [AH_TEMPLATE(AC_TR_CPP(HAVE_[]AC_Type),
               [Define if the system has the type `]AC_Type['.])
   # Success
   $2
   # Failure
   $3])
])


AH_DEFUN([AC_C_CHAR_UNSIGNED],
[AH_VERBATIM([__CHAR_UNSIGNED__],
[/* Define if type `char' is unsigned and you are not using gcc.  */
#ifndef __CHAR_UNSIGNED__
# undef __CHAR_UNSIGNED__
#endif])
])


AH_DEFUN([AC_AIX],
[AH_VERBATIM([_ALL_SOURCE],
[/* Define if on AIX 3.
   System headers sometimes define this.
   We just want to avoid a redefinition error message.  */
#ifndef _ALL_SOURCE
# undef _ALL_SOURCE
#endif])
])


AH_DEFUN([AC_F77_WRAPPERS],
[AH_TEMPLATE([F77_FUNC],
             [Define to a macro that performs the appropriate name
              mangling on its argument to make the C identifier, which
              *does not* contain underscores, match the name mangling
              scheme of the Fortran 77 compiler.])
AH_TEMPLATE([F77_FUNC_],
             [Define to a macro that performs the appropriate name
              mangling on its argument to make the C identifier, which
              *does* contain underscores, match the name mangling
              scheme of the Fortran 77 compiler.])])


AH_DEFUN([AC_CONFIG_HEADERS],
[@@@config_h=patsubst($1, [ .*$], [])@@@
])

# Enter the `autoheader' name space
m4_enable(autoheader)
