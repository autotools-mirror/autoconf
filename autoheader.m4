dnl Driver and redefinitions of some Autoconf macros for autoheader.
dnl This file is part of Autoconf.
dnl Copyright (C) 1994, 1995, 1999 Free Software Foundation, Inc.
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
dnl Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
dnl 02111-1307, USA.
dnl
dnl Written by Roland McGrath.
dnl
include(acgeneral.m4)dnl
m4_include(acspecific.m4)dnl
m4_include(acoldnames.m4)dnl


dnl These are alternate definitions of some macros, which produce
dnl strings in the output marked with "@@@" so we can easily extract
dnl the information we want.  The `#' at the end of the first line of
dnl each definition seems to be necessary to prevent m4 from eating
dnl the newline, which makes the @@@ not always be at the beginning of
dnl a line.

dnl AH_DEFINE(VARIABLE [, VALUE[, DESCRIPTION]])
dnl --------------------------------------------
dnl When running autoheader, this macro replaces AC_DEFINE and
dnl AC_DEFINE_UNQUOTED.
dnl
dnl We remember the symbols we already defined to avoid to define
dnl them twice.  In the future we may want to use another program
dnl than sh to issue the templates.  For instance with AWK, we
dnl may fill an associative array (key is $1, value is the template).
dnl This garantees that there is a unique prototype issued, and also
dnl that it will be sorted!
define([AH_DEFINE],
[ifset([$3],
       [AH_TEMPLATE([$1], [$3])],
       [#
dnl Ignore CPP macro arguments.
@@@syms="$syms patsubst($1, [(.*$])"@@@
])])

dnl AH_TEMPLATE(KEY, DESCRIPTION)
dnl Issue an autoheader template for KEY, i.e., a comment composed
dnl of DESCRIPTION (properly wrapped), and then #undef KEY.
define([AH_TEMPLATE],
[AH_VERBATIM([$1],
             AC_WRAP(_AC_SH_QUOTE([[$2 */]]), [   ], [/* ])[
#undef $1])])

dnl AH_VERBATIM(KEY, TEMPLATE)
dnl --------------------------
dnl If KEY is direct (i.e., no indirection such as in KEY=$my_func which may
dnl occur if there is AC_CHECK_FUNCS($my_func)), issue an autoheader TEMPLATE
dnl associated to the KEY.  Otherwise, do nothing.
dnl TEMPLATE is output as is, with no formating.
define([AH_VERBATIM],
[AC_VAR_IF_INDIR([$1],,
[#
@@@
ac_verbatim_$1="\
[$2]"
@@@
])])

define([AH_CHECK_LIB],
[AH_TEMPLATE(AC_TR_CPP(HAVE_$1),
             [Define if you have the `]$1[' library (-l]$1[).])
# Success
$3
# Failure
$4])

define([AH_CHECK_HEADERS],
[AC_FOREACH([AC_Header], [$1],
  [AH_TEMPLATE(AC_TR_CPP(HAVE_[]AC_Header),
               [Define if you have the <]AC_Header[> header file.])
# Success
$2
# Failure
$3])])

define([AH_NEED_DECLS],
[AC_FOREACH([AC_Symbol], [$1],
  [AH_TEMPLATE(AC_TR_CPP(NEED_DECL_[]AC_Symbol),
               [Define if you need the declaration of `]AC_Symbol['.])
# Success
$2
# Failure
$3])])

define([AH_CHECK_FUNCS],
[AC_FOREACH([AC_Func], [$1],
  [AH_TEMPLATE(AC_TR_CPP(HAVE_[]AC_Func),
               [Define if you have the `]AC_Func[' function.])
                # Success
                $2
                # Failure
                $3])
])

define([AH_CHECK_SIZEOF],
[AH_TEMPLATE(AC_TR_CPP(SIZEOF_$1),
             [The number of bytes in a `]$1['.])])

define([AH_PROG_LEX],
[AH_CHECK_LIB(fl)
AH_CHECK_LIB(l)])

define([AH_CHECK_MEMBERS],
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


define([AH_FUNC_ALLOCA],
[AH_TEMPLATE(HAVE_ALLOCA_H,
            [Define if you have <alloca.h> and it should be used
             (not on Ultrix).])
AH_TEMPLATE(HAVE_ALLOCA,
            [Define if you have `alloca', as a function or macro.])
AH_TEMPLATE(C_ALLOCA, [Define if using `alloca.c'.])
AH_TEMPLATE(CRAY_STACKSEG_END,
            [Define to one of _getb67, GETB67, getb67 for Cray-2 and Cray-YMP
             systems.  This function is required for alloca.c support on those
             systems.])
AH_VERBATIM([STACK_DIRECTION],
[/* If using the C implementation of alloca, define if you know the
   direction of stack growth for your system; otherwise it will be
   automatically deduced at run-time.
        STACK_DIRECTION > 0 => grows toward higher addresses
        STACK_DIRECTION < 0 => grows toward lower addresses
        STACK_DIRECTION = 0 => direction of growth unknown */
#undef STACK_DIRECTION
])
])dnl AH_FUNC_ALLOCA


define([AH_C_CHAR_UNSIGNED],
[AH_VERBATIM([__CHAR_UNSIGNED__],
[/* Define if type `char' is unsigned and you are not using gcc.  */
#ifndef __CHAR_UNSIGNED__
# undef __CHAR_UNSIGNED__
#endif])])


define([AH_AIX],
[AH_VERBATIM([_ALL_SOURCE],
[/* Define if on AIX 3.
   System headers sometimes define this.
   We just want to avoid a redefinition error message.  */
#ifndef _ALL_SOURCE
# undef _ALL_SOURCE
#endif])])


define([AH_F77_WRAPPERS],
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


define([AC_CONFIG_HEADER], [#
define([AC_CONFIG_H], patsubst($1, [ .*$], []))dnl
@@@config_h=AC_CONFIG_H@@@
])

dnl Install a new hook for AH_ macros.
define(AH_HOOK,
[m4_append([AH_HOOKS], [define([$1], defn([$2]))])])


dnl Autoheader is not the right program to complain about cross-compiling.
define([AC_TRY_RUN], [
$2
$3
$4])

AH_HOOK([AC_DEFINE], [AH_DEFINE])
AH_HOOK([AC_DEFINE_UNQUOTED], [AH_DEFINE])
AH_HOOK([AC_NEED_DECLS], [AH_NEED_DECLS])
AH_HOOK([AC_CHECK_SIZEOF], [AH_CHECK_SIZEOF])
AH_HOOK([AC_CHECK_FUNCS], [AH_CHECK_FUNCS])
AH_HOOK([AC_CHECK_HEADERS], [AH_CHECK_HEADERS])
AH_HOOK([AC_CHECK_HEADERS_DIRENT], [AH_CHECK_HEADERS])
AH_HOOK([AC_CHECK_MEMBERS], [AH_CHECK_MEMBERS])
AH_HOOK([AC_CHECK_LIB], [AH_CHECK_LIB])
AH_HOOK([AC_PROG_LEX], [AH_PROG_LEX])
AH_HOOK([AC_FUNC_ALLOCA], [AH_FUNC_ALLOCA])
AH_HOOK([AC_C_CHAR_UNSIGNED], [AH_C_CHAR_UNSIGNED])
AH_HOOK([AC_AIX], [AH_AIX])
AH_HOOK([AC_F77_WRAPPERS], [AH_F77_WRAPPERS])

dnl Install the AH_HOOKS
AH_HOOKS
