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


m4_define([AT_DEFINE], m4_defn([m4_define]))
m4_define([AT_INCLUDE], m4_defn([m4_include]))
m4_define([AT_SHIFT], m4_defn([m4_shift]))
m4_define([AT_UNDEFINE], m4_defn([m4_undefine]))



# Use of diversions:
#  0 - overall initialization; for each test group: skipping and cleanups;
#  2 - for each test group: proper code, to reinsert between cleanups;
#  3 - overall wrap up: generation of debugging scripts and statistics.


# AT_LINE
# -------
# Return the current file sans directory, a colon, and the current line.
AT_DEFINE([AT_LINE],
[m4_patsubst(__file__, ^.*/\(.*\), \1):__line__])


# AT_INIT(PROGRAM)
# ----------------
# Begin testing suite, using PROGRAM to check version.  The search path
# should be already preset so the proper executable will be selected.
AT_DEFINE([AT_INIT],
[m4_divert_push(0)dnl
AT_DEFINE([AT_ordinal], 0)
. ./atconfig
# -e sets to true
at_stop_on_error=false;
# Shall we save and check stdout and stderr?
# -n sets to false
at_check_stds=:;
# Shall we be verbose?
at_verbose=:
# Shall we keep the debug scripts?  Must be `:' when testsuite is
# run by a debug script, so that the script doesn't remove itself.
at_debug=false

at_usage="Usage: $[0] [OPTION]...

  -e  Abort the full suite and inhibit normal clean up if a test fails
  -n  Do not redirect stdout and stderr and do not test their contents
  -v  Force more detailed output, default for debugging scripts
  -x  Have the shell to trace command execution; also implies option -n"

while test $[#] -gt 0; do
  case $[1] in
    --help) echo "$at_usage"; exit 0 ;;
    --version) echo "$[0] ($at_package) $at_version"; exit 0 ;;
    -d) at_debug=:;;
    -e) at_stop_on_error=:;;
    -n) at_check_stds=false;;
    -v) at_verbose=echo;;
    -x) at_traceon='set -vx'; at_traceoff='set +vx'; at_check_stds=false;;
    *) echo 1>&2 "Try \`$[0] --help' for more information."; exit 1 ;;
  esac
  shift
done


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
  at_banner="Testing suite for $at_package, version $at_version"
  at_dashes=`echo $at_banner | sed s/./=/g`
  echo "$at_dashes"
  echo "$at_banner"
  echo "$at_dashes"
else
  echo '======================================================='
  echo 'ERROR: Not using the proper version, no tests performed'
  echo '======================================================='
  exit 1
fi

at_failed_list=
at_ignore_count=0
at_test_count=0
m4_divert_push(1)dnl

: ${tests="$TESTS"}
for test in $tests
do
  at_status=0;
  case $test in
m4_divert_pop[]dnl
m4_divert_push(3)[]dnl
  esac
  at_test_count=`expr 1 + $at_test_count`
  $at_verbose $at_n "     $test. $srcdir/`cat at-setup-line`: $at_c"
  case $at_status in
    0) echo ok
       ;;
    77) echo "ignored near \``cat at-check-line`'"
        at_ignore_count=`expr $at_ignore_count + 1`
        ;;
    *) echo "FAILED near \``cat at-check-line`'"
       at_failed_list="$at_failed_list $test"
       $at_stop_on_error && break
       ;;
  esac
  $at_debug || rm -rf $at_data_files
done

# Wrap up the testing suite with summary statistics.

rm -f at-check-line at-setup-line
at_fail_count=0
if test -z "$at_failed_list"; then
  if test "$at_ignore_count" = 0; then
    at_banner="All $at_test_count tests were successful"
  else
    at_banner="All $at_test_count tests were successful ($at_ignore_count ignored)"
  fi
elif test $at_debug = false; then
  # Remove any debugging script resulting from a previous run.
  rm -f debug-*.sh
  echo
  echo $at_n "Writing \`debug-NN.sh' scripts, NN =$at_c"
  for at_group in $at_failed_list; do
    echo $at_n " $at_group$at_c"
    ( echo "#! /bin/sh"
      echo 'at_banner="$[0]: '$at_desc'"'
      echo 'at_dashes=`echo $at_banner | sed s/./=/g`'
      echo 'echo'
      echo 'echo "$at_dashes"'
      echo 'echo "$at_banner"'
      echo 'echo "$at_dashes"'
      echo "export tests=$at_group"
      echo "exec $[0] -v -d"
      echo 'exit 1'
    ) >debug-$at_group.sh
    chmod +x debug-$at_group.sh
    at_fail_count=`expr $at_fail_count + 1`
  done
  echo ', done'
  if $at_stop_on_error; then
    at_banner='ERROR: One of the tests failed, inhibiting subsequent tests'
  else
    at_banner="ERROR: Suite unsuccessful, $at_fail_count of $at_test_count tests failed"
  fi
fi
at_dashes=`echo $at_banner | sed s/./=/g`
echo
echo "$at_dashes"
echo "$at_banner"
echo "$at_dashes"

if test $at_debug = false && test -n "$at_failed_list"; then
  echo
  echo 'When reporting failed tests to maintainers, do not merely list test'
  echo 'numbers, as the numbering changes between releases and pretests.'
  echo 'Be careful to give at least all the information you got about them.'
  echo 'You may investigate any problem if you feel able to do so, in which'
  echo 'case the testsuite provide a good starting point.'
  echo 'information.  Now, failed tests will be executed again, verbosely.'
  for at_group in $at_failed_list; do
    ./debug-$at_group.sh
  done
  exit 1
fi

exit 0
m4_divert_pop()dnl
m4_divert_push(1)dnl
m4_divert_push([KILL])dnl
m4_wrap([m4_divert_text(0,
                        [TESTS="m4_for([i], 1, AT_ordinal, 1, [i ])"])])dnl
])# AT_INIT



# AT_SETUP(DESCRIPTION)
# ---------------------
# Start a group of related tests, all to be executed in the same subshell.
# The group is testing what DESCRIPTION says.
AT_DEFINE([AT_SETUP],
[AT_DEFINE([AT_ordinal], m4_eval(AT_ordinal + 1))
m4_pushdef([AT_data_files], [stdout stderr ])
m4_divert_pop()dnl
  AT_ordinal )
dnl Here will be inserted the definition of at_data_files.
m4_divert(2)[]dnl
    rm -rf $at_data_files
    echo AT_LINE > at-setup-line
    $at_verbose 'testing $1'
    $at_verbose $at_n "     $at_c"
    if test $at_verbose = echo; then
      echo "AT_ordinal. $srcdir/AT_LINE..."
    else
      echo $at_n "m4_substr(AT_ordinal. $srcdir/AT_LINE                            , 0, 30)[]$at_c"
    fi
    (
      $at_traceon
])


# AT_CLEANUP_FILE_IFELSE(FILE, IF-REGISTERED, IF-NOT-REGISTERED)
# --------------------------------------------------------------
AT_DEFINE([AT_CLEANUP_FILE_IFELSE],
[ifelse(m4_regexp(AT_data_files, m4_patsubst([ $1 ], [\([\[\]*.]\)], [\\\1])),
        -1,
        [$3], [$2])])


# AT_CLEANUP_FILE(FILE)
# ---------------------
# Register FILE for AT_CLEANUP.
AT_DEFINE([AT_CLEANUP_FILE],
[AT_CLEANUP_FILE_IFELSE([$1], [],
                        [m4_append([AT_data_files], [$1 ])])])


# AT_CLEANUP_FILES(FILES)
# -----------------------
# Declare a list of FILES to clean.
AT_DEFINE([AT_CLEANUP_FILES],
[m4_foreach([AT_File], m4_quote(m4_patsubst([$1], [  *], [,])),
            [AT_CLEANUP_FILE(AT_File)])])


# AT_CLEANUP(FILES)
# -----------------
# Complete a group of related tests, recursively remove those FILES
# created within the test.  There is no need to list stdout, stderr,
# nor files created with AT_DATA.
AT_DEFINE([AT_CLEANUP],
[AT_CLEANUP_FILES([$1])dnl
      $at_traceoff
    )
    at_status=$?
    ;;
m4_divert(1)[]dnl
    at_data_files="AT_data_files"
m4_undivert(2)[]dnl
m4_popdef([AT_data_files])dnl
m4_divert_push([KILL])dnl
])# AT_CLEANUP


# AT_DATA(FILE, CONTENTS)
# -----------------------
# Initialize an input data FILE with given CONTENTS, which should end with
# an end of line.
# This macro is not robust to active symbols in CONTENTS *on purpose*.
# If you don't want CONTENT to be evaluated, quote it twice.
AT_DEFINE([AT_DATA],
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
AT_DEFINE([AT_CHECK],
[$at_traceoff
$at_verbose "$srcdir/AT_LINE: m4_patsubst([$1], [\([\"`$]\)], \\\1)"
echo AT_LINE > at-check-line
$at_check_stds && exec 5>&1 6>&2 1>stdout 2>stderr
$at_traceon
$1
ifelse([$2], [], [],
[at_status=$?
if test $at_status != $2; then
  $at_verbose "Exit code was $at_status, expected $2" >&6
dnl Maybe there was an important message to read before it died.
  $at_verbose = echo && $at_check_stds && cat stderr >&6
dnl Preserve exit code 77.
  test $at_status = 77 && exit 77
  exit 1
fi
])dnl
$at_traceoff
if $at_check_stds; then
dnl Restore stdout to fd1 and stderr to fd2.
  exec 1>&5 2>&6
dnl If not verbose, neutralize the output of diff.
  test $at_verbose = : && exec 1>/dev/null 2>/dev/null
  at_failed=false;
  m4_case([$4],
          ignore, [$at_verbose = echo && cat stderr;:],
          experr, [AT_CLEANUP_FILE([experr])dnl
$at_diff experr stderr || at_failed=:],
          [], [$at_diff empty stderr || at_failed=:],
          [echo $at_n "m4_patsubst([$4], [\([\"`$]\)], \\\1)$at_c" | $at_diff - stderr || at_failed=:])
  m4_case([$3],
          ignore, [test $at_verbose = echo && cat stdout;:],
          expout, [AT_CLEANUP_FILES([expout])dnl
$at_diff expout stdout || at_failed=:],
          [], [$at_diff empty stdout || at_failed=:],
          [echo $at_n "m4_patsubst([$3], [\([\"`$]\)], \\\1)$at_c" | $at_diff - stdout || at_failed=:])
  if $at_failed; then
    exit 1
  else
    :
  fi
fi
$at_traceon
])# AT_CHECK
