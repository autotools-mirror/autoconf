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
[[AC_INCLUDE(actest.m4)
AH_DEFUN(AC_ANAKIN,
[AH_TEMPLATE(Anakin, [The future Darth Vador?])])
AC_INIT
AC_TATOOINE
AC_ANAKIN
AC_CONFIG_HEADERS(config.h:config.hin)
AC_OUTPUT
]])

# Checking `autoheader'.
AT_CHECK([../autoheader -m .. -l $at_srcdir], 0)
AT_CHECK([cat config.hin], 0,
[/* config.hin.  Generated automatically from configure.in by autoheader.  */

/* The future Darth Vador? */
#undef Anakin

/* The planet where Luke was raised. */
#undef Tatooine
])

AT_CLEANUP(config.hin)



dnl autoupdate
dnl ----------
dnl
dnl Check that AC_LINK_FILES and AC_OUTPUT are properly updated.
AT_SETUP(autoupdate)

AT_DATA(configure.in,
[[AC_INIT
dnl The doc says 27 is a valid fubar.
fubar=27
AC_OUTPUT(Makefile, echo $fubar, fubar=$fubar)
]])

# Checking `autoupdate'.
AT_CHECK([../autoupdate -m .. -l $at_srcdir -<configure.in], 0,
[[AC_INIT
dnl The doc says 27 is a valid fubar.
fubar=27
AC_CONFIG_FILES(Makefile)
AC_CONFIG_COMMANDS(default, [echo $fubar], [fubar=$fubar])
AC_OUTPUT
]], ignore)

AT_CLEANUP
