#							-*- autoconf -*-

cat <<EOF

Checking the semantics of some macros.

EOF


dnl AC_CHECK_DECLS
dnl --------------
dnl Check that it performs the correct actions:
dnl Must define NEED_NO_DECL, but not NEED_YES_DECL.
AT_TEST_MACRO(AC_CHECK_DECLS,
[AC_CHECK_DECLS((yes, no),,,
                [int yes = 1;])],
[AT_CHECK_DEFINES(
[#define NEED_NO_DECL 1
/* #undef NEED_YES_DECL */
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
AT_TEST_MACRO(AC_CHECK_TYPES,
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
