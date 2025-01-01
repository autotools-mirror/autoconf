AS_INIT[]dnl                                            -*- shell-script -*-
# wrapper.as -- running '@wrap_program@' as if it were installed.
# @configure_input@
# Copyright (C) 2003-2004, 2007, 2009-2017, 2020-2025 Free Software
# Foundation, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

testdir='@abs_top_builddir@/tests'
PATH=$testdir$PATH_SEPARATOR$PATH
AUTOCONF=autoconf
AUTOHEADER=autoheader
AUTOM4TE=autom4te
AUTOM4TE_CFG='@abs_top_builddir@/lib/autom4te.cfg'
autom4te_buildauxdir='@abs_top_srcdir@/build-aux'
autom4te_perllibdir='@abs_top_srcdir@/lib'
trailer_m4='@abs_top_srcdir@/lib/autoconf/trailer.m4'
export AUTOCONF AUTOHEADER AUTOM4TE AUTOM4TE_CFG
export autom4te_buildauxdir autom4te_perllibdir trailer_m4

# Programs other than ifnames might need files from the build tree
# (frozen files), in addition to src files.
prog='@abs_top_builddir@/bin/@wrap_program@'
buildlib='@abs_top_builddir@/lib'
srclib='@abs_top_srcdir@/lib'
case $#,'@wrap_program@' in
  0,ifnames) exec "$prog" ;;
  *,ifnames) exec "$prog" "$@" ;;
  0,*)       exec "$prog" -B "$buildlib" -B "$srclib" ;;
  *)         exec "$prog" -B "$buildlib" -B "$srclib" "$@" ;;
esac
exit 1
