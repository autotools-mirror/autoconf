## ----------------------##                              -*- Autoconf -*-
## Prepare for testing.  ##
## ----------------------##

#serial 4

# Copyright 2000, 2001 Free Software Foundation, Inc.
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

# AT_CONFIG([AUTOTEST-PATH = .])
# ------------------------------
# Configure the test suite.
#
# AUTOTEST-PATH must help the test suite to find the executables, i.e.,
# if the test suite is in `tests/' and the executables are in `src/',
# pass `../src'.  If there are also executables in the source tree, use
# `../src:$top_srcdir/src'.
AC_DEFUN([AT_CONFIG],
[AC_SUBST([AUTOTEST_PATH], [m4_default([$1], [.])])])
