#							-*- autoconf -*-

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
dnl That miserable test comes from the old DejaGNU testsuite.
TEST_MACRO([AC_CHECK_SIZEOF(long *)])
