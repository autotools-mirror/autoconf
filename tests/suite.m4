#!/bin/sh
# Validation suite for Autoconf
# Copyright (C) 2000 Free Software Foundation, Inc.

# Still many parts of `autoconf' are not exercised by the test suite.  A few
# FIXME's, below, are used to list tests that we would need.  Do you feel
# like contributing new tests?  If you do, you may tell your intent to
# `autoconf@gnu.org', so no two people work at the same thing.

AT_INIT(autoconf)

dnl AT_TEST_MACRO(NAME-OF-THE-MACRO, [MACRO-USE], [ADDITIONAL-CMDS])
dnl ----------------------------------------------------------------
dnl Create a minimalist configure.in running the macro named
dnl NAME-OF-THE-MACRO, check that autoconf runs on that script,
dnl and that the shell runs correctly the configure.
AT_DEFINE(AT_TEST_MACRO,
[AT_SETUP([$1])

dnl Produce the configure.in
AT_DATA(configure.in,
[AC_INCLUDE(actest.m4)
AC_INIT
AC_CONFIG_HEADER(config.h)
AC_ENV_SAVE(expout)
ifelse([$2],,[$1], [$2])
AC_ENV_SAVE(env-after)
AC_OUTPUT
])

dnl  FIXME: Here we just don't consider the stderr from Autoconf.
dnl  Maybe some day we could be more precise and filter out warnings.
dnl  The problem is that currently some warnings are spread on several
dnl  lines, so grepping -v warning is not enough.
AT_CHECK([../autoconf -m .. -l $at_srcdir], 0,, ignore)
AT_CHECK([../autoheader -m .. -l $at_srcdir], 0,, ignore)
AT_CHECK([./configure], 0, ignore, ignore)
AT_CHECK([cat env-after], 0, expout)
$3
AT_CLEANUP(configure config.status config.log config.cache config.h.in config.h env-after)dnl
])dnl AT_TEST_MACRO


dnl Run semantics before, since there are little chances that syntax
dnl fails.

AT_INCLUDE(semantics.m4)
AT_INCLUDE(syntax.m4)
