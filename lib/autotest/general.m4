# This file is part of Autoconf.                          -*- Autoconf -*-
# M4 macros used in building test suites.
# Copyright 2000, 2001 Free Software Foundation, Inc.

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

# As a special exception, the Free Software Foundation gives unlimited
# permission to copy, distribute and modify the configure scripts that
# are the output of Autoconf.  You need not follow the terms of the GNU
# General Public License when using or distributing such scripts, even
# though portions of the text of Autoconf appear in them.  The GNU
# General Public License (GPL) does govern all other use of the material
# that constitutes the Autoconf program.
#
# Certain portions of the Autoconf source text are designed to be copied
# (in certain cases, depending on the input) into the output of
# Autoconf.  We call these the "data" portions.  The rest of the Autoconf
# source text consists of comments plus executable code that decides which
# of the data portions to output in any given case.  We call these
# comments and executable code the "non-data" portions.  Autoconf never
# copies any of the non-data portions into its output.
#
# This special exception to the GPL applies to versions of Autoconf
# released by the Free Software Foundation.  When you make and
# distribute a modified version of Autoconf, you may extend this special
# exception to the GPL to apply to your modified version as well, *unless*
# your modified version has the potential to copy into its output some
# of the text that was the non-data portion of the version that you started
# with.  (In other words, unless your change moves or copies text from
# the non-data portions to the data portions.)  If your modification has
# such potential, you must delete any notice of this special exception
# to the GPL from your modified version.

# Use of diversions:
#
#  - DEFAULT
#    Overall initialization, value of $at_tests_all.
#  - OPTIONS
#    Option processing
#    Be ready to run the tests.
#  - TESTS
#    The core of the test suite, the ``normal'' diversion.
#  - TAIL
#    tail of the core for;case, overall wrap up, generation of debugging
#    scripts and statistics.

m4_define([_m4_divert(DEFAULT)],       5)
m4_define([_m4_divert(OPTIONS)],      10)
m4_define([_m4_divert(TESTS)],        50)
m4_define([_m4_divert(TAIL)],         60)


# AT_LINE
# -------
# Return the current file sans directory, a colon, and the current
# line.  Be sure to return a _quoted_ filename, so if, for instance,
# the user is lunatic enough to have a file named `dnl' (and I, for
# one, love to be brainless and stubborn sometimes), then we return a
# quoted name.
#
# Gee, we can't use simply
#
#  m4_patsubst(__file__, [^.*/\(.*\)], [[\1]])
#
# since then, since `dnl' doesn't match the pattern, it is returned
# with once quotation level less, so you lose, dammit!  And since GNU M4
# is one of the biggest junk in the whole universe wrt regexp, don't
# even think about using `?' or `\?'.  Bah, `*' will do.
# Pleeeeeeeease, Gary, provide us with dirname and ERE!
m4_define([AT_LINE],
[m4_patsubst(__file__, [^\(.*/\)*\(.*\)], [[\2]]):__line__])


# AT_INIT([TESTSUITE-NAME])
# -------------------------
# Begin test suite.
m4_define([AT_INIT],
[AS_INIT
m4_pattern_forbid([^_?AT_])
m4_define([AT_TESTSUITE_NAME],
          m4_defn([PACKAGE_STRING])[ test suite]m4_ifval([$1], [: $1])[.])
m4_define([AT_ordinal], 0)
m4_define([AT_banner_ordinal], 0)
m4_define([AT_data_files], [stdout expout at-* stderr experr])
m4_define([AT_victims], [])
m4_divert_text([BINSH], [@%:@! /bin/sh])
m4_divert_push([DEFAULT])dnl

AS_SHELL_SANITIZE
SHELL=${CONFIG_SHELL-/bin/sh}

# How were we run?
at_cli_args=${1+"$[@]"}

# Load the config file.
for at_file in atconfig atlocal
do
  test -r $at_file || continue
  . ./$at_file || AS_ERROR([invalid content: $at_file])
done

# Use absolute file notations, as the test might change directories.
at_srcdir=`cd "$srcdir" && pwd`
at_top_srcdir=`cd "$top_srcdir" && pwd`

# Not all shells have the 'times' builtin; the subshell is needed to make
# sure we discard the 'times: not found' message from the shell.
at_times=:
(times) >/dev/null 2>&1 && at_times=times

# CLI Arguments to pass to the debugging scripts.
at_debug_args=
# -e sets to true
at_stop_on_error=false
# Shall we be verbose?
at_verbose=:
at_quiet=echo
# Shall we keep the debug scripts?  Must be `:' when test suite is
# run by a debug script, so that the script doesn't remove itself.
at_debug=false
# Display help message?
at_help=no
# Tests to run
at_tests=
dnl Other vars inserted here (DEFAULT).
m4_divert([OPTIONS])

while test $[@%:@] -gt 0; do
  case $[1] in
    --help | -h) at_help=short
        ;;

    --full-help | -H ) at_help=long
        ;;

    --version)
        echo "$as_me (PACKAGE_STRING)"
        exit 0
        ;;

    --clean | -c )
        rm -rf $at_data_files \
               $as_me.[[0-9]] $as_me.[[0-9][0-9]] $as_me.[[0-9][0-9][0-9]] \
               $as_me.log devnull
        exit 0
        ;;

    -d) at_debug=:
        ;;

    -e) at_debug=:
        at_stop_on_error=:
        ;;

    -v) at_verbose=echo; at_quiet=:
        ;;

    -x) at_traceon='set -vx'; at_traceoff='set +vx'
        ;;

    [[0-9] | [0-9][0-9] | [0-9][0-9][0-9] | [0-9][0-9][0-9][0-9]])
        at_tests="$at_tests$[1] "
        ;;

    # Ranges
    [[0-9]- | [0-9][0-9]- | [0-9][0-9][0-9]- | [0-9][0-9][0-9][0-9]-])
        at_range_start=`echo $[1] |tr -d '-'`
        at_range=`echo " $at_tests_all " | \
          sed -e 's,^.* '$at_range_start' ,'$at_range_start' ,'`
        at_tests="$at_tests$at_range "
        ;;

    [-[0-9] | -[0-9][0-9] | -[0-9][0-9][0-9] | -[0-9][0-9][0-9][0-9]])
        at_range_end=`echo $[1] |tr -d '-'`
        at_range=`echo " $at_tests_all " | \
          sed -e 's, '$at_range_end' .*$, '$at_range_end','`
        at_tests="$at_tests$at_range "
        ;;

    [[0-9]-[0-9] | [0-9]-[0-9][0-9] | [0-9]-[0-9][0-9][0-9]] | \
    [[0-9]-[0-9][0-9][0-9][0-9] | [0-9][0-9]-[0-9][0-9]] | \
    [[0-9][0-9]-[0-9][0-9][0-9] | [0-9][0-9]-[0-9][0-9][0-9][0-9]] | \
    [[0-9][0-9][0-9]-[0-9][0-9][0-9]] | \
    [[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]] | \
    [[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]] )
        at_range_start=`echo $[1] |sed 's,-.*,,'`
        at_range_end=`echo $[1] |sed 's,.*-,,'`
        # Maybe test to make sure start <= end?
        at_range=`echo " $at_tests_all " | \
          sed -e 's,^.* '$at_range_start' ,'$at_range_start' ,' \
              -e 's, '$at_range_end' .*$, '$at_range_end','`
        at_tests="$at_tests$at_range "
        ;;

    # Keywords.
    --keywords | -k )
        shift
        at_tests_selected=$at_help_all
        for at_keyword in `IFS=,; set X $[1]; shift; echo ${1+$[@]}`
        do
          # It is on purpose that we match the test group titles too.
          at_tests_selected=`echo "$at_tests_selected" |
                             egrep -i "^[[^;]]*;[[^;]]*;.*$at_keyword"`
        done
        at_tests_selected=`echo "$at_tests_selected" | sed 's/;.*//'`
        at_tests="$at_tests$at_tests_selected "
        ;;

    *=*)
  	at_envvar=`expr "x$[1]" : 'x\([[^=]]*\)='`
  	# Reject names that are not valid shell variable names.
  	expr "x$at_envvar" : "[.*[^_$as_cr_alnum]]" >/dev/null &&
  	  AS_ERROR([invalid variable name: $at_envvar])
  	at_value=`expr "x$[1]" : 'x[[^=]]*=\(.*\)'`
  	at_value=`echo "$at_value" | sed "s/'/'\\\\\\\\''/g"`
  	eval "$at_envvar='$at_value'"
  	export $at_envvar
	# Propagate to debug scripts.
  	at_debug_args="$at_debug_args $[1]"
  	;;

     *) echo "$as_me: invalid option: $[1]" >&2
        echo "Try \`$[0] --help' for more information." >&2
        exit 1
        ;;
  esac
  shift
done

# Help message.
if test "$at_help" != no; then
  # If tests were specified, display only their title.
  if test -z "$at_tests"; then
    cat <<_ATEOF
Usage: $[0] [[OPTION]]... [[TESTS]] [[VAR=VALUE]]

Run all the tests, or the selected TESTS.

Options:
  -h  Display this help message and the description of TESTS
  -c  Remove all the files this test suite might create and exit
  -e  Abort the test suite as soon as a test fails; implies -d
  -v  Force more detailed output, default for debugging scripts
  -d  Inhibit clean up and debug script creation, default for debugging scripts
  -x  Have the shell trace command execution

Tests:
_ATEOF
  else
    # "  1 42  45 " => " (1|42|45): "
    at_tests_pattern=`echo "$at_tests" | sed 's/^  *//;s/  *$//;s/  */|/g'`
    at_tests_pattern=" (${at_tests_pattern}): "
  fi
  case $at_help in
  short)
    echo "$at_help_all" |
      egrep -e "$at_tests_pattern" |
      awk 'BEGIN { FS = ";" }
           { if ($[1]) printf " %3d: %s\n", $[1], $[3] } ';;
  long)
    echo "$at_help_all" |
      egrep -e "$at_tests_pattern" |
      awk 'BEGIN { FS = ";" }
           { if ($[1]) printf " %3d: %-18s %s\n", $[1], $[2], $[3]
             if ($[4]) printf "      %s\n", $[4] } ';;
  esac
  echo
  echo "Report bugs to <PACKAGE_BUGREPORT>."
  exit 0
fi

# Tests to run.
test -z "$at_tests" && at_tests=$at_tests_all

# Don't take risks: use only absolute directories in PATH.
#
# For stand-alone test suites, AUTOTEST_PATH is relative to `.'.
#
# For embedded test suites, AUTOTEST_PATH is relative to the top level
# of the package.  Then expand it into build/src parts, since users
# may create executables in both places.
#
# There might be directories that don't exist, but don't redirect
# builtins' (eg., cd) stderr directly: Ultrix's sh hates that.
at_path=
_AS_PATH_WALK([$AUTOTEST_PATH $PATH],
[case $as_dir in
  [[\\/]]* | ?:[[\\/]]* )
    at_path=$at_path$PATH_SEPARATOR$as_dir
    ;;
  * )
    if test -z "$top_builddir"; then
      # Stand-alone test suite.
      at_path=$at_path$PATH_SEPARATOR$as_dir
    else
      # Embedded test suite.
      at_path=$at_path$PATH_SEPARATOR$top_builddir/$as_dir
      at_path=$at_path$PATH_SEPARATOR$top_srcdir/$as_dir
    fi
    ;;
esac])

# Now build and simplify PATH.
at_sep=
PATH=
_AS_PATH_WALK([$at_path],
[as_dir=`(cd "$as_dir" && pwd) 2>/dev/null`
test -d "$as_dir" || continue
case $PATH in
                  $as_dir                 | \
                  $as_dir$PATH_SEPARATOR* | \
  *$PATH_SEPARATOR$as_dir                 | \
  *$PATH_SEPARATOR$as_dir$PATH_SEPARATOR* ) ;;
  *) PATH=$PATH$at_sep$as_dir
     at_sep=$PATH_SEPARATOR;;
esac])
export PATH

# Can we diff with `/dev/null'?  DU 5.0 refuses.
if diff /dev/null /dev/null >/dev/null 2>&1; then
  at_devnull=/dev/null
else
  at_devnull=devnull
  cp /dev/null $at_devnull
fi

# Use `diff -u' when possible.
if diff -u $at_devnull $at_devnull >/dev/null 2>&1; then
  at_diff='diff -u'
else
  at_diff=diff
fi

# Setting up the FDs.
# 5 is stdout conditioned by verbosity.
if test $at_verbose = echo; then
  exec 5>&1
else
  exec 5>/dev/null
fi

# 6 is the log file.  To be preserved if `-d'.
m4_define([AS_MESSAGE_LOG_FD], [6])
if $at_debug; then
  exec AS_MESSAGE_LOG_FD>/dev/null
else
  exec AS_MESSAGE_LOG_FD>$as_me.log
fi

# Banners and logs.
AS_BOX(m4_defn([AT_TESTSUITE_NAME]))
{
  AS_BOX(m4_defn([AT_TESTSUITE_NAME]))
  echo

  echo "$as_me: command line was:"
  echo "  $ $[0] $at_cli_args"
  echo

  # Try to find a few ChangeLogs in case it might help determining the
  # exact version.  Use the relative dir: if the top dir is a symlink,
  # find will not follow it (and options to follow the links are not
  # portable), which would result in no output here.

  if test -n "$top_srcdir"; then
    AS_BOX([ChangeLogs.])
    echo
    for at_file in `find "$top_srcdir" -name ChangeLog -print`
    do
      echo "$as_me: $at_file:"
      sed 's/^/| /;10q' $at_file
      echo
    done

    AS_UNAME
    echo

    AS_BOX([Configuration logs.])
    echo
    for at_file in `find "$top_srcdir" -name config.log -print`
    do
      echo "$as_me: $at_file:"
      sed 's/^/| /;10q' $at_file
      echo
    done
  fi

  # Inform about the contents of the config files.
  for at_file in atconfig atlocal
  do
    test -r $at_file || continue
    echo "$as_me: $at_file:"
    sed 's/^/| /' $at_file
    echo
  done

  AS_BOX([Victims.])
  echo
} >&AS_MESSAGE_LOG_FD

# Report what programs are being tested.
for at_program in : $at_victims
do
  test "$at_program" = : && continue
  _AS_PATH_WALK([$PATH], [test -f $as_dir/$at_program && break])
  if test -f $as_dir/$at_program; then
    {
      echo "AT_LINE: $as_dir/$at_program --version"
      $as_dir/$at_program --version
      echo
    } >&AS_MESSAGE_LOG_FD 2>&1
  else
    AS_ERROR([cannot find $at_program])
  fi
done

{
  AS_BOX([Silently running the tests.])
} >&AS_MESSAGE_LOG_FD

at_start_date=`date`
at_start_time=`(date +%s) 2>/dev/null`
echo "$as_me: starting at: $at_start_date" >&AS_MESSAGE_LOG_FD
at_fail_list=
at_skip_list=
at_test_count=0
m4_divert([TESTS])dnl

for at_test in $at_tests
do
  at_status=0
  rm -rf $at_data_files
  # Clearly separate the tests when verbose.
  test $at_test_count != 0 && $at_verbose
  case $at_test in
dnl Tests inserted here (TESTS).
m4_divert([TAIL])[]dnl

  * )
    echo $as_me: no such test: $at_test
    continue
    ;;
  esac
  case $at_test in
    banner-*) ;;
    *)
      if test ! -f at-check-line; then
        sed "s/^ */$as_me: warning: /" <<_ATEOF
        A failure happened in a test group before any test could be
        run. This means that test suite is improperly designed.  Please
        report this failure to <PACKAGE_BUGREPORT>.
_ATEOF
    	echo "$at_setup_line" >at-check-line
      fi
      at_test_count=`expr 1 + $at_test_count`
      $at_verbose $ECHO_N "$at_test. $at_setup_line: $ECHO_C"
      case $at_status in
        0) at_msg="ok"
           ;;
        77) at_msg="ok (skipped near \``cat at-check-line`')"
            at_skip_list="$at_skip_list $at_test"
            ;;
        *) at_msg="FAILED near \``cat at-check-line`'"
           at_fail_list="$at_fail_list $at_test"
           ;;
      esac
      echo $at_msg
      at_log_msg="$at_test. $at_setup_line: $at_msg"
      # If the test failed, at-times is not available.
      test -f at-times && at_log_msg="$at_log_msg	(`sed 1d at-times`)"
      echo "$at_log_msg" >&AS_MESSAGE_LOG_FD
      $at_stop_on_error && test -n "$at_fail_list" && break
      ;;
  esac
done

at_stop_date=`date`
at_stop_time=`(date +%s) 2>/dev/null`
echo "$as_me: ending at: $at_stop_date" >&AS_MESSAGE_LOG_FD
at_duration_s=`(expr $at_stop_time - $at_start_time) 2>/dev/null`
at_duration_m=`(expr $at_duration_s / 60) 2>/dev/null`
at_duration_h=`(expr $at_duration_m / 60) 2>/dev/null`
at_duration_s=`(expr $at_duration_s % 60) 2>/dev/null`
at_duration_m=`(expr $at_duration_m % 60) 2>/dev/null`
at_duration="${at_duration_h}h ${at_duration_m}m ${at_duration_s}s"
if test "$at_duration" != "h m s"; then
  echo "$as_me: test suite duration: $at_duration" >&AS_MESSAGE_LOG_FD
fi

# Cleanup everything unless the user wants the files.
$at_debug || rm -rf $at_data_files

# Wrap up the test suite with summary statistics.
at_skip_count=`set dummy $at_skip_list; shift; echo $[@%:@]`
at_fail_count=`set dummy $at_fail_list; shift; echo $[@%:@]`
if test $at_fail_count = 0; then
  if test $at_skip_count = 0; then
    AS_BOX([All $at_test_count tests were successful.])
  else
    AS_BOX([All $at_test_count tests were successful ($at_skip_count skipped).])
  fi
elif test $at_debug = false; then
  if $at_stop_on_error; then
    AS_BOX([ERROR: One of the tests failed, inhibiting subsequent tests.])
  else
    AS_BOX([ERROR: Suite unsuccessful, $at_fail_count of $at_test_count tests failed.])
  fi

  # Remove any debugging script resulting from a previous run.
  rm -f $as_me.[[0-9]] $as_me.[[0-9][0-9]] $as_me.[[0-9][0-9][0-9]]

  echo
  echo $ECHO_N "Writing \`$as_me.NN' scripts, with NN =$ECHO_C"
  for at_group in $at_fail_list
  do
    # Normalize the names so that `ls' lists them in order.
    at_format=`echo $at_last_test | sed 's/././g'`
    at_number=`expr "000$at_group" : ".*\($at_format\)"`
    echo $ECHO_N " $at_number$ECHO_C"
    ( echo "#! /bin/sh"
      echo 'exec ${CONFIG_SHELL-'"$SHELL"'}' "$[0]" \
           '-v -d' "$at_debug_args" "$at_group" '${1+"$[@]"}'
      echo 'exit 1'
    ) >$as_me.$at_number
    chmod +x $as_me.$at_number
  done
  echo ', done'
  echo
  echo 'You may investigate any problem if you feel able to do so, in which'
  echo 'case the test suite provides a good starting point.'
  echo
  echo 'Now, failed tests will be executed again, verbosely, and logged'
  echo 'in the file '$as_me'.log.'

  {
    echo
    echo
    AS_BOX([Summary of the failures.])

    # Summary of failed and skipped tests.
    if test $at_fail_count != 0; then
      echo "Failed tests:"
      $SHELL $[0] $at_fail_list --help
      echo
    fi
    if test $at_skip_count != 0; then
      echo "Skipped tests:"
      $SHELL $[0] $at_skip_list --help
      echo
    fi
    echo

    AS_BOX([Verbosely re-running the failing tests])
    echo
  } >&AS_MESSAGE_LOG_FD

  $SHELL $[0] -v -d $at_fail_list 2>&1 | tee -a $as_me.log
  AS_BOX([$as_me.log is created.])

  echo
  echo "Please send \`$as_me.log' to <PACKAGE_BUGREPORT>,"
  echo "along with all information you think might help."
  exit 1
fi

exit 0
m4_divert_pop([TAIL])dnl
m4_wrap([m4_divert_text([DEFAULT],
                        [# List of the tested programs.
at_victims="AT_victims"
# List of the tests.
at_tests_all="AT_tests_all "
# Number of the last test.
at_last_test=AT_ordinal
# Description of all the tests.
at_help_all="AT_help"
# List of the output files.
at_data_files="AT_data_files "])])dnl
])# AT_INIT


# AT_VICTIMS(PROGRAMS)
# --------------------
# Specify the list of programs exercised by the test suite.  Their
# versions are logged, and in the case of embedded test suite, they
# must correspond to the version of the package..  The PATH should be
# already preset so the proper executable will be selected.
m4_define([AT_VICTIMS],
[m4_append_uniq([AT_victims], [$1], [ ])])


# AT_SETUP(DESCRIPTION)
# ---------------------
# Start a group of related tests, all to be executed in the same subshell.
# The group is testing what DESCRIPTION says.
m4_define([AT_SETUP],
[m4_ifdef([AT_keywords], [m4_undefine([AT_keywords])])
m4_define([AT_line], AT_LINE)
m4_define([AT_description], [$1])
m4_define([AT_ordinal], m4_incr(AT_ordinal))
m4_append([AT_tests_all], [ ]m4_defn([AT_ordinal]))
m4_divert_push([TESTS])dnl
  AT_ordinal ) @%:@ AT_ordinal. m4_defn([AT_line]): $1
    at_setup_line='m4_defn([AT_line])'
    $at_verbose "AT_ordinal. m4_defn([AT_line]): testing $1..."
    $at_quiet $ECHO_N "m4_format([[%3d: %-18s]],
                       AT_ordinal, m4_defn([AT_line]))[]$ECHO_C"
    (
      $at_traceon
])


# AT_KEYWORDS(KEYOWRDS)
# ---------------------
# Declare a list of keywords associated to the current test group.
m4_define([AT_KEYWORDS],
[m4_append_uniq([AT_keywords], [$1], [,])])


# _AT_CLEANUP_FILE(FILE)
# ----------------------
# Register FILE for AT_CLEANUP.
m4_define([_AT_CLEANUP_FILE],
[m4_append_uniq([AT_data_files], [$1], [ ])])


# AT_CLEANUP_FILES(FILES)
# -----------------------
# Declare a list of FILES to clean.
m4_define([AT_CLEANUP_FILES],
[m4_foreach([AT_File], m4_quote(m4_patsubst([$1], [  *], [,])),
            [_AT_CLEANUP_FILE(AT_File)])])


# AT_CLEANUP(FILES)
# -----------------
# Complete a group of related tests, recursively remove those FILES
# created within the test.  There is no need to list files created with
# AT_DATA.
m4_define([AT_CLEANUP],
[AT_CLEANUP_FILES([$1])dnl
m4_append([AT_help],
m4_defn([AT_ordinal]);m4_defn([AT_line]);m4_defn([AT_description]);m4_ifdef([AT_keywords], [m4_defn([AT_keywords])])
)dnl
    $at_times >at-times
    )
    at_status=$?
    ;;

m4_divert_pop([TESTS])dnl Back to KILL.
])# AT_CLEANUP


# AT_BANNER(TEXT)
# ---------------
# Output TEXT without any shell expansion.
m4_define([AT_BANNER],
[m4_define([AT_banner_ordinal], m4_incr(AT_banner_ordinal))
m4_append([AT_tests_all], [ banner-]m4_defn([AT_banner_ordinal]))
m4_divert_text([TESTS],
[
  banner-AT_banner_ordinal ) @%:@ Banner AT_banner_ordinal. AT_LINE
    cat <<\_ATEOF

$1

_ATEOF
    ;;
])dnl
])# AT_BANNER


# AT_DATA(FILE, CONTENTS)
# -----------------------
# Initialize an input data FILE with given CONTENTS, which should end with
# an end of line.
# This macro is not robust to active symbols in CONTENTS *on purpose*.
# If you don't want CONTENT to be evaluated, quote it twice.
m4_define([AT_DATA],
[AT_CLEANUP_FILES([$1])dnl
cat >$1 <<'_ATEOF'
$2[]_ATEOF
])


# AT_CHECK(COMMANDS, [STATUS = 0], STDOUT, STDERR)
# ------------------------------------------------
# Execute a test by performing given shell COMMANDS.  These commands
# should normally exit with STATUS, while producing expected STDOUT and
# STDERR contents.
#
# STATUS, STDOUT, and STDERR are not checked if equal to `ignore'.
#
# If STDOUT is `expout', then stdout is compared to the content of the file
# `expout'.  Likewise for STDERR and `experr'.
#
# If STDOUT is `stdout', then the stdout is left in the file `stdout',
# likewise for STDERR and `stderr'.  Don't do this:
#
#    AT_CHECK([command >out])
#    # Some checks on `out'
#
# do this instead:
#
#    AT_CHECK([command], [], [stdout])
#    # Some checks on `stdout'
#
# This is an unfortunate limitation inherited from Ultrix which will not
# let you redirect several times the same FD (see the Autoconf documentation).
# If you use the `AT_CHECK([command >out])' be sure to get a test suite
# that will show spurious failures.
#
# You might wonder why not just use `ignore' and directly use stdout and
# stderr left by the test suite.  Firstly because the names of these files
# is an internal detail, and secondly, because
#
#    AT_CHECK([command], [], [ignore])
#    AT_CHECK([check stdout])
#
# will use `stdout' both in input and output: undefined behavior would
# certainly result.  That's why the test suite will save them in `at-stdout'
# and `at-stderr', and will provide you with `stdout' and `stderr'.
#
# Any line of stderr starting with leading blanks and a `+' are filtered
# out, since most shells when tracing include subshell traces in stderr.
# This may cause spurious failures when the test suite is run with `-x'.
#
#
# Implementation Details
# ----------------------
# Ideally, we would like to run
#
#    ( $at_traceon; COMMANDS >at-stdout 2> at-stderr )
#
# but we must group COMMANDS as it is not limited to a single command, and
# then the shells will save the traces in at-stderr. So we have to filter
# them out when checking stderr, and we must send them into the test suite's
# stderr to honor -x properly.
#
# Limiting COMMANDS to a single command is not good either, since them
# the user herself would use {} or (), and then we face the same problem.
#
# But then, there is no point in running
#
#   ( $at_traceon { $1 ; } >at-stdout 2>at-stder1 )
#
# instead of the simpler
#
#  ( $at_traceon; $1 ) >at-stdout 2>at-stder1
#
m4_define([AT_CHECK],
[$at_traceoff
$at_verbose "AT_LINE: AS_ESCAPE([$1])"
echo AT_LINE >at-check-line
( $at_traceon; $1 ) >at-stdout 2>at-stder1
at_status=$?
egrep '^ *\+' at-stder1 >&2
egrep -v '^ *\+' at-stder1 >at-stderr
at_failed=false
dnl Check stderr.
m4_case([$4],
        stderr, [(echo stderr:; tee stderr <at-stderr) >&5],
        ignore, [(echo stderr:; cat at-stderr) >&5],
        experr, [$at_diff experr at-stderr >&5 || at_failed=:],
        [],     [$at_diff $at_devnull  at-stderr >&5 || at_failed=:],
        [echo >>at-stderr; echo "AS_ESCAPE([$4])" | $at_diff - at-stderr >&5 || at_failed=:])
dnl Check stdout.
m4_case([$3],
        stdout, [(echo stdout:; tee stdout <at-stdout) >&5],
        ignore, [(echo stdout:; cat at-stdout) >&5],
        expout, [$at_diff expout at-stdout >&5 || at_failed=:],
        [],     [$at_diff $at_devnull  at-stdout >&5 || at_failed=:],
        [echo >>at-stdout; echo "AS_ESCAPE([$3])" | $at_diff - at-stdout >&5 || at_failed=:])
dnl Check exit val.  Don't `skip' if we are precisely checking $? = 77.
case $at_status in
m4_case([$2],
  [77],
    [],
    [   77) exit 77;;
])dnl
m4_case([$2],
  [ignore],
    [   *);;],
    [   m4_default([$2], [0])) ;;
   *) $at_verbose "AT_LINE: exit code was $at_status, expected m4_default([$2], [0])" >&2
      at_failed=:;;])
esac
AS_IF($at_failed, [$5], [$6])
$at_failed && exit 1
$at_traceon
])# AT_CHECK
