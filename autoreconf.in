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

usage="\
Usage: autoreconf [--help] [--macrodir=dir] [--verbose] [--version]
       [directory...]"
verbose=
show_version=

test -z "$AC_MACRODIR" && AC_MACRODIR=@datadir@
export AC_MACRODIR # Pass it down to autoconf and autoheader.

while test $# -gt 0; do
  case "$1" in 
  --help | --hel | --he | --h)
    echo "$usage"; exit 0 ;;
  --macrodir=* | --m*=* )
    AC_MACRODIR="`echo \"$1\" | sed -e 's/^[^=]*=//'`"
    shift ;;
  -m | --macrodir | --m*)
    shift
    test $# -eq 0 && { echo "$usage" 1>&2; exit 1; }
    AC_MACRODIR="$1"
    shift ;;
  --verbose | --verbos | --verbo | --verb)
    verbose=t; shift ;;
  --version | --versio | --versi | --vers)
    show_version=t; shift ;;
  --)     # Stop option processing.
    shift; break ;;
  -*) echo "$usage" 1>&2; exit 1 ;;
  *) break ;;
  esac
done

if test -n "$show_version"; then
  version=`sed -n 's/define.AC_ACVERSION.[ 	]*\([0-9.]*\).*/\1/p' \
    $AC_MACRODIR/acgeneral.m4`
  echo "Autoconf version $version"
  exit 0
fi

if test $# -eq 0; then paths=.; else paths="$@"; fi

# The xargs grep filters out Cygnus configure.in files.
find $paths -name configure.in -print |
xargs grep -l AC_OUTPUT |
while read confin; do
  (
  dir=`echo $confin|sed 's%/[^/][^/]*$%%'`
  cd $dir || exit 1
  test -n "$verbose" && echo running autoconf in $dir
  autoconf
  if grep AC_CONFIG_HEADER configure.in > /dev/null; then
    test -n "$verbose" && echo running autoheader in $dir
    autoheader
  fi
  )
done

