#                                                       -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
AC_PREREQ(2.50)
AC_INIT(GNU Autoconf, 2.52a, bug-autoconf@gnu.org)
AC_CONFIG_SRCDIR(autoconf.in)
AC_CONFIG_AUX_DIR(config)
AM_INIT_AUTOMAKE(autoconf, 2.52a)

# Initialize the test suite.
AT_CONFIG(..)
AC_PATH_PROG(EXPR, expr)

# We use a path for GNU m4 so even if users have another m4 first in
# their path, the installer can configure with a path that has GNU m4
# first and get that path embedded in the installed autoconf and
# autoheader scripts.
AC_PROG_GNU_M4
if test x"$ac_cv_prog_gnu_m4" != xyes; then
  AC_MSG_ERROR([GNU m4 1.4 is required])
fi
# This is needed because Automake does not seem to realize there is
# a AC-SUBST inside AC-PROG-GNU-M4.  Grmph!
AC_SUBST(M4)

# `ifnames' uses AWK.
AC_PROG_AWK

# Generating man pages.
AM_MISSING_PROG(HELP2MAN, help2man)

# We use a path for perl so the #! line in autoscan will work.
AC_PATH_PROG(PERL, perl, no)
AC_SUBST(PERL)dnl
if test "$PERL" = no; then
  AC_MSG_ERROR([perl is not found])
fi
$PERL -e 'require 5.005;' || {
   AC_MSG_ERROR([perl 5.005 or better is required])
}

AC_PROG_INSTALL

# Automake can't see inner AC_SUBSTS (`aclocal' is bypassed), so we tag the
# AC_SUBSTS here too.
AC_SUBST(PACKAGE_NAME)
AC_SUBST(PACKAGE)
AC_SUBST(VERSION)

AC_CONFIG_FILES(Makefile m4/Makefile man/Makefile doc/Makefile config/Makefile
                lib/Makefile lib/Autoconf/Makefile lib/autoscan/Makefile
                lib/m4sugar/Makefile
                lib/autoconf/Makefile lib/autotest/Makefile
                tests/Makefile tests/atconfig)

AC_OUTPUT
# Report the state of this version of Autoconf if this is a beta.
m4_match(m4_defn([AC_PACKAGE_VERSION]),  [[a-z]],
[    cat <<EOF

You are about to use an experimental version of Autoconf.  Be sure to
read the relevant mailing lists, most importantly <autoconf@gnu.org>.

Below you will find information on the status of this version of Autoconf.


EOF
    sed -n '/^\* Status/,$p' $srcdir/BUGS
])
