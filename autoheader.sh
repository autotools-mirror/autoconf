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

  -h, --help               print this help, then exit
  -V, --version            print version number, then exit
  -v, --verbose            verbosely report processing
  -d, --debug              don't remove temporary files
  -W, --warnings=CATEGORY  report the warnings falling in CATEGORY

Warning categories include:
  \`obsolete'   obsolete constructs
  \`all'        all the warnings
  \`error'      warnings are error

Library directories:
  -A, --autoconf-dir=ACDIR  Autoconf's macro files location (rarely needed)
  -l, --localdir=DIR        location of \`aclocal.m4' and \`acconfig.h'

Report bugs to <bug-autoconf@gnu.org>."

version="\
autoheader (GNU @PACKAGE@) @VERSION@
Written by Roland McGrath.

Copyright (C) 1992-94, 96, 98, 99, 2000 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."

help="\
Try \`$me --help' for more information."

exit_missing_arg="\
echo \"$me: option \\\`\$1' requires an argument\" >&2
echo \"\$help\" >&2
exit 1"

# NLS nuisances.
# Only set these to C if already set.  These must not be set unconditionally
# because not all systems understand e.g. LANG=C (notably SCO).
# Fixing LC_MESSAGES prevents Solaris sh from translating var values in `set'!
# Non-C LC_CTYPE values break the ctype check.
if test "${LANG+set}"   = set; then LANG=C;   export LANG;   fi
if test "${LC_ALL+set}" = set; then LC_ALL=C; export LC_ALL; fi
if test "${LC_MESSAGES+set}" = set; then LC_MESSAGES=C; export LC_MESSAGES; fi
if test "${LC_CTYPE+set}"    = set; then LC_CTYPE=C;    export LC_CTYPE;    fi

# Variables.
: ${autoconf_dir=${AC_MACRODIR=@datadir@}}
dir=`echo "$0" | sed -e 's/[^/]*$//'`
# We test "$dir/autoconf" in case we are in the build tree, in which case
# the names are not transformed yet.
for autoconf in "$AUTOCONF" \
                "$dir/@autoconf-name@" \
                "$dir/autoconf" \
                "@bindir@/@autoconf-name@"; do
  test -f "$autoconf" && break
done
debug=false
localdir=.
status=0
tmp=
verbose=:
warning_all=false
warning_error=false
warning_obsolete=false

# Parse command line.
while test $# -gt 0 ; do
  optarg=`expr "x$1" : 'x--[^=]*=\(.*\)' \| \
               "x$1" : 'x-.\(.*\)'`
  case $1 in
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
       localdir=$optarg
       shift ;;
    --localdir | --l* | -l )
       test $# = 1 && eval "$exit_missing_arg"
       shift
       localdir=$1
       shift ;;

    --autoconf-dir=*)
      autoconf_dir=$optarg
       shift ;;
    --autoconf-dir | -A* )
       test $# = 1 && eval "$exit_missing_arg"
       shift
       autoconf_dir=$1
       shift ;;
    --macrodir=* | --m*=* )
       echo "$me: warning: --macrodir is obsolete, use --autoconf-dir" >&1
       autoconf_dir=$optarg
       shift ;;
    --macrodir | --m* | -m )
       echo "$me: warning: --macrodir is obsolete, use --autoconf-dir" >&1
       test $# = 1 && eval "$exit_missing_arg"
       shift
       autoconf_dir=$1
       shift ;;

    --warnings | -W )
       test $# = 1 && eval "$exit_missing_arg"
       shift
       warnings=$warnings,$1
       shift ;;
    --warnings=* | -W*)
       warnings=$warnings,$optarg
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

# The warnings are the concatenation of 1. application's defaults
# (here, none), 2. $WARNINGS, $3 command line options, in that order.
alphabet='abcdefghijklmnopqrstuvwxyz'
ALPHABET='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
_ac_warnings=
for warning in `IFS=,; echo $WARNINGS,$warnings | tr $ALPHABET $alphabet`
do
  case $warning in
  '' | ,)   continue;;
  no-*) eval warning_`expr x$warning : 'xno-\(.*\)'`=false;;
  *)    eval warning_$warning=:;;
  esac
done

# Trap on 0 to stop playing with `rm'.
$debug ||
{
  trap 'status=$?; rm -rf $tmp && exit $status' 0
  trap '(exit $?); exit' 1 2 13 15
}

# Create a (secure) tmp directory for tmp files.
: ${TMPDIR=/tmp}
{
  tmp=`(umask 077 && mktemp -d -q "$TMPDIR/ahXXXXXX") 2>/dev/null` &&
  test -n "$tmp" && test -d "$tmp"
}  ||
{
  tmp=$TMPDIR/ah$$
  (umask 077 && mkdir $tmp)
} ||
{
   echo "$me: cannot create a temporary directory in $TMPDIR" >&2
   (exit 1); exit
}

# Preach.
if ($warning_all || $warning_obsolete) &&
    (test -f $config_h.top ||
     test -f $config_h.bot ||
     test -f $localdir/acconfig.h); then
  sed -e "s/^    /$me: WARNING: /" >&2 <<\EOF
    Using auxiliary files such as `acconfig.h', `config.h.bot'
    and `config.h.top', to define templates for `config.h.in'
    is deprecated and discouraged.

    Using the third argument of `AC_DEFINE' and
    `AC_DEFINE_UNQUOTED' allows to define a template without
    `acconfig.h':

      AC_DEFINE([NEED_MAIN], 1,
                [Define if a function `main' is needed.])

    More sophisticated templates can also be produced, see the
    documentation.
EOF
  $warning_error && { (exit 1); exit; }
fi

acconfigs=
test -r $localdir/acconfig.h && acconfigs="$acconfigs $localdir/acconfig.h"

# Find the input file.
case $# in
  0) infile=configure.in ;;
  1) infile=$1 ;;
  *) exec >&2
     echo "$me: invalid number of arguments."
     echo "$help"
     (exit 1); exit ;;
esac

# Set up autoconf.
autoconf="$autoconf -l $localdir"
export autoconf_dir

# ----------------------- #
# Real work starts here.  #
# ----------------------- #

# Source what the traces are trying to tell us.
$verbose $me: running $autoconf to trace from $infile >&2
$autoconf  \
  --trace AC_CONFIG_HEADERS:'config_h="$1"' \
  --trace AH_OUTPUT:'ac_verbatim_$1="\
$2"' \
  --trace AC_DEFINE:'syms="$$syms $1"' \
  --trace AC_DEFINE_UNQUOTED:'syms="$$syms $1"' \
  $infile >$tmp/traces.sh || { (exit 1); exit; }

$verbose $me: sourcing $tmp/traces.sh >&2
. $tmp/traces.sh

# Make SYMS newline-separated rather than blank-separated, and remove dups.
# Start each symbol with a blank (to match the blank after "#undef")
# to reduce the possibility of mistakenly matching another symbol that
# is a substring of it.
# Beware that some of the symbols might actually be macro with arguments:
# keep only their name.
syms=`for sym in $syms; do echo $sym; done |
  sed -e 's/(.*//' |
  sort |
  uniq |
  sed -e 's@^@ @'`


# We template only the first CONFIG_HEADER.
config_h=`echo "$config_h" | sed -e 's/ .*//'`
# Support "outfile[:infile]", defaulting infile="outfile.in".
case "$config_h" in
"") echo "$me: error: AC_CONFIG_HEADERS not found in $infile" >&2
    (exit 1); exit ;;
*:*) config_h_in=`echo "$config_h" | sed 's/.*://'`
     config_h=`echo "$config_h" | sed 's/:.*//'` ;;
*) config_h_in="$config_h.in" ;;
esac

# Don't write "do not edit" -- it will get copied into the
# config.h, which it's ok to edit.
cat <<EOF >$tmp/config.hin
/* $config_h_in.  Generated automatically from $infile by autoheader.  */
EOF

# Dump the top.
test -r $config_h.top && cat $config_h.top >>$tmp/config.hin

# Dump `acconfig.h' but its bottom.
test -r $localdir/acconfig.h &&
  sed -e '/@BOTTOM@/,$d' -e 's/@TOP@//' $localdir/acconfig.h >>$tmp/config.hin

# Dump the templates from `configure.in'.
for verb in `(set) 2>&1 | sed -n -e '/^ac_verbatim/s/^\([^=]*\)=.*$/\1/p' | sort`; do
  echo >>$tmp/config.hin
  eval echo '"${'$verb'}"' >>$tmp/config.hin
done

# Handle the case where @BOTTOM@ is the first line of acconfig.h.
test -r $localdir/acconfig.h &&
  grep @BOTTOM@ $localdir/acconfig.h >/dev/null &&
  sed -n '/@BOTTOM@/,${/@BOTTOM@/!p;}' $localdir/acconfig.h >>$tmp/config.hin
test -f $config_h.bot && cat $config_h.bot >>$tmp/config.hin


# Check that all the symbols have a template.
$verbose $me: checking completeness of the template >&2
# Regexp for a white space.
w='[ 	]'
if test -n "$syms"; then
  for sym in $syms; do
    if egrep "^#$w*[a-z]*$w$w*$sym($w*|$w.*)$" $tmp/config.hin >/dev/null; then
      : # All is well.
    else
      echo "$me: No template for symbol \`$sym'" >&2
      status=1
    fi
  done
fi


# If the run was successful, output the result.
if test $status = 0; then
  if test $# = 0; then
    # Output is a file
    if test -f $config_h_in && cmp -s $tmp/config.hin $config_h_in; then
      # File didn't change, so don't update its mod time.
      echo "$me: $config_h_in is unchanged" >&2
    else
      mv -f $tmp/config.hin $config_h_in
    fi
  else
    # Output is stdout
    cat $tmp/config.hin
  fi
fi

(exit $status); exit
