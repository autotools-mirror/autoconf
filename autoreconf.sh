#!/bin/sh
# autoreconf - remake all Autoconf configure scripts in a directory tree
# Copyright (C) 1994 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

# Written by David MacKenzie <djm@gnu.ai.mit.edu>.

if test $# -eq 0; then paths=.; else paths="$@"; fi

# The xargs grep filters out Cygnus configure.in files.
find $paths -name configure.in -print |
xargs grep -l AC_OUTPUT |
while read confin; do
  (
  dir=`echo $confin|sed 's%/[^/][^/]*$%%'`
  cd $dir || exit 1
  echo running autoconf in $dir
  autoconf
  if grep AC_CONFIG_HEADER configure.in > /dev/null; then
    echo running autoheader in $dir
    autoheader
  fi
  )
done

