#                                                       -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

# Copyright (C) 1992, 1993, 1994, 1995, 1999, 2000, 2001, 2002, 2003
# Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# We need AC_CONFIG_TESTDIR.
AC_PREREQ([2.59])

AC_INIT([GNU Autoconf], [2.59a], [bug-autoconf@gnu.org])
AC_SUBST([PACKAGE_NAME])dnl
AC_CONFIG_SRCDIR([ChangeLog])

AC_CONFIG_AUX_DIR([config])
AC_CONFIG_FILES([config/Makefile])

AM_INIT_AUTOMAKE([check-news 1.7.9 dist-bzip2 readme-alpha])

# We use `/bin/sh -n script' to check that there are no syntax errors
# in the scripts.  Although incredible, there are /bin/sh that go into
# endless loops with `-n', e.g., SunOS's:
#
#   $ uname -a
#   SunOS ondine 4.1.3 2 sun4m unknown
#   $ cat endless.sh
#   while false
#   do
#     :
#   done
#   exit 0
#   $ time sh endless.sh
#   sh endless.sh  0,02s user 0,03s system 78% cpu 0,064 total
#   $ time sh -nx endless.sh
#   ^Csh -nx endless.sh  3,67s user 0,03s system 63% cpu 5,868 total
#
# So before using `/bin/sh -n' to check our scripts, we first check
# that `/bin/sh -n' is not broken to death.

# A script that never returns.  We don't care that it never returns,
# broken /bin/sh loop equally with `false', but it makes it easier to
# test the robustness in a good environment: just remove the `-n'.
AC_CACHE_CHECK([whether sh -n works], ac_cv_sh_n_works,
[cat > conftest.sh <<_CONFEOF_
while :
do
  :
done
_CONFEOF_

(/bin/sh -n conftest.sh) &
sleep 2
if kill $! >/dev/null 2>&1; then
  # We managed to kill the child, which means that we probably
  # can't trust `/bin/sh -n', hence the test failed.
  ac_cv_sh_n_works=no
else
  ac_cv_sh_n_works=yes
fi
rm conftest.sh
])
AC_SUBST(ac_cv_sh_n_works)

# Initialize the test suite and build position independent wrappers.
AC_CONFIG_TESTDIR([tests])
AC_CONFIG_FILES([tests/Makefile tests/atlocal])
AC_CONFIG_FILES([tests/autoconf:tests/wrapper.in],
                [chmod +x tests/autoconf])
AC_CONFIG_FILES([tests/autoheader:tests/wrapper.in],
                [chmod +x tests/autoheader])
AC_CONFIG_FILES([tests/autom4te:tests/wrapper.in],
                [chmod +x tests/autom4te])
AC_CONFIG_FILES([tests/autoreconf:tests/wrapper.in],
                [chmod +x tests/autoreconf])
AC_CONFIG_FILES([tests/autoscan:tests/wrapper.in],
                [chmod +x tests/autoscan])
AC_CONFIG_FILES([tests/autoupdate:tests/wrapper.in],
                [chmod +x tests/autoupdate])
AC_CONFIG_FILES([tests/ifnames:tests/wrapper.in],
                [chmod +x tests/ifnames])
AC_PATH_PROG([EXPR], [expr])


## ---- ##
## M4.  ##
## ---- ##

# We use a path for GNU m4 so even if users have another m4 first in
# their path, the installer can configure with a path that has GNU m4
# first and get that path embedded in the installed autoconf and
# autoheader scripts.
AC_PROG_GNU_M4
if test x"$ac_cv_prog_gnu_m4" != xyes; then
  AC_MSG_ERROR([GNU M4 1.4 is required])
fi

## ----------- ##
## Man pages.  ##
## ----------- ##

AC_CONFIG_FILES(man/Makefile)
AM_MISSING_PROG(HELP2MAN, help2man)


## ------ ##
## Perl.  ##
## ------ ##

# We use a path for perl so the #! line in autoscan will work.
AC_PATH_PROG([PERL], perl, no)
AC_SUBST([PERL])dnl
if test "$PERL" = no; then
  AC_MSG_ERROR([perl is not found])
fi
$PERL -e 'require 5.005_03;' || {
   AC_MSG_ERROR([Perl 5.005_03 or better is required])
}


## ------- ##
## Emacs.  ##
## ------- ##

AC_CONFIG_FILES([lib/emacs/Makefile])
TEST_EMACS=$EMACS
test x"$TEST_EMACS" = xt && TEST_EMACS=
AC_CHECK_PROGS([TEST_EMACS], [emacs xemacs], [no])

# autoconf-mode.el and autotest-mode.el do not work with older version of
# Emacs (i.e. 18.x.x).  During byte-compilation, Emacs complains:
# "Variable (broken nil) seen on pass 2 of byte compiler but not pass 1"
# We detect this problem here.
AS_IF([test "$TEST_EMACS" != no],
  [AC_CACHE_CHECK([whether $TEST_EMACS is sufficiently recent],
    [ac_cv_prog_emacs_ok],
    [# Note: The quoted "EOF" is intentional.  It protects the ` in the text.
    cat >conftest.el << "EOF"
      (defvar broken)
      (defun broken-mode () (setq broken-defaults `(broken nil)))
EOF
    AS_IF([AC_RUN_LOG(
      [$TEST_EMACS -batch -q -f batch-byte-compile conftest.el 1>&2])],
      [ac_cv_prog_emacs_ok=yes], [ac_cv_prog_emacs_ok=no])
    rm -f conftest.el conftest.elc])
  AS_IF([test $ac_cv_prog_emacs_ok = no], [TEST_EMACS=no])])

AC_SUBST([EMACS], [$TEST_EMACS])

AM_PATH_LISPDIR


## ------------ ##
## Conclusion.  ##
## ------------ ##

AC_CONFIG_FILES([Makefile doc/Makefile
                 lib/Makefile lib/Autom4te/Makefile lib/autoscan/Makefile
                 lib/m4sugar/Makefile
                 lib/autoconf/Makefile lib/autotest/Makefile
                 bin/Makefile])

AC_OUTPUT
# Report the state of this version of Autoconf if this is a beta.
m4_bmatch(m4_defn([AC_PACKAGE_VERSION]),  [[a-z]],
[    cat <<EOF

You are about to use an experimental version of Autoconf.  Be sure to
read the relevant mailing lists, most importantly <autoconf@gnu.org>.

Below you will find information on the status of this version of Autoconf.


EOF
    sed -n '/^\* Status/,$p' $srcdir/BUGS
])
