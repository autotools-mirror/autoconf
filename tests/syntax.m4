#							-*- autoconf -*-

dnl TEST_MACRO(NAME-OF-THE-MACRO)
dnl -----------------------------
dnl Run AT_TEST_MACRO(NAME-OF-THE-MACRO) on selected macros only.
dnl There are macros which require argument.  We cannot run them without.
dnl FIXME: AC_INIT creates an infinite loop in m4 when called twice.
dnl I inserted the exception here, not in Makefile.am, because it seems
dnl better to me.  I did not use m4_case, since libm4 is not ready yet.
AT_DEFINE(TEST_MACRO,
[AT_CASE([$1],
         [AC_ARG_VAR],,
         [AC_CHECK_FUNCS],,
         [AC_CHECK_HEADERS],,
         [AC_CHECK_MEMBER],,
         [AC_CHECK_MEMBERS],,
         [AC_CHECK_PROGS],,
         [AC_CONFIG_AUX_DIR],,
         [AC_CONFIG_AUX_DIRS],,
         [AC_INIT],,
         [AC_INIT_PARSE_ARGS],,
         [AC_LINKER_OPTION],,
         [AC_LINK_FILES],,
         [AC_LIST_MEMBER_OF],,
         [AC_PATH_PROGS],,
         [AC_REPLACE_FUNCS],,
         [AC_SEARCH_LIBS],,

         [AT_TEST_MACRO([$1])])])

cat <<EOF

Syntax of macros and completeness of the header templates.

EOF

AT_INCLUDE(macros.m4)
dnl That miserable test comes from the old DejaGNU testsuite.
TEST_MACRO([AC_CHECK_SIZEOF(long *)])
