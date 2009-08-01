# This file is part of Autoconf.                          -*- Autoconf -*-
# M4 macros used in running tests using third-party testing tools.
m4_define([_AT_COPYRIGHT_YEARS],
[Copyright (C) 2009 Free Software Foundation, Inc.])

# This program is free software: you can redistribute it and/or modify
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
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.

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


## ------------------------ ##
## Erlang EUnit unit tests.  ##
## ------------------------ ##

# AT_CHECK_EUNIT(MODULE, SPEC, [ERLFLAGS], [RUN-IF-FAIL], [RUN-IF-PASS])
# ----------------------------------------------------------------------
# Check that the EUnit test specification SPEC passes. The ERLFLAGS
# optional flags are passed to the Erlang interpreter command line to
# execute the test. The test is executed from an automatically
# generated Erlang module named MODULE. Each call to this macro should
# have a distinct MODULE name within each test group, to ease
# debugging.
# An Erlang/OTP version which contains the eunit library must be
# installed, in order to execute this macro in a test suite.  The ERL,
# ERLC, and ERLCFLAGS variables must be defined in atconfig,
# typically by using the AC_ERLANG_PATH_ERL and AC_ERLANG_PATH_ERLC
# Autoconf macros.
_AT_DEFINE_SETUP([AT_CHECK_EUNIT],
[AT_SKIP_IF([test ! -f "$ERL" || test ! -f "$ERLC"])
## A wrapper to EUnit, to exit the Erlang VM with the right exit code:
AT_DATA([$1.erl],
[[-module($1).
-export([test/0, test/1]).
test() -> test([]).
test(Options) ->
  TestSpec = $2,
  ReturnValue = case code:load_file(eunit) of
    {module, _} -> case eunit:test(TestSpec, Options) of
        ok -> 0; %% test passes
        _  -> 1  %% test fails
      end;
    _ -> 77 %% EUnit not found, test skipped
  end,
  init:stop(ReturnValue).
]])
AT_CHECK(["$ERLC" $ERLCFLAGS -b beam $1.erl])
## Make EUnit verbose when testsuite is verbose:
if test -z "$at_verbose"; then
  at_eunit_options="verbose"
else
  at_eunit_options=""
fi
AT_CHECK(["$ERL" $3 -s $1 test $at_eunit_options -noshell], [0], [ignore], [],
         [$4], [$5])
])
