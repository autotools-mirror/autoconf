#							-*- autoconf -*-

cat <<EOF

Syntax of macros and completeness of the header templates.

EOF

AT_INCLUDE(macros.m4)
dnl That miserable test comes from the old DejaGNU testsuite.
TEST_MACRO([AC_CHECK_SIZEOF(long *)])
