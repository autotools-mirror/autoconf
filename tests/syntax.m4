#							-*- autoconf -*-

dnl AT_TEST_MACRO(NAME-OF-THE-MACRO)
dnl --------------------------------
dnl Create a minimalist configure.in running the macro named
dnl NAME-OF-THE-MACRO, check that autoconf runs on that script,
dnl and that the shell runs correctly the configure.
AT_DEFINE(AT_TEST_MACRO,
[AT_SETUP($1)

# An extremely simple configure.in
AT_DATA(configure.in,
[AC_INIT
AC_CONFIG_HEADER(config.h)
$1
AC_OUTPUT
])

# FIXME: Here we just don't consider the stderr from Autoconf.
# Maybe some day we could be more precise and filter out warnings.
# The problem is that currently some warnings are spread on several
# lines, so grepping -v warning is not enough.
AT_CHECK([../autoconf -m ..], 0,, ignore)
AT_CHECK([../autoheader -m ..], 0,, ignore)
AT_CHECK([./configure], 0, ignore, ignore)
AT_CLEANUP(configure config.status config.log config.cache config.h.in config.h)dnl
])dnl AT_TEST_MACRO

dnl TEST_MACRO(NAME-OF-THE-MACRO)
dnl -----------------------------
dnl Run AT_TEST_MACRO(NAME-OF-THE-MACRO) on selected macros only.
dnl There are macros which require argument.  We cannot run them without.
dnl FIXME: AC_INIT creates an infinite loop in m4 when called twice.
dnl I inserted the exception here, not in Makefile.am, because it seems
dnl better to me.  I did not use m4_case, since libm4 is not ready yet.
AT_DEFINE(TEST_MACRO,
[ifelse([$1], [AC_CHECK_FUNCS],,
        [$1], [AC_CHECK_HEADERS],,
        [$1], [AC_CHECK_MEMBER],,
        [$1], [AC_CHECK_MEMBERS],,
        [$1], [AC_CHECK_PROGS],,
        [$1], [AC_CONFIG_AUX_DIR],,
        [$1], [AC_CONFIG_AUX_DIRS],,
        [$1], [AC_INIT],,
        [$1], [AC_LINKER_OPTION],,
        [$1], [AC_LINK_FILES],,
        [$1], [AC_LIST_MEMBER_OF],,
        [$1], [AC_PATH_PROGS],,
        [$1], [AC_REPLACE_FUNCS],,
        [$1], [AC_SEARCH_LIBS],,
        [AT_TEST_MACRO([$1])])])

echo
echo 'Syntax of macros and completeness of the header templates.'
echo

AT_INCLUDE(macros.m4)

echo
echo 'More specific tests.'
echo

TEST_MACRO([AC_CHECK_SIZEOF(long *)])
