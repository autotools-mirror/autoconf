#! @SHELL@
# autoheader -- create `config.h.in' from `configure.in'
# Copyright (C) 1992-94, 96, 98, 99, 2000 Free Software Foundation, Inc.

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
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# Written by Roland McGrath.

# If given no args, create `config.h.in' from template file `configure.in'.
# With one arg, create a header file on standard output from
# the given template file.

me=`echo "$0" | sed -e 's,.*/,,'`

usage="\
Usage: $0 [OPTION] ... [TEMPLATE-FILE]

Create a template file of C \`#define' statements for \`configure' to
use.  To this end, scan TEMPLATE-FILE, or \`configure.in' if none
given.

  -h, --help            print this help, then exit
  -V, --version         print version number, then exit
  -v, --verbose         verbosely report processing
  -d, --debug           don't remove temporary files
  -m, --macrodir=DIR    directory storing Autoconf's macro files
  -l, --localdir=DIR    directory storing \`aclocal.m4' and \`acconfig.h'

Report bugs to <bug-autoconf@gnu.org>."

version="\
autoheader (GNU @PACKAGE@) @VERSION@
Written by Roland McGrath.

Copyright (C) 1992-94, 96, 98, 99, 2000 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."

help="\
Try \`$me --help' for more information."

# NLS nuisances.
# Only set these to C if already set.  These must not be set unconditionally
# because not all systems understand e.g. LANG=C (notably SCO).
# Fixing LC_MESSAGES prevents Solaris sh from translating var values in `set'!
# Non-C LC_CTYPE values break the ctype check.
if test "${LANG+set}"   = set; then LANG=C;   export LANG;   fi
if test "${LC_ALL+set}" = set; then LC_ALL=C; export LC_ALL; fi
if test "${LC_MESSAGES+set}" = set; then LC_MESSAGES=C; export LC_MESSAGES; fi
if test "${LC_CTYPE+set}"    = set; then LC_CTYPE=C;    export LC_CTYPE;    fi

# ac_LF_and_DOT
# We use echo to avoid assuming a particular line-breaking character.
# The extra dot is to prevent the shell from consuming trailing
# line-breaks from the sub-command output.  A line-break within
# single-quotes doesn't work because, if this script is created in a
# platform that uses two characters for line-breaks (e.g., DOS), tr
# would break.
ac_LF_and_DOT=`echo; echo .`

# Variables.
: ${AC_MACRODIR=@datadir@}
debug=false
localdir=.
verbose=:
# Basename for temporary files.
: ${TMPDIR=/tmp}
tmpbase=$TMPDIR/ah$$
tmpout=$tmpbase.out

while test $# -gt 0 ; do
  case "$1" in
    --version | --vers* | -V )
       echo "$version" ; exit 0 ;;
    --help | --h* | -h )
       echo "$usage"; exit 0 ;;

    --debug | --d* | -d )
       debug=:; shift ;;
    --verbose | --verb* | -v )
       verbose=echo
       shift;;

    --localdir=* | --l*=* )
       localdir=`echo "$1" | sed -e 's/^[^=]*=//'`
       shift ;;
    --localdir | --l* | -l )
       shift
       test $# = 0 && { echo "$help" >&2; exit 1; }
       localdir=$1
       shift ;;

    --macrodir=* | --m*=* )
       AC_MACRODIR=`echo "$1" | sed -e 's/^[^=]*=//'`
       shift ;;
    --macrodir | --m* | -m )
       shift
       test $# = 0 && { echo "$help" >&2; exit 1; }
       AC_MACRODIR=$1
       shift ;;

    -- )     # Stop option processing
      shift; break ;;
    - )     # Use stdin as input.
      break ;;
    -* )
      exec >&2
      echo "$me: invalid option $1"
      echo "$help"
      exit 1 ;;
    * )
      break ;;
  esac
done

acconfigs=
test -r $localdir/acconfig.h && acconfigs="$acconfigs $localdir/acconfig.h"

# Find the input file.
case $# in
  0) infile=configure.in ;;
  1) infile=$1 ;;
  *) exec >&2
     echo "$me: invalid number of arguments."
     echo "$help"
     exit 1 ;;
esac

# Trap on 0 to stop playing with `rm'.
$debug ||
{
  trap 'status=$?; rm -f $tmpbase* && exit $status' 0
  trap 'exit $?' 1 2 13 15
}

# Well, work now!
config_h=
syms=

# Source what the traces are trying to tell us.
autoconf=`echo "$0" | sed -e 's/autoheader$/autoconf/'`
test -n "$localdir" && autoconf="$autoconf -l $localdir"
export AC_MACRODIR
$autoconf --trace AH_OUTPUT:'$1' --trace AC_CONFIG_HEADERS:'config_h="$1"' \
  $infile >$tmpbase.decls
. $tmpbase.decls
$debug || rm -f $tmpbase.decls

# Make SYMS newline-separated rather than blank-separated, and remove dups.
# Start each symbol with a blank (to match the blank after "#undef")
# to reduce the possibility of mistakenly matching another symbol that
# is a substring of it.
syms=`for sym in $syms; do echo $sym; done | sort | uniq | sed 's@^@ @'`


# We template only the first CONFIG_HEADER.
config_h=`echo "$config_h" | sed -e 's/ .*//'`
# Support "outfile[:infile]", defaulting infile="outfile.in".
case "$config_h" in
"") echo "$me: error: AC_CONFIG_HEADERS not found in $infile" >&2; exit 1 ;;
*:*) config_h_in=`echo "$config_h" | sed 's/.*://'`
     config_h=`echo "$config_h" | sed 's/:.*//'` ;;
*) config_h_in="$config_h.in" ;;
esac


# Don't write "do not edit" -- it will get copied into the
# config.h, which it's ok to edit.
cat <<EOF >$tmpout
/* $config_h_in.  Generated automatically from $infile by autoheader.  */
EOF

test -r ${config_h}.top && cat ${config_h}.top  >>$tmpout
test -r $localdir/acconfig.h &&
  grep @TOP@ $localdir/acconfig.h >/dev/null &&
  sed '/@TOP@/,$d' $localdir/acconfig.h >>$tmpout

# This puts each template paragraph on its own line, separated by @s.
if test -n "$syms"; then
  # Make sure the boundary of template files is also the boundary
  # of the paragraph.  Extra newlines don't hurt since they will
  # be removed.
  # Stuff outside of @TOP@ and @BOTTOM@ is ignored in all the acconfig.hs.
  for t in $acconfigs; do
    sedscript=""
    grep @TOP@ $t >/dev/null && sedscript="1,/@TOP@/d;"
    grep @BOTTOM@ $t >/dev/null && sedscript="$sedscript /@BOTTOM@/,\$d;"
    # This substitution makes "#undef<TAB>FOO" in acconfig.h work.
    sed -n -e "$sedscript s/	/ /g; p" $t
    echo; echo
  done |
  # The sed script is suboptimal because it has to take care of
  # some broken seds (e.g. AIX) that remove '\n' from the
  # pattern/hold space if the line is empty. (junio@twinsun.com).
  sed -n -e '
	/^[ 	]*$/{
		x
		s/\n/@/g
		p
		s/.*/@/
		x
	}
	H' | sed -e 's/@@*/@/g' |
  # Select each paragraph that refers to a symbol we picked out above.
  # Some fgrep's have limits on the number of lines that can be in the
  # pattern on the command line, so use a temporary file containing the
  # pattern.
  (fgrep_tmp=$tmpbase.fgrep
   cat > $fgrep_tmp <<EOF
$syms
EOF
   fgrep -f $fgrep_tmp
   rm -f $fgrep_tmp) |
  tr @. "$ac_LF_and_DOT" >>$tmpout
fi

for verb in `(set) 2>&1 | sed -n -e '/^ac_verbatim/s/^\([^=]*\)=.*$/\1/p'`; do
  echo >>$tmpout
  eval echo >>$tmpout '"${'$verb'}"'
done

# Handle the case where @BOTTOM@ is the first line of acconfig.h.
test -r $localdir/acconfig.h &&
  grep @BOTTOM@ $localdir/acconfig.h >/dev/null &&
  sed -n '/@BOTTOM@/,${/@BOTTOM@/!p;}' $localdir/acconfig.h >>$tmpout
test -f ${config_h}.bot && cat ${config_h}.bot >>$tmpout


# Check that all the symbols have a template.
status=0
# Regexp for a white space.
w='[ 	]'
if test -n "$syms"; then
  for sym in $syms; do
    if egrep "^#$w*[a-z]*$w$w*$sym($w*|$w.*)$" $tmpout >/dev/null; then
      : # All is well.
    else
      echo "$0: No template for symbol \`$sym'" >&2
      status=1
    fi
  done
fi


# If the run was successful, output the result.
if test $status = 0; then
  if test $# = 0; then
    # Output is a file
    if test -f $config_h_in && cmp -s $tmpout $config_h_in; then
      # File didn't change, so don't update its mod time.
      echo "$0: $config_h_in is unchanged" >&2
    else
      mv -f $tmpout $config_h_in
    fi
  else
    # Output is stdout
    cat $tmpout
  fi
fi

exit $status
