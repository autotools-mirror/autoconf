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

me=`echo "$0" | sed -e 's,.*/,,'`

usage="\
Usage: autoconf [OPTION] ... [TEMPLATE-FILE]

Generate a configuration script from a TEMPLATE-FILE if given, or
\`configure.in' by default.  Output is sent to the standard output if
TEMPLATE-FILE is given, else into \`configure'.

If the option \`--trace' is used, no configuration script is created.

  -h, --help          print this help, then exit
  -V, --version       print version number, then exit
  -m, --macrodir=DIR  directory storing Autoconf's macro files
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

# Find GNU m4.
# Handle the case that m4 has moved since we were configured.
# It may have been found originally in a build directory.
: ${M4=@M4@}
case "$M4" in
/*) test -f "$M4" || M4=m4 ;;
esac
# Some non-GNU m4's don't reject the --help option, so give them /dev/null.
case `$M4 --help < /dev/null 2>&1` in
*reload-state*);;
*) echo "$me: Autoconf requires GNU m4 1.4 or later" >&2; exit 1 ;;
esac

# Variables.
: ${AC_MACRODIR=@datadir@}
: ${AC_ACLOCALDIR=`(aclocal --print-ac-dir) 2>/dev/null`}
: ${AWK=@AWK@}
localdir=
outfile=
# Tasks:
# - trace
#   Trace the first arguments of some macros
# - script
#   Produce the configure script (default)
task=script
: ${TMPDIR=/tmp}
tmpin=$TMPDIR/acin.$$
tmpout=$TMPDIR/acout.$$
verbose=:

# Parse command line
while test $# -gt 0 ; do
  case "$1" in
    --version | --vers* | -V )
       echo "$version" ; exit 0 ;;
    --help | --h* | -h )
       echo "$usage"; exit 0 ;;

    --localdir=* | --l*=* )
       localdir=`echo "$1" | sed -e 's/^[^=]*=//'`
       shift ;;
    --localdir | --l* | -l )
       shift
       test $# -eq 0 && { echo "$help" >&2; exit 1; }
       localdir="$1"
       shift ;;

    --macrodir=* | --m*=* )
       AC_MACRODIR=`echo "$1" | sed -e 's/^[^=]*=//'`
       shift ;;
    --macrodir | --m* | -m )
       shift
       test $# -eq 0 && { echo "$help" >&2; exit 1; }
       AC_MACRODIR="$1"
       shift ;;

    --install )
       task=install
       shift;;

    --verbose | --verb* )
       verbose=echo
       shift;;

    --trace | -t )
       task=trace
       shift
       traces="$traces -t $1"
       shift ;;
    --trace=* )
       task=trace
       traces="$traces -t `echo \"$1\" | sed -e 's/^[^=]*=//'`"
       shift ;;

    --output | -o )
       shift
       outfile="$1"
       shift ;;
    --output=* )
       outfile=`echo "$1" | sed -e 's/^[^=]*=//'`
       shift ;;

    -- )     # Stop option processing
       shift; break ;;
    - )	# Use stdin as input.
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

# Running m4.
if test -n "$localdir"; then
  use_localdir="-I$localdir -DAC_LOCALDIR=$localdir"
fi
run_m4="$M4 --reload $AC_MACRODIR/autoconf.m4f $use_localdir"


case $# in
  0) infile=configure.in
     test $task = script && test "x$outfile" = x && outfile=configure;;
  1) infile="$1" ;;
  *) exec >&2
     echo "$me: invalid number of arguments."
     echo "$help"
     exit 1 ;;
esac

trap 'rm -f $tmpin $tmpout' 0 1 2 15
if test z$infile = z-; then
  infile=$tmpin
  cat >$infile
elif test ! -r "$infile"; then
  echo "$me: $infile: No such file or directory" >&2
  exit 1
fi

# Output is produced into FD 4.  Prepare it.
case "x$outfile" in
 x- | x )  # Output to stdout
  exec 4>&1 ;;
 * )
  exec 4>$outfile;;
esac

# Initializations are performed.  Proceed to the main task.
case $task in

  ## --------------------- ##
  ## Generate the script.  ##
  ## --------------------- ##
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
  sed -e 's/[ 	]*$//' <$tmpout |
    sed -e '/^$/N;/\n$/D' |
    $AWK '
      /__oline__/ { printf "%d:", NR + 1 }
  	          { print }' |
    sed '
      /__oline__/s/^\([0-9][0-9]*\):\(.*\)__oline__/\2\1/
      s/@<:@/[/g
      s/@:>@/]/g
      s/@S|@/$/g
      s/@%:@/#/g
      ' >&4
  ;; # End of the task script.

  ## -------------- ##
  ## Trace macros.  ##
  ## -------------- ##
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




  ## -------------------------------------------------------- ##
  ## Task --install.  Install links to the library m4 files.  ##
  ## -------------------------------------------------------- ##
  install)
  # An m4 program that reports what macros are requested, and where
  # they were defined.
  cat >$tmpin <<\EOF
dnl Keep the definition of the old AC_DEFUN
define([AC_DEFUN_OLD], defn([AC_DEFUN]))

dnl Define the macro so that the first time it is expanded, it reports
dnl on stderr its name, and where it was defined.
define([AC_DEFUN],
[AC_DEFUN_OLD([$1],
   [ifdef([AC_DECLARED{$1}],,
	  [define([AC_DECLARED{$1}])errprint(]]__file__:__line__:[[ [$1]
)])dnl
][$2])])

dnl All the includes must be disabled.  If they are not, since people don't
dnl protect the first argument of AC_DEFUN, then, if read a second time
dnl this argument will be expanded, and we'll get pure junk out of m4.
define([AC_INCLUDE])
EOF
  # Run m4 with all the library files, save its report on strderr.
  $verbose Running $run_m4 -dipa -t m4_include -t m4_sinclude $tmpin $localdir/*.m4 $AC_ACLOCALDIR/*.m4 $infile
  $run_m4 -dipa -t m4_include -t m4_sinclude $tmpin $localdir/*.m4 $AC_ACLOCALDIR/*.m4 $infile >the-script 2>$tmpout
  # Keep only the good lines, there may be other outputs
  grep '^[^: ]*:[0-9][0-9]*:[^:]*$' $tmpout >$tmpin
  # Extract the files that are not in the local dir, and install the links.
  # Save in $tmpout the list of installed links.
  >$tmpout
  $verbose "Required macros:"
  $verbose "`sed -e 's/^/| /' $tmpin`"
  cat $tmpin |
    while read line
    do
      file=`echo "$line" | sed -e 's/:.*//'`
      filename=`echo "$file" | sed -e 's,.*/,,'`
      macro=`echo "$line" | sed -e 's/.*:[ 	]*//'`
      if test -f "$file" && test "x$file" != "x$infile"; then
        if test -f $localdir/$filename; then
          $verbose "$filename already installed"
  	else
  	  $verbose "installing $file which provides $macro"
  	  ln -s "$file" "$localdir/$filename" ||
  	  cp "$file" "$localdir/$filename" ||
  	  {
  	    echo "$me: cannot link from $file to $localdir/$filename" >&2
  	    exit 1
  	  }
  	fi
        echo "$localdir/$filename" >>$tmpout
      fi
    done
  # Now that we have installed the links, and that we know that the
  # user needs the FILES, check that there is an exact correspondence.
  # Use yourself to get the list of the included files.
  export AC_ACLOCALDIR
  export AC_MACRODIR
  # Not m4_s?include, because it would catch acsite and aclocal, which
  # we don't care of.
  $0 -l "$localdir" -t AC_INCLUDE $inline |
    sed -e 's/^[^:]*:[^:]*:[^:]*://g' |
    sort |
    uniq >$tmpin
  # All the included files are needed.
  for file in `cat $tmpin`;
  do
    if fgrep "$file" $tmpout >/dev/null 2>&1; then :; else
      echo "\`$file' is uselessly included" >&2
    fi
  done
  # All the needed files are included.
  for file in `sort $tmpout | uniq`;
  do
    if fgrep "$file" $tmpin >/dev/null 2>&1; then :; else
      echo "\`$file' is not included" >&2
    fi
  done
  ;;



  ## ------------ ##
  ## Unknown task ##
  ## ------------ ##

  *)echo "$me: internal error: unknown task: $task" >&2
    exit 1
esac

exit $status
