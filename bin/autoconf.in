#! @SHELL@
# autoconf -- create `configure' using m4 macros
# Copyright (C) 1992, 1993, 1994, 1996, 1999 Free Software Foundation, Inc.

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

# If given no args, create `configure' from template file `configure.in'.
# With one arg, create a configure script on standard output from
# the given template file.

usage="\
Usage: autoconf [OPTION] ... [TEMPLATE-FILE]

Generate a configuration script from a TEMPLATE-FILE if given, or
\`configure.in' by default.  Output is sent to the standard output if
TEMPLATE-FILE is given, else into \`configure'.

If the option \`--trace' is used, no configuration script is created.

  -h, --help          print this help, then exit
      --version       print version number, then exit
  -m, --macrodir=DIR  directory storing macro files
  -l, --localdir=DIR  directory storing the \`aclocal.m4' file
  -t, --trace=MACRO   report the list of calls to MACRO
  -o, --output=FILE   save output in FILE (stdout is the default)

Report bugs to <bug-autoconf@gnu.org>."

version="\
autoconf (GNU @PACKAGE@) @VERSION@
Written by David J. MacKenzie.

Copyright (C) 1992, 1993, 1994, 1996, 1999 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."

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
ac_LF_and_DOT="`echo; echo .`"

: ${AC_MACRODIR=@datadir@}
: ${M4=@M4@}
: ${AWK=@AWK@}
case "$M4" in
/*) # Handle the case that m4 has moved since we were configured.
    # It may have been found originally in a build directory.
    test -f "$M4" || M4=m4 ;;
esac

: ${TMPDIR=/tmp}
tmpin=$TMPDIR/acin.$$
tmpout=$TMPDIR/acout.$$
localdir=
outfile=
# Tasks:
# - trace
#   Trace the first arguments of some macros
# - script
#   Produce the configure script (default)
task=script

while test $# -gt 0 ; do
  case "$1" in
    -h | --help | --h* )
       echo "$usage"; exit 0 ;;
    --localdir=* | --l*=* )
       localdir="`echo \"$1\" | sed -e 's/^[^=]*=//'`"
       shift ;;
    -l | --localdir | --l*)
       shift
       test $# -eq 0 && { echo "$usage" 1>&2; exit 1; }
       localdir="$1"
       shift ;;
    --macrodir=* | --m*=* )
       AC_MACRODIR="`echo \"$1\" | sed -e 's/^[^=]*=//'`"
       shift ;;
    -m | --macrodir | --m* )
       shift
       test $# -eq 0 && { echo "$usage" 1>&2; exit 1; }
       AC_MACRODIR="$1"
       shift ;;
    --trace | -t )
       task=trace
       shift
       traces="$traces -t $1"
       shift ;;
    --trace=* )
       task=trace
       traces="$traces -t `echo \"$1\" | sed -e 's/^[^=]*=//'`"
       shift ;;
    -t* )
       task=trace
       traces="$traces -t `echo \"$1\" | sed -e 's/^-t//'`"
       shift ;;
    --output | -o )
       shift
       outfile="$1"
       shift ;;
    --output=* )
       outfile="`echo \"$1\" | sed -e 's/^[^=]*=//'`"
       shift ;;
    -o* )
       outfile="`echo \"$1\" | sed -e 's/^-o//'`"
       shift ;;
    --version | --v* )
       echo "$version" ; exit 0 ;;
    -- )     # Stop option processing
       shift; break ;;
    - )	# Use stdin as input.
       break ;;
    -* )
       echo "$usage" 1>&2; exit 1 ;;
    * )
       break ;;
  esac
done

case $# in
  0) infile=configure.in
     test $task = script && test "x$outfile" = x && outfile=configure;;
  1) infile="$1" ;;
  *) echo "$usage" >&2; exit 1 ;;
esac

trap 'rm -f $tmpin $tmpout' 0 1 2 15
if test z$infile = z-; then
  infile=$tmpin
  cat >$infile
elif test ! -r "$infile"; then
  echo "autoconf: $infile: No such file or directory" >&2
  exit 1
fi

if test -n "$localdir"; then
  use_localdir="-I$localdir -DAC_LOCALDIR=$localdir"
else
  use_localdir=
fi

# Use the frozen version of Autoconf if available.
r= f=
# Some non-GNU m4's don't reject the --help option, so give them /dev/null.
case `$M4 --help < /dev/null 2>&1` in
*reload-state*) test -r $AC_MACRODIR/autoconf.m4f && { r=--reload f=f; } ;;
*traditional*) ;;
*) echo Autoconf requires GNU m4 1.1 or later >&2; exit 1 ;;
esac
run_m4="$M4 -I$AC_MACRODIR $use_localdir $r autoconf.m4$f"

# Output is produced into FD 4.  Prepare it.
case "x$outfile" in
 x- | x )  # Output to stdout
  exec 4>&1 ;;
 * )
  exec 4>$outfile;;
esac

# Initializations are performed.  Perform the task.
case $task in
  #
  # Generate the script
  #
  script)
  $run_m4 $infile > $tmpout || exit 2

  # You could add your own prefixes to pattern if you wanted to check for
  # them too, e.g. pattern='\(AC_\|ILT_\)', except that UNIX sed doesn't do
  # alternation.
  pattern="A[CHM]_"

  status=0
  if grep "^[^#]*$pattern" $tmpout > /dev/null 2>&1; then
    echo "autoconf: Undefined macros:" >&2
    sed -n "s/^[^#]*\\($pattern[_A-Za-z0-9]*\\).*/\\1/p" $tmpout |
      while read macro; do
  	grep -n "^[^#]*$macro" $infile /dev/null
  	test $? -eq 1 && echo "***BUG in Autoconf--please report*** $macro"
      done | sort -u >&2
    status=1
  fi

  if test -n "$outfile"; then
    chmod +x $outfile
  fi

  # Put the real line numbers into configure to make config.log more helpful.
  # Because quoting can sometimes get really painful in m4, there are special
  # @tokens@ to substitute.
  $AWK '
  /__oline__/ { printf "%d:", NR + 1 }
  	     { print }
  ' $tmpout | sed '
  /__oline__/s/^\([0-9][0-9]*\):\(.*\)__oline__/\2\1/
  s/@BKL@/[/g
  s/@BKR@/]/g
  s/@DLR@/$/g
  s/@PND@/#/g
  ' >&4
  ;; # End of the task script.

  #
  # Trace macros.
  #
  trace)
  $run_m4 $traces -dafl $infile -o $tmpout>/dev/null || exit 2
  # The output looks like this:
  #  | m4trace:configure.in:2: -1- AC_CHECK_FUNCS(foo bar
  #  | baz, fubar)
  # and should be like this:
  #  configure.in:2:AC_CHECK_FUNCS:foo bar baz, fubar
  cat $tmpout |
    # No need to be too verbose
    uniq |
    sed -e 's/m4trace:/@&/' |
    # Join arguments spread on several lines
    tr "$ac_LF_and_DOT" ' .' |
    tr @. "$ac_LF_and_DOT" |
    # Remove m4trace and -1-
    sed -n -e 's/^[^:]*:\([^:]*:[^:]*:\)[^a-zA-Z_]*\([a-zA-Z_]*.*\) $/\1\2/p' |
    # Replace the first `(' by a colon, remove the last `)'.
    sed -e 's/(/:/; s/)$//' >&4
  # The last eof was eaten.
  echo >&4
  ;;

  *)echo "$0: internal error: unknown task: $task" >&2
    exit 1
esac

exit $status
