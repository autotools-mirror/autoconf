#							-*- autoconf -*-

cat <<EOF

Autoheader, autoupdate...

EOF

dnl actest.m4 AU_ defines OSBOLETE to UPDATED.


dnl AH_DEFUN
dnl --------
dnl
dnl We check that both the AH_DEFUN given in auxiliary files and in
dnl `configure.in' function properly.
AT_SETUP(AH_DEFUN)

AT_DATA(configure.in,
[AC_INCLUDE(actest.m4)
AH_DEFUN(AC_ANAKIN,
[AH_TEMPLATE(Anakin, [The future Darth Vador?])])
AC_INIT
AC_TATOOINE
AC_ANAKIN
AC_CONFIG_HEADERS(config.h:config.hin)
AC_OUTPUT
])

# The user must know the macro is obsolete.
AT_CHECK([../autoheader -m .. -l $at_srcdir], 0)

# And autoupdate should update it properly.
AT_CHECK([cat config.hin], 0,
[/* config.hin.  Generated automatically from configure.in by autoheader.  */

/* The future Darth Vador? */
#undef Anakin

/* The planet where Luke was raised. */
#undef Tatooine
])

AT_CLEANUP(config.hin)
