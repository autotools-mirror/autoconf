#							-*- autoconf -*-

cat <<EOF

Base layer.

EOF

# m4_wrap
# -------

AT_SETUP(m4_wrap)

# m4_wrap is used to display the help strings.  Also, check that
# commas are not swallowed.  This can easily happen because of
# m4-listification.

AT_DATA(libm4.in,
[[include(libm4.m4)divert(0)dnl
m4_wrap([Short string */], [   ], [/* ], 20)

m4_wrap([Much longer string */], [   ], [/* ], 20)

m4_wrap([Short doc.], [          ], [  --short ], 30)

m4_wrap([Short doc.], [          ], [  --too-wide], 30)

m4_wrap([Super long documentation.], [          ], [  --too-wide], 30)

m4_wrap([First, second  , third, [,quoted]])
]])

AT_DATA(expout,
[[/* Short string */

/* Much longer
   string */

  --short Short doc.

  --too-wide
          Short doc.

  --too-wide
          Super long
          documentation.

First, second , third, [,quoted]
]])

AT_CHECK([$M4 -I $at_top_srcdir libm4.in], 0, expout)

AT_CLEANUP()



# AC_REQUIRE
# ----------

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

AC_DIVERT_POP()
TEST1
test -z "$test1" && exit 1
exit 0
]])

AT_CHECK([../autoconf -m .. -l $at_srcdir], 0, [], [])
AT_CHECK([./configure], 0)

AT_CLEANUP(configure)
