#							-*- autoconf -*-

cat <<EOF

Semantics.

EOF


# AC_TRY_LINK_FUNC
# ----------------
AT_TEST_MACRO(AC_TRY_LINK_FUNC,
[AC_TRY_LINK_FUNC(exit,, exit 1)
AC_TRY_LINK_FUNC(Be_doomed_if_your_libc_has_a_function_named_like_this,
                 exit 1)])


# AC_CHECK_LIB
# ------------
# Well, I can't imagine a system where `cos' is neither in libc, nor
# in libm.  Nor can I imagine a lib more likely to exists than libm.
# But there are system without libm, on which we don't want to have
# this test fail, so exit successfully if `cos' is in libc.
AT_TEST_MACRO(AC_CHECK_LIB,
[AC_TRY_LINK_FUNC(cos, exit 0)
AC_CHECK_LIB(m, cos,, exit 1)])


# AC_CHECK_DECLS
# --------------
# Check that it performs the correct actions:
# Must define NEED_NO_DECL, but not NEED_YES_DECL.
AT_TEST_MACRO(AC_CHECK_DECLS,
[AC_CHECK_DECLS((yes, no),,,
                [int yes = 1;])],
[AT_CHECK_DEFINES(
[#define HAVE_DECL_NO 0
#define HAVE_DECL_YES 1
])])


# AC_CHECK_FUNCS
# --------------
# Check that it performs the correct actions:
# Must define HAVE_EXIT, but not HAVE_AUTOCONF_TIXE
AT_TEST_MACRO(AC_CHECK_FUNCS,
[AC_CHECK_FUNCS(exit autoconf_tixe)],
[AT_CHECK_DEFINES(
[/* #undef HAVE_AUTOCONF_TIXE */
#define HAVE_EXIT 1
])])



# AC_CHECK_HEADERS
# ----------------
# Check that it performs the correct actions:
# Must define HAVE_STDIO_H, but not HAVE_AUTOCONF_IO_H.
AT_TEST_MACRO(AC_CHECK_HEADERS,
[AC_CHECK_HEADERS(stdio.h autoconf_io.h)],
[AT_CHECK_DEFINES(
[/* #undef HAVE_AUTOCONF_IO_H */
#define HAVE_STDIO_H 1
])])



# AC_CHECK_MEMBERS
# ----------------
# Check that it performs the correct actions.
# Must define HAVE_STRUCT_YES_YES, but not HAVE_STRUCT_YES_NO.
AT_TEST_MACRO(AC_CHECK_MEMBERS,
[AC_CHECK_MEMBERS((struct yes.yes, struct yes.no),,,
                  [struct yes { int yes ;} ;])],
[AT_CHECK_DEFINES(
[/* #undef HAVE_STRUCT_YES_NO */
#define HAVE_STRUCT_YES_YES 1
])])



# AC_CHECK_SIZEOF
# --------------
# Check that it performs the correct actions.
# Must define HAVE_STRUCT_YES, HAVE_INT, but not HAVE_STRUCT_NO.
# `int' and `struct yes' are both checked to test both the compiler
# builtin types, and defined types.
AT_TEST_MACRO(AC_CHECK_SIZEOF,
[AC_CHECK_SIZEOF(char)
AC_CHECK_SIZEOF(charchar,,
[#include <stdio.h>
typedef struct
{
  char a;
  char b;
} charchar;])],
[AT_CHECK_DEFINES(
[#define SIZEOF_CHAR 1
#define SIZEOF_CHARCHAR 2
])])



# AC_CHECK_TYPES
# --------------
# Check that it performs the correct actions.
# Must define HAVE_STRUCT_YES, HAVE_INT, but not HAVE_STRUCT_NO.
# `int' and `struct yes' are both checked to test both the compiler
# builtin types, and defined types.
AT_TEST_MACRO(AC_CHECK_TYPES,
[AC_CHECK_TYPES((int, struct yes, struct no),,,
                [struct yes { int yes ;} ;])],
[AT_CHECK_DEFINES(
[#define HAVE_INT 1
/* #undef HAVE_STRUCT_NO */
#define HAVE_STRUCT_YES 1
])])


# AC_CHECK_TYPES
# --------------
# Check that we properly dispatch properly to the old implementation
# or to the new one.
AT_SETUP([AC_CHECK_TYPES])

AT_DATA(configure.in,
[[AC_INIT
m4_define([_AC_CHECK_TYPE_NEW], [NEW])
m4_define([_AC_CHECK_TYPE_OLD], [OLD])
#(cut-from-here
AC_CHECK_TYPE(ptrdiff_t)
AC_CHECK_TYPE(ptrdiff_t, int)
AC_CHECK_TYPE(quad, long long)
AC_CHECK_TYPE(table_42, [int[42]])
# Nice machine!
AC_CHECK_TYPE(uint8_t, uint65536_t)
AC_CHECK_TYPE(a,b,c,d)
#to-here)
AC_OUTPUT
]])

AT_CHECK([../autoconf -m .. -l $at_srcdir], 0,,
[configure.in:10: warning: AC_CHECK_TYPE: assuming `uint65536_t' is not a type
])
AT_CHECK([[sed -e '/^#(cut-from-here/,/^#to-here)/!d' -e '/^#/d' configure]],
         0,
         [NEW
OLD
OLD
OLD
NEW
NEW
])

AT_CLEANUP(autoconf.err)



# AC_CHECK_FILES
# --------------
# FIXME: To really test HAVE_AC_EXISTS2 and HAVE_AC_MISSING2 we need to
# open AH_TEMPLATE to `configure.in', which is not yet the case.
AT_TEST_MACRO(AC_CHECK_FILES,
[touch ac-exists1 ac-exists2
ac_exists2=ac-exists2
ac_missing2=ac-missing2
AC_CHECK_FILES(ac-exists1 ac-missing1 $ac_exists2 $ac_missing2)
rm ac-exists1 ac-exists2],
[AT_CHECK_DEFINES(
[#define HAVE_AC_EXISTS1 1
/* #undef HAVE_AC_MISSING1 */
])])



## ------------------------------ ##
## AC_CHECK_PROG & AC_PATH_PROG.  ##
## ------------------------------ ##

AT_SETUP(AC_CHECK_PROG & AC_PATH_PROG)

# Create a sub directory `path' with 6 subdirs which all 7 contain
# an executable `tool'. `6' contains a `better' tool.

mkdir path

cat >path/tool <<\EOF
#! /bin/sh
exit 0
EOF
chmod +x path/tool

for i in 1 2 3 4 5 6
do
  mkdir path/$i
  cp path/tool path/$i
done
cp path/tool path/6/better


# -------------------------------- #
# AC_CHECK_PROG & AC_CHECK_PROGS.  #
# -------------------------------- #

AT_DATA(configure.in,
[[AC_INIT
pwd=`pwd`
path=`echo "1:2:3:4:5:6" | sed -e 's,\([[0-9]]\),'"$pwd"'/path/\1,g'`
fail=0

AC_CHECK_PROG(TOOL1, tool, found, not-found, $path)
test "$TOOL1" = found || fail=1

# Yes, the semantics of this macro is weird.
AC_CHECK_PROG(TOOL2, tool,, not-found, $path)
test "$TOOL2" = not-found || fail=1

AC_CHECK_PROG(TOOL3, tool, tool, not-found, $path, $pwd/path/1/tool)
test "$TOOL3" = $pwd/path/2/tool || fail=1

AC_CHECK_PROG(TOOL4, better, better, not-found, $path, $pwd/path/1/tool)
test "$TOOL4" = better || fail=1

# When a tool is not found, and no value is given for not-found,
# the variable is left empty.
AC_CHECK_PROGS(TOOL5, missing,, $path)
test -z "$TOOL5" || fail=1

AC_CHECK_PROGS(TOOL6, missing tool better,, $path)
test "$TOOL6" = tool || fail=1

# no AC_OUTPUT, we don't need config.status.
exit $fail
]])

AT_CHECK([../autoconf -m .. -l $at_srcdir], 0,, ignore)
AT_CHECK([./configure], 0, ignore)


# ------------------------------ #
# AC_PATH_PROG & AC_PATH_PROGS.  #
# ------------------------------ #

AT_DATA(configure.in,
[[AC_INIT
pwd=`pwd`
path=`echo "1:2:3:4:5:6" | sed -e 's,\([[0-9]]\),'"$pwd"'/path/\1,g'`
fail=0

AC_PATH_PROG(TOOL1, tool, not-found, $path)
test "$TOOL1" = $pwd/path/1/tool || fail=1

AC_PATH_PROG(TOOL2, better, not-found, $path)
test "$TOOL2" = $pwd/path/6/better || fail=1

# When a tool is not found, and no value is given for not-found,
# the variable is left empty.
AC_PATH_PROGS(TOOL3, missing,, $path)
test -z "$TOOL3" || fail=1

AC_PATH_PROGS(TOOL4, missing tool better,, $path)
test "$TOOL4" = $pwd/path/1/tool || fail=1

# no AC_OUTPUT, we don't need config.status.
exit $fail
]])

AT_CHECK([../autoconf -m .. -l $at_srcdir], 0,, ignore)
AT_CHECK([./configure], 0, ignore)

AT_CLEANUP(path config.log config.cache configure)
