#							-*- autoconf -*-

dnl AT_AUTOCONF_TEST(NAME-OF-THE-MACRO)
dnl -----------------------------------
dnl Create a minimalist configure.in running the macro named
dnl NAME-OF-THE-MACRO, check that autoconf runs on that script,
dnl and that the shell runs correctly the configure.
AT_DEFINE(TEST_MACRO,
[AT_SETUP($1)

# An extremely simple configure.in
AT_DATA(configure.in,
[AC_INIT
$1
AC_OUTPUT
])

# FIXME: Here we just don't consider the stderr from Autoconf.
# Maybe some day we could be more precise and filter out warnings.
# The problem is that currently some warnings are spread on several
# lines, so grepping -v warning is not enough.
AT_CHECK([../autoconf -m ..], 0,, ignore)
AT_CHECK([./configure], 0, ignore, ignore)
AT_CLEANUP(configure config.status config.log config.cache)])

echo
echo 'Syntax of specific macros.'
echo

AT_INCLUDE(macros.m4)
