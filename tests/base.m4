#							-*- autoconf -*-

cat <<EOF

Autoconf base layer.

EOF


## ------------ ##
## AC_REQUIRE.  ##
## ------------ ##

# Check that dependencies are always properly honored.

AT_SETUP(AC_REQUIRE)

AT_DATA(configure.in,
[[define([REQUIRE_AND_CHECK],
[AC_REQUIRE([$1])dnl
test -z "$translit([$1], [A-Z], [a-z])" && exit 1])

AC_DEFUN([TEST1],
[REQUIRE_AND_CHECK([TEST2a])
REQUIRE_AND_CHECK([TEST2b])
test1=set])

AC_DEFUN([TEST2a],
[test2a=set])

AC_DEFUN([TEST2b],
[REQUIRE_AND_CHECK([TEST3])
test2b=set])

AC_DEFUN([TEST3],
[REQUIRE_AND_CHECK([TEST2a])
test3=set])

AC_PLAIN_SCRIPT
TEST1
test -z "$test1" && exit 1
exit 0
]])

AT_CHECK([../autoconf --autoconf-dir .. -l $at_srcdir], 0, [], [])
AT_CHECK([./configure], 0)

AT_CLEANUP(configure)
