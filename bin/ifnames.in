#!/bin/sh
# ifnames - print the identifiers used in C preprocessor conditionals
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

# Usage: ifnames [--macrodir=dir] [--help] [--version] [file...]
# Reads from stdin if no files are given.
# Writes to stdout.

# Written by David MacKenzie <djm@gnu.ai.mit.edu>

usage="Usage: ifnames [--macrodir=dir] [--help] [--version] [file...]"
show_version=no

test -z "$AC_MACRODIR" && AC_MACRODIR=@datadir@

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
  --version | --versio | --versi | --vers)
    show_version=yes; shift ;;
  --)     # Stop option processing.
    shift; break ;;
  -*) echo "$usage" 1>&2; exit 1 ;;
  *) break ;;
  esac
done

if test $show_version = yes; then
  version=`sed -n 's/define.AC_ACVERSION.[ 	]*\([0-9.]*\).*/\1/p' \
    $AC_MACRODIR/acgeneral.m4`
  echo "Autoconf version $version"
  exit 0
fi

if test $# -eq 0; then
	cat > stdin
	set stdin
	trap 'rm -f stdin' 0
	trap 'rm -f stdin; exit 1' 1 3 15
fi

for arg
do
sed -n '
# Remove comments.  Not perfect, but close enough.
s,/\*[^/]*\*/,,g
# Comments that end on a later line.
s,/\*[^/]*,,g
/^[ 	]*#[ 	]*ifn*def[ 	][ 	]*\([A-Za-z0-9_]*\).*/s//\1/p
/^[ 	]*#[ 	]*e*l*if[ 	]/{
	s///
	s/@//g
	# Enclose identifiers in @ and a space.
	s/\([A-Za-z_][A-Za-z_0-9]*\)/@\1 /g
	# Handle "#if 0" -- there are no @s to trigger removal.
	s/$/@ /
	# Remove non-identifiers.
	s/@defined //g
	s/[^@]*@\([^ ]* \)[^@]*/\1/g
	# Remove any spaces at the end.
	s/ *$//
	# Translate any other spaces to newlines.
	s/ /\
/g
	p
}
' $arg | sort -u | sed 's,$, '$arg','
done | awk '
{ files[$1] = files[$1] " " $2 }
END { for (sym in files) print sym files[sym] }' | sort
