# This file is part of Autoconf.                       -*- Autoconf -*-
# Macros that test for specific features.
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


## --------------------- ##
## Checks for programs.  ##
## --------------------- ##


# _AC_PROG_ECHO
# -------------
# Check whether to use -n, \c, or newline-tab to separate
# checking messages from result messages.
# Don't try to cache, since the results of this macro are needed to
# display the checking message.  In addition, caching something used once
# has little interest.
# Idea borrowed from dist 3.0.
AC_DEFUN(_AC_PROG_ECHO,
[if (echo "testing\c"; echo 1,2,3) | grep c >/dev/null; then
  # Stardent Vistra SVR4 grep lacks -e, says Kaveh R. Ghazi.
  if (echo -n testing; echo 1,2,3) | sed s/-n/xn/ | grep xn >/dev/null; then
    ECHO_N= ECHO_C='
' ECHO_T='	'
  else
    ECHO_N=-n ECHO_C= ECHO_T=
  fi
else
  ECHO_N= ECHO_C='\c' ECHO_T=
fi
AC_SUBST(ECHO_C)dnl
AC_SUBST(ECHO_N)dnl
AC_SUBST(ECHO_T)dnl
])# _AC_PROG_ECHO


# AC_PROG_CC([COMPILER ...])
# --------------------------
# COMPILER ... is a space separated list of C compilers to search for.
# This just gives the user an opportunity to specify an alternative
# search list for the C compiler.
AC_DEFUN(AC_PROG_CC,
[AC_BEFORE([$0], [AC_PROG_CPP])dnl
AC_ARG_VAR([CFLAGS], [Extra flags for the C compiler])
ifelse([$1], ,
[
  AC_CHECK_PROG(CC, gcc, gcc)
  if test -z "$CC"; then
    AC_CHECK_PROG(CC, cc, cc, , , /usr/ucb/cc)
    if test -z "$CC"; then
      AC_CHECK_PROGS(CC, cl)
    fi
  fi
], [AC_CHECK_PROGS(CC, [$1])])

test -z "$CC" && AC_MSG_ERROR([no acceptable cc found in \$PATH])

AC_PROG_CC_WORKS
AC_PROG_CC_GNU

if test $ac_cv_prog_gcc = yes; then
  GCC=yes
else
  GCC=
fi

dnl Check whether -g works, even if CFLAGS is set, in case the package
dnl plays around with CFLAGS (such as to build both debugging and
dnl normal versions of a library), tasteless as that idea is.
ac_test_CFLAGS="${CFLAGS+set}"
ac_save_CFLAGS="$CFLAGS"
CFLAGS=
AC_PROG_CC_G
if test "$ac_test_CFLAGS" = set; then
  CFLAGS="$ac_save_CFLAGS"
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
])# AC_PROG_CC


# AC_PROG_CXX([LIST-OF-COMPILERS])
# --------------------------------
# LIST-OF-COMPILERS is a space separated list of C++ compilers to search
# for (if not specified, a default list is used).  This just gives the
# user an opportunity to specify an alternative search list for the C++
# compiler.
AC_DEFUN(AC_PROG_CXX,
[AC_BEFORE([$0], [AC_PROG_CXXCPP])dnl
AC_CHECK_PROGS(CXX, $CCC m4_default([$1], [c++ g++ gpp CC cxx cc++ cl]), g++)

AC_PROG_CXX_WORKS
AC_PROG_CXX_GNU

if test $ac_cv_prog_gxx = yes; then
  GXX=yes
else
  GXX=
fi

dnl Check whether -g works, even if CXXFLAGS is set, in case the package
dnl plays around with CXXFLAGS (such as to build both debugging and
dnl normal versions of a library), tasteless as that idea is.
ac_test_CXXFLAGS="${CXXFLAGS+set}"
ac_save_CXXFLAGS="$CXXFLAGS"
CXXFLAGS=
AC_PROG_CXX_G
if test "$ac_test_CXXFLAGS" = set; then
  CXXFLAGS="$ac_save_CXXFLAGS"
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
])# AC_PROG_CXX


# AC_PROG_F77([COMPILERS...])
# ---------------------------
# COMPILERS is a space separated list of Fortran 77 compilers to search
# for.
AC_DEFUN(AC_PROG_F77,
[AC_BEFORE([$0], [AC_PROG_CPP])dnl
AC_CHECK_PROGS(F77,
               m4_default([$1], [g77 f77 xlf cf77 fl32 fort77 f90 xlf90 f2c]))

AC_PROG_F77_WORKS
AC_PROG_F77_GNU

if test $ac_cv_prog_g77 = yes; then
  G77=yes
dnl Check whether -g works, even if FFLAGS is set, in case the package
dnl plays around with FFLAGS (such as to build both debugging and
dnl normal versions of a library), tasteless as that idea is.
  ac_test_FFLAGS="${FFLAGS+set}"
  ac_save_FFLAGS="$FFLAGS"
  FFLAGS=
  AC_PROG_F77_G
  if test "$ac_test_FFLAGS" = set; then
    FFLAGS="$ac_save_FFLAGS"
  elif test $ac_cv_prog_f77_g = yes; then
    FFLAGS="-g -O2"
  else
    FFLAGS="-O2"
  fi
else
  G77=
  test "${FFLAGS+set}" = set || FFLAGS="-g"
fi
])# AC_PROG_F77


# AC_PROG_CC_WORKS
# ----------------
AC_DEFUN(AC_PROG_CC_WORKS,
[AC_MSG_CHECKING([whether the C compiler ($CC $CFLAGS $CPPFLAGS $LDFLAGS) works])
AC_LANG_SAVE
AC_LANG_C
AC_TRY_COMPILER([int main(){return(0);}],
                ac_cv_prog_cc_works, ac_cv_prog_cc_cross)
AC_LANG_RESTORE
AC_MSG_RESULT($ac_cv_prog_cc_works)
if test $ac_cv_prog_cc_works = no; then
  AC_MSG_ERROR([installation or configuration problem: C compiler cannot create executables.], 77)
fi
AC_MSG_CHECKING([whether the C compiler ($CC $CFLAGS $CPPFLAGS $LDFLAGS) is a cross-compiler])
AC_MSG_RESULT($ac_cv_prog_cc_cross)
cross_compiling=$ac_cv_prog_cc_cross
])# AC_PROG_CC_WORKS


# AC_PROG_CXX_WORKS
# -----------------
AC_DEFUN(AC_PROG_CXX_WORKS,
[AC_MSG_CHECKING([whether the C++ compiler ($CXX $CXXFLAGS $CPPFLAGS $LDFLAGS) works])
AC_LANG_SAVE
AC_LANG_CPLUSPLUS
AC_TRY_COMPILER([int main(){return(0);}],
                ac_cv_prog_cxx_works, ac_cv_prog_cxx_cross)
AC_LANG_RESTORE
AC_MSG_RESULT($ac_cv_prog_cxx_works)
if test $ac_cv_prog_cxx_works = no; then
  AC_MSG_ERROR([installation or configuration problem: C++ compiler cannot create executables.], 77)
fi
AC_MSG_CHECKING([whether the C++ compiler ($CXX $CXXFLAGS $CPPFLAGS $LDFLAGS) is a cross-compiler])
AC_MSG_RESULT($ac_cv_prog_cxx_cross)
cross_compiling=$ac_cv_prog_cxx_cross
])# AC_PROG_CXX_WORKS


# AC_PROG_F77_WORKS
# -----------------
# Test whether the Fortran 77 compiler can compile and link a trivial
# Fortran program.  Also, test whether the Fortran 77 compiler is a
# cross-compiler (which may realistically be the case if the Fortran
# compiler is `g77').
AC_DEFUN(AC_PROG_F77_WORKS,
[AC_MSG_CHECKING([whether the Fortran 77 compiler ($F77 $FFLAGS $LDFLAGS) works])
AC_LANG_SAVE
AC_LANG_FORTRAN77
AC_TRY_COMPILER(
[      program conftest
      end
], ac_cv_prog_f77_works, ac_cv_prog_f77_cross)
AC_LANG_RESTORE
AC_MSG_RESULT($ac_cv_prog_f77_works)
if test $ac_cv_prog_f77_works = no; then
  AC_MSG_ERROR([installation or configuration problem: Fortran 77 compiler cannot create executables.], 77)
fi
AC_MSG_CHECKING([whether the Fortran 77 compiler ($F77 $FFLAGS $LDFLAGS) is a cross-compiler])
AC_MSG_RESULT($ac_cv_prog_f77_cross)
cross_compiling=$ac_cv_prog_f77_cross
])# AC_PROG_F77_WORKS


# AC_PROG_CC_GNU
# --------------
AC_DEFUN(AC_PROG_CC_GNU,
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
fi])dnl
])# AC_PROG_CC_GNU


# AC_PROG_CXX_GNU
# ---------------
AC_DEFUN(AC_PROG_CXX_GNU,
[AC_CACHE_CHECK(whether we are using GNU C++, ac_cv_prog_gxx,
[dnl The semicolon is to pacify NeXT's syntax-checking cpp.
cat >conftest.C <<EOF
#ifdef __GNUC__
  yes;
#endif
EOF
if AC_TRY_COMMAND(${CXX-g++} -E conftest.C) | egrep yes >/dev/null 2>&1; then
  ac_cv_prog_gxx=yes
else
  ac_cv_prog_gxx=no
fi])dnl
])# AC_PROG_CXX_GNU


# AC_PROG_F77_GNU
# ---------------
# Test whether for Fortran 77 compiler is `g77' (the GNU Fortran 77
# Compiler).  This test depends on whether the Fortran 77 compiler can
# do CPP pre-processing.
AC_DEFUN(AC_PROG_F77_GNU,
[AC_CACHE_CHECK(whether we are using GNU Fortran 77, ac_cv_prog_g77,
[cat >conftest.fpp <<EOF
#ifdef __GNUC__
  yes
#endif
EOF
if AC_TRY_COMMAND($F77 -E conftest.fpp) | egrep yes >/dev/null 2>&1; then
  ac_cv_prog_g77=yes
else
  ac_cv_prog_g77=no
fi])])


# AC_PROG_CC_G
# ------------
AC_DEFUN(AC_PROG_CC_G,
[AC_CACHE_CHECK(whether ${CC-cc} accepts -g, ac_cv_prog_cc_g,
[echo 'void f(){}' >conftest.c
if test -z "`${CC-cc} -g -c conftest.c 2>&1`"; then
  ac_cv_prog_cc_g=yes
else
  ac_cv_prog_cc_g=no
fi
rm -f conftest*
])])


# AC_PROG_CXX_G
# -------------
AC_DEFUN(AC_PROG_CXX_G,
[AC_CACHE_CHECK(whether ${CXX-g++} accepts -g, ac_cv_prog_cxx_g,
[echo 'void f(){}' >conftest.cc
if test -z "`${CXX-g++} -g -c conftest.cc 2>&1`"; then
  ac_cv_prog_cxx_g=yes
else
  ac_cv_prog_cxx_g=no
fi
rm -f conftest*
])])


# AC_PROG_F77_G
# -------------
# Test whether the Fortran 77 compiler can accept the `-g' option to
# enable debugging.
AC_DEFUN(AC_PROG_F77_G,
[AC_CACHE_CHECK(whether $F77 accepts -g, ac_cv_prog_f77_g,
[cat >conftest.f <<EOF
       program conftest
       end
EOF
if test -z "`$F77 -g -c conftest.f 2>&1`"; then
  ac_cv_prog_f77_g=yes
else
  ac_cv_prog_f77_g=no
fi
rm -f conftest*
])])


# AC_PROG_GCC_TRADITIONAL
# -----------------------
AC_DEFUN(AC_PROG_GCC_TRADITIONAL,
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
AC_DEFUN(AC_PROG_CC_C_O,
[if test "x$CC" != xcc; then
  AC_MSG_CHECKING(whether $CC and cc understand -c and -o together)
else
  AC_MSG_CHECKING(whether cc understands -c and -o together)
fi
set dummy $CC; ac_cc=`echo [$]2 |
		      sed -e 's/[[^a-zA-Z0-9_]]/_/g' -e 's/^[[0-9]]/_/'`
AC_CACHE_VAL(ac_cv_prog_cc_${ac_cc}_c_o,
[echo 'foo(){}' >conftest.c
# Make sure it works both with $CC and with simple cc.
# We do the test twice because some compilers refuse to overwrite an
# existing .o file with -o, though they will create one.
ac_try='${CC-cc} -c conftest.c -o conftest.o 1>&AC_FD_CC'
if AC_TRY_EVAL(ac_try) &&
   test -f conftest.o && AC_TRY_EVAL(ac_try);
then
  eval ac_cv_prog_cc_${ac_cc}_c_o=yes
  if test "x$CC" != xcc; then
    # Test first that cc exists at all.
    if AC_TRY_COMMAND(cc -c conftest.c 1>&AC_FD_CC); then
      ac_try='cc -c conftest.c -o conftest.o 1>&AC_FD_CC'
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


# AC_PROG_F77_C_O
# ---------------
# Test if the Fortran 77 compiler accepts the options `-c' and `-o'
# simultaneously, and define `F77_NO_MINUS_C_MINUS_O' if it does not.
#
# The usefulness of this macro is questionable, as I can't really see
# why anyone would use it.  The only reason I include it is for
# completeness, since a similar test exists for the C compiler.
AC_DEFUN(AC_PROG_F77_C_O,
[AC_BEFORE([$0], [AC_PROG_F77])dnl
AC_MSG_CHECKING(whether $F77 understand -c and -o together)
set dummy $F77; ac_f77=`echo [$]2 |
sed -e 's/[[^a-zA-Z0-9_]]/_/g' -e 's/^[[0-9]]/_/'`
AC_CACHE_VAL(ac_cv_prog_f77_${ac_f77}_c_o,
[cat >conftest.f <<EOF
       program conftest
       end
EOF
# We do the `AC_TRY_EVAL' test twice because some compilers refuse to
# overwrite an existing `.o' file with `-o', although they will create
# one.
ac_try='$F77 $FFLAGS -c conftest.f -o conftest.o 1>&AC_FD_CC'
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


# AC_PROG_CC_STDC
# ---------------
# If the C compiler in not in ANSI C mode by default, try to add an
# option to output variable @code{CC} to make it so.  This macro tries
# various options that select ANSI C on some system or another.  It
# considers the compiler to be in ANSI C mode if it handles function
# prototypes correctly.
AC_DEFUN(AC_PROG_CC_STDC,
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
ac_save_CC="$CC"
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
  AC_TRY_COMPILE(
[#include <stdarg.h>
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
char **argv;],
[return f (e, argv, 0) != argv[0]  ||  f (e, argv, 1) != argv[1];],
[ac_cv_prog_cc_stdc="$ac_arg"; break])
done
CC="$ac_save_CC"
])
case "x$ac_cv_prog_cc_stdc" in
  x|xno)
    AC_MSG_RESULT([none needed]) ;;
  *)
    AC_MSG_RESULT($ac_cv_prog_cc_stdc)
    CC="$CC $ac_cv_prog_cc_stdc" ;;
esac
])# AC_PROG_CC_STDC


# AC_PROG_GNU_M4
# --------------
# Check for GNU m4, at least 1.3 (supports frozen files).
AC_DEFUN(AC_PROG_GNU_M4,
[AC_PATH_PROGS(M4, gm4 gnum4 m4, m4)
AC_CACHE_CHECK(whether m4 supports frozen files, ac_cv_prog_gnu_m4,
[ac_cv_prog_gnu_m4=no
if test x"$M4" != x; then
  case `$M4 --help < /dev/null 2>&1` in
    *reload-state*) ac_cv_prog_gnu_m4=yes ;;
  esac
fi])])


# AC_PROG_MAKE_SET
# ----------------
# Define SET_MAKE to set ${MAKE} if make doesn't.
AC_DEFUN(AC_PROG_MAKE_SET,
[AC_MSG_CHECKING(whether ${MAKE-make} sets \${MAKE})
set dummy ${MAKE-make}; ac_make=`echo "[$]2" | sed 'y%./+-%__p_%'`
AC_CACHE_VAL(ac_cv_prog_make_${ac_make}_set,
[cat >conftestmake <<\EOF
all:
	@echo 'ac_maketemp="${MAKE}"'
EOF
# GNU make sometimes prints "make[1]: Entering...", which would confuse us.
eval `${MAKE-make} -f conftestmake 2>/dev/null | grep temp=`
if test -n "$ac_maketemp"; then
  eval ac_cv_prog_make_${ac_make}_set=yes
else
  eval ac_cv_prog_make_${ac_make}_set=no
fi
rm -f conftestmake])dnl
if eval "test \"`echo '$ac_cv_prog_make_'${ac_make}_set`\" = yes"; then
  AC_MSG_RESULT(yes)
  SET_MAKE=
else
  AC_MSG_RESULT(no)
  SET_MAKE="MAKE=${MAKE-make}"
fi
AC_SUBST([SET_MAKE])dnl
])# AC_PROG_MAKE_SET


AC_DEFUN(AC_PROG_RANLIB,
[AC_CHECK_PROG(RANLIB, ranlib, ranlib, :)])


# Check for mawk first since it's generally faster.
AC_DEFUN(AC_PROG_AWK,
[AC_CHECK_PROGS(AWK, mawk gawk nawk awk, )])


# AC_PROG_BINSH
# -------------
# Check the maximum length of an here document.
# FIXME: Is this test really reliable?
AC_DEFUN(AC_PROG_BINSH,
[AC_CACHE_CHECK([for max here document length], ac_cv_prog_binsh_max_heredoc,
[echo >conftest.s1 "\
ac_test='This is a sample string to test here documents.'"
dnl 2^8 = 256 lines
for ac_cnt in 0 1 2 3 4 5 6 7
do
  cat conftest.s1 conftest.s1 >conftest.sh
  mv conftest.sh conftest.s1
done
echo 'cat >conftest.s1 <<CEOF' >conftest.sh
cat conftest.s1 >>conftest.sh
echo 'echo "Success"' >>conftest.sh
echo 'CEOF' >>conftest.sh
$SHELL ./conftest.sh
if test "`$SHELL ./conftest.s1`" != Success; then
dnl Some people say to limit oneself to 12, which seems incredibly small.
  ac_cv_prog_binsh_max_heredoc=12
else
  ac_cv_prog_binsh_max_heredoc=infinite
fi
])dnl
])# AC_PROG_BINSH


# AC_PROG_YACC
# ------------
AC_DEFUN(AC_PROG_YACC,
[AC_CHECK_PROGS(YACC, 'bison -y' byacc, yacc)])


# AC_PROG_CPP
# -----------
AC_DEFUN(AC_PROG_CPP,
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
  ac_cv_prog_CPP="$CPP"])dnl
  CPP="$ac_cv_prog_CPP"
else
  ac_cv_prog_CPP="$CPP"
fi
AC_MSG_RESULT($CPP)
AC_SUBST(CPP)dnl
])# AC_PROG_CPP


# AC_PROG_CXXCPP
# --------------
AC_DEFUN(AC_PROG_CXXCPP,
[AC_MSG_CHECKING(how to run the C++ preprocessor)
if test -z "$CXXCPP"; then
AC_CACHE_VAL(ac_cv_prog_CXXCPP,
[AC_LANG_SAVE()dnl
AC_LANG_CPLUSPLUS()dnl
  CXXCPP="${CXX-g++} -E"
  AC_TRY_CPP([#include <stdlib.h>], , CXXCPP=/lib/cpp)
  ac_cv_prog_CXXCPP="$CXXCPP"
AC_LANG_RESTORE()dnl
])dnl
CXXCPP="$ac_cv_prog_CXXCPP"
fi
AC_MSG_RESULT($CXXCPP)
AC_SUBST(CXXCPP)dnl
])


# Require finding the C or C++ preprocessor, whichever is the
# current language.
AC_DEFUN(AC_REQUIRE_CPP,
[AC_LANG_CASE(C, [AC_REQUIRE([AC_PROG_CPP])],
                 [AC_REQUIRE([AC_PROG_CXXCPP])])])


# AC_PROG_LEX
# -----------
AC_DEFUN(AC_PROG_LEX,
[AC_CHECK_PROG(LEX, flex, flex, lex)
if test -z "$LEXLIB"
then
  case "$LEX" in
  flex*) ac_lib=fl ;;
  *) ac_lib=l ;;
  esac
  AC_CHECK_LIB($ac_lib, yywrap, LEXLIB="-l$ac_lib")
fi
AC_SUBST(LEXLIB)])


# AC_DECL_YYTEXT
# --------------
# Check if lex declares yytext as a char * by default, not a char[].
# FIXME: Why the heck is there the following line?
undefine([AC_DECL_YYTEXT])
AC_DEFUN(AC_DECL_YYTEXT,
[AC_REQUIRE_CPP()dnl
AC_REQUIRE([AC_PROG_LEX])dnl
AC_CACHE_CHECK(lex output file root, ac_cv_prog_lex_root,
[# The minimal lex program is just a single line: %%.  But some broken lexes
# (Solaris, I think it was) want two %% lines, so accommodate them.
echo '%%
%%' | $LEX
if test -f lex.yy.c; then
  ac_cv_prog_lex_root=lex.yy
elif test -f lexyy.c; then
  ac_cv_prog_lex_root=lexyy
else
  AC_MSG_ERROR(cannot find output from $LEX; giving up)
fi])
LEX_OUTPUT_ROOT=$ac_cv_prog_lex_root
AC_SUBST(LEX_OUTPUT_ROOT)dnl

AC_CACHE_CHECK(whether yytext is a pointer, ac_cv_prog_lex_yytext_pointer,
[# POSIX says lex can declare yytext either as a pointer or an array; the
# default is implementation-dependent. Figure out which it is, since
# not all implementations provide the %pointer and %array declarations.
ac_cv_prog_lex_yytext_pointer=no
echo 'extern char *yytext;' >>$LEX_OUTPUT_ROOT.c
ac_save_LIBS="$LIBS"
LIBS="$LIBS $LEXLIB"
AC_TRY_LINK(`cat $LEX_OUTPUT_ROOT.c`, , ac_cv_prog_lex_yytext_pointer=yes)
LIBS="$ac_save_LIBS"
rm -f "${LEX_OUTPUT_ROOT}.c"
])
dnl
if test $ac_cv_prog_lex_yytext_pointer = yes; then
  AC_DEFINE(YYTEXT_POINTER, 1,
            [Define if `lex' declares `yytext' as a `char *' by default,
             not a `char[]'.])
fi
])# AC_DECL_YYTEXT


# AC_PROG_INSTALL
# ---------------
AC_DEFUN(AC_PROG_INSTALL,
[AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
# Find a good install program.  We prefer a C program (faster),
# so one script is as good as another.  But avoid the broken or
# incompatible versions:
# SysV /etc/install, /usr/sbin/install
# SunOS /usr/etc/install
# IRIX /sbin/install
# AIX /bin/install
# AIX 4 /usr/bin/installbsd, which doesn't work without a -g flag
# AFS /usr/afsws/bin/install, which mishandles nonexistent args
# SVR4 /usr/ucb/install, which tries to use the nonexistent group "staff"
# ./install, which can be erroneously created by make from ./install.sh.
AC_MSG_CHECKING(for a BSD compatible install)
if test -z "$INSTALL"; then
AC_CACHE_VAL(ac_cv_path_install,
[  IFS="${IFS= 	}"; ac_save_IFS="$IFS"; IFS=":"
  for ac_dir in $PATH; do
    # Account for people who put trailing slashes in PATH elements.
    case "$ac_dir/" in
    /|./|.//|/etc/*|/usr/sbin/*|/usr/etc/*|/sbin/*|/usr/afsws/bin/*|/usr/ucb/*) ;;
    *)
      # OSF1 and SCO ODT 3.0 have their own names for install.
      # Don't use installbsd from OSF since it installs stuff as root
      # by default.
      for ac_prog in ginstall scoinst install; do
        if test -f $ac_dir/$ac_prog; then
	  if test $ac_prog = install &&
            grep dspmsg $ac_dir/$ac_prog >/dev/null 2>&1; then
	    # AIX install.  It has an incompatible calling convention.
	    :
	  elif test $ac_prog = install &&
	    grep pwplus $ac_dir/$ac_prog >/dev/null 2>&1; then
	    # program-specific install script used by HP pwplus--don't use.
	    :
	  else
	    ac_cv_path_install="$ac_dir/$ac_prog -c"
	    break 2
	  fi
	fi
      done
      ;;
    esac
  done
  IFS="$ac_save_IFS"
])dnl
  if test "${ac_cv_path_install+set}" = set; then
    INSTALL="$ac_cv_path_install"
  else
    # As a last resort, use the slow shell script.  We don't cache a
    # path for INSTALL within a source directory, because that will
    # break other packages using the cache if that directory is
    # removed, or if the path is relative.
    INSTALL="$ac_install_sh"
  fi
fi
dnl We do special magic for INSTALL instead of AC_SUBST, to get
dnl relative paths right.
AC_MSG_RESULT($INSTALL)

# Use test -z because SunOS4 sh mishandles braces in ${var-val}.
# It thinks the first close brace ends the variable substitution.
test -z "$INSTALL_PROGRAM" && INSTALL_PROGRAM='${INSTALL}'
AC_SUBST(INSTALL_PROGRAM)dnl

test -z "$INSTALL_SCRIPT" && INSTALL_SCRIPT='${INSTALL}'
AC_SUBST(INSTALL_SCRIPT)dnl

test -z "$INSTALL_DATA" && INSTALL_DATA='${INSTALL} -m 644'
AC_SUBST(INSTALL_DATA)dnl
])# AC_PROG_INSTALL


# AC_PROG_LN_S
# ------------
AC_DEFUN(AC_PROG_LN_S,
[AC_MSG_CHECKING(whether ln -s works)
AC_CACHE_VAL(ac_cv_prog_LN_S,
[rm -f conftestdata
if ln -s X conftestdata 2>/dev/null
then
  rm -f conftestdata
  ac_cv_prog_LN_S="ln -s"
else
  ac_cv_prog_LN_S=ln
fi])dnl
LN_S="$ac_cv_prog_LN_S"
if test "$ac_cv_prog_LN_S" = "ln -s"; then
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
fi
AC_SUBST(LN_S)dnl
])# AC_PROG_LN_S


AC_DEFUNCT(AC_RSH, [; replace it with equivalent code])




## ------------------------- ##
## Checks for declarations.  ##
## ------------------------- ##


# AC_DECL_SYS_SIGLIST
# -------------------
AC_DEFUN(AC_DECL_SYS_SIGLIST,
[AC_CACHE_CHECK([for sys_siglist declaration in signal.h or unistd.h],
  ac_cv_decl_sys_siglist,
[AC_TRY_COMPILE([#include <sys/types.h>
#include <signal.h>
/* NetBSD declares sys_siglist in unistd.h.  */
#if HAVE_UNISTD_H
# include <unistd.h>
#endif
], [char *msg = *(sys_siglist + 1);],
  ac_cv_decl_sys_siglist=yes, ac_cv_decl_sys_siglist=no)])
if test $ac_cv_decl_sys_siglist = yes; then
  AC_DEFINE(SYS_SIGLIST_DECLARED, 1,
            [Define if `sys_siglist' is declared by <signal.h> or <unistd.h>.])
fi
])# AC_DECL_SYS_SIGLIST




## ------------------------- ##
## Checks for header files.  ##
## ------------------------- ##


# _AC_CHECK_HEADER_DIRENT(HEADER-FILE, ACTION-IF-FOUND)
# ----------------------------------------------------
# Like AC_CHECK_HEADER, except also make sure that HEADER-FILE
# defines the type `DIR'.  dirent.h on NextStep 3.2 doesn't.
AC_DEFUN(_AC_CHECK_HEADER_DIRENT,
[ac_safe=`echo "$1" | sed 'y%./+-%__p_%'`
AC_MSG_CHECKING([for $1 that defines DIR])
AC_CACHE_VAL(ac_cv_header_dirent_$ac_safe,
[AC_TRY_COMPILE([#include <sys/types.h>
#include <$1>
], [DIR *dirp = 0;],
  eval "ac_cv_header_dirent_$ac_safe=yes",
  eval "ac_cv_header_dirent_$ac_safe=no")])dnl
if eval "test \"`echo '$ac_cv_header_dirent_'$ac_safe`\" = yes"; then
  AC_MSG_RESULT(yes)
  $2
else
  AC_MSG_RESULT(no)
fi
])# _AC_CHECK_HEADER_DIRENT


# _AC_CHECK_HEADERS_DIRENT(HEADER-FILE... [, ACTION])
# --------------------------------------------------
# Like AC_CHECK_HEADERS, except succeed only for a HEADER-FILE that
# defines `DIR'.
define(_AC_CHECK_HEADERS_DIRENT,
[for ac_hdr in $1
do
_AC_CHECK_HEADER_DIRENT($ac_hdr,
[changequote(, )dnl
  ac_tr_hdr=HAVE_`echo $ac_hdr | sed 'y%abcdefghijklmnopqrstuvwxyz./-%ABCDEFGHIJKLMNOPQRSTUVWXYZ___%'`
changequote([, ])dnl
  AC_DEFINE_UNQUOTED($ac_tr_hdr) $2])dnl
done])# _AC_CHECK_HEADERS_DIRENT


# AC_HEADER_DIRENT
# ----------------
AC_DEFUN(AC_HEADER_DIRENT,
[ac_header_dirent=no
_AC_CHECK_HEADERS_DIRENT(dirent.h sys/ndir.h sys/dir.h ndir.h,
  [ac_header_dirent=$ac_hdr; break])
# Two versions of opendir et al. are in -ldir and -lx on SCO Xenix.
if test $ac_header_dirent = dirent.h; then
  AC_CHECK_LIB(dir, opendir, LIBS="$LIBS -ldir")
else
  AC_CHECK_LIB(x, opendir, LIBS="$LIBS -lx")
fi
])# AC_HEADER_DIRENT


# AC_HEADER_MAJOR
# ---------------
AC_DEFUN(AC_HEADER_MAJOR,
[AC_CACHE_CHECK(whether sys/types.h defines makedev,
  ac_cv_header_sys_types_h_makedev,
[AC_TRY_LINK([#include <sys/types.h>
], [return makedev(0, 0);],
  ac_cv_header_sys_types_h_makedev=yes, ac_cv_header_sys_types_h_makedev=no)
])

if test $ac_cv_header_sys_types_h_makedev = no; then
AC_CHECK_HEADER(sys/mkdev.h,
                [AC_DEFINE(MAJOR_IN_MKDEV, 1,
                           [Define if `major', `minor', and `makedev' are
                            declared in <mkdev.h>.])])

  if test $ac_cv_header_sys_mkdev_h = no; then
    AC_CHECK_HEADER(sys/sysmacros.h,
                    [AC_DEFINE(MAJOR_IN_SYSMACROS, 1,
                               [Define if `major', `minor', and `makedev' are
                                declared in <sysmacros.h>.])])
  fi
fi
])# AC_HEADER_MAJOR


# AC_HEADER_STAT
# --------------
# FIXME: Shouldn't this be named AC_HEADER_SYS_STAT?
AC_DEFUN(AC_HEADER_STAT,
[AC_CACHE_CHECK(whether stat file-mode macros are broken,
  ac_cv_header_stat_broken,
[AC_EGREP_CPP([You lose], [#include <sys/types.h>
#include <sys/stat.h>

#if defined(S_ISBLK) && defined(S_IFDIR)
# if S_ISBLK (S_IFDIR)
You lose.
# endif
#endif

#if defined(S_ISBLK) && defined(S_IFCHR)
# if S_ISBLK (S_IFCHR)
You lose.
# endif
#endif

#if defined(S_ISLNK) && defined(S_IFREG)
# if S_ISLNK (S_IFREG)
You lose.
# endif
#endif

#if defined(S_ISSOCK) && defined(S_IFREG)
# if S_ISSOCK (S_IFREG)
You lose.
# endif
#endif
], ac_cv_header_stat_broken=yes, ac_cv_header_stat_broken=no)])
if test $ac_cv_header_stat_broken = yes; then
  AC_DEFINE(STAT_MACROS_BROKEN, 1,
            [Define if the `S_IS*' macros in <sys/stat.h> do not
             work properly.])
fi
])# AC_HEADER_STAT


# AC_HEADER_STDC
# --------------
AC_DEFUN(AC_HEADER_STDC,
[AC_REQUIRE_CPP()dnl
AC_CACHE_CHECK(for ANSI C header files, ac_cv_header_stdc,
[AC_TRY_CPP([#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <float.h>
], ac_cv_header_stdc=yes, ac_cv_header_stdc=no)

if test $ac_cv_header_stdc = yes; then
  # SunOS 4.x string.h does not declare mem*, contrary to ANSI.
AC_EGREP_HEADER(memchr, string.h, , ac_cv_header_stdc=no)
fi

if test $ac_cv_header_stdc = yes; then
  # ISC 2.0.2 stdlib.h does not declare free, contrary to ANSI.
AC_EGREP_HEADER(free, stdlib.h, , ac_cv_header_stdc=no)
fi

if test $ac_cv_header_stdc = yes; then
  # /bin/cc in Irix-4.0.5 gets non-ANSI ctype macros unless using -ansi.
AC_TRY_RUN(
[#include <ctype.h>
#if ((' ' & 0x0FF) == 0x020)
# define ISLOWER(c) ('a' <= (c) && (c) <= 'z')
# define TOUPPER(c) (ISLOWER(c) ? 'A' + ((c) - 'a') : (c))
#else
# define ISLOWER(c) (('a' <= (c) && (c) <= 'i') \
                     || ('j' <= (c) && (c) <= 'r') \
                     || ('s' <= (c) && (c) <= 'z'))
# define TOUPPER(c) (ISLOWER(c) ? ((c) | 0x40) : (c))
#endif

#define XOR(e, f) (((e) && !(f)) || (!(e) && (f)))
int
main ()
{
  int i;
  for (i = 0; i < 256; i++)
    if (XOR (islower (i), ISLOWER (i))
        || toupper (i) != TOUPPER (i))
      exit(2);
  exit (0);
}], , ac_cv_header_stdc=no, :)
fi])
if test $ac_cv_header_stdc = yes; then
  AC_DEFINE(STDC_HEADERS, 1, [Define if you have the ANSI C header files.])
fi
])# AC_HEADER_STDC


# AC_HEADER_SYS_WAIT
# ------------------
AC_DEFUN(AC_HEADER_SYS_WAIT,
[AC_CACHE_CHECK([for sys/wait.h that is POSIX.1 compatible],
  ac_cv_header_sys_wait_h,
[AC_TRY_COMPILE(
[#include <sys/types.h>
#include <sys/wait.h>
#ifndef WEXITSTATUS
# define WEXITSTATUS(stat_val) ((unsigned)(stat_val) >> 8)
#endif
#ifndef WIFEXITED
# define WIFEXITED(stat_val) (((stat_val) & 255) == 0)
#endif],
[  int s;
  wait (&s);
  s = WIFEXITED (s) ? WEXITSTATUS (s) : 1;],
ac_cv_header_sys_wait_h=yes, ac_cv_header_sys_wait_h=no)])
if test $ac_cv_header_sys_wait_h = yes; then
  AC_DEFINE(HAVE_SYS_WAIT_H, 1,
            [Define if you have <sys/wait.h> that is POSIX.1 compatible.])
fi
])# AC_HEADER_SYS_WAIT


# AC_HEADER_TIME
# --------------
AC_DEFUN(AC_HEADER_TIME,
[AC_CACHE_CHECK([whether time.h and sys/time.h may both be included],
  ac_cv_header_time,
[AC_TRY_COMPILE([#include <sys/types.h>
#include <sys/time.h>
#include <time.h>
],
[struct tm *tp;], ac_cv_header_time=yes, ac_cv_header_time=no)])
if test $ac_cv_header_time = yes; then
  AC_DEFINE(TIME_WITH_SYS_TIME, 1,
            [Define if you can safely include both <sys/time.h> and <time.h>.])
fi
])# AC_HEADER_TIME




# A few hasbeen'd macros.

AC_DEFUNCT(AC_UNISTD_H, [; instead use AC_CHECK_HEADERS(unistd.h)])

AC_DEFUNCT(AC_USG,
           [; instead use AC_CHECK_HEADERS(string.h) and HAVE_STRING_H])

# If memchr and the like aren't declared in <string.h>, include <memory.h>.
# To avoid problems, don't check for gcc2 built-ins.
AC_DEFUNCT(AC_MEMORY_H,
           [; instead use AC_CHECK_HEADERS(memory.h) and HAVE_MEMORY_H])


# Like calling `AC_HEADER_DIRENT' and `AC_FUNC_CLOSEDIR_VOID', but
# defines a different set of C preprocessor macros to indicate which
# header file is found.  This macro and the names it defines are
# considered obsolete.
AC_DEFUNCT(AC_DIR_HEADER,
[; instead use AC_HEADER_DIRENT])






## --------------------- ##
## Checks for typedefs.  ##
## --------------------- ##


# AC_TYPE_GETGROUPS
# -----------------
AC_DEFUN(AC_TYPE_GETGROUPS,
[AC_REQUIRE([AC_TYPE_UID_T])dnl
AC_CACHE_CHECK(type of array argument to getgroups, ac_cv_type_getgroups,
[AC_TRY_RUN(
[/* Thanks to Mike Rendell for this test.  */
#include <sys/types.h>
#define NGID 256
#undef MAX
#define MAX(x, y) ((x) > (y) ? (x) : (y))
int
main ()
{
  gid_t gidset[NGID];
  int i, n;
  union { gid_t gval; long lval; }  val;

  val.lval = -1;
  for (i = 0; i < NGID; i++)
    gidset[i] = val.gval;
  n = getgroups (sizeof (gidset) / MAX (sizeof (int), sizeof (gid_t)) - 1,
                 gidset);
  /* Exit non-zero if getgroups seems to require an array of ints.  This
     happens when gid_t is short but getgroups modifies an array of ints.  */
  exit ((n > 0 && gidset[n] != val.gval) ? 1 : 0);
}],
  ac_cv_type_getgroups=gid_t, ac_cv_type_getgroups=int,
  ac_cv_type_getgroups=cross)
if test $ac_cv_type_getgroups = cross; then
  dnl When we can't run the test program (we are cross compiling), presume
  dnl that <unistd.h> has either an accurate prototype for getgroups or none.
  dnl Old systems without prototypes probably use int.
  AC_EGREP_HEADER([getgroups.*int.*gid_t], unistd.h,
		  ac_cv_type_getgroups=gid_t, ac_cv_type_getgroups=int)
fi])
AC_DEFINE_UNQUOTED(GETGROUPS_T, $ac_cv_type_getgroups,
                   [Define to the type of elements in the array set by
                    `getgroups'. Usually this is either `int' or `gid_t'.])
])# AC_TYPE_GETGROUPS


# AC_TYPE_UID_T
# -------------
# FIXME: Rewrite using AC_CHECK_TYPE.
AC_DEFUN(AC_TYPE_UID_T,
[AC_CACHE_CHECK(for uid_t in sys/types.h, ac_cv_type_uid_t,
[AC_EGREP_HEADER(uid_t, sys/types.h,
  ac_cv_type_uid_t=yes, ac_cv_type_uid_t=no)])
if test $ac_cv_type_uid_t = no; then
  AC_DEFINE(uid_t, int, [Define to `int' if <sys/types.h> doesn't define.])
  AC_DEFINE(gid_t, int, [Define to `int' if <sys/types.h> doesn't define.])
fi
])

# FIXME: AU_DEFUN these guys?
AC_DEFUN(AC_TYPE_SIZE_T,
[AC_CHECK_TYPE(size_t, unsigned)])

AC_DEFUN(AC_TYPE_PID_T,
[AC_CHECK_TYPE(pid_t, int)])

AC_DEFUN(AC_TYPE_OFF_T,
[AC_CHECK_TYPE(off_t, long)])

AC_DEFUN(AC_TYPE_MODE_T,
[AC_CHECK_TYPE(mode_t, int)])


# AC_TYPE_SIGNAL
# --------------
# Note that identifiers starting with SIG are reserved by ANSI C.
AC_DEFUN(AC_TYPE_SIGNAL,
[AC_CACHE_CHECK([return type of signal handlers], ac_cv_type_signal,
[AC_TRY_COMPILE([#include <sys/types.h>
#include <signal.h>
#ifdef signal
# undef signal
#endif
#ifdef __cplusplus
extern "C" void (*signal (int, void (*)(int)))(int);
#else
void (*signal ()) ();
#endif
],
[int i;], ac_cv_type_signal=void, ac_cv_type_signal=int)])
AC_DEFINE_UNQUOTED(RETSIGTYPE, $ac_cv_type_signal,
                   [Define as the return type of signal handlers
                    (`int' or `void').])
])




## ---------------------- ##
## Checks for functions.  ##
## ---------------------- ##


# AC_FUNC_ALLOCA
# --------------
AC_DEFUN(AC_FUNC_ALLOCA,
[AC_REQUIRE_CPP()dnl Set CPP; we run AC_EGREP_CPP conditionally.
# The Ultrix 4.2 mips builtin alloca declared by alloca.h only works
# for constant arguments.  Useless!
AC_CACHE_CHECK([for working alloca.h], ac_cv_working_alloca_h,
[AC_TRY_LINK([#include <alloca.h>],
  [char *p = (char *) alloca (2 * sizeof (int));],
  ac_cv_working_alloca_h=yes, ac_cv_working_alloca_h=no)])
if test $ac_cv_working_alloca_h = yes; then
  AC_DEFINE(HAVE_ALLOCA_H, 1,
            [Define if you have <alloca.h> and it should be used
             (not on Ultrix).])
fi

AC_CACHE_CHECK([for alloca], ac_cv_func_alloca_works,
[AC_TRY_LINK(
[#ifdef __GNUC__
# define alloca __builtin_alloca
#else
# ifdef _MSC_VER
#  include <malloc.h>
#  define alloca _alloca
# else
#  if HAVE_ALLOCA_H
#   include <alloca.h>
#  else
#   ifdef _AIX
 #pragma alloca
#   else
#    ifndef alloca /* predefined by HP cc +Olibcalls */
char *alloca ();
#    endif
#   endif
#  endif
# endif
#endif
], [char *p = (char *) alloca(1);],
  ac_cv_func_alloca_works=yes, ac_cv_func_alloca_works=no)])
if test $ac_cv_func_alloca_works = yes; then
  AC_DEFINE(HAVE_ALLOCA, 1,
            [Define if you have `alloca', as a function or macro.])
fi

if test $ac_cv_func_alloca_works = no; then
  # The SVR3 libPW and SVR4 libucb both contain incompatible functions
  # that cause trouble.  Some versions do not even contain alloca or
  # contain a buggy version.  If you still want to use their alloca,
  # use ar to extract alloca.o from them instead of compiling alloca.c.
  ALLOCA=alloca.${ac_objext}
  AC_DEFINE(C_ALLOCA, 1, [Define if using `alloca.c'.])

AC_CACHE_CHECK(whether alloca needs Cray hooks, ac_cv_os_cray,
[AC_EGREP_CPP(webecray,
[#if defined(CRAY) && ! defined(CRAY2)
webecray
#else
wenotbecray
#endif
], ac_cv_os_cray=yes, ac_cv_os_cray=no)])
if test $ac_cv_os_cray = yes; then
for ac_func in _getb67 GETB67 getb67; do
  AC_CHECK_FUNC($ac_func,
                [AC_DEFINE_UNQUOTED(CRAY_STACKSEG_END, $ac_func,
                                    [Define to one of _getb67, GETB67, getb67
                                     for Cray-2 and Cray-YMP systems.
                                     This function is required for alloca.c
                                     support on those systems.])
  break])
done
fi

AC_CACHE_CHECK(stack direction for C alloca, ac_cv_c_stack_direction,
[AC_TRY_RUN(
[find_stack_direction ()
{
  static char *addr = 0;
  auto char dummy;
  if (addr == 0)
    {
      addr = &dummy;
      return find_stack_direction ();
    }
  else
    return (&dummy > addr) ? 1 : -1;
}

int
main ()
{
  exit (find_stack_direction () < 0);
}], ac_cv_c_stack_direction=1, ac_cv_c_stack_direction=-1,
  ac_cv_c_stack_direction=0)])
AC_DEFINE_UNQUOTED(STACK_DIRECTION, $ac_cv_c_stack_direction)
fi
AC_SUBST(ALLOCA)dnl
])# AC_FUNC_ALLOCA


# AC_FUNC_CLOSEDIR_VOID
# ---------------------
# Check whether closedir returns void, and #define CLOSEDIR_VOID in
# that case.
AC_DEFUN(AC_FUNC_CLOSEDIR_VOID,
[AC_REQUIRE([AC_HEADER_DIRENT])dnl
AC_CACHE_CHECK(whether closedir returns void, ac_cv_func_closedir_void,
[AC_TRY_RUN(
[#include <sys/types.h>
#include <$ac_header_dirent>

int closedir ();
int
main ()
{
  exit (closedir (opendir (".")) != 0);
}],
  ac_cv_func_closedir_void=no,
  ac_cv_func_closedir_void=yes,
  ac_cv_func_closedir_void=yes)])
if test $ac_cv_func_closedir_void = yes; then
  AC_DEFINE(CLOSEDIR_VOID, 1,
            [Define if the `closedir' function returns void instead of `int'.])
fi
])


# AC_FUNC_FNMATCH
# ---------------
# We look for fnmatch.h to avoid that the test fails in C++.
AC_DEFUN(AC_FUNC_FNMATCH,
[AC_CHECK_HEADERS(fnmatch.h)
AC_CACHE_CHECK(for working fnmatch, ac_cv_func_fnmatch_works,
# Some versions of Solaris or SCO have a broken fnmatch function.
# So we run a test program.  If we are cross-compiling, take no chance.
# Thanks to John Oleynick and Franc,ois Pinard for this test.
[AC_TRY_RUN(
[#if HAVE_FNMATCH_H
# include <fnmatch.h>
#endif

int
main ()
{
  exit (fnmatch ("a*", "abc", 0) != 0);
}],
ac_cv_func_fnmatch_works=yes, ac_cv_func_fnmatch_works=no,
ac_cv_func_fnmatch_works=no)])
if test $ac_cv_func_fnmatch_works = yes; then
  AC_DEFINE(HAVE_FNMATCH, 1,
            [Define if your system has a working `fnmatch' function.])
fi
])# AC_FUNC_FNMATCH


# AC_FUNC_GETLOADAVG
# ------------------
AC_DEFUN(AC_FUNC_GETLOADAVG,
[ac_have_func=no # yes means we've found a way to get the load average.

# Some systems with -lutil have (and need) -lkvm as well, some do not.
# On Solaris, -lkvm requires nlist from -lelf, so check that first
# to get the right answer into the cache.
AC_CHECK_LIB(elf, elf_begin, LIBS="-lelf $LIBS")
AC_CHECK_LIB(kvm, kvm_open, LIBS="-lkvm $LIBS")
AC_CHECK_LIB(kstat, kstat_open)
# Check for the 4.4BSD definition of getloadavg.
AC_CHECK_LIB(util, getloadavg,
  [LIBS="-lutil $LIBS" ac_have_func=yes ac_cv_func_getloadavg_setgid=yes])

if test $ac_have_func = no; then
  # There is a commonly available library for RS/6000 AIX.
  # Since it is not a standard part of AIX, it might be installed locally.
  ac_getloadavg_LIBS="$LIBS"; LIBS="-L/usr/local/lib $LIBS"
  AC_CHECK_LIB(getloadavg, getloadavg,
    LIBS="-lgetloadavg $LIBS", LIBS="$ac_getloadavg_LIBS")
fi

# Make sure it is really in the library, if we think we found it.
AC_REPLACE_FUNCS(getloadavg)

if test $ac_cv_func_getloadavg = yes; then
  AC_DEFINE(HAVE_GETLOADAVG, 1,
            [Define if your system has its own `getloadavg' function.])
  ac_have_func=yes
else
  # Figure out what our getloadavg.c needs.
  ac_have_func=no
  AC_CHECK_HEADER(sys/dg_sys_info.h,
  [ac_have_func=yes;
   AC_DEFINE(DGUX, 1, [Define for DGUX with <sys/dg_sys_info.h>.])
   AC_CHECK_LIB(dgc, dg_sys_info)])

  # We cannot check for <dwarf.h>, because Solaris 2 does not use dwarf (it
  # uses stabs), but it is still SVR4.  We cannot check for <elf.h> because
  # Irix 4.0.5F has the header but not the library.
  if test $ac_have_func = no && test $ac_cv_lib_elf_elf_begin = yes; then
    ac_have_func=yes;
    AC_DEFINE(SVR4, 1,
              [Define on System V Release 4.])
  fi

  if test $ac_have_func = no; then
    AC_CHECK_HEADER(inq_stats/cpustats.h,
    [ac_have_func=yes;
     AC_DEFINE(UMAX, 1,
               [Define for Encore UMAX.])
     AC_DEFINE(UMAX4_3, 1,
               [Define for Encore UMAX 4.3 that has <inq_status/cpustats.h>
                instead of <sys/cpustats.h>.])])
  fi

  if test $ac_have_func = no; then
    AC_CHECK_HEADER(sys/cpustats.h,
    [ac_have_func=yes; AC_DEFINE(UMAX)])
  fi

  if test $ac_have_func = no; then
    AC_CHECK_HEADERS(mach/mach.h)
  fi

  AC_CHECK_HEADER(nlist.h,
  [AC_DEFINE(NLIST_STRUCT, 1, [Define if you have <nlist.h>.])
  AC_CACHE_CHECK([for n_un in struct nlist], ac_cv_struct_nlist_n_un,
  [AC_TRY_COMPILE([#include <nlist.h>
],
                  [struct nlist n; n.n_un.n_name = 0;],
                  ac_cv_struct_nlist_n_un=yes, ac_cv_struct_nlist_n_un=no)])
  if test $ac_cv_struct_nlist_n_un = yes; then
    AC_DEFINE(NLIST_NAME_UNION, 1,
              [Define if your `struct nlist' has an `n_un' member.])
  fi
  ])dnl
fi # Do not have getloadavg in system libraries.

# Some definitions of getloadavg require that the program be installed setgid.
dnl FIXME: Don't hardwire the path of getloadavg.c in the top-level directory.
AC_CACHE_CHECK(whether getloadavg requires setgid,
  ac_cv_func_getloadavg_setgid,
[AC_EGREP_CPP([Yowza Am I SETGID yet],
[#include "$srcdir/getloadavg.c"
#ifdef LDAV_PRIVILEGED
Yowza Am I SETGID yet
#endif],
  ac_cv_func_getloadavg_setgid=yes, ac_cv_func_getloadavg_setgid=no)])
if test $ac_cv_func_getloadavg_setgid = yes; then
  NEED_SETGID=true;
  AC_DEFINE(GETLOADAVG_PRIVILEGED, 1,
            [Define if the `getloadavg' function needs to be run setuid
             or setgid.])
else
  NEED_SETGID=false
fi
AC_SUBST(NEED_SETGID)dnl

if test $ac_cv_func_getloadavg_setgid = yes; then
  AC_CACHE_CHECK(group of /dev/kmem, ac_cv_group_kmem,
[ # On Solaris, /dev/kmem is a symlink.  Get info on the real file.
  ac_ls_output=`ls -lgL /dev/kmem 2>/dev/null`
  # If we got an error (system does not support symlinks), try without -L.
  test -z "$ac_ls_output" && ac_ls_output=`ls -lg /dev/kmem`
  ac_cv_group_kmem=`echo $ac_ls_output \
    | sed -ne ['s/[ 	][ 	]*/ /g;
	       s/^.[sSrwx-]* *[0-9]* *\([^0-9]*\)  *.*/\1/;
	       / /s/.* //;p;']`
])
  KMEM_GROUP=$ac_cv_group_kmem
fi
AC_SUBST(KMEM_GROUP)dnl
])# AC_FUNC_GETLOADAVG


# AC_FUNC_GETMNTENT
# -----------------
AC_DEFUN(AC_FUNC_GETMNTENT,
[# getmntent is in -lsun on Irix 4, -lseq on Dynix/PTX, -lgen on Unixware.
AC_CHECK_LIB(sun, getmntent, LIBS="-lsun $LIBS",
  [AC_CHECK_LIB(seq, getmntent, LIBS="-lseq $LIBS",
    [AC_CHECK_LIB(gen, getmntent, LIBS="-lgen $LIBS")])])
AC_CHECK_FUNC(getmntent,
              [AC_DEFINE(HAVE_GETMNTENT, 1,
                         [Define if you have the `getmntent' function.])])])


# AC_FUNC_GETPGRP
# ---------------
AC_DEFUN(AC_FUNC_GETPGRP,
[AC_CACHE_CHECK(whether getpgrp takes no argument, ac_cv_func_getpgrp_void,
[AC_TRY_RUN(
[/*
 * If this system has a BSD-style getpgrp(),
 * which takes a pid argument, exit unsuccessfully.
 *
 * Snarfed from Chet Ramey's bash pgrp.c test program
 */
#include <stdio.h>
#include <sys/types.h>

int     pid;
int     pg1, pg2, pg3, pg4;
int     ng, np, s, child;

int
main ()
{
  pid = getpid ();
  pg1 = getpgrp (0);
  pg2 = getpgrp ();
  pg3 = getpgrp (pid);
  pg4 = getpgrp (1);

  /* If all of these values are the same, it's pretty sure that we're
     on a system that ignores getpgrp's first argument.  */
  if (pg2 == pg4 && pg1 == pg3 && pg2 == pg3)
    exit (0);

  child = fork ();
  if (child < 0)
    exit(1);
  else if (child == 0)
    {
      np = getpid ();
      /*  If this is Sys V, this will not work; pgrp will be set to np
	 because setpgrp just changes a pgrp to be the same as the
	 pid.  */
      setpgrp (np, pg1);
      ng = getpgrp (0);        /* Same result for Sys V and BSD */
      if (ng == pg1)
  	exit (1);
      else
  	exit (0);
    }
  else
    {
      wait (&s);
      exit (s>>8);
    }
}], ac_cv_func_getpgrp_void=yes, ac_cv_func_getpgrp_void=no,
   AC_MSG_ERROR(cannot check getpgrp if cross compiling))
])
if test $ac_cv_func_getpgrp_void = yes; then
  AC_DEFINE(GETPGRP_VOID, 1,
            [Define if the `getpgrp' function takes no argument.])
fi
])# AC_FUNC_GETPGRP


# AC_FUNC_MKTIME
# --------------
AC_DEFUN(AC_FUNC_MKTIME,
[AC_REQUIRE([AC_HEADER_TIME])dnl
AC_CHECK_HEADERS(sys/time.h unistd.h)
AC_CHECK_FUNCS(alarm)
AC_CACHE_CHECK([for working mktime], ac_cv_func_working_mktime,
[AC_TRY_RUN(
[/* Test program from Paul Eggert and Tony Leneis.  */
#if TIME_WITH_SYS_TIME
# include <sys/time.h>
# include <time.h>
#else
# if HAVE_SYS_TIME_H
#  include <sys/time.h>
# else
#  include <time.h>
# endif
#endif

#if HAVE_UNISTD_H
# include <unistd.h>
#endif

#if !HAVE_ALARM
# define alarm(X) /* empty */
#endif

/* Work around redefinition to rpl_putenv by other config tests.  */
#undef putenv

static time_t time_t_max;

/* Values we'll use to set the TZ environment variable.  */
static const char *const tz_strings[] = {
  (const char *) 0, "TZ=GMT0", "TZ=JST-9",
  "TZ=EST+3EDT+2,M10.1.0/00:00:00,M2.3.0/00:00:00"
};
#define N_STRINGS (sizeof (tz_strings) / sizeof (tz_strings[0]))

/* Fail if mktime fails to convert a date in the spring-forward gap.
   Based on a problem report from Andreas Jaeger.  */
static void
spring_forward_gap ()
{
  /* glibc (up to about 1998-10-07) failed this test) */
  struct tm tm;

  /* Use the portable POSIX.1 specification "TZ=PST8PDT,M4.1.0,M10.5.0"
     instead of "TZ=America/Vancouver" in order to detect the bug even
     on systems that don't support the Olson extension, or don't have the
     full zoneinfo tables installed.  */
  putenv ("TZ=PST8PDT,M4.1.0,M10.5.0");

  tm.tm_year = 98;
  tm.tm_mon = 3;
  tm.tm_mday = 5;
  tm.tm_hour = 2;
  tm.tm_min = 0;
  tm.tm_sec = 0;
  tm.tm_isdst = -1;
  if (mktime (&tm) == (time_t)-1)
    exit (1);
}

static void
mktime_test (now)
     time_t now;
{
  struct tm *lt;
  if ((lt = localtime (&now)) && mktime (lt) != now)
    exit (1);
  now = time_t_max - now;
  if ((lt = localtime (&now)) && mktime (lt) != now)
    exit (1);
}

static void
irix_6_4_bug ()
{
  /* Based on code from Ariel Faigon.  */
  struct tm tm;
  tm.tm_year = 96;
  tm.tm_mon = 3;
  tm.tm_mday = 0;
  tm.tm_hour = 0;
  tm.tm_min = 0;
  tm.tm_sec = 0;
  tm.tm_isdst = -1;
  mktime (&tm);
  if (tm.tm_mon != 2 || tm.tm_mday != 31)
    exit (1);
}

static void
bigtime_test (j)
     int j;
{
  struct tm tm;
  time_t now;
  tm.tm_year = tm.tm_mon = tm.tm_mday = tm.tm_hour = tm.tm_min = tm.tm_sec = j;
  now = mktime (&tm);
  if (now != (time_t) -1)
    {
      struct tm *lt = localtime (&now);
      if (! (lt
	     && lt->tm_year == tm.tm_year
	     && lt->tm_mon == tm.tm_mon
	     && lt->tm_mday == tm.tm_mday
	     && lt->tm_hour == tm.tm_hour
	     && lt->tm_min == tm.tm_min
	     && lt->tm_sec == tm.tm_sec
	     && lt->tm_yday == tm.tm_yday
	     && lt->tm_wday == tm.tm_wday
	     && ((lt->tm_isdst < 0 ? -1 : 0 < lt->tm_isdst)
		  == (tm.tm_isdst < 0 ? -1 : 0 < tm.tm_isdst))))
	exit (1);
    }
}

int
main ()
{
  time_t t, delta;
  int i, j;

  /* This test makes some buggy mktime implementations loop.
     Give up after 60 seconds; a mktime slower than that
     isn't worth using anyway.  */
  alarm (60);

  for (time_t_max = 1; 0 < time_t_max; time_t_max *= 2)
    continue;
  time_t_max--;
  delta = time_t_max / 997; /* a suitable prime number */
  for (i = 0; i < N_STRINGS; i++)
    {
      if (tz_strings[i])
	putenv (tz_strings[i]);

      for (t = 0; t <= time_t_max - delta; t += delta)
	mktime_test (t);
      mktime_test ((time_t) 60 * 60);
      mktime_test ((time_t) 60 * 60 * 24);

      for (j = 1; 0 < j; j *= 2)
        bigtime_test (j);
      bigtime_test (j - 1);
    }
  irix_6_4_bug ();
  spring_forward_gap ();
  exit (0);
}],
ac_cv_func_working_mktime=yes, ac_cv_func_working_mktime=no,
ac_cv_func_working_mktime=no)])
if test $ac_cv_func_working_mktime = no; then
  LIBOBJS="$LIBOBJS mktime.${ac_objext}"
fi
])# AC_FUNC_MKTIME


# AC_FUNC_MMAP
# ------------
AC_DEFUN(AC_FUNC_MMAP,
[AC_CHECK_HEADERS(stdlib.h unistd.h sys/stat.h)
AC_CHECK_FUNCS(getpagesize)
AC_CACHE_CHECK(for working mmap, ac_cv_func_mmap_fixed_mapped,
[AC_TRY_RUN(
[/* Thanks to Mike Haertel and Jim Avera for this test.
   Here is a matrix of mmap possibilities:
	mmap private not fixed
	mmap private fixed at somewhere currently unmapped
	mmap private fixed at somewhere already mapped
	mmap shared not fixed
	mmap shared fixed at somewhere currently unmapped
	mmap shared fixed at somewhere already mapped
   For private mappings, we should verify that changes cannot be read()
   back from the file, nor mmap's back from the file at a different
   address.  (There have been systems where private was not correctly
   implemented like the infamous i386 svr4.0, and systems where the
   VM page cache was not coherent with the file system buffer cache
   like early versions of FreeBSD and possibly contemporary NetBSD.)
   For shared mappings, we should conversely verify that changes get
   propogated back to all the places they're supposed to be.

   Grep wants private fixed already mapped.
   The main things grep needs to know about mmap are:
   * does it exist and is it safe to write into the mmap'd area
   * how to use it (BSD variants)  */
#include <sys/types.h>
#include <fcntl.h>
#include <sys/mman.h>

#if HAVE_STDLIB_H
# include <stdlib.h>
#else
char *malloc ();
#endif
#if HAVE_UNISTD_H
# include <unistd.h>
#endif
#if HAVE_SYS_STAT_H
# include <sys/stat.h>
#endif

/* This mess was copied from the GNU getpagesize.h.  */
#if !HAVE_GETPAGESIZE
/* Assume that all systems that can run configure have sys/param.h.  */
# if !HAVE_SYS_PARAM_H
#  define HAVE_SYS_PARAM_H 1
# endif

# ifdef _SC_PAGESIZE
#  define getpagesize() sysconf(_SC_PAGESIZE)
# else /* no _SC_PAGESIZE */
#  if HAVE_SYS_PARAM_H
#   include <sys/param.h>
#   ifdef EXEC_PAGESIZE
#    define getpagesize() EXEC_PAGESIZE
#   else /* no EXEC_PAGESIZE */
#    ifdef NBPG
#     define getpagesize() NBPG * CLSIZE
#     ifndef CLSIZE
#      define CLSIZE 1
#     endif /* no CLSIZE */
#    else /* no NBPG */
#     ifdef NBPC
#      define getpagesize() NBPC
#     else /* no NBPC */
#      ifdef PAGESIZE
#       define getpagesize() PAGESIZE
#      endif /* PAGESIZE */
#     endif /* no NBPC */
#    endif /* no NBPG */
#   endif /* no EXEC_PAGESIZE */
#  else /* no HAVE_SYS_PARAM_H */
#   define getpagesize() 8192	/* punt totally */
#  endif /* no HAVE_SYS_PARAM_H */
# endif /* no _SC_PAGESIZE */

#endif /* no HAVE_GETPAGESIZE */

int
main ()
{
  char *data, *data2, *data3;
  int i, pagesize;
  int fd;

  pagesize = getpagesize ();

  /* First, make a file with some known garbage in it. */
  data = (char *) malloc (pagesize);
  if (!data)
    exit (1);
  for (i = 0; i < pagesize; ++i)
    *(data + i) = rand ();
  umask (0);
  fd = creat ("conftestmmap", 0600);
  if (fd < 0)
    exit (1);
  if (write (fd, data, pagesize) != pagesize)
    exit (1);
  close (fd);

  /* Next, try to mmap the file at a fixed address which already has
     something else allocated at it.  If we can, also make sure that
     we see the same garbage.  */
  fd = open ("conftestmmap", O_RDWR);
  if (fd < 0)
    exit (1);
  data2 = (char *) malloc (2 * pagesize);
  if (!data2)
    exit (1);
  data2 += (pagesize - ((int) data2 & (pagesize - 1))) & (pagesize - 1);
  if (data2 != mmap (data2, pagesize, PROT_READ | PROT_WRITE,
                     MAP_PRIVATE | MAP_FIXED, fd, 0L))
    exit (1);
  for (i = 0; i < pagesize; ++i)
    if (*(data + i) != *(data2 + i))
      exit (1);

  /* Finally, make sure that changes to the mapped area do not
     percolate back to the file as seen by read().  (This is a bug on
     some variants of i386 svr4.0.)  */
  for (i = 0; i < pagesize; ++i)
    *(data2 + i) = *(data2 + i) + 1;
  data3 = (char *) malloc (pagesize);
  if (!data3)
    exit (1);
  if (read (fd, data3, pagesize) != pagesize)
    exit (1);
  for (i = 0; i < pagesize; ++i)
    if (*(data + i) != *(data3 + i))
      exit (1);
  close (fd);
  unlink ("conftestmmap");
  exit (0);
}], ac_cv_func_mmap_fixed_mapped=yes, ac_cv_func_mmap_fixed_mapped=no,
ac_cv_func_mmap_fixed_mapped=no)])
if test $ac_cv_func_mmap_fixed_mapped = yes; then
  AC_DEFINE(HAVE_MMAP, 1,
            [Define if you have a working `mmap' system call.])
fi
])# AC_FUNC_MMAP


# AC_FUNC_MEMCMP
# --------------
AC_DEFUN(AC_FUNC_MEMCMP,
[AC_CACHE_CHECK(for 8-bit clean memcmp, ac_cv_func_memcmp_clean,
[AC_TRY_RUN(
[int
main()
{
  char c0 = 0x40, c1 = 0x80, c2 = 0x81;
  exit (memcmp(&c0, &c2, 1) < 0
        && memcmp(&c1, &c2, 1) < 0 ? 0 : 1);
}], ac_cv_func_memcmp_clean=yes, ac_cv_func_memcmp_clean=no,
ac_cv_func_memcmp_clean=no)])
test $ac_cv_func_memcmp_clean = no && LIBOBJS="$LIBOBJS memcmp.${ac_objext}"
AC_SUBST(LIBOBJS)dnl
])# AC_FUNC_MEMCMP


# AC_FUNC_SELECT_ARGTYPES
# -----------------------
AC_DEFUN(AC_FUNC_SELECT_ARGTYPES,
[AC_MSG_CHECKING([types of arguments for select()])
 AC_CACHE_VAL(ac_cv_func_select_arg234,dnl
 [AC_CACHE_VAL(ac_cv_func_select_arg1,dnl
  [AC_CACHE_VAL(ac_cv_func_select_arg5,dnl
   [for ac_cv_func_select_arg234 in 'fd_set *' 'int *' 'void *'; do
     for ac_cv_func_select_arg1 in 'int' 'size_t' 'unsigned long' 'unsigned'; do
      for ac_cv_func_select_arg5 in 'struct timeval *' 'const struct timeval *'; do
       AC_TRY_COMPILE(
[#if HAVE_SYS_TYPES_H
# include <sys/types.h>
#endif
#if HAVE_SYS_TIME_H
# include <sys/time.h>
#endif
#if HAVE_SYS_SELECT_H
# include <sys/select.h>
#endif
#if HAVE_SYS_SOCKET_H
# include <sys/socket.h>
#endif
extern select ($ac_cv_func_select_arg1,$ac_cv_func_select_arg234,$ac_cv_func_select_arg234,$ac_cv_func_select_arg234,$ac_cv_func_select_arg5);],,dnl
        [ac_not_found=no ; break 3],ac_not_found=yes)
      done
     done
    done
   ])dnl AC_CACHE_VAL
  ])dnl AC_CACHE_VAL
 ])dnl AC_CACHE_VAL
 if test "$ac_not_found" = yes; then
  ac_cv_func_select_arg1=int
  ac_cv_func_select_arg234='int *'
  ac_cv_func_select_arg5='struct timeval *'
 fi
 AC_MSG_RESULT([$ac_cv_func_select_arg1,$ac_cv_func_select_arg234,$ac_cv_func_select_arg5])
 AC_DEFINE_UNQUOTED(SELECT_TYPE_ARG1, $ac_cv_func_select_arg1,
                    [Define to the type of arg 1 for `select'.])
 AC_DEFINE_UNQUOTED(SELECT_TYPE_ARG234, ($ac_cv_func_select_arg234),
                    [Define to the type of args 2, 3 and 4 for `select'.])
 AC_DEFINE_UNQUOTED(SELECT_TYPE_ARG5, ($ac_cv_func_select_arg5),
                    [Define to the type of arg 5 for `select'.])
])# AC_FUNC_SELECT_ARGTYPES


# AC_FUNC_SETPGRP
# ---------------
AC_DEFUN(AC_FUNC_SETPGRP,
[AC_CACHE_CHECK(whether setpgrp takes no argument, ac_cv_func_setpgrp_void,
AC_TRY_RUN(
[#if HAVE_UNISTD_H
# include <unistd.h>
#endif

/* If this system has a BSD-style setpgrp, which takes arguments, exit
   successfully.  */

int
main ()
{
  if (setpgrp (1,1) == -1)
    exit (0);
  else
    exit (1);
}], ac_cv_func_setpgrp_void=no, ac_cv_func_setpgrp_void=yes,
   AC_MSG_ERROR(cannot check setpgrp if cross compiling))
)
if test $ac_cv_func_setpgrp_void = yes; then
  AC_DEFINE(SETPGRP_VOID, 1,
            [Define if the `setpgrp' function takes no argument.])
fi
])# AC_FUNC_SETPGRP


# AC_FUNC_STRFTIME
# ----------------
AC_DEFUN(AC_FUNC_STRFTIME,
[AC_CHECK_FUNC(strftime,
               [AC_DEFINE(HAVE_STRFTIME, 1,
                          [Define if you have the `strftime' function.])],
[# strftime is in -lintl on SCO UNIX.
AC_CHECK_LIB(intl, strftime,
[AC_DEFINE(HAVE_STRFTIME, 1,
           [Define if you have the `strftime' function.])
LIBS="-lintl $LIBS"])])dnl
])# AC_FUNC_STRFTIME


# AC_FUNC_VFORK
# -------------
AC_DEFUN(AC_FUNC_VFORK,
[AC_REQUIRE([AC_TYPE_PID_T])dnl
AC_CHECK_HEADER(vfork.h,
                AC_DEFINE(HAVE_VFORK_H, 1,
                          [Define if you have <vfork.h>.]))
AC_CACHE_CHECK(for working vfork, ac_cv_func_vfork_works,
[AC_TRY_RUN([/* Thanks to Paul Eggert for this test.  */
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#if HAVE_UNISTD_H
# include <unistd.h>
#endif
#if HAVE_VFORK_H
# include <vfork.h>
#endif
/* On some sparc systems, changes by the child to local and incoming
   argument registers are propagated back to the parent.  The compiler
   is told about this with #include <vfork.h>, but some compilers
   (e.g. gcc -O) don't grok <vfork.h>.  Test for this by using a
   static variable whose address is put into a register that is
   clobbered by the vfork.  */
static
#ifdef __cplusplus
sparc_address_test (int arg)
# else
sparc_address_test (arg) int arg;
#endif
{
  static pid_t child;
  if (!child) {
    child = vfork ();
    if (child < 0) {
      perror ("vfork");
      _exit(2);
    }
    if (!child) {
      arg = getpid();
      write(-1, "", 0);
      _exit (arg);
    }
  }
}

int
main ()
{
  pid_t parent = getpid ();
  pid_t child;

  sparc_address_test ();

  child = vfork ();

  if (child == 0) {
    /* Here is another test for sparc vfork register problems.  This
       test uses lots of local variables, at least as many local
       variables as main has allocated so far including compiler
       temporaries.  4 locals are enough for gcc 1.40.3 on a Solaris
       4.1.3 sparc, but we use 8 to be safe.  A buggy compiler should
       reuse the register of parent for one of the local variables,
       since it will think that parent can't possibly be used any more
       in this routine.  Assigning to the local variable will thus
       munge parent in the parent process.  */
    pid_t
      p = getpid(), p1 = getpid(), p2 = getpid(), p3 = getpid(),
      p4 = getpid(), p5 = getpid(), p6 = getpid(), p7 = getpid();
    /* Convince the compiler that p..p7 are live; otherwise, it might
       use the same hardware register for all 8 local variables.  */
    if (p != p1 || p != p2 || p != p3 || p != p4
	|| p != p5 || p != p6 || p != p7)
      _exit(1);

    /* On some systems (e.g. IRIX 3.3), vfork doesn't separate parent
       from child file descriptors.  If the child closes a descriptor
       before it execs or exits, this munges the parent's descriptor
       as well.  Test for this by closing stdout in the child.  */
    _exit(close(fileno(stdout)) != 0);
  } else {
    int status;
    struct stat st;

    while (wait(&status) != child)
      ;
    exit(
	 /* Was there some problem with vforking?  */
	 child < 0

	 /* Did the child fail?  (This shouldn't happen.)  */
	 || status

	 /* Did the vfork/compiler bug occur?  */
	 || parent != getpid()

	 /* Did the file descriptor bug occur?  */
	 || fstat(fileno(stdout), &st) != 0
	 );
  }
}],
ac_cv_func_vfork_works=yes, ac_cv_func_vfork_works=no, AC_CHECK_FUNC(vfork)
ac_cv_func_vfork_works=$ac_cv_func_vfork)])
if test "x$ac_cv_func_vfork_works" = xno; then
  AC_DEFINE(vfork, fork, [Define as `fork' if `vfork' does not work.])
fi
])# AC_FUNC_VFORK


# AC_FUNC_VPRINTF
# ---------------
# Why the heck is that _doprnt does not define HAVE__DOPRNT???
# That the logical name!  In addition, why doesn't it use
# AC_CHECK_FUNCS(vprintf)?  Because old Autoconf uses sh for loops.
# FIXME: To be changed in Autoconf 3?
AC_DEFUN(AC_FUNC_VPRINTF,
[AC_CHECK_FUNC(vprintf,
               AC_DEFINE(HAVE_VPRINTF, 1,
               [Define if you have the `vprintf' function.]))
if test "$ac_cv_func_vprintf" != yes; then
AC_CHECK_FUNC(_doprnt,
              AC_DEFINE(HAVE_DOPRNT, 1,
                        [Define if you don't have `vprintf' but do have
                         `_doprnt.']))
fi
])


# AC_FUNC_WAIT3
# -------------
AC_DEFUN(AC_FUNC_WAIT3,
[AC_CACHE_CHECK(for wait3 that fills in rusage, ac_cv_func_wait3_rusage,
[AC_TRY_RUN(
[#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <stdio.h>
/* HP-UX has wait3 but does not fill in rusage at all.  */
int
main ()
{
  struct rusage r;
  int i;
  /* Use a field that we can force nonzero --
     voluntary context switches.
     For systems like NeXT and OSF/1 that don't set it,
     also use the system CPU time.  And page faults (I/O) for Linux.  */
  r.ru_nvcsw = 0;
  r.ru_stime.tv_sec = 0;
  r.ru_stime.tv_usec = 0;
  r.ru_majflt = r.ru_minflt = 0;
  switch (fork ())
    {
    case 0: /* Child.  */
      sleep(1); /* Give up the CPU.  */
      _exit(0);
    case -1: /* What can we do?  */
      _exit(0);
    default: /* Parent.  */
      wait3(&i, 0, &r);
      /* Avoid "text file busy" from rm on fast HP-UX machines.  */
      sleep(2);
      exit (r.ru_nvcsw == 0 && r.ru_majflt == 0 && r.ru_minflt == 0
	    && r.ru_stime.tv_sec == 0 && r.ru_stime.tv_usec == 0);
    }
}], ac_cv_func_wait3_rusage=yes, ac_cv_func_wait3_rusage=no,
ac_cv_func_wait3_rusage=no)])
if test $ac_cv_func_wait3_rusage = yes; then
  AC_DEFINE(HAVE_WAIT3, 1,
            [Define if you have the `wait3' system call.])
fi
])# AC_FUNC_WAIT3


# AC_FUNC_UTIME_NULL
# ------------------
AC_DEFUN(AC_FUNC_UTIME_NULL,
[AC_CACHE_CHECK(whether utime accepts a null argument, ac_cv_func_utime_null,
[rm -f conftestdata; >conftestdata
# Sequent interprets utime(file, 0) to mean use start of epoch.  Wrong.
AC_TRY_RUN(
[#include <sys/types.h>
#include <sys/stat.h>
int
main()
{
  struct stat s, t;
  exit (!(stat ("conftestdata", &s) == 0
          && utime ("conftestdata", (long *)0) == 0
          && stat ("conftestdata", &t) == 0
          && t.st_mtime >= s.st_mtime
          && t.st_mtime - s.st_mtime < 120));
}], ac_cv_func_utime_null=yes, ac_cv_func_utime_null=no,
  ac_cv_func_utime_null=no)
rm -f core core.* *.core])
if test $ac_cv_func_utime_null = yes; then
  AC_DEFINE(HAVE_UTIME_NULL, 1,
            [Define if `utime(file, NULL)' sets file's timestamp to the
             present.])
fi
])# AC_FUNC_UTIME_NULL


# AC_FUNC_STRCOLL
# ---------------
AC_DEFUN(AC_FUNC_STRCOLL,
[AC_CACHE_CHECK(for working strcoll, ac_cv_func_strcoll_works,
[AC_TRY_RUN([#include <string.h>
int
main ()
{
  exit (strcoll ("abc", "def") >= 0 ||
	strcoll ("ABC", "DEF") >= 0 ||
	strcoll ("123", "456") >= 0);
}], ac_cv_func_strcoll_works=yes, ac_cv_func_strcoll_works=no,
ac_cv_func_strcoll_works=no)])
if test $ac_cv_func_strcoll_works = yes; then
  AC_DEFINE(HAVE_STRCOLL, 1,
            [Define if you have the `strcoll' function and it is properly
             defined.])
fi
])# AC_FUNC_STRCOLL


# AC_FUNC_SETVBUF_REVERSED
# ------------------------
AC_DEFUN(AC_FUNC_SETVBUF_REVERSED,
[AC_CACHE_CHECK(whether setvbuf arguments are reversed,
  ac_cv_func_setvbuf_reversed,
[AC_TRY_RUN([#include <stdio.h>
/* If setvbuf has the reversed format, exit 0. */
int
main ()
{
  /* This call has the arguments reversed.
     A reversed system may check and see that the address of main
     is not _IOLBF, _IONBF, or _IOFBF, and return nonzero.  */
  if (setvbuf(stdout, _IOLBF, (char *) main, BUFSIZ) != 0)
    exit(1);
  putc('\r', stdout);
  exit(0);			/* Non-reversed systems segv here.  */
}], ac_cv_func_setvbuf_reversed=yes, ac_cv_func_setvbuf_reversed=no)
rm -f core core.* *.core])
if test $ac_cv_func_setvbuf_reversed = yes; then
  AC_DEFINE(SETVBUF_REVERSED, 1,
            [Define if the `setvbuf' function takes the buffering type as
             its second argument and the buffer pointer as the third, as on
             System V before release 3.])
fi
])# AC_FUNC_SETVBUF_REVERSED





## ------------------------------ ##
## Checks for structure members.  ##
## ------------------------------ ##


# AC_STRUCT_TM
# ------------
# FIXME: This macro is badly named, it should be AC_CHECK_TYPE_STRUCT_TM.
# Or something else, but what? AC_CHECK_TYPE_STRUCT_TM_IN_SYS_TIME?
AC_DEFUN(AC_STRUCT_TM,
[AC_CACHE_CHECK([whether struct tm is in sys/time.h or time.h],
  ac_cv_struct_tm,
[AC_TRY_COMPILE([#include <sys/types.h>
#include <time.h>
],
[struct tm *tp; tp->tm_sec;],
  ac_cv_struct_tm=time.h, ac_cv_struct_tm=sys/time.h)])
if test $ac_cv_struct_tm = sys/time.h; then
  AC_DEFINE(TM_IN_SYS_TIME, 1,
            [Define if your <sys/time.h> declares `struct tm'.])
fi
])# AC_STRUCT_TM


# AC_STRUCT_TIMEZONE
# ------------------
# Figure out how to get the current timezone.  If `struct tm' has a
# `tm_zone' member, define `HAVE_TM_ZONE'.  Otherwise, if the
# external array `tzname' is found, define `HAVE_TZNAME'.
AC_DEFUN(AC_STRUCT_TIMEZONE,
[AC_REQUIRE([AC_STRUCT_TM])dnl
AC_CHECK_MEMBERS((struct tm.tm_zone),,,[#include <sys/types.h>
#include <$ac_cv_struct_tm>
])
if test "$ac_cv_member_struct_tm_tm_zone" = yes; then
  AC_DEFINE(HAVE_TM_ZONE, 1,
            [Define if your `struct tm' has `tm_zone'. Deprecated, use
             `HAVE_STRUCT_TM_TM_ZONE' instead.])
else
  AC_CACHE_CHECK(for tzname, ac_cv_var_tzname,
[AC_TRY_LINK(
[#include <time.h>
#ifndef tzname /* For SGI.  */
extern char *tzname[]; /* RS6000 and others reject char **tzname.  */
#endif
],
[atoi(*tzname);], ac_cv_var_tzname=yes, ac_cv_var_tzname=no)])
  if test $ac_cv_var_tzname = yes; then
    AC_DEFINE(HAVE_TZNAME, 1,
              [Define if you don't have `tm_zone' but do have the external
               array `tzname'.])
  fi
fi
])# AC_STRUCT_TIMEZONE



# FIXME: The following three macros should no longer be supported in the
# future.  They made sense when there was no means to directly check for
# members of aggregates.


# AC_STRUCT_ST_BLKSIZE
# --------------------
AC_DEFUN(AC_STRUCT_ST_BLKSIZE,
[AC_OBSOLETE([$0], [; replace it with
  AC_CHECK_MEMBERS((struct stat.st_blksize))
Please note that it will define `HAVE_STRUCT_STAT_ST_BLKSIZE',
and not `HAVE_ST_BLKSIZE'.])dnl
AC_CHECK_MEMBERS((struct stat.st_blksize),
                  [AC_DEFINE(HAVE_ST_BLKSIZE, 1,
                             [Define if your `struct stat' has
                              `st_blksize'.  Deprecated, use
                              `HAVE_STRUCT_STAT_ST_BLKSIZE' instead.])],,
                  [#include <sys/types.h>
#include <sys/stat.h>
])dnl
])# AC_STRUCT_ST_BLKSIZE


# AC_STRUCT_ST_BLOCKS
# -------------------
# If `struct stat' contains an `st_blocks' member, define
# HAVE_STRUCT_STAT_ST_BLOCKS.  Otherwise, add `fileblocks.o' to the
# output variable LIBOBJS.  We still define HAVE_ST_BLOCKS for backward
# compatibility.  In the future, we will activate specializations for
# this macro, so don't obsolete it right now.
#
# AC_OBSOLETE([$0], [; replace it with
#   AC_CHECK_MEMBERS((struct stat.st_blocks),
#                     LIBOBJS="$LIBOBJS fileblocks.${ac_objext}")
# Please note that it will define `HAVE_STRUCT_STAT_ST_BLOCKS',
# and not `HAVE_ST_BLOCKS'.])dnl
#
AC_DEFUN(AC_STRUCT_ST_BLOCKS,
[AC_CHECK_MEMBERS((struct stat.st_blocks),
                  [AC_DEFINE(HAVE_ST_BLOCKS, 1,
                             [Define if your `struct stat' has
                              `st_blocks'.  Deprecated, use
                              `HAVE_STRUCT_STAT_ST_BLOCKS' instead.])],
                  [LIBOBJS="$LIBOBJS fileblocks.${ac_objext}"
AC_SUBST(LIBOBJS)],
                  [#include <sys/types.h>
#include <sys/stat.h>
])dnl
])# AC_STRUCT_ST_BLOCKS


# AC_STRUCT_ST_RDEV
# -----------------
AC_DEFUN(AC_STRUCT_ST_RDEV,
[AC_OBSOLETE([$0], [; replace it with
  AC_CHECK_MEMBERS((struct stat.st_rdev))
Please note that it will define `HAVE_STRUCT_STAT_ST_RDEV',
and not `HAVE_ST_RDEV'.])dnl
AC_CHECK_MEMBERS((struct stat.st_rdev),
                  [AC_DEFINE(HAVE_ST_RDEV, 1,
                             [Define if your `struct stat' has `st_rdev'.
                              Deprecated, use
                              `HAVE_STRUCT_STAT_ST_RDEV' instead.])],,
                  [#include <sys/types.h>
#include <sys/stat.h>
])dnl
])# AC_STRUCT_ST_RDEV






## --------------------------------------- ##
## Checks for C compiler characteristics.  ##
## --------------------------------------- ##


AC_DEFUN(AC_C_CROSS,
[AC_OBSOLETE([$0], [; it has been merged into AC_PROG_CC])])


# AC_C_CHAR_UNSIGNED
# ------------------
AC_DEFUN(AC_C_CHAR_UNSIGNED,
[AC_CACHE_CHECK(whether char is unsigned, ac_cv_c_char_unsigned,
[if test "$GCC" = yes; then
  # GCC predefines this symbol on systems where it applies.
AC_EGREP_CPP(yes,
[#ifdef __CHAR_UNSIGNED__
  yes
#endif
], ac_cv_c_char_unsigned=yes, ac_cv_c_char_unsigned=no)
else
AC_TRY_RUN(
[/* volatile prevents gcc2 from optimizing the test away on sparcs.  */
#if !defined(__STDC__) || __STDC__ != 1
# define volatile
#endif
int
main()
{
  volatile char c = 255;
  exit(c < 0);
}], ac_cv_c_char_unsigned=yes, ac_cv_c_char_unsigned=no)
fi])
if test $ac_cv_c_char_unsigned = yes && test "$GCC" != yes; then
  AC_DEFINE(__CHAR_UNSIGNED__)
fi
])# AC_C_CHAR_UNSIGNED


# AC_C_LONG_DOUBLE
# ----------------
AC_DEFUN(AC_C_LONG_DOUBLE,
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
  exit(sizeof(long double) < sizeof(double));
}],
ac_cv_c_long_double=yes, ac_cv_c_long_double=no)
fi])
if test $ac_cv_c_long_double = yes; then
  AC_DEFINE(HAVE_LONG_DOUBLE, 1,
            [Define if the `long double' type works.])
fi
])# AC_C_LONG_DOUBLE


AC_DEFUNCT(AC_INT_16_BITS, [; instead use AC_CHECK_SIZEOF(int)])
AC_DEFUNCT(AC_LONG_64_BITS, [; instead use AC_CHECK_SIZEOF(long)])


# AC_C_BIGENDIAN
# --------------
AC_DEFUN(AC_C_BIGENDIAN,
[AC_CACHE_CHECK(whether byte ordering is bigendian, ac_cv_c_bigendian,
[ac_cv_c_bigendian=unknown
# See if sys/param.h defines the BYTE_ORDER macro.
AC_TRY_COMPILE([#include <sys/types.h>
#include <sys/param.h>
],
[#if !BYTE_ORDER || !BIG_ENDIAN || !LITTLE_ENDIAN
 bogus endian macros
#endif
],
[# It does; now see whether it defined to BIG_ENDIAN or not.
AC_TRY_COMPILE([#include <sys/types.h>
#include <sys/param.h>
], [#if BYTE_ORDER != BIG_ENDIAN
 not big endian
#endif
], ac_cv_c_bigendian=yes, ac_cv_c_bigendian=no)])
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
AC_DEFUN(AC_C_INLINE,
[AC_REQUIRE([AC_PROG_CC_STDC])dnl
AC_CACHE_CHECK([for inline], ac_cv_c_inline,
[ac_cv_c_inline=no
for ac_kw in inline __inline__ __inline; do
  AC_TRY_COMPILE(,
[#ifndef __cplusplus
  } $ac_kw int foo() {
#endif
],
[ac_cv_c_inline=$ac_kw; break])
done
])
case "$ac_cv_c_inline" in
  inline | yes) ;;
  no) AC_DEFINE(inline,,
                [Define as `__inline' if that's what the C compiler calls it,
                 or to nothing if it is not supported.]) ;;
  *)  AC_DEFINE_UNQUOTED(inline, $ac_cv_c_inline) ;;
esac
])# AC_C_INLINE


# AC_C_CONST
# ----------
AC_DEFUN(AC_C_CONST,
[AC_REQUIRE([AC_PROG_CC_STDC])dnl
AC_CACHE_CHECK([for an ANSI C-conforming const], ac_cv_c_const,
[AC_TRY_COMPILE(,
[/* FIXME: Include the comments suggested by Paul. */
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
],
                ac_cv_c_const=yes, ac_cv_c_const=no)])
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
AC_DEFUN(AC_C_VOLATILE,
[AC_REQUIRE([AC_PROG_CC_STDC])dnl
AC_CACHE_CHECK([for working volatile], ac_cv_c_volatile,
[AC_TRY_COMPILE(,[
volatile int x;
int * volatile y;],
ac_cv_c_volatile=yes, ac_cv_c_volatile=no)])
if test $ac_cv_c_volatile = no; then
  AC_DEFINE(volatile,,
            [Define to empty if the keyword `volatile' does not work.
             Warning: valid code using `volatile' can become incorrect
             without.  Disable with care.])
fi
])


# AC_C_STRINGIZE
# --------------
# Checks if `#' can be used to glue strings together at the CPP level.
# Defines HAVE_STRINGIZE if positive.
AC_DEFUN(AC_C_STRINGIZE,
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
AC_DEFUN(AC_C_PROTOTYPES,
[AC_REQUIRE([AC_PROG_CC_STDC])dnl
AC_REQUIRE([AC_PROG_CPP])dnl
AC_MSG_CHECKING([for function prototypes])
if test "$ac_cv_prog_cc_stdc" != no; then
  AC_MSG_RESULT(yes)
  AC_DEFINE(PROTOTYPES, 1,
            [Define if the compiler supports function prototypes.])
else
  AC_MSG_RESULT(no)
fi
])# AC_C_PROTOTYPES




## ----------------------------------------- ##
## Checks for F77 compiler characteristics.  ##
## ----------------------------------------- ##


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
AC_DEFUN(AC_F77_LIBRARY_LDFLAGS,
[AC_CACHE_CHECK([for Fortran 77 libraries],
                 ac_cv_flibs,
[
  AC_REQUIRE([AC_PROG_F77])dnl
  AC_REQUIRE([AC_CYGWIN])dnl

  AC_LANG_SAVE
  AC_LANG_FORTRAN77

# This is the simplest of all Fortran 77 programs.
  cat >conftest.$ac_ext <<EOF
    end
EOF

  # Save the "compiler output file descriptor" to FD 8.
  exec 8>&AC_FD_CC

  # Temporarily redirect compiler output to stdout, since this is what
  # we want to capture in AC_LINK_OUTPUT.
  exec AC_FD_CC>&1

  # Compile and link our simple test program by passing the "-v" flag
  # to the Fortran 77 compiler in order to get "verbose" output that
  # we can then parse for the Fortran 77 linker flags.  I don't know
  # what to do if your compiler doesn't have -v.
  ac_save_FFLAGS="$FFLAGS"
  FFLAGS="$FFLAGS -v"
  ac_link_output=`eval $ac_link 2>&1 | grep -v 'Driving:'`
  FFLAGS="$ac_save_FFLAGS"

  # Restore the "compiler output file descriptor".
  exec AC_FD_CC>&8

  rm -f conftest.*

  AC_LANG_RESTORE

  # This will ultimately be our output variable.
  FLIBS=

  # If we are using xlf then replace all the commas with spaces.
  if test `echo $ac_link_output | grep xlfentry >/dev/null 2>&1`; then
      ac_link_output=`echo $ac_link_output | sed 's/,/ /g'`
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
    ac_previous_arg="$ac_save_arg"
    test -n "`echo $ac_arg | sed -n -e '/^-/!p'`" && ac_previous_arg=
    case "$ac_previous_arg" in
      '')
        case "$ac_arg" in
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
            ac_arg="$temp_arg"
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
    test -n "$ac_arg" && FLIBS="$FLIBS $ac_arg"
  done

  # Assumption: We only see "LD_RUN_PATH" on Solaris systems.  If this
  # is seen, then we insist that the "run path" must be an absolute
  # path (i.e. it must begin with a "/").
  ac_ld_run_path=`echo $ac_link_output |
                  sed -n -e 's%^.*LD_RUN_PATH *= *\(/[[^ ]]*\).*$%\1%p'`
  test -n "$ac_ld_run_path" && FLIBS="$ac_ld_run_path $FLIBS"

  ac_cv_flibs="$FLIBS"
])
AC_SUBST(FLIBS)
])


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
#
AC_DEFUN(AC_F77_NAME_MANGLING,
[
  AC_CACHE_CHECK([for Fortran 77 name-mangling scheme],
                 ac_cv_f77_mangling,
  [
    AC_REQUIRE([AC_PROG_CC])dnl
    AC_REQUIRE([AC_PROG_F77])dnl

    AC_LANG_SAVE
    AC_LANG_FORTRAN77

cat >conftest.$ac_ext <<EOF
      subroutine foobar()
      return
      end
      subroutine foo_bar()
      return
      end
EOF

    if AC_TRY_EVAL(ac_compile); then

      mv conftest.${ac_objext} cf77_test.${ac_objext}

      AC_LANG_SAVE
      AC_LANG_C

      ac_save_LIBS="$LIBS"
      LIBS="cf77_test.${ac_objext} $LIBS"

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

      if test x"$f77_case" = x || test x"$f77_underscore" = x; then
        ac_cv_f77_mangling="unknown"
      else
        ac_cv_f77_mangling="$f77_case case, $f77_underscore underscores"
      fi

      LIBS="$ac_save_LIBS"
      AC_LANG_RESTORE

      rm -f conftest*
      rm -f cf77_test*

    else
      echo "configure: failed program was:" >&AC_FD_CC
      cat conftest.$ac_ext >&AC_FD_CC
    fi
dnl Matthew: We need to pop the language stack twice.
dnl Akim: FIXME: Why?  You've done it above, AFAICT.
AC_LANG_RESTORE()dnl
AC_LANG_RESTORE()dnl
])])


# AC_F77_WRAPPERS
# ---------------
# Defines C macros F77_FUNC(name,NAME) and F77_FUNC_(name,NAME) to
# properly mangle the names of C identifiers, and C identifiers with
# underscores, respectively, so that they match the name mangling
# scheme used by the Fortran 77 compiler.
AC_DEFUN(AC_F77_WRAPPERS,
[
  AC_CACHE_CHECK([if we can define Fortran 77 name-mangling macros],
                 ac_cv_f77_wrappers,
  [
dnl Be optimistic at first.
    ac_cv_f77_wrappers="yes"

    AC_REQUIRE([AC_F77_NAME_MANGLING])dnl
    case "$f77_case" in
        lower)
            case "$f77_underscore" in
                no)
                    AC_DEFINE([F77_FUNC(name,NAME)],  [name])
                    AC_DEFINE([F77_FUNC_(name,NAME)], [name])
                    ;;
                single)
                    AC_DEFINE([F77_FUNC(name,NAME)],  [name ## _])
                    AC_DEFINE([F77_FUNC_(name,NAME)], [name ## _])
                    ;;
                double)
                    AC_DEFINE([F77_FUNC(name,NAME)],  [name ## _])
                    AC_DEFINE([F77_FUNC_(name,NAME)], [name ## __])
                    ;;
                *)
                    AC_MSG_WARN(unknown Fortran 77 name-mangling scheme)
                    ;;
            esac
            ;;
        upper)
            case "$f77_underscore" in
                no)
                    AC_DEFINE([F77_FUNC(name,NAME)],  [NAME])
                    AC_DEFINE([F77_FUNC_(name,NAME)], [NAME])
                    ;;
                single)
                    AC_DEFINE([F77_FUNC(name,NAME)],  [NAME ## _])
                    AC_DEFINE([F77_FUNC_(name,NAME)], [NAME ## _])
                    ;;
                double)
                    AC_DEFINE([F77_FUNC(name,NAME)],  [NAME ## _])
                    AC_DEFINE([F77_FUNC_(name,NAME)], [NAME ## __])
                    ;;
                *)
                    AC_MSG_WARN(unknown Fortran 77 name-mangling scheme)
                    ;;
            esac
            ;;
        *)
            AC_MSG_WARN(unknown Fortran 77 name-mangling scheme)
            ;;
    esac
])])



## -------------------------------------- ##
## Checks for operating system services.  ##
## -------------------------------------- ##


# AC_SYS_INTERPRETER
# ------------------
AC_DEFUN(AC_SYS_INTERPRETER,
[AC_CACHE_CHECK(whether @%:@! works in shell scripts, ac_cv_sys_interpreter,
[echo '#! /bin/cat
exit 69
' >conftest
chmod u+x conftest
(SHELL=/bin/sh; export SHELL; ./conftest >/dev/null)
if test $? -ne 69; then
   ac_cv_sys_interpreter=yes
else
   ac_cv_sys_interpreter=no
fi
rm -f conftest])
interpval="$ac_cv_sys_interpreter"
])

AC_DEFUNCT(AC_HAVE_POUNDBANG, [;use AC_SYS_INTERPRETER, taking no arguments])
AC_DEFUNCT(AC_ARG_ARRAY, [; don't do unportable things with arguments])


# AC_SYS_LONG_FILE_NAMES
# ----------------------
AC_DEFUN(AC_SYS_LONG_FILE_NAMES,
[AC_CACHE_CHECK(for long file names, ac_cv_sys_long_file_names,
[ac_cv_sys_long_file_names=yes
# Test for long file names in all the places we know might matter:
#      .		the current directory, where building will happen
#      $prefix/lib	where we will be installing things
#      $exec_prefix/lib	likewise
# eval it to expand exec_prefix.
#      $TMPDIR		if set, where it might want to write temporary files
# if $TMPDIR is not set:
#      /tmp		where it might want to write temporary files
#      /var/tmp		likewise
#      /usr/tmp		likewise
if test -n "$TMPDIR" && test -d "$TMPDIR" && test -w "$TMPDIR"; then
  ac_tmpdirs="$TMPDIR"
else
  ac_tmpdirs='/tmp /var/tmp /usr/tmp'
fi
for ac_dir in  . $ac_tmpdirs `eval echo $prefix/lib $exec_prefix/lib` ; do
  test -d $ac_dir || continue
  test -w $ac_dir || continue # It is less confusing to not echo anything here.
  (echo 1 >$ac_dir/conftest9012345) 2>/dev/null
  (echo 2 >$ac_dir/conftest9012346) 2>/dev/null
  ac_val=`cat $ac_dir/conftest9012345 2>/dev/null`
  if test ! -f $ac_dir/conftest9012345 || test "$ac_val" != 1; then
    ac_cv_sys_long_file_names=no
    rm -f $ac_dir/conftest9012345 $ac_dir/conftest9012346 2>/dev/null
    break
  fi
  rm -f $ac_dir/conftest9012345 $ac_dir/conftest9012346 2>/dev/null
done])
if test $ac_cv_sys_long_file_names = yes; then
  AC_DEFINE(HAVE_LONG_FILE_NAMES, 1,
            [Define if you support file names longer than 14 characters.])
fi
])


# AC_SYS_RESTARTABLE_SYSCALLS
# ---------------------------
# If the system automatically restarts a system call that is
# interrupted by a signal, define `HAVE_RESTARTABLE_SYSCALLS'.
AC_DEFUN(AC_SYS_RESTARTABLE_SYSCALLS,
[AC_REQUIRE([AC_HEADER_SYS_WAIT])dnl
AC_CHECK_HEADERS(unistd.h)
AC_CACHE_CHECK(for restartable system calls, ac_cv_sys_restartable_syscalls,
[AC_TRY_RUN(
[/* Exit 0 (true) if wait returns something other than -1,
   i.e. the pid of the child, which means that wait was restarted
   after getting the signal.  */

#include <sys/types.h>
#include <signal.h>
#if HAVE_UNISTD_H
# include <unistd.h>
#endif
#if HAVE_SYS_WAIT_H
# include <sys/wait.h>
#endif

/* Some platforms explicitly require an extern "C" signal handler
   when using C++. */
#ifdef __cplusplus
extern "C" void ucatch (int dummy) { }
#else
void ucatch (dummy) int dummy; { }
#endif

int
main ()
{
  int i = fork (), status;

  if (i == 0)
    {
      sleep (3);
      kill (getppid (), SIGINT);
      sleep (3);
      exit (0);
    }

  signal (SIGINT, ucatch);

  status = wait (&i);
  if (status == -1)
    wait (&i);

  exit (status == -1);
}], ac_cv_sys_restartable_syscalls=yes, ac_cv_sys_restartable_syscalls=no)])
if test $ac_cv_sys_restartable_syscalls = yes; then
  AC_DEFINE(HAVE_RESTARTABLE_SYSCALLS, 1,
            [Define if system calls automatically restart after interruption
             by a signal.])
fi
])# AC_SYS_RESTARTABLE_SYSCALLS




## --------------------- ##
## Checks for X window.  ##
## --------------------- ##


# AC_PATH_X
# ---------
# If we find X, set shell vars x_includes and x_libraries to the
# paths, otherwise set no_x=yes.
# Uses ac_ vars as temps to allow command line to override cache and checks.
# --without-x overrides everything else, but does not touch the cache.
AC_DEFUN(AC_PATH_X,
[AC_REQUIRE_CPP()dnl Set CPP; we run _AC_PATH_X_DIRECT conditionally.
AC_MSG_CHECKING(for X)

dnl Document the X abnormal options inherited from history.
AC_EXPAND_ONCE([AC_DIVERT_PUSH(AC_DIVERSION_HELP_BEGIN)dnl

X features:
  --x-includes=DIR    X include files are in DIR
  --x-libraries=DIR   X library files are in DIR
AC_DIVERT_POP()])dnl

AC_ARG_WITH(x, [  --with-x                use the X Window System])
# $have_x is `yes', `no', `disabled', or empty when we do not yet know.
if test "x$with_x" = xno; then
  # The user explicitly disabled X.
  have_x=disabled
else
  if test "x$x_includes" != xNONE && test "x$x_libraries" != xNONE; then
    # Both variables are already set.
    have_x=yes
  else
AC_CACHE_VAL(ac_cv_have_x,
[# One or both of the vars are not set, and there is no cached value.
ac_x_includes=NO ac_x_libraries=NO
_AC_PATH_X_XMKMF
_AC_PATH_X_DIRECT
if test "$ac_x_includes" = NO || test "$ac_x_libraries" = NO; then
  # Didn't find X anywhere.  Cache the known absence of X.
  ac_cv_have_x="have_x=no"
else
  # Record where we found X for the cache.
  ac_cv_have_x="have_x=yes \
	        ac_x_includes=$ac_x_includes ac_x_libraries=$ac_x_libraries"
fi])dnl
  fi
  eval "$ac_cv_have_x"
fi # $with_x != no

if test "$have_x" != yes; then
  AC_MSG_RESULT($have_x)
  no_x=yes
else
  # If each of the values was on the command line, it overrides each guess.
  test "x$x_includes" = xNONE && x_includes=$ac_x_includes
  test "x$x_libraries" = xNONE && x_libraries=$ac_x_libraries
  # Update the cache value to reflect the command line values.
  ac_cv_have_x="have_x=yes \
		ac_x_includes=$x_includes ac_x_libraries=$x_libraries"
  AC_MSG_RESULT([libraries $x_libraries, headers $x_includes])
fi
])# AC_PATH_X


# _AC_PATH_X_XMKMF
# ---------------
# Internal subroutine of AC_PATH_X.
# Set ac_x_includes and/or ac_x_libraries.
AC_DEFUN(_AC_PATH_X_XMKMF,
[rm -fr conftestdir
if mkdir conftestdir; then
  cd conftestdir
  # Make sure to not put "make" in the Imakefile rules, since we grep it out.
  cat >Imakefile <<'EOF'
acfindx:
	@echo 'ac_im_incroot="${INCROOT}"; ac_im_usrlibdir="${USRLIBDIR}"; ac_im_libdir="${LIBDIR}"'
EOF
  if (xmkmf) >/dev/null 2>/dev/null && test -f Makefile; then
    # GNU make sometimes prints "make[1]: Entering...", which would confuse us.
    eval `${MAKE-make} acfindx 2>/dev/null | grep -v make`
    # Open Windows xmkmf reportedly sets LIBDIR instead of USRLIBDIR.
    for ac_extension in a so sl; do
      if test ! -f $ac_im_usrlibdir/libX11.$ac_extension &&
        test -f $ac_im_libdir/libX11.$ac_extension; then
        ac_im_usrlibdir=$ac_im_libdir; break
      fi
    done
    # Screen out bogus values from the imake configuration.  They are
    # bogus both because they are the default anyway, and because
    # using them would break gcc on systems where it needs fixed includes.
    case "$ac_im_incroot" in
	/usr/include) ;;
	*) test -f "$ac_im_incroot/X11/Xos.h" && ac_x_includes="$ac_im_incroot" ;;
    esac
    case "$ac_im_usrlibdir" in
	/usr/lib | /lib) ;;
	*) test -d "$ac_im_usrlibdir" && ac_x_libraries="$ac_im_usrlibdir" ;;
    esac
  fi
  cd ..
  rm -fr conftestdir
fi
])# _AC_PATH_X_XMKMF


# _AC_PATH_X_DIRECT
# ----------------
# Internal subroutine of AC_PATH_X.
# Set ac_x_includes and/or ac_x_libraries.
AC_DEFUN(_AC_PATH_X_DIRECT,
[if test "$ac_x_includes" = NO; then
  # Guess where to find include files, by looking for this one X11 .h file.
  test -z "$ac_x_direct_test_include" &&
    ac_x_direct_test_include=X11/Intrinsic.h

  # First, try using that file with no special directory specified.
AC_TRY_CPP([#include <$ac_x_direct_test_include>],
[# We can compile using X headers with no special include directory.
ac_x_includes=],
[# Look for the header file in a standard set of common directories.
# Check X11 before X11Rn because it is often a symlink to the current release.
  for ac_dir in               \
    /usr/X11/include          \
    /usr/X11R6/include        \
    /usr/X11R5/include        \
    /usr/X11R4/include        \
                              \
    /usr/include/X11          \
    /usr/include/X11R6        \
    /usr/include/X11R5        \
    /usr/include/X11R4        \
                              \
    /usr/local/X11/include    \
    /usr/local/X11R6/include  \
    /usr/local/X11R5/include  \
    /usr/local/X11R4/include  \
                              \
    /usr/local/include/X11    \
    /usr/local/include/X11R6  \
    /usr/local/include/X11R5  \
    /usr/local/include/X11R4  \
                              \
    /usr/X386/include         \
    /usr/x386/include         \
    /usr/XFree86/include/X11  \
                              \
    /usr/include              \
    /usr/local/include        \
    /usr/unsupported/include  \
    /usr/athena/include       \
    /usr/local/x11r5/include  \
    /usr/lpp/Xamples/include  \
                              \
    /usr/openwin/include      \
    /usr/openwin/share/include \
    ; \
  do
    if test -r "$ac_dir/$ac_x_direct_test_include"; then
      ac_x_includes=$ac_dir
      break
    fi
  done])
fi # $ac_x_includes = NO

if test "$ac_x_libraries" = NO; then
  # Check for the libraries.

  test -z "$ac_x_direct_test_library" && ac_x_direct_test_library=Xt
  test -z "$ac_x_direct_test_function" && ac_x_direct_test_function=XtMalloc

  # See if we find them without any special options.
  # Don't add to $LIBS permanently.
  ac_save_LIBS="$LIBS"
  LIBS="-l$ac_x_direct_test_library $LIBS"
AC_TRY_LINK(, [${ac_x_direct_test_function}()],
[LIBS="$ac_save_LIBS"
# We can link X programs with no special library path.
ac_x_libraries=],
[LIBS="$ac_save_LIBS"
# First see if replacing the include by lib works.
# Check X11 before X11Rn because it is often a symlink to the current release.
for ac_dir in `echo "$ac_x_includes" | sed s/include/lib/` \
    /usr/X11/lib          \
    /usr/X11R6/lib        \
    /usr/X11R5/lib        \
    /usr/X11R4/lib        \
                          \
    /usr/lib/X11          \
    /usr/lib/X11R6        \
    /usr/lib/X11R5        \
    /usr/lib/X11R4        \
                          \
    /usr/local/X11/lib    \
    /usr/local/X11R6/lib  \
    /usr/local/X11R5/lib  \
    /usr/local/X11R4/lib  \
                          \
    /usr/local/lib/X11    \
    /usr/local/lib/X11R6  \
    /usr/local/lib/X11R5  \
    /usr/local/lib/X11R4  \
                          \
    /usr/X386/lib         \
    /usr/x386/lib         \
    /usr/XFree86/lib/X11  \
                          \
    /usr/lib              \
    /usr/local/lib        \
    /usr/unsupported/lib  \
    /usr/athena/lib       \
    /usr/local/x11r5/lib  \
    /usr/lpp/Xamples/lib  \
    /lib/usr/lib/X11	  \
                          \
    /usr/openwin/lib      \
    /usr/openwin/share/lib \
    ; \
do
dnl Don't even attempt the hair of trying to link an X program!
  for ac_extension in a so sl; do
    if test -r $ac_dir/lib${ac_x_direct_test_library}.$ac_extension; then
      ac_x_libraries=$ac_dir
      break 2
    fi
  done
done])
fi # $ac_x_libraries = NO
])# _AC_PATH_X_DIRECT


# AC_PATH_XTRA
# ------------
# Find additional X libraries, magic flags, etc.
AC_DEFUN(AC_PATH_XTRA,
[AC_REQUIRE([AC_PATH_X])dnl
if test "$no_x" = yes; then
  # Not all programs may use this symbol, but it does not hurt to define it.
  AC_DEFINE(X_DISPLAY_MISSING, 1,
            [Define if the X Window System is missing or not being used.])
  X_CFLAGS= X_PRE_LIBS= X_LIBS= X_EXTRA_LIBS=
else
  if test -n "$x_includes"; then
    X_CFLAGS="$X_CFLAGS -I$x_includes"
  fi

  # It would also be nice to do this for all -L options, not just this one.
  if test -n "$x_libraries"; then
    X_LIBS="$X_LIBS -L$x_libraries"
dnl FIXME: banish uname from this macro!
    # For Solaris; some versions of Sun CC require a space after -R and
    # others require no space.  Words are not sufficient . . . .
    case "`(uname -sr) 2>/dev/null`" in
    "SunOS 5"*)
      AC_MSG_CHECKING(whether -R must be followed by a space)
      ac_xsave_LIBS="$LIBS"; LIBS="$LIBS -R$x_libraries"
      AC_TRY_LINK(, , ac_R_nospace=yes, ac_R_nospace=no)
      if test $ac_R_nospace = yes; then
	AC_MSG_RESULT(no)
	X_LIBS="$X_LIBS -R$x_libraries"
      else
	LIBS="$ac_xsave_LIBS -R $x_libraries"
	AC_TRY_LINK(, , ac_R_space=yes, ac_R_space=no)
	if test $ac_R_space = yes; then
	  AC_MSG_RESULT(yes)
	  X_LIBS="$X_LIBS -R $x_libraries"
	else
	  AC_MSG_RESULT(neither works)
	fi
      fi
      LIBS="$ac_xsave_LIBS"
    esac
  fi

  # Check for system-dependent libraries X programs must link with.
  # Do this before checking for the system-independent R6 libraries
  # (-lICE), since we may need -lsocket or whatever for X linking.

  if test "$ISC" = yes; then
    X_EXTRA_LIBS="$X_EXTRA_LIBS -lnsl_s -linet"
  else
    # Martyn Johnson says this is needed for Ultrix, if the X
    # libraries were built with DECnet support.  And Karl Berry says
    # the Alpha needs dnet_stub (dnet does not exist).
    AC_CHECK_LIB(dnet, dnet_ntoa, [X_EXTRA_LIBS="$X_EXTRA_LIBS -ldnet"])
    if test $ac_cv_lib_dnet_dnet_ntoa = no; then
      AC_CHECK_LIB(dnet_stub, dnet_ntoa,
	[X_EXTRA_LIBS="$X_EXTRA_LIBS -ldnet_stub"])
    fi

    # msh@cis.ufl.edu says -lnsl (and -lsocket) are needed for his 386/AT,
    # to get the SysV transport functions.
    # Chad R. Larson says the Pyramis MIS-ES running DC/OSx (SVR4)
    # needs -lnsl.
    # The nsl library prevents programs from opening the X display
    # on Irix 5.2, according to T.E. Dickey.
    # The functions gethostbyname, getservbyname, and inet_addr are
    # in -lbsd on LynxOS 3.0.1/i386, according to Lars Hecking.
    AC_CHECK_FUNC(gethostbyname)
    if test $ac_cv_func_gethostbyname = no; then
      AC_CHECK_LIB(nsl, gethostbyname, X_EXTRA_LIBS="$X_EXTRA_LIBS -lnsl")
      if test $ac_cv_lib_nsl_gethostbyname = no; then
        AC_CHECK_LIB(bsd, gethostbyname, X_EXTRA_LIBS="$X_EXTRA_LIBS -lbsd")
      fi
    fi

    # lieder@skyler.mavd.honeywell.com says without -lsocket,
    # socket/setsockopt and other routines are undefined under SCO ODT
    # 2.0.  But -lsocket is broken on IRIX 5.2 (and is not necessary
    # on later versions), says Simon Leinen: it contains gethostby*
    # variants that don't use the nameserver (or something).  -lsocket
    # must be given before -lnsl if both are needed.  We assume that
    # if connect needs -lnsl, so does gethostbyname.
    AC_CHECK_FUNC(connect)
    if test $ac_cv_func_connect = no; then
      AC_CHECK_LIB(socket, connect, X_EXTRA_LIBS="-lsocket $X_EXTRA_LIBS", ,
	$X_EXTRA_LIBS)
    fi

    # Guillermo Gomez says -lposix is necessary on A/UX.
    AC_CHECK_FUNC(remove)
    if test $ac_cv_func_remove = no; then
      AC_CHECK_LIB(posix, remove, X_EXTRA_LIBS="$X_EXTRA_LIBS -lposix")
    fi

    # BSDI BSD/OS 2.1 needs -lipc for XOpenDisplay.
    AC_CHECK_FUNC(shmat)
    if test $ac_cv_func_shmat = no; then
      AC_CHECK_LIB(ipc, shmat, X_EXTRA_LIBS="$X_EXTRA_LIBS -lipc")
    fi
  fi

  # Check for libraries that X11R6 Xt/Xaw programs need.
  ac_save_LDFLAGS="$LDFLAGS"
  test -n "$x_libraries" && LDFLAGS="$LDFLAGS -L$x_libraries"
  # SM needs ICE to (dynamically) link under SunOS 4.x (so we have to
  # check for ICE first), but we must link in the order -lSM -lICE or
  # we get undefined symbols.  So assume we have SM if we have ICE.
  # These have to be linked with before -lX11, unlike the other
  # libraries we check for below, so use a different variable.
  # John Interrante, Karl Berry
  AC_CHECK_LIB(ICE, IceConnectionNumber,
    [X_PRE_LIBS="$X_PRE_LIBS -lSM -lICE"], , $X_EXTRA_LIBS)
  LDFLAGS="$ac_save_LDFLAGS"

fi
AC_SUBST(X_CFLAGS)dnl
AC_SUBST(X_PRE_LIBS)dnl
AC_SUBST(X_LIBS)dnl
AC_SUBST(X_EXTRA_LIBS)dnl
])# AC_PATH_XTRA



## ------------------------------------ ##
## Checks for not-quite-Unix variants.  ##
## ------------------------------------ ##

# The old Cygwin32 macro is deprecated.
AU_DEFUN(AC_CYGWIN32,
[AC_CYGWIN])


# AC_CYGWIN
# ---------
# Check for Cygwin.  This is a way to set the right value for
# EXEEXT.
AC_DEFUN(AC_CYGWIN,
[AC_CACHE_CHECK(for Cygwin environment, ac_cv_cygwin,
[AC_TRY_COMPILE(,
[#ifndef __CYGWIN__
# define __CYGWIN__ __CYGWIN32__
#endif
return __CYGWIN__;],
ac_cv_cygwin=yes, ac_cv_cygwin=no)])
CYGWIN=
test "$ac_cv_cygwin" = yes && CYGWIN=yes])


# AC_MINGW32
# ----------
# Check for mingw32.  This is another way to set the right value for
# EXEEXT.
AC_DEFUN(AC_MINGW32,
[AC_CACHE_CHECK(for mingw32 environment, ac_cv_mingw32,
[AC_TRY_COMPILE(,[return __MINGW32__;],
ac_cv_mingw32=yes, ac_cv_mingw32=no)])
MINGW32=
test "$ac_cv_mingw32" = yes && MINGW32=yes])


# AC_EMXOS2
# ---------
# Check for EMX on OS/2.  This is another way to set the right value
# for EXEEXT.
AC_DEFUN(AC_EMXOS2,
[AC_CACHE_CHECK(for EMX OS/2 environment, ac_cv_emxos2,
[AC_TRY_COMPILE(,[return __EMX__;],
ac_cv_emxos2=yes, ac_cv_emxos2=no)])
EMXOS2=
test "$ac_cv_emxos2" = yes && EMXOS2=yes])


# AC_EXEEXT
# ---------
# Check for the extension used for executables.  This knows that we
# add .exe for Cygwin or mingw32.  Otherwise, it compiles a test
# executable.  If this is called, the executable extensions will be
# automatically used by link commands run by the configure script.
AC_DEFUN(AC_EXEEXT,
[AC_REQUIRE([AC_CYGWIN])dnl
AC_REQUIRE([AC_MINGW32])dnl
AC_REQUIRE([AC_EMXOS2])dnl
AC_MSG_CHECKING([for executable suffix])
AC_CACHE_VAL(ac_cv_exeext,
[if test "$CYGWIN" = yes || test "$MINGW32" = yes || test "$EMXOS2" = yes; then
  ac_cv_exeext=.exe
else
  rm -f conftest*
  echo 'int main () { return 0; }' >conftest.$ac_ext
  ac_cv_exeext=
  if AC_TRY_EVAL(ac_link); then
    for ac_file in conftest.*; do
      case $ac_file in
      *.c | *.C | *.o | *.obj | *.xcoff) ;;
      *) ac_cv_exeext=`echo $ac_file | sed -e s/conftest//` ;;
      esac
    done
  else
    AC_MSG_ERROR([installation or configuration problem: compiler cannot create executables.])
  fi
  rm -f conftest*
  test x"${ac_cv_exeext}" = x && ac_cv_exeext=no
fi])
EXEEXT=""
test x"${ac_cv_exeext}" != xno && EXEEXT=${ac_cv_exeext}
AC_MSG_RESULT(${ac_cv_exeext})
dnl Setting ac_exeext will implicitly change the ac_link command.
ac_exeext=$EXEEXT
AC_SUBST(EXEEXT)dnl
])# AC_EXEEXT


# AC_OBJEXT
# ---------
# Check the object extension used by the compiler: typically .o or
# .obj.  If this is called, some other behaviour will change,
# determined by ac_objext.
AC_DEFUN(AC_OBJEXT,
[AC_MSG_CHECKING([for object suffix])
AC_CACHE_VAL(ac_cv_objext,
[rm -f conftest*
echo 'int i = 1;' >conftest.$ac_ext
if AC_TRY_EVAL(ac_compile); then
  for ac_file in conftest.*; do
    case $ac_file in
    *.c) ;;
    *) ac_cv_objext=`echo $ac_file | sed -e s/conftest.//` ;;
    esac
  done
else
  AC_MSG_ERROR([installation or configuration problem; compiler does not work])
fi
rm -f conftest*])
AC_MSG_RESULT($ac_cv_objext)
OBJEXT=$ac_cv_objext
ac_objext=$ac_cv_objext
AC_SUBST(OBJEXT)])




## -------------------------- ##
## Checks for UNIX variants.  ##
## -------------------------- ##


# These are kludges which should be replaced by a single POSIX check.
# They aren't cached, to discourage their use.

# AC_AIX
# ------
AC_DEFUN(AC_AIX,
[AC_BEFORE([$0], [AC_TRY_COMPILE])dnl
AC_BEFORE([$0], [AC_TRY_RUN])dnl
AC_MSG_CHECKING(for AIX)
AC_EGREP_CPP(yes,
[#ifdef _AIX
  yes
#endif
],
[AC_MSG_RESULT(yes)
AC_DEFINE(_ALL_SOURCE)],
AC_MSG_RESULT(no))
])# AC_AIX


# AC_MINIX
# --------
AC_DEFUN(AC_MINIX,
[AC_BEFORE([$0], [AC_TRY_COMPILE])dnl
AC_BEFORE([$0], [AC_TRY_RUN])dnl
AC_CHECK_HEADER(minix/config.h, MINIX=yes, MINIX=)
if test "$MINIX" = yes; then
  AC_DEFINE(_POSIX_SOURCE, 1,
            [Define if you need to in order for `stat' and other things to
             work.])
  AC_DEFINE(_POSIX_1_SOURCE, 2,
            [Define if the system does not provide POSIX.1 features except
             with this defined.])
  AC_DEFINE(_MINIX, 1,
            [Define if on MINIX.])
fi
])# AC_MINIX


# AC_ISC_POSIX
# ------------
AC_DEFUN(AC_ISC_POSIX,
[AC_REQUIRE([AC_PROG_CC])dnl
AC_BEFORE([$0], [AC_TRY_COMPILE])dnl
AC_BEFORE([$0], [AC_TRY_RUN])dnl
AC_MSG_CHECKING(for POSIXized ISC)
if test -d /etc/conf/kconfig.d &&
   grep _POSIX_VERSION [/usr/include/sys/unistd.h] >/dev/null 2>&1
then
  AC_MSG_RESULT(yes)
  ISC=yes # If later tests want to check for ISC.
  AC_DEFINE(_POSIX_SOURCE, 1,
            [Define if you need to in order for stat and other things to
             work.])
  if test "$GCC" = yes; then
    CC="$CC -posix"
  else
    CC="$CC -Xp"
  fi
else
  AC_MSG_RESULT(no)
  ISC=
fi
])# AC_ISC_POSIX

AC_DEFUNCT(AC_XENIX_DIR, [; instead use AC_HEADER_DIRENT])
AC_DEFUNCT(AC_DYNIX_SEQ, [; instead use AC_FUNC_GETMNTENT])
AC_DEFUNCT(AC_IRIX_SUN,
           [; instead use AC_FUNC_GETMNTENT or AC_CHECK_LIB(sun, getpwnam)])
AC_DEFUNCT(AC_SCO_INTL, [; instead use AC_FUNC_STRFTIME])
