# This file is part of Autoconf.                       -*- Autoconf -*-
# Programming languages support.
# Copyright (C) 1992, 93, 94, 95, 96, 98, 99, 2000
# Free Software Foundation, Inc.
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
# As a special exception, the Free Software Foundation gives unlimited
# permission to copy, distribute and modify the configure scripts that
# are the output of Autoconf.  You need not follow the terms of the GNU
# General Public License when using or distributing such scripts, even
# though portions of the text of Autoconf appear in them.  The GNU
# General Public License (GPL) does govern all other use of the material
# that constitutes the Autoconf program.
#
# Certain portions of the Autoconf source text are designed to be copied
# (in certain cases, depending on the input) into the output of
# Autoconf.  We call these the "data" portions.  The rest of the Autoconf
# source text consists of comments plus executable code that decides which
# of the data portions to output in any given case.  We call these
# comments and executable code the "non-data" portions.  Autoconf never
# copies any of the non-data portions into its output.
#
# This special exception to the GPL applies to versions of Autoconf
# released by the Free Software Foundation.  When you make and
# distribute a modified version of Autoconf, you may extend this special
# exception to the GPL to apply to your modified version as well, *unless*
# your modified version has the potential to copy into its output some
# of the text that was the non-data portion of the version that you started
# with.  (In other words, unless your change moves or copies text from
# the non-data portions to the data portions.)  If your modification has
# such potential, you must delete any notice of this special exception
# to the GPL from your modified version.
#
# Written by David MacKenzie, with help from
# Franc,ois Pinard, Karl Berry, Richard Pixley, Ian Lance Taylor,
# Roland McGrath, Noah Friedman, david d zuhn, and many others.


# Table of Contents:
#
# 1. Language selection
#    and routines to produce programs in a given language.
#  a. generic routines
#  b. C
#  c. C++
#  d. Fortran 77
#
# 2. Producing programs in a given language.
#  a. generic routines
#  b. C
#  c. C++
#  d. Fortran 77
#
# 3. Looking for a compiler
#    And possibly the associated preprocessor.
#  a. Generic routines.
#  b. C
#  c. C++
#  d. Fortran 77
#
# 4. Compilers' characteristics.
#  a. Generic routines.
#  b. C
#  c. C++
#  d. Fortran 77



## ----------------------- ##
## 1. Language selection.  ##
## ----------------------- ##



# -------------------------------- #
# 1a. Generic language selection.  #
# -------------------------------- #

# AC_LANG_CASE(LANG1, IF-LANG1, LANG2, IF-LANG2, ..., DEFAULT)
# ------------------------------------------------------------
# Expand into IF-LANG1 if the current language is LANG1 etc. else
# into default.
define([AC_LANG_CASE],
[m4_case(_AC_LANG, $@)])


# _AC_LANG_DISPATCH(MACRO, LANG, ARGS)
# ------------------------------------
# Call the specialization of MACRO for LANG with ARGS.  Complain if
# unavailable.
define([_AC_LANG_DISPATCH],
[ifdef([$1($2)],
       [indir([$1($2)], m4_shiftn(2, $@))],
       [AC_FATAL([$1: unknown language: $2])])])


# AC_LANG(LANG)
# -------------
# Set the current language to LANG.
#
# Do *not* write AC_LANG([$1]), because this pair of parens do not
# correspond to an evaluation, rather, they are just part of the name.
# If you add quotes here, they will be part of the name too, yielding
# `AC_LANG([C])' for instance, which does not exist.
AC_DEFUN([AC_LANG],
[define([_AC_LANG], [$1])dnl
_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_PUSH(LANG)
# ------------------
# Save the current language, and use LANG.
define([AC_LANG_PUSH],
[pushdef([_AC_LANG])dnl
AC_LANG([$1])])


# AC_LANG_POP
# -----------
# Restore the previous language.
define([AC_LANG_POP],
[popdef([_AC_LANG])dnl
ifelse(_AC_LANG, [_AC_LANG],
        [AC_FATAL([too many $0])])dnl
AC_LANG(_AC_LANG)])


# AC_LANG_SAVE
# ------------
# Save the current language, but don't change language.
AU_DEFUN([AC_LANG_SAVE],
[AC_DIAGNOSE([obsolete],
             [instead of using `AC_LANG', `AC_LANG_SAVE',
and `AC_LANG_RESTORE', you should use `AC_LANG_PUSH' and `AC_LANG_POP'.])
pushdef([_AC_LANG], _AC_LANG)])


# AC_LANG_RESTORE
# ---------------
# Restore the current language from the stack.
AU_DEFUN([AC_LANG_RESTORE], [AC_LANG_POP($@)])



# -------------------- #
# 1b. The C language.  #
# -------------------- #


# AC_LANG(C)
# ----------
define([AC_LANG(C)],
[ac_ext=c
# CFLAGS is not in ac_cpp because -g, -O, etc. are not valid cpp options.
ac_cpp='$CPP $CPPFLAGS'
ac_compile='${CC-cc} -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&AC_FD_LOG'
ac_link='${CC-cc} -o conftest${ac_exeext} $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&AC_FD_LOG'
])


# AC_LANG_C
# ---------
AU_DEFUN([AC_LANG_C], [AC_LANG(C)])



# ---------------------- #
# 1c. The C++ language.  #
# ---------------------- #


# AC_LANG(C++)
# ------------
define([AC_LANG(C++)],
[ac_ext=cc
# CXXFLAGS is not in ac_cpp because -g, -O, etc. are not valid cpp options.
ac_cpp='$CXXCPP $CPPFLAGS'
ac_compile='${CXX-g++} -c $CXXFLAGS $CPPFLAGS conftest.$ac_ext >&AC_FD_LOG'
ac_link='${CXX-g++} -o conftest${ac_exeext} $CXXFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&AC_FD_LOG'
])


# AC_LANG_CPLUSPLUS
# -----------------
AU_DEFUN([AC_LANG_CPLUSPLUS], [AC_LANG(C++)])



# ----------------------------- #
# 1d. The Fortran 77 language.  #
# ----------------------------- #


# AC_LANG(Fortran 77)
# -------------------
define([AC_LANG(Fortran 77)],
[ac_ext=f
ac_compile='${F77-f77} -c $FFLAGS conftest.$ac_ext >&AC_FD_LOG'
ac_link='${F77-f77} -o conftest${ac_exeext} $FFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&AC_FD_LOG'
])


# AC_LANG_FORTRAN77
# -----------------
AU_DEFUN([AC_LANG_FORTRAN77], [AC_LANG(Fortran 77)])






## ---------------------- ##
## 2.Producing programs.  ##
## ---------------------- ##

# ---------------------- #
# 2a. Generic routines.  #
# ---------------------- #

# AC_LANG_SOURCE(BODY)
# --------------------
# Produce a valid source for the current language, which includes the
# BODY.  Include the `#line' sync lines.
AC_DEFUN([AC_LANG_SOURCE],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_PROGRAM([PROLOGUE], [BODY])
# -----------------------------------
# Produce a valid source for the current language.  Prepend the
# PROLOGUE (typically CPP directives and/or declarations) to an
# execution the BODY (typically glued inside the `main' function, or
# equivalent).
AC_DEFUN([AC_LANG_PROGRAM],
[AC_LANG_SOURCE([_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])])


# AC_LANG_CALL(PROLOGUE, FUNCTION)
# --------------------------------
# Call the FUNCTION.
AC_DEFUN([AC_LANG_CALL],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_FUNC_LINK_TRY(FUNCTION)
# -------------------------------
# Produce a source which links correctly iff the FUNCTION exists.
AC_DEFUN([AC_LANG_FUNC_LINK_TRY],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_BOOL_COMPILE_TRY(PROLOGUE, EXPRESSION)
# ----------------------------------------------
# Produce a program that compiles with success iff the boolean EXPRESSION
# evaluates to true at compile time.
AC_DEFUN([AC_LANG_BOOL_COMPILE_TRY],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_INT_SAVE(PROLOGUE, EXPRESSION)
# --------------------------------------
# Produce a program that saves the runtime evaluation of the integer
# EXPRESSION into `conftestval'.
AC_DEFUN([AC_LANG_INT_SAVE],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# --------------- #
# 2b. C sources.  #
# --------------- #

# AC_LANG_SOURCE(C)(BODY)
# -----------------------
# This sometimes fails to find confdefs.h, for some reason.
# #line __oline__ "$[0]"
define([AC_LANG_SOURCE(C)],
[#line __oline__ "configure"
#include "confdefs.h"
$1])


# AC_LANG_PROGRAM(C)([PROLOGUE], [BODY])
# --------------------------------------
define([AC_LANG_PROGRAM(C)],
[$1
int
main ()
{
dnl Do *not* indent the following line: there may be CPP directives.
dnl Don't move the `;' right after for the same reason.
$2
  ;
  return 0;
}])


# AC_LANG_CALL(C)(PROLOGUE, FUNCTION)
# -----------------------------------
# Avoid conflicting decl of main.
define([AC_LANG_CALL(C)],
[AC_LANG_PROGRAM([$1
ifelse([$2], [main], ,
[/* Override any gcc2 internal prototype to avoid an error.  */
#ifdef __cplusplus
extern "C"
#endif
/* We use char because int might match the return type of a gcc2
   builtin and then its argument prototype would still apply.  */
char $2 ();])], [$2 ();])])


# AC_LANG_FUNC_LINK_TRY(C)(FUNCTION)
# ----------------------------------
# Don't include <ctype.h> because on OSF/1 3.0 it includes
# <sys/types.h> which includes <sys/select.h> which contains a
# prototype for select.  Similarly for bzero.
define([AC_LANG_FUNC_LINK_TRY(C)],
[AC_LANG_PROGRAM(
[/* System header to define __stub macros and hopefully few prototypes,
    which can conflict with char $1 (); below.  */
#include <assert.h>
/* Override any gcc2 internal prototype to avoid an error.  */
#ifdef __cplusplus
extern "C"
#endif
/* We use char because int might match the return type of a gcc2
   builtin and then its argument prototype would still apply.  */
char $1 ();
char (*f) ();
],
[/* The GNU C library defines this for functions which it implements
    to always fail with ENOSYS.  Some functions are actually named
    something starting with __ and the normal name is an alias.  */
#if defined (__stub_$1) || defined (__stub___$1)
choke me
#else
f = $1;
#endif
])])


# AC_LANG_BOOL_COMPILE_TRY(C)(PROLOGUE, EXPRESSION)
# -------------------------------------------------
define([AC_LANG_BOOL_COMPILE_TRY(C)],
[AC_LANG_PROGRAM([$1], [int _array_ @<:@1 - 2 * !($2)@:>@])])


# AC_LANG_INT_SAVE(C)(PROLOGUE, EXPRESSION)
# -----------------------------------------
# We need `stdio.h' to open a `FILE', so the prologue defaults to the
# inclusion of `stdio.h'.
define([AC_LANG_INT_SAVE(C)],
[AC_LANG_PROGRAM([m4_default([$1], [@%:@include "stdio.h"])],
[FILE *f = fopen ("conftestval", "w");
if (!f)
  exit (1);
fprintf (f, "%d\n", ($2));])])


# ----------------- #
# 2c. C++ sources.  #
# ----------------- #

# AC_LANG_SOURCE(C++)(BODY)
# -------------------------
define([AC_LANG_SOURCE(C++)],
[#line __oline__ "configure"
#include "confdefs.h"
#ifdef __cplusplus
extern "C" void exit (int);
#endif
$1])


# AC_LANG_PROGRAM(C++)([PROLOGUE], [BODY])
# ----------------------------------------
# Same as C.
define([AC_LANG_PROGRAM(C++)], defn([AC_LANG_PROGRAM(C)]))


# AC_LANG_CALL(C++)(PROLOGUE, FUNCTION)
# -------------------------------------
# Same as C.
define([AC_LANG_CALL(C++)], defn([AC_LANG_CALL(C)]))


# AC_LANG_FUNC_LINK_TRY(C++)(FUNCTION)
# ------------------------------------
# Same as C.
define([AC_LANG_FUNC_LINK_TRY(C++)], defn([AC_LANG_FUNC_LINK_TRY(C)]))


# AC_LANG_BOOL_COMPILE_TRY(C++)(PROLOGUE, EXPRESSION)
# ---------------------------------------------------
# Same as C.
define([AC_LANG_BOOL_COMPILE_TRY(C++)], defn([AC_LANG_BOOL_COMPILE_TRY(C)]))


# AC_LANG_INT_SAVE(C++)(PROLOGUE, EXPRESSION)
# -------------------------------------------
# Same as C.
define([AC_LANG_INT_SAVE(C++)], defn([AC_LANG_INT_SAVE_TRY(C)]))



# ------------------------ #
# 2d. Fortran 77 sources.  #
# ------------------------ #

# AC_LANG_SOURCE(Fortran 77)(BODY)
# --------------------------------
# FIXME: Apparently, according to former AC_TRY_COMPILER, the CPP
# directives must not be included.  But AC_TRY_RUN_NATIVE was not
# avoiding them, so?
define([AC_LANG_SOURCE(Fortran 77)],
[$1])


# AC_LANG_PROGRAM(Fortran 77)([PROLOGUE], [BODY])
# -----------------------------------------------
# Yes, we discard the PROLOGUE.
define([AC_LANG_PROGRAM(Fortran 77)],
[      program main
$2
      end])


# AC_LANG_CALL(Fortran 77)(PROLOGUE, FUNCTION)
# --------------------------------------------
# FIXME: This is a guess, help!
define([AC_LANG_CALL(Fortran 77)],
[AC_LANG_PROGRAM([$1],
[      call $2])])




## -------------------------------------------- ##
## 3. Looking for Compilers and Preprocessors.  ##
## -------------------------------------------- ##

# ----------------------------------------------------- #
# 3a. Generic routines in compilers and preprocessors.  #
# ----------------------------------------------------- #

# AC_REQUIRE_CPP
# --------------
# Require finding the C or C++ preprocessor, whichever is the
# current language.
AC_DEFUN([AC_REQUIRE_CPP],
[AC_LANG_CASE(C, [AC_REQUIRE([AC_PROG_CPP])],
                 [AC_REQUIRE([AC_PROG_CXXCPP])])])


# AC_LANG_COMPILER_WORKS
# ----------------------
define([_AC_LANG_COMPILER_WORKS],
[AC_MSG_CHECKING([whether the _AC_LANG compiler works])
AC_LINK_IFELSE([AC_LANG_PROGRAM()],
[# FIXME: these cross compiler hacks should be removed for autoconf 3.0
# If not cross compiling, check that we can run a simple program.
if test "$cross_compiling" != yes; then
  if AC_TRY_COMMAND(./conftest); then
    cross_compiling=no
  else
    if test "$cross_compiling" = maybe; then
      cross_compiling=yes
    else
      AC_MSG_ERROR([cannot run _AC_LANG compiled programs.
To enable cross compilation, use `--host'.])
    fi
  fi
fi
AC_MSG_RESULT(yes)],
[AC_MSG_RESULT(no)
AC_MSG_ERROR([_AC_LANG compiler cannot create executables], 77)])[]dnl
AC_MSG_CHECKING([whether we are cross compiling])
AC_MSG_RESULT($cross_compiling)
])# AC_LANG_COMPILER_WORKS


# -------------------- #
# 3b. The C compiler.  #
# -------------------- #


# AC_PROG_CPP
# -----------
AC_DEFUN([AC_PROG_CPP],
[AC_MSG_CHECKING(how to run the C preprocessor)
# On Suns, sometimes $CPP names a directory.
if test -n "$CPP" && test -d "$CPP"; then
  CPP=
fi
if test -z "$CPP"; then
AC_CACHE_VAL(ac_cv_prog_CPP,
[  # This must be in double quotes, not single quotes, because CPP may get
  # substituted into the Makefile and "${CC-cc}" will confuse make.
  CPP="${CC-cc} -E"
  # On the NeXT, cc -E runs the code through the compiler's parser,
  # not just through cpp.
dnl Use a header file that comes with gcc, so configuring glibc
dnl with a fresh cross-compiler works.
  AC_TRY_CPP([#include <assert.h>
Syntax Error], ,
  CPP="${CC-cc} -E -traditional-cpp"
  AC_TRY_CPP([#include <assert.h>
Syntax Error], ,
  CPP="${CC-cc} -nologo -E"
  AC_TRY_CPP([#include <assert.h>
Syntax Error], , CPP=/lib/cpp)))
  ac_cv_prog_CPP=$CPP])dnl
  CPP=$ac_cv_prog_CPP
else
  ac_cv_prog_CPP=$CPP
fi
AC_MSG_RESULT($CPP)
AC_SUBST(CPP)dnl
])# AC_PROG_CPP


# AC_PROG_CC([COMPILER ...])
# --------------------------
# COMPILER ... is a space separated list of C compilers to search for.
# This just gives the user an opportunity to specify an alternative
# search list for the C compiler.
AC_DEFUN([AC_PROG_CC],
[AC_BEFORE([$0], [AC_PROG_CPP])dnl
AC_LANG_PUSH(C)
AC_ARG_VAR([CFLAGS], [Extra flags for the C compiler])
ifval([$1],
      [AC_CHECK_TOOLS(CC, [$1])],
[
  AC_CHECK_TOOL(CC, gcc)
  if test -z "$CC"; then
    AC_CHECK_PROG(CC, cc, cc, , , /usr/ucb/cc)
    if test -z "$CC"; then
      AC_CHECK_PROGS(CC, cl)
    fi
  fi
])

test -z "$CC" && AC_MSG_ERROR([no acceptable cc found in \$PATH])

_AC_LANG_COMPILER_WORKS
_AC_PROG_CC_GNU

dnl Check whether -g works, even if CFLAGS is set, in case the package
dnl plays around with CFLAGS (such as to build both debugging and
dnl normal versions of a library), tasteless as that idea is.
ac_test_CFLAGS=${CFLAGS+set}
ac_save_CFLAGS=$CFLAGS
CFLAGS=
_AC_PROG_CC_G
if test "$ac_test_CFLAGS" = set; then
  CFLAGS=$ac_save_CFLAGS
elif test $ac_cv_prog_cc_g = yes; then
  if test "$GCC" = yes; then
    CFLAGS="-g -O2"
  else
    CFLAGS="-g"
  fi
else
  if test "$GCC" = yes; then
    CFLAGS="-O2"
  else
    CFLAGS=
  fi
fi
AC_EXPAND_ONCE([_AC_EXEEXT])
AC_EXPAND_ONCE([_AC_OBJEXT])
AC_LANG_POP
])# AC_PROG_CC


# _AC_PROG_CC_GNU
# ---------------
define([_AC_PROG_CC_GNU],
[AC_CACHE_CHECK(whether we are using GNU C, ac_cv_prog_gcc,
[dnl The semicolon is to pacify NeXT's syntax-checking cpp.
cat >conftest.c <<EOF
#ifdef __GNUC__
  yes;
#endif
EOF
if AC_TRY_COMMAND(${CC-cc} -E conftest.c) | egrep yes >/dev/null 2>&1; then
  ac_cv_prog_gcc=yes
else
  ac_cv_prog_gcc=no
fi])
if test $ac_cv_prog_gcc = yes; then
  GCC=yes
else
  GCC=
fi[]dnl
])# _AC_PROG_CC_GNU


# _AC_PROG_CC_G
# ------------
define([_AC_PROG_CC_G],
[AC_CACHE_CHECK(whether ${CC-cc} accepts -g, ac_cv_prog_cc_g,
[echo 'void f(){}' >conftest.c
if test -z "`${CC-cc} -g -c conftest.c 2>&1`"; then
  ac_cv_prog_cc_g=yes
else
  ac_cv_prog_cc_g=no
fi
rm -f conftest*
])])# _AC_PROG_CC_G


# AC_PROG_GCC_TRADITIONAL
# -----------------------
AC_DEFUN([AC_PROG_GCC_TRADITIONAL],
[AC_REQUIRE([AC_PROG_CC])dnl
AC_REQUIRE([AC_PROG_CPP])dnl
if test $ac_cv_prog_gcc = yes; then
    AC_CACHE_CHECK(whether ${CC-cc} needs -traditional,
      ac_cv_prog_gcc_traditional,
[  ac_pattern="Autoconf.*'x'"
  AC_EGREP_CPP($ac_pattern, [#include <sgtty.h>
Autoconf TIOCGETP],
  ac_cv_prog_gcc_traditional=yes, ac_cv_prog_gcc_traditional=no)

  if test $ac_cv_prog_gcc_traditional = no; then
    AC_EGREP_CPP($ac_pattern, [#include <termio.h>
Autoconf TCGETA],
    ac_cv_prog_gcc_traditional=yes)
  fi])
  if test $ac_cv_prog_gcc_traditional = yes; then
    CC="$CC -traditional"
  fi
fi
])# AC_PROG_GCC_TRADITIONAL


# AC_PROG_CC_C_O
# --------------
AC_DEFUN([AC_PROG_CC_C_O],
[if test "x$CC" != xcc; then
  AC_MSG_CHECKING(whether $CC and cc understand -c and -o together)
else
  AC_MSG_CHECKING(whether cc understands -c and -o together)
fi
set dummy $CC; ac_cc=`echo $[2] |
		      sed -e 's/[[^a-zA-Z0-9_]]/_/g' -e 's/^[[0-9]]/_/'`
AC_CACHE_VAL(ac_cv_prog_cc_${ac_cc}_c_o,
[echo 'foo(){}' >conftest.c
# Make sure it works both with $CC and with simple cc.
# We do the test twice because some compilers refuse to overwrite an
# existing .o file with -o, though they will create one.
ac_try='${CC-cc} -c conftest.c -o conftest.o >&AC_FD_LOG'
if AC_TRY_EVAL(ac_try) &&
   test -f conftest.o && AC_TRY_EVAL(ac_try);
then
  eval ac_cv_prog_cc_${ac_cc}_c_o=yes
  if test "x$CC" != xcc; then
    # Test first that cc exists at all.
    if AC_TRY_COMMAND(cc -c conftest.c >&AC_FD_LOG); then
      ac_try='cc -c conftest.c -o conftest.o >&AC_FD_LOG'
      if AC_TRY_EVAL(ac_try) &&
	 test -f conftest.o && AC_TRY_EVAL(ac_try);
      then
        # cc works too.
        :
      else
        # cc exists but doesn't like -o.
        eval ac_cv_prog_cc_${ac_cc}_c_o=no
      fi
    fi
  fi
else
  eval ac_cv_prog_cc_${ac_cc}_c_o=no
fi
rm -f conftest*
])dnl
if eval "test \"`echo '$ac_cv_prog_cc_'${ac_cc}_c_o`\" = yes"; then
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
  AC_DEFINE(NO_MINUS_C_MINUS_O, 1,
            [Define if your C compiler doesn't accept -c and -o together.])
fi
])# AC_PROG_CC_C_O



# ---------------------- #
# 3c. The C++ compiler.  #
# ---------------------- #


# AC_PROG_CXXCPP
# --------------
AC_DEFUN([AC_PROG_CXXCPP],
[AC_MSG_CHECKING(how to run the C++ preprocessor)
if test -z "$CXXCPP"; then
AC_CACHE_VAL(ac_cv_prog_CXXCPP,
[AC_LANG_PUSH(C++)
  CXXCPP="${CXX-g++} -E"
  AC_TRY_CPP([#include <stdlib.h>], , CXXCPP=/lib/cpp)
  ac_cv_prog_CXXCPP=$CXXCPP
AC_LANG_POP()dnl
])dnl
CXXCPP=$ac_cv_prog_CXXCPP
fi
AC_MSG_RESULT($CXXCPP)
AC_SUBST(CXXCPP)dnl
])
# AC_PROG_CXXCPP


# AC_PROG_CXX([LIST-OF-COMPILERS])
# --------------------------------
# LIST-OF-COMPILERS is a space separated list of C++ compilers to search
# for (if not specified, a default list is used).  This just gives the
# user an opportunity to specify an alternative search list for the C++
# compiler.
# aCC	HP-UX C++ compiler much better than `CC', so test before.
# KCC	KAI C++ compiler
# RCC	Rational C++
# xlC_r	AIX C Set++ (with support for reentrant code)
# xlC	AIX C Set++
AC_DEFUN([AC_PROG_CXX],
[AC_BEFORE([$0], [AC_PROG_CXXCPP])dnl
AC_LANG_PUSH(C++)
AC_CHECK_TOOLS(CXX,
               $CCC m4_default([$1],
                          [g++ c++ gpp aCC CC cxx cc++ cl KCC RCC xlC_r xlC]),
               g++)

_AC_LANG_COMPILER_WORKS
_AC_PROG_CXX_GNU

dnl Check whether -g works, even if CXXFLAGS is set, in case the package
dnl plays around with CXXFLAGS (such as to build both debugging and
dnl normal versions of a library), tasteless as that idea is.
ac_test_CXXFLAGS=${CXXFLAGS+set}
ac_save_CXXFLAGS=$CXXFLAGS
CXXFLAGS=
_AC_PROG_CXX_G
if test "$ac_test_CXXFLAGS" = set; then
  CXXFLAGS=$ac_save_CXXFLAGS
elif test $ac_cv_prog_cxx_g = yes; then
  if test "$GXX" = yes; then
    CXXFLAGS="-g -O2"
  else
    CXXFLAGS="-g"
  fi
else
  if test "$GXX" = yes; then
    CXXFLAGS="-O2"
  else
    CXXFLAGS=
  fi
fi
AC_EXPAND_ONCE([_AC_EXEEXT])
AC_EXPAND_ONCE([_AC_OBJEXT])
AC_LANG_POP
])# AC_PROG_CXX


# _AC_PROG_CXX_GNU
# ----------------
define([_AC_PROG_CXX_GNU],
[AC_CACHE_CHECK(whether we are using GNU C++, ac_cv_prog_gxx,
[dnl The semicolon is to pacify NeXT's syntax-checking cpp.
cat >conftest.cc <<EOF
#ifdef __GNUC__
  yes;
#endif
EOF
if AC_TRY_COMMAND(${CXX-g++} -E conftest.cc) | egrep yes >/dev/null 2>&1; then
  ac_cv_prog_gxx=yes
else
  ac_cv_prog_gxx=no
fi])

if test $ac_cv_prog_gxx = yes; then
  GXX=yes
else
  GXX=
fi[]dnl
])# _AC_PROG_CXX_GNU


# _AC_PROG_CXX_G
# -------------
define([_AC_PROG_CXX_G],
[AC_CACHE_CHECK(whether ${CXX-g++} accepts -g, ac_cv_prog_cxx_g,
[echo 'void f(){}' >conftest.cc
if test -z "`${CXX-g++} -g -c conftest.cc 2>&1`"; then
  ac_cv_prog_cxx_g=yes
else
  ac_cv_prog_cxx_g=no
fi
rm -f conftest*
])])# _AC_PROG_CXX_G



# ----------------------------- #
# 3d. The Fortran 77 compiler.  #
# ----------------------------- #


# AC_PROG_F77([COMPILERS...])
# ---------------------------
# COMPILERS is a space separated list of Fortran 77 compilers to search
# for.
#
# Compilers are ordered by
#  1. F77, F90, F95
#  2. Good native compilers, bad native compilers, wrappers around f2c.
#
# `fort77' and `fc' are wrappers around `f2c', `fort77' being better.
# It is believed that under HP-UX `fort77' is the name of the native
# compiler.  NAG f95 is preferred over `fc', so put `fc' last.
AC_DEFUN([AC_PROG_F77],
[AC_BEFORE([$0], [AC_PROG_CPP])dnl
dnl Fortran 95 isn't strictly backwards-compatiable with Fortran 77, but
dnl `f95' is worth trying.
dnl pgf77 is the Portland Group f77 compiler
dnl lf95 is the Lahey-Fujitsu compiler
AC_LANG_PUSH(Fortran 77)
AC_CHECK_TOOLS(F77,
               m4_default([$1],
                          [g77 f77 xlf cf77 pgf77 fl32 fort77 f90 xlf90 f95 lf95 fc]))

_AC_LANG_COMPILER_WORKS
_AC_PROG_F77_GNU

dnl Check whether -g works, even if FFLAGS is set, in case the package
dnl plays around with FFLAGS (such as to build both debugging and
dnl normal versions of a library), tasteless as that idea is.
ac_test_FFLAGS=${FFLAGS+set}
ac_save_FFLAGS=$FFLAGS
FFLAGS=
_AC_PROG_F77_G
if test "$ac_test_FFLAGS" = set; then
  FFLAGS=$ac_save_FFLAGS
elif test $ac_cv_prog_f77_g = yes; then
  if test "$G77" = yes; then
    FFLAGS="-g -O2"
  else
    FFLAGS="-g"
  fi
else
  if test "$G77" = yes; then
    FFLAGS="-O2"
  else
    FFLAGS=
  fi
fi
AC_EXPAND_ONCE([_AC_EXEEXT])
AC_EXPAND_ONCE([_AC_OBJEXT])
AC_LANG_POP
])# AC_PROG_F77


# _AC_PROG_F77_GNU
# ----------------
# Test whether for Fortran 77 compiler is `g77' (the GNU Fortran 77
# Compiler).  This test depends on whether the Fortran 77 compiler can
# do CPP pre-processing.
define([_AC_PROG_F77_GNU],
[AC_CACHE_CHECK(whether we are using GNU Fortran 77, ac_cv_prog_g77,
[cat >conftest.f <<EOF
#ifdef __GNUC__
  yes
#endif
EOF
if AC_TRY_COMMAND($F77 -E conftest.f) | egrep yes >/dev/null 2>&1; then
  ac_cv_prog_g77=yes
else
  ac_cv_prog_g77=no
fi])
if test $ac_cv_prog_g77 = yes; then
  G77=yes
else
  G77=
fi[]dnl
])# _AC_PROG_F77_GNU


# _AC_PROG_F77_G
# -------------
# Test whether the Fortran 77 compiler can accept the `-g' option to
# enable debugging.
define([_AC_PROG_F77_G],
[AC_CACHE_CHECK(whether $F77 accepts -g, ac_cv_prog_f77_g,
[FFLAGS=-g
AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
[ac_cv_prog_f77_g=yes],
[ac_cv_prog_f77_g=no])
])])# _AC_PROG_F77_G


# AC_PROG_F77_C_O
# ---------------
# Test if the Fortran 77 compiler accepts the options `-c' and `-o'
# simultaneously, and define `F77_NO_MINUS_C_MINUS_O' if it does not.
#
# The usefulness of this macro is questionable, as I can't really see
# why anyone would use it.  The only reason I include it is for
# completeness, since a similar test exists for the C compiler.
AC_DEFUN([AC_PROG_F77_C_O],
[AC_BEFORE([$0], [AC_PROG_F77])dnl
AC_MSG_CHECKING(whether $F77 understand -c and -o together)
set dummy $F77; ac_f77=`echo $[2] |
sed -e 's/[[^a-zA-Z0-9_]]/_/g' -e 's/^[[0-9]]/_/'`
AC_CACHE_VAL(ac_cv_prog_f77_${ac_f77}_c_o,
[cat >conftest.f <<EOF
       program conftest
       end
EOF
# We do the `AC_TRY_EVAL' test twice because some compilers refuse to
# overwrite an existing `.o' file with `-o', although they will create
# one.
ac_try='$F77 $FFLAGS -c conftest.f -o conftest.o >&AC_FD_LOG'
if AC_TRY_EVAL(ac_try) && test -f conftest.o && AC_TRY_EVAL(ac_try); then
  eval ac_cv_prog_f77_${ac_f77}_c_o=yes
else
  eval ac_cv_prog_f77_${ac_f77}_c_o=no
fi
rm -f conftest*
])dnl
if eval "test \"`echo '$ac_cv_prog_f77_'${ac_f77}_c_o`\" = yes"; then
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
  AC_DEFINE(F77_NO_MINUS_C_MINUS_O, 1,
            [Define if your Fortran 77 compiler doesn't accept -c and -o together.])
fi
])# AC_PROG_F77_C_O





## ------------------------------- ##
## 4. Compilers' characteristics.  ##
## ------------------------------- ##


# -------------------------------- #
# 4b. C compiler characteristics.  #
# -------------------------------- #

# AC_PROG_CC_STDC
# ---------------
# If the C compiler in not in ANSI C mode by default, try to add an
# option to output variable @code{CC} to make it so.  This macro tries
# various options that select ANSI C on some system or another.  It
# considers the compiler to be in ANSI C mode if it handles function
# prototypes correctly.
AC_DEFUN([AC_PROG_CC_STDC],
[AC_REQUIRE([AC_PROG_CC])dnl
AC_BEFORE([$0], [AC_C_INLINE])dnl
AC_BEFORE([$0], [AC_C_CONST])dnl
dnl Force this before AC_PROG_CPP.  Some cpp's, eg on HPUX, require
dnl a magic option to avoid problems with ANSI preprocessor commands
dnl like #elif.
dnl FIXME: can't do this because then AC_AIX won't work due to a
dnl circular dependency.
dnl AC_BEFORE([$0], [AC_PROG_CPP])
AC_MSG_CHECKING(for ${CC-cc} option to accept ANSI C)
AC_CACHE_VAL(ac_cv_prog_cc_stdc,
[ac_cv_prog_cc_stdc=no
ac_save_CC=$CC
# Don't try gcc -ansi; that turns off useful extensions and
# breaks some systems' header files.
# AIX			-qlanglvl=ansi
# Ultrix and OSF/1	-std1
# HP-UX 10.20 and later	-Ae
# HP-UX older versions	-Aa -D_HPUX_SOURCE
# SVR4			-Xc -D__EXTENSIONS__
for ac_arg in "" -qlanglvl=ansi -std1 -Ae "-Aa -D_HPUX_SOURCE" "-Xc -D__EXTENSIONS__"
do
  CC="$ac_save_CC $ac_arg"
  AC_COMPILE_IFELSE(
[AC_LANG_PROGRAM(
[[#include <stdarg.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
/* Most of the following tests are stolen from RCS 5.7's src/conf.sh.  */
struct buf { int x; };
FILE * (*rcsopen) (struct buf *, struct stat *, int);
static char *e (p, i)
     char **p;
     int i;
{
  return p[i];
}
static char *f (char * (*g) (char **, int), char **p, ...)
{
  char *s;
  va_list v;
  va_start (v,p);
  s = g (p, va_arg (v,int));
  va_end (v);
  return s;
}
int test (int i, double x);
struct s1 {int (*f) (int a);};
struct s2 {int (*f) (double a);};
int pairnames (int, char **, FILE *(*)(struct buf *, struct stat *, int), int, int);
int argc;
char **argv;]],
[[return f (e, argv, 0) != argv[0]  ||  f (e, argv, 1) != argv[1];]])],
                     [ac_cv_prog_cc_stdc=$ac_arg; break])
done
CC=$ac_save_CC
])
case "x$ac_cv_prog_cc_stdc" in
  x|xno)
    AC_MSG_RESULT([none needed]) ;;
  *)
    AC_MSG_RESULT($ac_cv_prog_cc_stdc)
    CC="$CC $ac_cv_prog_cc_stdc" ;;
esac
])# AC_PROG_CC_STDC






AC_DEFUN([AC_C_CROSS],
[AC_OBSOLETE([$0], [; it has been merged into AC_PROG_CC])])


# AC_C_CHAR_UNSIGNED
# ------------------
AC_DEFUN([AC_C_CHAR_UNSIGNED],
[AH_VERBATIM([__CHAR_UNSIGNED__],
[/* Define if type `char' is unsigned and you are not using gcc.  */
#ifndef __CHAR_UNSIGNED__
# undef __CHAR_UNSIGNED__
#endif])dnl
AC_CACHE_CHECK(whether char is unsigned, ac_cv_c_char_unsigned,
[AC_COMPILE_IFELSE([AC_LANG_BOOL_COMPILE_TRY([AC_INCLUDES_DEFAULT([])],
                                             [((char) -1) < 0])],
                   ac_cv_c_char_unsigned=no, ac_cv_c_char_unsigned=yes)])
if test $ac_cv_c_char_unsigned = yes && test "$GCC" != yes; then
  AC_DEFINE(__CHAR_UNSIGNED__)
fi
])# AC_C_CHAR_UNSIGNED


# AC_C_LONG_DOUBLE
# ----------------
AC_DEFUN([AC_C_LONG_DOUBLE],
[AC_CACHE_CHECK(for long double, ac_cv_c_long_double,
[if test "$GCC" = yes; then
  ac_cv_c_long_double=yes
else
AC_TRY_RUN(
[int
main ()
{
  /* The Stardent Vistra knows sizeof(long double), but does not
     support it.  */
  long double foo = 0.0;
  /* On Ultrix 4.3 cc, long double is 4 and double is 8.  */
  exit (sizeof (long double) < sizeof (double));
}],
ac_cv_c_long_double=yes, ac_cv_c_long_double=no)
fi])
if test $ac_cv_c_long_double = yes; then
  AC_DEFINE(HAVE_LONG_DOUBLE, 1,
            [Define if the `long double' type works.])
fi
])# AC_C_LONG_DOUBLE


# AC_C_BIGENDIAN
# --------------
AC_DEFUN([AC_C_BIGENDIAN],
[AC_CACHE_CHECK(whether byte ordering is bigendian, ac_cv_c_bigendian,
[ac_cv_c_bigendian=unknown
# See if sys/param.h defines the BYTE_ORDER macro.
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([#include <sys/types.h>
#include <sys/param.h>
],
[#if !BYTE_ORDER || !BIG_ENDIAN || !LITTLE_ENDIAN
 bogus endian macros
#endif
])],
[# It does; now see whether it defined to BIG_ENDIAN or not.
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([#include <sys/types.h>
#include <sys/param.h>
], [#if BYTE_ORDER != BIG_ENDIAN
 not big endian
#endif
])],               [ac_cv_c_bigendian=yes],
                   [ac_cv_c_bigendian=no])])
if test $ac_cv_c_bigendian = unknown; then
AC_TRY_RUN(
[int
main ()
{
  /* Are we little or big endian?  From Harbison&Steele.  */
  union
  {
    long l;
    char c[sizeof (long)];
  } u;
  u.l = 1;
  exit (u.c[sizeof (long) - 1] == 1);
}], ac_cv_c_bigendian=no, ac_cv_c_bigendian=yes)
fi])
if test $ac_cv_c_bigendian = yes; then
  AC_DEFINE(WORDS_BIGENDIAN, 1,
            [Define if your processor stores words with the most significant
             byte first (like Motorola and SPARC, unlike Intel and VAX).])
fi
])# AC_C_BIGENDIAN


# AC_C_INLINE
# -----------
# Do nothing if the compiler accepts the inline keyword.
# Otherwise define inline to __inline__ or __inline if one of those work,
# otherwise define inline to be empty.
AC_DEFUN([AC_C_INLINE],
[AC_REQUIRE([AC_PROG_CC_STDC])dnl
AC_CACHE_CHECK([for inline], ac_cv_c_inline,
[ac_cv_c_inline=no
for ac_kw in inline __inline__ __inline; do
  AC_COMPILE_IFELSE([AC_LANG_SOURCE(
[#ifndef __cplusplus
$ac_kw int foo () {return 0; }
#endif
])],
                    [ac_cv_c_inline=$ac_kw; break])
done
])
case $ac_cv_c_inline in
  inline | yes) ;;
  no) AC_DEFINE(inline,,
                [Define as `__inline' if that's what the C compiler calls it,
                 or to nothing if it is not supported.]) ;;
  *)  AC_DEFINE_UNQUOTED(inline, $ac_cv_c_inline) ;;
esac
])# AC_C_INLINE


# AC_C_CONST
# ----------
AC_DEFUN([AC_C_CONST],
[AC_REQUIRE([AC_PROG_CC_STDC])dnl
AC_CACHE_CHECK([for an ANSI C-conforming const], ac_cv_c_const,
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],
[[/* FIXME: Include the comments suggested by Paul. */
#ifndef __cplusplus
  /* Ultrix mips cc rejects this.  */
  typedef int charset[2];
  const charset x;
  /* SunOS 4.1.1 cc rejects this.  */
  char const *const *ccp;
  char **p;
  /* NEC SVR4.0.2 mips cc rejects this.  */
  struct point {int x, y;};
  static struct point const zero = {0,0};
  /* AIX XL C 1.02.0.0 rejects this.
     It does not let you subtract one const X* pointer from another in
     an arm of an if-expression whose if-part is not a constant
     expression */
  const char *g = "string";
  ccp = &g + (g ? g-g : 0);
  /* HPUX 7.0 cc rejects these. */
  ++ccp;
  p = (char**) ccp;
  ccp = (char const *const *) p;
  { /* SCO 3.2v4 cc rejects this.  */
    char *t;
    char const *s = 0 ? (char *) 0 : (char const *) 0;

    *t++ = 0;
  }
  { /* Someone thinks the Sun supposedly-ANSI compiler will reject this.  */
    int x[] = {25, 17};
    const int *foo = &x[0];
    ++foo;
  }
  { /* Sun SC1.0 ANSI compiler rejects this -- but not the above. */
    typedef const int *iptr;
    iptr p = 0;
    ++p;
  }
  { /* AIX XL C 1.02.0.0 rejects this saying
       "k.c", line 2.27: 1506-025 (S) Operand must be a modifiable lvalue. */
    struct s { int j; const int *ap[3]; };
    struct s *b; b->j = 5;
  }
  { /* ULTRIX-32 V3.1 (Rev 9) vcc rejects this */
    const int foo = 10;
  }
#endif
]])],
                   [ac_cv_c_const=yes],
                   [ac_cv_c_const=no])])
if test $ac_cv_c_const = no; then
  AC_DEFINE(const,,
            [Define to empty if `const' does not conform to ANSI C.])
fi
])# AC_C_CONST


# AC_C_VOLATILE
# -------------
# Note that, unlike const, #defining volatile to be the empty string can
# actually turn a correct program into an incorrect one, since removing
# uses of volatile actually grants the compiler permission to perform
# optimizations that could break the user's code.  So, do not #define
# volatile away unless it is really necessary to allow the user's code
# to compile cleanly.  Benign compiler failures should be tolerated.
AC_DEFUN([AC_C_VOLATILE],
[AC_REQUIRE([AC_PROG_CC_STDC])dnl
AC_CACHE_CHECK([for working volatile], ac_cv_c_volatile,
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [
volatile int x;
int * volatile y;])],
                   [ac_cv_c_volatile=yes],
                   [ac_cv_c_volatile=no])])
if test $ac_cv_c_volatile = no; then
  AC_DEFINE(volatile,,
            [Define to empty if the keyword `volatile' does not work.
             Warning: valid code using `volatile' can become incorrect
             without.  Disable with care.])
fi
])# AC_C_VOLATILE


# AC_C_STRINGIZE
# --------------
# Checks if `#' can be used to glue strings together at the CPP level.
# Defines HAVE_STRINGIZE if positive.
AC_DEFUN([AC_C_STRINGIZE],
[AC_REQUIRE([AC_PROG_CPP])dnl
AC_MSG_CHECKING([for preprocessor stringizing operator])
AC_CACHE_VAL(ac_cv_c_stringize,
AC_EGREP_CPP([#teststring],[
#define x(y) #y

char *s = x(teststring);
], ac_cv_c_stringize=no, ac_cv_c_stringize=yes))
if test "${ac_cv_c_stringize}" = yes; then
  AC_DEFINE(HAVE_STRINGIZE, 1,
            [Define if cpp supports the ANSI # stringizing operator.])
fi
AC_MSG_RESULT([${ac_cv_c_stringize}])
])# AC_C_STRINGIZE


# AC_C_PROTOTYPES
# ---------------
# Check if the C compiler supports prototypes, included if it needs
# options.
AC_DEFUN([AC_C_PROTOTYPES],
[AC_REQUIRE([AC_PROG_CC_STDC])dnl
AC_REQUIRE([AC_PROG_CPP])dnl
AC_MSG_CHECKING([for function prototypes])
if test "$ac_cv_prog_cc_stdc" != no; then
  AC_MSG_RESULT(yes)
  AC_DEFINE(PROTOTYPES, 1,
            [Define if the C compiler supports function prototypes.])
else
  AC_MSG_RESULT(no)
fi
])# AC_C_PROTOTYPES




# ---------------------------------------- #
# 4d. Fortan 77 compiler characteristics.  #
# ---------------------------------------- #


# AC_F77_LIBRARY_LDFLAGS
# ----------------------
#
# Determine the linker flags (e.g. "-L" and "-l") for the Fortran 77
# intrinsic and run-time libraries that are required to successfully
# link a Fortran 77 program or shared library.  The output variable
# FLIBS is set to these flags.
#
# This macro is intended to be used in those situations when it is
# necessary to mix, e.g. C++ and Fortran 77, source code into a single
# program or shared library.
#
# For example, if object files from a C++ and Fortran 77 compiler must
# be linked together, then the C++ compiler/linker must be used for
# linking (since special C++-ish things need to happen at link time
# like calling global constructors, instantiating templates, enabling
# exception support, etc.).
#
# However, the Fortran 77 intrinsic and run-time libraries must be
# linked in as well, but the C++ compiler/linker doesn't know how to
# add these Fortran 77 libraries.  Hence, the macro
# "AC_F77_LIBRARY_LDFLAGS" was created to determine these Fortran 77
# libraries.
#
# This macro was packaged in its current form by Matthew D. Langston.
# However, nearly all of this macro came from the "OCTAVE_FLIBS" macro
# in "octave-2.0.13/aclocal.m4", and full credit should go to John
# W. Eaton for writing this extremely useful macro.  Thank you John.
AC_DEFUN([AC_F77_LIBRARY_LDFLAGS],
[AC_REQUIRE([AC_PROG_F77])dnl
AC_CACHE_CHECK([for Fortran 77 libraries], ac_cv_flibs,
[if test "x$FLIBS" != "x"; then
  ac_cv_flibs="$FLIBS" # Let the user override the test.
else
AC_LANG_PUSH(Fortran 77)

# This is the simplest of all Fortran 77 programs.
cat >conftest.$ac_ext <<EOF
      end
EOF

# Compile and link our simple test program by passing the "-v" flag
# to the Fortran 77 compiler in order to get "verbose" output that
# we can then parse for the Fortran 77 linker flags.  I don't know
# what to do if your compiler doesn't have -v.
ac_save_FFLAGS=$FFLAGS
FFLAGS="$FFLAGS -v"
ac_link_output=`eval $ac_link AC_FD_LOG>&1 2>&1 | grep -v 'Driving:'`
FFLAGS=$ac_save_FFLAGS

rm -f conftest.*
AC_LANG_POP()dnl

# This will ultimately be our output variable.
FLIBS=

# If we are using xlf then replace all the commas with spaces.
if echo $ac_link_output | grep xlfentry >/dev/null 2>&1; then
  ac_link_output=`echo $ac_link_output | sed 's/,/ /g'`
fi

# If we are using Cray Fortran then delete quotes.
# Use "\"" instead of '"' for font-lock-mode.
# FIXME: a more general fix for quoted arguments with spaces?
if echo $ac_link_output | grep cft90 >/dev/null 2>&1; then
  ac_link_output=`echo $ac_link_output | sed "s/\"//g"`
fi

# AC_SAVE_ARG will be set to the current option (i.e. something
# beginning with a "-") when we come across an option that we think
# will take an argument (e.g. -L /usr/local/lib/foo).  When
# AC_SAVE_ARG is set, we append AC_ARG to AC_SEEN without any
# further examination.
ac_save_arg=

# This is just a "list" (i.e. space delimited elements) of flags
# that we've already seen.  This just help us not add the same
# linker flags twice to FLIBS.
ac_seen=

# The basic algorithm is that if AC_ARG makes it all the way through
# down to the bottom of the the "for" loop, then it is added to
# FLIBS.
for ac_arg in $ac_link_output; do
  # Assume that none of the options that take arguments expect the
  # argument to start with a "-".  If we ever see this case, then
  # reset AC_PREVIOUS_ARG so that we don't try and process AC_ARG as
  # an argument.
  ac_previous_arg=$ac_save_arg
  echo $ac_arg | grep '^[^-]' >/dev/null 2>&1 && ac_previous_arg=
  case $ac_previous_arg in
    '')
      case $ac_arg in
        /*.a)
          # Append to AC_SEEN if it's not already there.
          AC_LIST_MEMBER_OF($ac_arg, $ac_seen,
                            ac_arg=, ac_seen="$ac_seen $ac_arg")
          ;;
        -bI:*)
          # Append to AC_SEEN if it's not already there.
          AC_LIST_MEMBER_OF($ac_arg, $ac_seen,
                            ac_arg=, [AC_LINKER_OPTION([$ac_arg], ac_seen)])
          ;;
          # Ignore these flags.
        -lang* | -lcrt0.o | -l[[cm]] | -lgcc | -LANG:=*)
          ac_arg=
          ;;
        -lkernel32)
          # Only ignore this flag under the Cygwin environment.
          if test x"$CYGWIN" = xyes; then
            ac_arg=
          else
            ac_seen="$ac_seen $ac_arg"
          fi
          ;;
        -[[LRu]])
          # These flags, when seen by themselves, take an argument.
          ac_save_arg=$ac_arg
          ac_arg=
          ;;
        -YP,*)
          temp_arg=
          for ac_i in `echo $ac_arg | sed -e 's%^P,%-L%' -e 's%:% -L%g'`; do
            # Append to AC_SEEN if it's not already there.
            AC_LIST_MEMBER_OF($ac_i, $ac_seen,
                              temp_arg="$temp_arg $ac_i",
                              ac_seen="$ac_seen $ac_i")
          done
          ac_arg=$temp_arg
          ;;
        -[[lLR]]*)
          # Append to AC_SEEN if it's not already there.
          AC_LIST_MEMBER_OF($ac_arg, $ac_seen,
                            ac_arg=, ac_seen="$ac_seen $ac_arg")
          ;;
        *)
          # Ignore everything else.
          ac_arg=
          ;;
      esac
      ;;
    -[[LRu]])
      ac_arg="$ac_previous_arg $ac_arg"
      ;;
  esac

  # If "ac_arg" has survived up until this point, then put it in FLIBS.
  test "x$ac_arg" != x && FLIBS="$FLIBS $ac_arg"
done

# Assumption: We only see "LD_RUN_PATH" on Solaris systems.  If this
# is seen, then we insist that the "run path" must be an absolute
# path (i.e. it must begin with a "/").
ac_ld_run_path=`echo $ac_link_output |
                sed -n -e 's%^.*LD_RUN_PATH *= *\(/[[^ ]]*\).*$%\1%p'`
test "x$ac_ld_run_path" != x && FLIBS="$ac_ld_run_path $FLIBS"
ac_cv_flibs=$FLIBS
fi # test "x$FLIBS" = "x"
])
FLIBS="$ac_cv_flibs"
AC_SUBST(FLIBS)
])# AC_F77_LIBRARY_LDFLAGS


# AC_F77_NAME_MANGLING
# --------------------
# Test for the name mangling scheme used by the Fortran 77 compiler.
# Two variables are set by this macro:
#
#	 f77_case: Set to either "upper" or "lower", depending on the
#		   case of the name mangling.
#
#  f77_underscore: Set to either "no", "single" or "double", depending
#		   on how underscores (i.e. "_") are appended to
#		   identifiers, if at all.
#
#		   If no underscores are appended, then the value is
#		   "no".
#
#		   If a single underscore is appended, even with
#		   identifiers which already contain an underscore
#		   somewhere in their name, then the value is
#		   "single".
#
#		   If a single underscore is appended *and* two
#		   underscores are appended to identifiers which
#		   already contain an underscore somewhere in their
#		   name, then the value is "double".
AC_DEFUN([AC_F77_NAME_MANGLING],
[AC_REQUIRE([AC_PROG_CC])dnl
AC_REQUIRE([AC_PROG_F77])dnl
AC_REQUIRE([AC_F77_LIBRARY_LDFLAGS])dnl
AC_CACHE_CHECK([for Fortran 77 name-mangling scheme],
               ac_cv_f77_mangling,
[AC_LANG_PUSH(Fortran 77)
AC_COMPILE_IFELSE(
[      subroutine foobar()
      return
      end
      subroutine foo_bar()
      return
      end],
[mv conftest.${ac_objext} cf77_test.${ac_objext}

  AC_LANG_PUSH(C)

  ac_save_LIBS=$LIBS
  LIBS="cf77_test.${ac_objext} $FLIBS $LIBS"

  f77_case=
  f77_underscore=

  AC_TRY_LINK_FUNC(foobar,
    f77_case=lower
    f77_underscore=no
    ac_foo_bar=foo_bar_,
    AC_TRY_LINK_FUNC(foobar_,
      f77_case=lower
      f77_underscore=single
      ac_foo_bar=foo_bar__,
      AC_TRY_LINK_FUNC(FOOBAR,
        f77_case=upper
        f77_underscore=no
        ac_foo_bar=FOO_BAR_,
        AC_TRY_LINK_FUNC(FOOBAR_,
          f77_case=upper
          f77_underscore=single
          ac_foo_bar=FOO_BAR__))))

  AC_TRY_LINK_FUNC(${ac_foo_bar}, f77_underscore=double)

  if test -z "$f77_case" || test -z "$f77_underscore"; then
    ac_cv_f77_mangling="unknown"
  else
    ac_cv_f77_mangling="$f77_case case, $f77_underscore underscores"
  fi

  LIBS=$ac_save_LIBS
  AC_LANG_POP()dnl
  rm -f cf77_test*])
AC_LANG_POP()dnl
])
f77_case=`echo "$ac_cv_f77_mangling" | sed 's/ case.*$//'`
f77_underscore=`echo "$ac_cv_f77_mangling" | sed 's/^.*, \(.*\) .*$/\1/'`
])# AC_F77_NAME_MANGLING


# AC_F77_WRAPPERS
# ---------------
# Defines C macros F77_FUNC(name,NAME) and F77_FUNC_(name,NAME) to
# properly mangle the names of C identifiers, and C identifiers with
# underscores, respectively, so that they match the name mangling
# scheme used by the Fortran 77 compiler.
AC_DEFUN([AC_F77_WRAPPERS],
[AC_REQUIRE([AC_F77_NAME_MANGLING])dnl
AH_TEMPLATE([F77_FUNC],
    [Define to a macro mangling the given C identifier (in lower and upper
     case), which must not contain underscores, for linking with Fortran.])dnl
AH_TEMPLATE([F77_FUNC_],
    [As F77_FUNC, but for C identifiers containing underscores.])dnl
case $f77_case,$f77_underscore in
  lower,no)
          AC_DEFINE([F77_FUNC(name,NAME)],  [name])
          AC_DEFINE([F77_FUNC_(name,NAME)], [name]) ;;
  lower,single)
          AC_DEFINE([F77_FUNC(name,NAME)],  [name ## _])
          AC_DEFINE([F77_FUNC_(name,NAME)], [name ## _]) ;;
  lower,double)
          AC_DEFINE([F77_FUNC(name,NAME)],  [name ## _])
          AC_DEFINE([F77_FUNC_(name,NAME)], [name ## __]) ;;
  upper,no)
          AC_DEFINE([F77_FUNC(name,NAME)],  [NAME])
          AC_DEFINE([F77_FUNC_(name,NAME)], [NAME]) ;;
  upper,single)
          AC_DEFINE([F77_FUNC(name,NAME)],  [NAME ## _])
          AC_DEFINE([F77_FUNC_(name,NAME)], [NAME ## _]) ;;
  upper,double)
          AC_DEFINE([F77_FUNC(name,NAME)],  [NAME ## _])
          AC_DEFINE([F77_FUNC_(name,NAME)], [NAME ## __]) ;;
  *)
          AC_MSG_WARN(unknown Fortran 77 name-mangling scheme)
          ;;
esac
])# AC_F77_WRAPPERS
