#							-*- autoconf -*-

cat <<EOF

Semantics.

EOF



dnl AC_CHECK_DECLS
dnl --------------
dnl Check that it performs the correct actions:
dnl Must define NEED_NO_DECL, but not NEED_YES_DECL.
AT_TEST_MACRO(AC_CHECK_DECLS,
[AC_CHECK_DECLS((yes, no),,,
                [int yes = 1;])],
[AT_CHECK_DEFINES(
[#define HAVE_DECL_NO 0
#define HAVE_DECL_YES 1
])])


dnl AC_CHECK_FUNCS
dnl --------------
dnl Check that it performs the correct actions:
dnl Must define HAVE_EXIT, but not HAVE_AUTOCONF_TIXE
AT_TEST_MACRO(AC_CHECK_FUNCS,
[AC_CHECK_FUNCS(exit autoconf_tixe)],
[AT_CHECK_DEFINES(
[/* #undef HAVE_AUTOCONF_TIXE */
#define HAVE_EXIT 1
])])



dnl AC_CHECK_HEADERS
dnl ----------------
dnl Check that it performs the correct actions:
dnl Must define HAVE_STDIO_H, but not HAVE_AUTOCONF_IO_H.
AT_TEST_MACRO(AC_CHECK_HEADERS,
[AC_CHECK_HEADERS(stdio.h autoconf_io.h)],
[AT_CHECK_DEFINES(
[/* #undef HAVE_AUTOCONF_IO_H */
#define HAVE_STDIO_H 1
])])



dnl AC_CHECK_MEMBERS
dnl ----------------
dnl Check that it performs the correct actions.
dnl Must define HAVE_STRUCT_YES_YES, but not HAVE_STRUCT_YES_NO.
AT_TEST_MACRO(AC_CHECK_MEMBERS,
[AC_CHECK_MEMBERS((struct yes.yes, struct yes.no),,,
                  [struct yes { int yes ;} ;])],
[AT_CHECK_DEFINES(
[/* #undef HAVE_STRUCT_YES_NO */
#define HAVE_STRUCT_YES_YES 1
])])



dnl AC_CHECK_SIZEOF
dnl --------------
dnl Check that it performs the correct actions.
dnl Must define HAVE_STRUCT_YES, HAVE_INT, but not HAVE_STRUCT_NO.
dnl `int' and `struct yes' are both checked to test both the compiler
dnl builtin types, and defined types.
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



dnl AC_CHECK_TYPES
dnl --------------
dnl Check that it performs the correct actions.
dnl Must define HAVE_STRUCT_YES, HAVE_INT, but not HAVE_STRUCT_NO.
dnl `int' and `struct yes' are both checked to test both the compiler
dnl builtin types, and defined types.
AT_TEST_MACRO(AC_CHECK_TYPES,
[AC_CHECK_TYPES((int, struct yes, struct no),,,
                [struct yes { int yes ;} ;])],
[AT_CHECK_DEFINES(
[#define HAVE_INT 1
/* #undef HAVE_STRUCT_NO */
#define HAVE_STRUCT_YES 1
])])


dnl AC_CHECK_TYPES
dnl --------------
dnl Check that we properly dispatch properly to the old implementation
dnl or to the new one.
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
dnl Nice machine!
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



dnl AC_CHECK_FILES
dnl --------------
dnl FIXME: To really test HAVE_AC_EXISTS2 and HAVE_AC_MISSING2 we need to
dnl open AH_TEMPLATE to `configure.in', which is not yet the case.
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
