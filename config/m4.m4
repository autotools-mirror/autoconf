# Copyright (C) 2000, 2006, 2008 Free Software Foundation, Inc.
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

# AC_PROG_GNU_M4
# --------------
# Check for GNU m4, at least 1.3 (supports frozen files).
# Also, check whether --error-output (through 1.4.x, but warns in 1.6)
# or --debugfile (since 1.4.7) is supported, and AC_SUBST M4_DEBUGFILE.
AC_DEFUN([AC_PROG_GNU_M4],
[AC_PATH_PROGS([M4], [gm4 gnum4 m4], [m4])
AC_CACHE_CHECK([whether m4 supports frozen files], [ac_cv_prog_gnu_m4],
[ac_cv_prog_gnu_m4=no
if test x"$M4" != x; then
  case `$M4 --help < /dev/null 2>&1` in
    *reload-state*) ac_cv_prog_gnu_m4=yes ;;
  esac
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
