include(m4sh.m4)					    -*- Autoconf -*-
# M4 macros used in building test suites.
# Copyright 2000 Free Software Foundation, Inc.

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

# This script is part of Autotest.  Unlimited permission to copy,
# distribute and modify the testing scripts that are the output of
# that Autotest script is given.  You need not follow the terms of the
# GNU General Public License when using or distributing such scripts,
# even though portions of the text of Autotest appear in them.  The
# GNU General Public License (GPL) does govern all other use of the
# material that constitutes the Autotest.
#
# Certain portions of the Autotest source text are designed to be
# copied (in certain cases, depending on the input) into the output of
# Autotest.  We call these the "data" portions.  The rest of the
# Autotest source text consists of comments plus executable code that
# decides which of the data portions to output in any given case.  We
# call these comments and executable code the "non-data" portions.
# Autotest never copies any of the non-data portions into its output.
#
# This special exception to the GPL applies to versions of Autotest
# released by the Free Software Foundation.  When you make and
# distribute a modified version of Autotest, you may extend this
# special exception to the GPL to apply to your modified version as
# well, *unless* your modified version has the potential to copy into
# its output some of the text that was the non-data portion of the
# version that you started with.  (In other words, unless your change
# moves or copies text from the non-data portions to the data
# portions.)  If your modification has such potential, you must delete
# any notice of this special exception to the GPL from your modified
# version.


# Use of diversions:
#
#  - DEFAULT
#    Overall initialization, value of $at_tests_all.
#  - OPTIONS
#    Option processing
#  - HELP
#    Help message.  Of course it is useless, you could just push into
#    OPTIONS, but that's much clearer this way.
#  - SETUP
#    Be ready to run the tests.
#  - TESTS
#    The core of the test suite, the ``normal'' diversion.
#  - TAIL
#    tail of the core for;case, overall wrap up, generation of debugging
#    scripts and statistics.

m4_define([_m4_divert(DEFAULT)],       0)
m4_define([_m4_divert(OPTIONS)],      10)
m4_define([_m4_divert(HELP)],         20)
m4_define([_m4_divert(SETUP)],        30)
m4_define([_m4_divert(TESTS)],        50)
m4_define([_m4_divert(TAIL)],         60)

m4_divert_push([TESTS])
m4_divert_push([KILL])


# AT_LINE
# -------
# Return the current file sans directory, a colon, and the current line.
m4_define([AT_LINE],
[m4_patsubst(__file__, ^.*/\(.*\), \1):__line__])


# AT_INIT(PROGRAM)
# ----------------
# Begin testing suite, using PROGRAM to check version.  The search path
# should be already preset so the proper executable will be selected.
m4_define([AT_INIT],
[m4_define([AT_ordinal], 0)
m4_define([AT_banner_ordinal], 0)
m4_define([AT_data_files], [stdout stderr ])
m4_divert_push([DEFAULT])dnl
#! /bin/sh

AS_SHELL_SANITIZE

# Name of the executable.
as_me=`echo "$[0]" | sed 's,.*/,,'`

. ./atconfig
# Use absolute file notations, as the test might change directories.
at_srcdir=`cd "$srcdir" && pwd`
at_top_srcdir=`cd "$top_srcdir" && pwd`

# Don't take risks: use absolute path names.
at_path=`pwd`
at_IFS_save=$IFS
IFS=:
for at_dir in $AUTOTEST_PATH:$PATH; do
  at_path=$at_path:`cd "$at_dir" && pwd`
done
IFS=$at_IFS_save
PATH=$at_path
export PATH

test -f atlocal && . ./atlocal

# -e sets to true
at_stop_on_error=false
# Shall we be verbose?
at_verbose=:
at_quiet=echo
# Shall we keep the debug scripts?  Must be `:' when testsuite is
# run by a debug script, so that the script doesn't remove itself.
at_debug=false
# Display help message?
at_help=false
# Tests to run
at_tests=
dnl Other vars inserted here (DEFAULT).
m4_divert([OPTIONS])

while test $[#] -gt 0; do
  case $[1] in
    --help | -h) at_help=: ;;
    --version) echo "$[0] ($at_package) $at_version"; exit 0 ;;

    -d) at_debug=:;;
    -e) at_stop_on_error=:;;
    -v) at_verbose=echo; at_quiet=:;;
    -x) at_traceon='set -vx'; at_traceoff='set +vx';;

    [[0-9] | [0-9][0-9] | [0-9][0-9][0-9] | [0-9][0-9][0-9][0-9]])
        at_tests="$at_tests$[1] ";;

     *) echo 1>&2 "Try \`$[0] --help' for more information."; exit 1 ;;
  esac
  shift
done

test -z "$at_tests" && at_tests=$at_tests_all

# Help message.
# Display only the title of selected tests.
if $at_help; then
  cat <<EOF
Usage: $[0] [[OPTION]]... [[TESTS]]

Run all the tests, or the selected TESTS.

Options:
  -h  Display this help message and the description of TESTS
  -e  Abort the full suite and inhibit normal clean up if a test fails
  -v  Force more detailed output, default for debugging scripts
  -x  Have the shell to trace command execution

Tests:
EOF
  # "  1 42  45 " => " (1|42|45): "
  at_tests_pattern=`echo "$at_tests" | sed 's/^  *//;s/  *$//;s/  */|/g'`
  egrep -e " (${at_tests_pattern}): " <<EOF
m4_divert([HELP])dnl Help message inserted here.
m4_divert([SETUP])dnl
EOF
  exit 0
fi

# To check whether a test succeeded or not, we compare an expected
# output with a reference.  In the testing suite, we just need `cmp'
# but in debugging scripts, we want more information, so we prefer
# `diff -u'.  Nonetheless we will use `diff' only, because in DOS
# environments, `diff' considers that two files are equal included
# when there are only differences on the coding of new lines. `cmp'
# does not.
#
# Finally, not all the `diff' support `-u', and some, like Tru64, even
# refuse to `diff' /dev/null.
: >empty

if diff -u empty empty >/dev/null 2>&1; then
  at_diff='diff -u'
else
  at_diff='diff'
fi



# Each generated debugging script, containing a single test group, cleans
# up files at the beginning only, not at the end.  This is so we can repeat
# the script many times and browse left over files.  To cope with such left
# over files, the full test suite cleans up both before and after test groups.

if $1 --version | grep "$at_package.*$at_version" >/dev/null; then
  AS_BOX([Testing suite for $at_package $at_version])
else
  AS_BOX([ERROR: Not using the proper version, no tests performed])
  exit 1
fi

# Setting up the FDs.
# 5 is stdout conditioned by verbosity.
if test $at_verbose = echo; then
  exec 5>&1
else
  exec 5>/dev/null
fi

at_failed_list=
at_skip_count=0
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
  esac
  case $at_test in
    banner-*) ;;
    *)
      at_test_count=`expr 1 + $at_test_count`
      $at_verbose $at_n "$at_test. $srcdir/`cat at-setup-line`: $at_c"
      case $at_status in
        0) echo ok
           ;;
        77) echo "ok (skipped near \``cat at-check-line`')"
            at_skip_count=`expr $at_skip_count + 1`
            ;;
        *) echo "FAILED near \``cat at-check-line`'"
           at_failed_list="$at_failed_list $at_test"
           $at_stop_on_error && break
           ;;
      esac
      $at_debug || rm -rf $at_data_files
      ;;
  esac
done

# Wrap up the testing suite with summary statistics.

rm -f at-check-line at-setup-line
if test -z "$at_failed_list"; then
  if test "$at_skip_count" = 0; then
    AS_BOX([All $at_test_count tests were successful])
  else
    AS_BOX([All $at_test_count tests were successful ($at_skip_count skipped)])
  fi
elif test $at_debug = false; then
  at_fail_count=`set dummy $at_failed_list; shift; echo $[#]`
  if $at_stop_on_error; then
    AS_BOX([ERROR: One of the tests failed, inhibiting subsequent tests])
  else
    AS_BOX([ERROR: Suite unsuccessful, $at_fail_count of $at_test_count tests failed])
  fi

  # Remove any debugging script resulting from a previous run.
  rm -f debug-*.sh $[0].log
  echo
  echo $at_n "Writing \`debug-NN.sh' scripts, NN =$at_c"
  for at_group in $at_failed_list; do
    echo $at_n " $at_group$at_c"
    ( echo "#! /bin/sh"
      echo 'exec ${CONFIG_SHELL-/bin/sh} '"$[0]"' -v -d '"$at_group"' ${1+"$[@]"}'
      echo 'exit 1'
    ) >debug-$at_group.sh
    chmod +x debug-$at_group.sh
  done
  echo ', done'
  echo
  echo 'You may investigate any problem if you feel able to do so, in which'
  echo 'case the testsuite provide a good starting point.'
  echo
  echo 'Now, failed tests will be executed again, verbosely, and logged'
  echo 'in the file '$[0]'.log.'

  AS_UNAME >$[0].log
  ${CONFIG_SHELL-/bin/sh} $[0] -v -d $at_failed_list 2>&1 | tee -a $[0].log
  AS_BOX([$[0].log is created])

  echo
  echo "Please send \`$[0].log' to <$at_bugreport> together with as"
  echo 'information as you think might help.'
  exit 1
fi

exit 0
m4_divert_pop()dnl
m4_wrap([m4_divert_text([DEFAULT],
                        [# List of the tests.
at_tests_all="AT_TESTS_ALL "])])dnl
m4_wrap([m4_divert_text([SETUP],
                        [# List of the output files.
at_data_files="AT_data_files "])])dnl
])# AT_INIT



# AT_SETUP(DESCRIPTION)
# ---------------------
# Start a group of related tests, all to be executed in the same subshell.
# The group is testing what DESCRIPTION says.
m4_define([AT_SETUP],
[m4_define([AT_ordinal], m4_incr(AT_ordinal))
m4_append([AT_TESTS_ALL], [ ]m4_defn([AT_ordinal]))
m4_divert_text([HELP],
               [m4_format([ %3d: %-15s %s], AT_ordinal, AT_LINE, [$1])])
m4_divert_push([TESTS])dnl
  AT_ordinal ) [#] AT_ordinal. AT_LINE: $1
    echo AT_LINE >at-setup-line
    $at_verbose "AT_ordinal. $srcdir/AT_LINE: testing $1..."
    $at_quiet $at_n "m4_format([%3d: %-18s], AT_ordinal, AT_LINE)[]$at_c"
    (
      $at_traceon
])


# AT_CLEANUP_FILE_IFELSE(FILE, IF-REGISTERED, IF-NOT-REGISTERED)
# --------------------------------------------------------------
# We try to build a regular expression matching `[', `]', `*', and
# `.', i.e., the regexp active characters.
#
# Novices would write, `[[]*.]', which sure fails since the character
# class ends with the first closing braquet.
# M4 gurus will sure write `[\[\]*.]', but it will fail too because
# regexp does not support this and understands `\' per se.
# Regexp gurus will write `[][*.]' which is indeed what Regexp expects,
# but it will fail for M4 reasons: it's the same as `[*.]'.
#
# So the question is:
#
#       Can you write a regexp that matches those four characters,
#       and respects the M4 quotation contraints?
#
# The answer is: (rot13) tvira va gur ertrkc orybj, lbh vqvbg!
m4_define([AT_CLEANUP_FILE_IFELSE],
[m4_if(m4_regexp(AT_data_files, m4_patsubst([ $1 ], [[[]\|[]]\|[*.]], [\\\&])),
       -1,
       [$3], [$2])])


# AT_CLEANUP_FILE(FILE)
# ---------------------
# Register FILE for AT_CLEANUP.
m4_define([AT_CLEANUP_FILE],
[AT_CLEANUP_FILE_IFELSE([$1], [],
                        [m4_append([AT_data_files], [$1 ])])])


# AT_CLEANUP_FILES(FILES)
# -----------------------
# Declare a list of FILES to clean.
m4_define([AT_CLEANUP_FILES],
[m4_foreach([AT_File], m4_quote(m4_patsubst([$1], [  *], [,])),
            [AT_CLEANUP_FILE(AT_File)])])


# AT_CLEANUP(FILES)
# -----------------
# Complete a group of related tests, recursively remove those FILES
# created within the test.  There is no need to list stdout, stderr,
# nor files created with AT_DATA.
m4_define([AT_CLEANUP],
[AT_CLEANUP_FILES([$1])dnl
      $at_traceoff
    )
    at_status=$?
    ;;

m4_divert([TESTS])[]dnl
m4_divert_pop()dnl
])# AT_CLEANUP


# AT_BANNER(TEXT)
# ---------------
# Output TEXT without any shell expansion.
m4_define([AT_BANNER],
[m4_define([AT_banner_ordinal], m4_incr(AT_banner_ordinal))
m4_append([AT_TESTS_ALL], [ banner-]m4_defn([AT_banner_ordinal]))
m4_divert_push([TESTS])dnl
  banner-AT_banner_ordinal ) [#] Banner AT_banner_ordinal. AT_LINE
    cat <<\_ATEOF

$1

_ATEOF
    ;;

m4_divert_pop()dnl
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


# AT_CHECK(COMMANDS, [STATUS], STDOUT, STDERR)
# --------------------------------------------
# Execute a test by performing given shell COMMANDS.  These commands
# should normally exit with STATUS, while producing expected STDOUT and
# STDERR contents.  The special word `expout' for STDOUT means that file
# `expout' contents has been set to the expected stdout.  The special word
# `experr' for STDERR means that file `experr' contents has been set to
# the expected stderr.
# STATUS is not checked if it is empty.
# STDOUT and STDERR can be the special value `ignore', in which case
# their content is not checked.
m4_define([AT_CHECK],
[$at_traceoff
$at_verbose "$srcdir/AT_LINE: m4_patsubst([$1], [\([\"`$]\)], \\\1)"
echo AT_LINE >at-check-line
$at_traceon
( $1 ) >stdout 2>stderr
at_status=$?
$at_traceoff
at_failed=false
dnl Check stderr.
m4_case([$4],
        ignore, [cat stderr >&5],
        experr, [AT_CLEANUP_FILE([experr])dnl
$at_diff experr stderr >&5 || at_failed=:],
        [], [$at_diff empty stderr >&5 || at_failed=:],
        [echo $at_n "m4_patsubst([$4], [\([\"`$]\)], \\\1)$at_c" | $at_diff - stderr >&5 || at_failed=:])
dnl Check stdout.
m4_case([$3],
        ignore, [cat stdout >&5],
        expout, [AT_CLEANUP_FILES([expout])dnl
$at_diff expout stdout >&5 || at_failed=:],
        [], [$at_diff empty stdout >&5 || at_failed=:],
        [echo $at_n "m4_patsubst([$3], [\([\"`$]\)], \\\1)$at_c" | $at_diff - stdout >&5 || at_failed=:])
dnl Check exit val.
case $at_status in
  77) exit 77;;
m4_case([$2],
  [ignore],
    [   *);;],
    [   m4_default([$2], [0])) ;;
   *) $at_verbose "$srcdir/AT_LINE: exit code was $at_status, expected m4_default([$2], [0])" >&2
      at_failed=:;;])
esac
AS_IF($at_failed, [$5], [$6])
$at_failed && exit 1
$at_traceon
])# AT_CHECK
