# m4.m4 serial 3
dnl Copyright (C) 2000, 2006, 2007 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# AC_PROG_GNU_M4
# --------------
# Check for GNU M4, at least 1.4.5 (all earlier versions had a bug in
# trace support:
# http://lists.gnu.org/archive/html/bug-gnu-utils/2006-11/msg00096.html)
# Also, check whether --error-output (through 1.4.x) or --debugfile (2.0)
# is supported, and AC_SUBST M4_DEBUGFILE accordingly.
AC_DEFUN([AC_PROG_GNU_M4],
[AC_PATH_PROGS([M4], [gm4 gnum4 m4], [m4])
AC_CACHE_CHECK([whether m4 supports accurate traces], [ac_cv_prog_gnu_m4],
[ac_cv_prog_gnu_m4=no
dnl Creative quoting here to avoid raw dnl and ifdef in configure.
if test x"$M4" != x \
    && test -z "`echo if'def(mac,bug)d'nl | $M4 --trace=mac 2>&1`" ; then
  ac_cv_prog_gnu_m4=yes
fi])
if test $ac_cv_prog_gnu_m4 = yes ; then
  AC_CACHE_CHECK([how m4 supports trace files], [ac_cv_prog_gnu_m4_debugfile],
  [case `$M4 --help < /dev/null 2>&1` in
    *debugfile*) ac_cv_prog_gnu_m4_debugfile=--debugfile ;;
    *) ac_cv_prog_gnu_m4_debugfile=--error-output ;;
  esac])
  AC_SUBST([M4_DEBUGFILE], $ac_cv_prog_gnu_m4_debugfile)
fi
])
