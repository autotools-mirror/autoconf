#							-*- autoconf -*-

cat <<EOF

Checking the semantics of some macros.

EOF

dnl Check that AC_CHECK_MEMBERS performs the correct actions:
dnl Must define HAVE_STRUCT_YES_YES, but not HAVE_STRUCT_YES_NO.
AT_TEST_MACRO(AC_CHECK_MEMBERS,
[AC_CHECK_MEMBERS((struct yes.yes, struct yes.no),,,
                  [struct yes { int yes ;} ;])],
[AT_CHECK([grep HAVE_STRUCT_YES_YES config.h],,
          [#define HAVE_STRUCT_YES_YES 1
])
AT_CHECK([grep HAVE_STRUCT_YES_NO config.h],,
          [/* #undef HAVE_STRUCT_YES_NO */
])])


dnl Check that AC_CHECK_TYPES performs the correct actions:
dnl Must define HAVE_STRUCT_YES, but not HAVE_STRUCT_NO.
AT_TEST_MACRO(AC_CHECK_TYPES,
[AC_CHECK_TYPES((struct yes, struct no),,,
                [struct yes { int yes ;} ;])],
[AT_CHECK([grep HAVE_STRUCT_YES config.h],,
          [#define HAVE_STRUCT_YES 1
])
AT_CHECK([grep HAVE_STRUCT_NO config.h],,
          [/* #undef HAVE_STRUCT_NO */
])])



dnl Check that AC_CHECK_DECLS performs the correct actions:
dnl Must define NEED_NO_DECL, but not NEED_YES_DECL.
AT_TEST_MACRO(AC_CHECK_DECLS,
[AC_CHECK_DECLS((yes, no),,,
                [int yes = 1;])],
[AT_CHECK([grep NEED_YES_DECL config.h],,
          [/* #undef NEED_YES_DECL */
])
AT_CHECK([grep NEED_NO_DECL config.h],,
          [#define NEED_NO_DECL 1
])])
