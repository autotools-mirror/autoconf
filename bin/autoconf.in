#! @SHELL@
# autoconf -- create `configure' using m4 macros
# Copyright (C) 1992, 93, 94, 96, 99, 2000 Free Software Foundation, Inc.

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
Usage: $0 [OPTION] ... [TEMPLATE-FILE]

Generate a configuration script from a TEMPLATE-FILE if given, or
\`configure.in' by default.  Output is sent to the standard output if
TEMPLATE-FILE is given, else into \`configure'.

Operation modes:
  -h, --help               print this help, then exit
  -V, --version            print version number, then exit
  -v, --verbose            verbosely report processing
  -d, --debug              don't remove temporary files
  -m, --macrodir=DIR       directory storing Autoconf's macro files
  -l, --localdir=DIR       directory storing the \`aclocal.m4' file
  -o, --output=FILE        save output in FILE (stdout is the default)
  -W, --warnings=CATEGORY  report the warnings falling in CATEGORY [syntax]

Warning categories include:
  \`cross'        cross compilation issues
  \`obsolete'     obsolete constructs
  \`syntax'       dubious syntactic constructs
  \`all'          all the warnings
  \`noCATEGORY'   turn off the warnings on CATEGORY
  \`none'         turn off all the warnings
  \`error'        warnings are error

The environment variable \`WARNINGS' is honored.

Tracing:
  -t, --trace=MACRO     report the list of calls to MACRO
  -i, --initialization  also trace Autoconf's initialization process

In tracing mode, no configuration script is created.

Report bugs to <bug-autoconf@gnu.org>."

version="\
autoconf (GNU @PACKAGE@) @VERSION@
Written by David J. MacKenzie.

Copyright (C) 1992, 93, 94, 96, 99, 2000 Free Software Foundation, Inc.
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
case `$M4 --help </dev/null 2>&1` in
*reload-state*);;
*) echo "$me: Autoconf requires GNU m4 1.4 or later" >&2; exit 1 ;;
esac

# Variables.
: ${AC_MACRODIR=@datadir@}
: ${AC_ACLOCALDIR=`(aclocal --print-ac-dir) 2>/dev/null`}
: ${AWK=@AWK@}
debug=false
# Trace Autoconf's initialization?
initialization=false
localdir=.
outfile=
# Exit status.
status=0
# Tasks:
# - install
#   Install links to the needed *.m4 extensions.
# - trace
#   Trace the first arguments of some macros
# - script
#   Produce the configure script (default)
task=script
tmp=
verbose=:

# Parse command line.
while test $# -gt 0 ; do
  optarg=`expr "$1" : '--[^=]*=\(.*\)' \| \
               "$1" : '-.\(.*\)'`
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

    --macrodir=* | --m*=* )
       AC_MACRODIR=$optarg
       shift ;;
    --macrodir | --m* | -m )
       test $# = 1 && eval "$exit_missing_arg"
       shift
       AC_MACRODIR=$1
       shift ;;

    --install )
       task=install
       shift;;

    --trace | -t )
       test $# = 1 && eval "$exit_missing_arg"
       task=trace
       shift
       traces="$traces '"`echo "$1" | sed "s/'/'\\\\\\\\''/g"`"'"
       shift ;;
    --trace=* )
       task=trace
       traces="$traces '"`echo "$optarg" | sed "s/'/'\\\\\\\\''/g"`"'"
       shift ;;
    --initialization | -i )
       initialization=:
       shift;;

    --output | -o )
       test $# = 1 && eval "$exit_missing_arg"
       shift
       outfile=$1
       shift ;;
    --output=* )
       outfile=$optarg
       shift ;;
    -o* )
       outfile=$optarg
       shift ;;

    --warnings | -W )
       test $# = 1 && eval "$exit_missing_arg"
       shift
       warnings=$warnings,$1
       shift ;;
    --warnings=* )
       warnings=$warnings,$optarg
       shift ;;
    -W* ) # People are used to -Wall, -Werror etc.
       warnings=$warnings,$optarg
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

# The warnings are the concatenation of 1. application's defaults,
# 2. $WARNINGS, $3 command line options, in that order.
# Set them in the order expected by the M4 macros: the converse.
_ac_warnings=
for warning in `IFS=,; echo syntax,$WARNINGS,$warnings | tr [A-Z] [a-z]`
do
  test -n $warning || continue
  _ac_warnings="$warning"`test -n "$_ac_warnings" && echo ",$_ac_warnings"`
done


# Trap on 0 to stop playing with `rm'.
$debug ||
{
  trap 'status=$?; rm -rf $tmp && exit $status' 0
  trap 'exit $?' 1 2 13 15
}

# Create a (secure) tmp directory for tmp files.
: ${TMPDIR=/tmp}
{
  tmp=`(umask 077 && mktemp -d -q "$TMPDIR/acXXXXXX") 2>/dev/null` &&
  test -n "$tmp" && test -d "$tmp"
}  ||
{
  tmp=$TMPDIR/ac$$ && (umask 077 && mkdir $tmp)
} ||
{
   echo "$me: cannot create a temporary directory in $TMPDIR" >&2
   exit 1;
}

# Running m4.
test -f "$AC_MACRODIR/acsite.m4" && acsite_m4="$AC_MACRODIR/acsite.m4"
test -f "$localdir/aclocal.m4"   && aclocal_m4="$localdir/aclocal.m4"
m4_common="$acsite_m4 $aclocal_m4 -I $AC_MACRODIR -I $localdir"
run_m4="$M4           $AC_MACRODIR/autoconf.m4  $m4_common"
run_m4f="$M4 --reload $AC_MACRODIR/autoconf.m4f $m4_common"

# Find the input file.
case $# in
  0) infile=configure.in
     test $task = script && test -z "$outfile" && outfile=configure;;
  1) infile=$1 ;;
  *) exec >&2
     echo "$me: invalid number of arguments."
     echo "$help"
     exit 1 ;;
esac

# Unless specified, the output is stdout.
test -z "$outfile" && outfile=-

# We need an actual file.
if test z$infile = z-; then
  infile=$tmp/stdin
  cat >$infile
elif test ! -r "$infile"; then
  echo "$me: $infile: No such file or directory" >&2
  exit 1
fi

# Output is produced into FD 4.  Prepare it.
case "x$outfile" in
 x-)  # Output to stdout
  exec 4>&1 ;;
 * )
  exec 4>$outfile;;
esac

# Initializations are performed.  Proceed to the main task.
case $task in

  ## --------------------------------- ##
  ## Generate the `configure' script.  ##
  ## --------------------------------- ##
  script)
  # M4 expansion.
  $run_m4f -D_AC_WARNINGS=$_ac_warnings $infile >$tmp/configure || exit 2

  # You could add your own prefixes to pattern if you wanted to check for
  # them too, e.g. pattern='\(AC_\|ILT_\)', except that UNIX sed doesn't do
  # alternation.
  pattern="A[CHM]_"

  if grep "^[^#]*$pattern" $tmp/configure >/dev/null 2>&1; then
    echo "$me: undefined macros:" >&2
    sed -n "s/^[^#]*\\($pattern[_A-Za-z0-9]*\\).*/\\1/p" $tmp/configure |
      while read macro; do
  	grep -n "^[^#]*$macro" $infile /dev/null
  	test $? = 1 && echo "***BUG in Autoconf--please report*** $macro"
      done | sort -u >&2
    status=1
  fi

  if test "x$outfile" != x-; then
    chmod +x $outfile
  fi

  # Put the real line numbers into configure to make config.log more
  # helpful.  Because quoting can sometimes get really painful in m4,
  # there are special @tokens@ to substitute.
  $AWK '
    {
      sub(/[         ]*$/, "")
      if ($0 == "")
        {
          if (!duplicate)
            print
          duplicate = 1
          next
        }
      duplicate = 0
      oline++
      if ($0 ~ /__oline__/)
        while (sub(/__oline__/, oline))
          continue
      while (sub(/@<:@/, "["))
        continue
      while (sub(/@:>@/, "]"))
        continue
      while (sub(/@S\|@/, "$"))
        continue
      while (sub(/@%:@/, "#"))
        continue
      print
    }' <$tmp/configure >&4
  ;; # End of the task script.



  ## -------------- ##
  ## Trace macros.  ##
  ## -------------- ##
  trace)
  # trace.m4
  # --------
  # Routines to process formatted m4 traces.
  cat >$tmp/trace.m4 <<\EOF
divert(-1)
  changequote([, ])
  # _MODE(SEPARATOR, ELT1, ELT2...)
  # -------------------------------
  # List the elements, separating then with SEPARATOR.
  # MODE can be:
  #  `at'       -- the elements are enclosed in brackets.
  #  `star'     -- the elements are listed as are.
  #  `percent'  -- the elements are `smashed': spaces are singled out,
  #                and no new line remains.
  define([_at],
         [ifelse([$#], [1], [],
                 [$#], [2], [[[$2]]],
                 [[[$2]][$1]$0([$1], shift(shift($@)))])])
  define([_percent],
         [ifelse([$#], [1], [],
                 [$#], [2], [smash([$2])],
                 [smash([$2])[$1]$0([$1], shift(shift($@)))])])
  define([_star],
         [ifelse([$#], [1], [],
                 [$#], [2], [[$2]],
                 [[$2][$1]$0([$1], shift(shift($@)))])])

  # Smash quotes its result.
  define([smash],
         [patsubst(patsubst(patsubst([[[$1]]],
                                     [\\
]),
                            [[
     ]+],
                            [ ]),
    		   [^ *\(.*\) *$], [[\1]])])
  define([args],    [shift(shift(shift(shift(shift($@)))))])
  define([at],      [_$0([$1], args($@))])
  define([percent], [_$0([$1], args($@))])
  define([star],    [_$0([$1], args($@))])
EOF

  # trace2m4.sed
  # ------------
  # Transform the traces from m4 into an m4 input file.
  # Typically, transform:
  # | m4trace:configure.in:3: -1- AC_SUBST([exec_prefix], [NONE])
  # into
  # | AT_AC_SUBST([configure.in], [3], [1], [AC_SUBST], [exec_prefix], [NONE])
  # Pay attention that the file name might include colons, if under DOS
  # for instance, so we don't use `[^:][^:]*'.
  # The first s/// catches multiline traces, the second, traces as above.
  preamble='m4trace:\(..*\):\([0-9][0-9]*\): -\([0-9][0-9]*\)-'
  cat >$tmp/trace2m4.sed <<EOF
  s/^$preamble \([^(][^(]*\)(\(.*\)$/AT_\4([\1], [\2], [\3], [\4], \5/
  s/^$preamble \(.*\)$/AT_\4([\1], [\2], [\3], [\4])/
EOF

  # translate.awk
  # -------------
  # Translate user tracing requests into m4 macros.
  cat >$tmp/translate.awk <<\EOF
  function trans (arg, sep)
  {
    # File name.
    if (arg == "f")
      return "$1"
    # Line number.
    if (arg == "l")
      return "$2"
    # Depth.
    if (arg == "d")
      return "$3"
    # Name (also available as $0).
    if (arg == "n")
      return "$4"
    # Escaped dollar.
    if (arg == "$")
      return "$"

    # $@, list of quoted effective arguments.
    if (arg == "@")
      return "]at([" (separator ? separator : ",") "], $@)["
    # $*, list of unquoted effective arguments.
    if (arg == "*")
      return "]star([" (separator ? separator : ",") "], $@)["
    # $%, list of smashed unquoted effective arguments.
    if (arg == "%")
      return "]percent([" (separator ? separator : ":") "], $@)["
  }

  function error (message)
  {
    print message | "cat >&2"
    exit 1
  }

  {
    # Accumulate the whole input.
    request = request $0 "\n"
  }

  END {
    # Chomp.
    request = substr (request, 1, length (request) - 1)
    # The default request is `$f:$l:$n:$*'.
    colon   = index (request, ":")
    macro   = colon ? substr (request, 1, colon - 1) : request
    request = colon ? substr (request, colon + 1)    : "$f:$l:$n:$%"

    res = ""

    for (cp = request; cp; cp = substr (cp, 2))
      {
  	char = substr (cp, 1, 1)
  	if (char == "$")
  	  {
  	    if (match (cp, /^\$[0-9]+/))
  	      {
  		# $n -> $(n + 4)
  		res = res "$" (substr (cp, 2, RLENGTH - 1) + 4)
  		cp = substr (cp, RLENGTH)
  	      }
  	    else if (substr (cp, 2, 1) ~ /[fldn$@%*]/)
  	      {
  		# $x, no separator given.
  		res = res trans(substr (cp, 2, 1))
  		cp = substr (cp, 2)
  	      }
  	    else if (substr (cp, 2, 1) == "{")
  	      {
  		# ${sep}x, long separator.
  		end = index (cp, "}")
  		if (!end)
  		  error("invalid escape: " cp)
  		separator = substr (cp, 3, end - 3)
  		if (substr (cp, end + 1, 1) ~ /[*@%]/)
  		  res = res trans(substr (cp, end + 1, 1), separator)
  		else
  		  error("invalid escape: " cp)
  		cp = substr (cp, end + 1)
  	      }
  	    else if (substr (cp, 3, 1) ~ /[*@%]/)
  	      {
  		# $sx, short separator `s'.
  		res = res trans(substr (cp, 3, 1), substr (cp, 2, 1))
  		cp = substr(cp, 3)
  	      }
  	    else
  	      {
  		error("invalid escape: " substr (cp, 1, 2))
  	      }
  	  }
  	else
  	  res = res char
      }

    # Produce the definition of AT_<MACRO> = the translation of the request.
    print "define([AT_" macro "], [[" res "]])"
    close("cat >&2")
  }
EOF
  # Extract both the m4 program and the m4 options from TRACES.
  eval set dummy "$traces"
  shift
  for trace
  do
    # The request may be several lines long, hence sed has to quit.
    trace_opt="$trace_opt -t "`echo "$trace" | sed -e 's/:.*//;q'`
    echo "$trace" | $AWK -f $tmp/translate.awk >>$tmp/trace.m4 || exit 1
  done
  echo "divert(0)dnl" >>$tmp/trace.m4

  # Do we trace the initialization?
  # `errprint' must be silent, otherwise there can be warnings mixed
  # with traces in m4's stderr.
  if $initialization; then
    run_m4_trace="$run_m4 $trace_opt -daflq -Derrprint"
  else
    run_m4_trace="$run_m4f $trace_opt -daflq -Derrprint"
  fi

  # Run m4 on the input file to get traces.
  $verbose "Running $run_m4_trace $infile | $M4 $tmp/trace.m4" >&2
  $run_m4_trace $infile 2>&1 >/dev/null |
    sed -f $tmp/trace2m4.sed |
    # Now we are ready to run m4 to process the trace file.
    $M4 $tmp/trace.m4 - |
    # It makes no sense to try to transform __oline__.
    sed '
      s/@<:@/[/g
      s/@:>@/]/g
      s/@S|@/$/g
      s/@%:@/#/g
      ' >&4
  ;;




  ## -------------------------------------------------------- ##
  ## Task --install.  Install links to the library m4 files.  ##
  ## -------------------------------------------------------- ##
  install)
  # An m4 program that reports what macros are requested, and where
  # they were defined.
  cat >$tmp/request.m4 <<\EOF
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
EOF

  # Run m4 with all the library files, discard stdout, save stderr in
  # $requested.
  run_m4_request="$run_m4f -dipa -t m4_include -t m4_sinclude $tmp/request.m4"
  $verbose $run_m4_request $localdir/*.m4 $AC_ACLOCALDIR/*.m4 $infile >&2
  $run_m4_request $localdir/*.m4 $AC_ACLOCALDIR/*.m4 $infile 2>&1 >/dev/null |
    # Keep only the good lines, there may be other outputs
    grep '^[^: ]*:[0-9][0-9]*:[^:]*$' >$tmp/requested

  # Extract the files that are not in the local dir, and install the links.
  # Save in `installed' the list of installed links.
  $verbose "Required macros:" >&2
  $verbose "`sed -e 's/^/| /' $tmp/requested`" >&2
  : >$tmp/installed
  cat $tmp/requested |
    while read line
    do
      file=`echo "$line" | sed -e 's/:.*//'`
      filename=`echo "$file" | sed -e 's,.*/,,'`
      macro=`echo "$line" | sed -e 's/.*:[ 	]*//'`
      if test -f "$file" && test "x$file" != "x$infile"; then
        if test -f $localdir/$filename; then
          $verbose "$filename already installed" >&2
  	else
  	  $verbose "installing $file which provides $macro" >&2
  	  ln -s "$file" "$localdir/$filename" ||
  	  cp "$file" "$localdir/$filename" ||
  	  {
  	    echo "$me: cannot link from $file to $localdir/$filename" >&2
  	    exit 1
  	  }
  	fi
        echo "$localdir/$filename" >>$tmp/installed
      fi
    done
  # Now that we have installed the links, and that we know that the
  # user needs the FILES, check that there is an exact correspondence.
  # Use yourself to get the list of the included files.
  export AC_ACLOCALDIR
  export AC_MACRODIR
  $0 -l "$localdir" -t include:'$1' -t m4_include:'$1' -t m4_sinclude:'$1' $infile |
    sort |
    uniq >$tmp/included
  # All the included files are needed.
  for file in `cat $tmp/included`;
  do
    if fgrep "$file" $tmp/installed >/dev/null 2>&1; then :; else
      echo "\`$file' is uselessly included" >&2
    fi
  done
  # All the needed files are included.
  for file in `sort $tmp/installed | uniq`;
  do
    if fgrep "$file" $tmp/included >/dev/null 2>&1; then :; else
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
