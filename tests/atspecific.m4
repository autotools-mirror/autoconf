divert(-1)						-*- Autoconf -*-
# `m4' macros used in building Autoconf test suites.

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

include(atgeneral.m4)m4_divert(-1)



## ---------------------------------------- ##
## Macros specialized in testing Autoconf.  ##
## ---------------------------------------- ##


# AT_CHECK_AUTOCONF
# -----------------
AT_DEFINE([AT_CHECK_AUTOCONF],
[AT_CLEANUP_FILES(configure)dnl
AT_CHECK([autoconf --autoconf-dir .. -l $at_srcdir], 0, [], [])])


# AT_CHECK_AUTOHEADER
# -------------------
AT_DEFINE([AT_CHECK_AUTOHEADER],
[AT_CLEANUP_FILES(config.hin)dnl
AT_CHECK([autoheader --autoconf-dir .. -l $at_srcdir], 0, [], [])])


# AT_CHECK_CONFIGURE
# -------------------
AT_DEFINE([AT_CHECK_CONFIGURE],
[AT_CLEANUP_FILE_IFELSE([config.hin],
                        [AT_CLEANUP_FILE(config.h)])dnl
AT_CLEANUP_FILES(config.log config.status config.cache)dnl
AT_CHECK([top_srcdir=$top_srcdir ./configure], 0, ignore, [])
test $at_verbose = echo && echo "--- config.log" && cat config.log])


# _AT_CHECK_AC_MACRO(AC-BODY, PRE-TESTS)
# --------------------------------------
# Create a minimalist configure.in running the macro named
# NAME-OF-THE-MACRO, check that autoconf runs on that script,
# and that the shell runs correctly the configure.
# TOP_SRCDIR is needed to set the auxdir (some macros need `install-sh',
# `config.guess' etc.).
AT_DEFINE([_AT_CHECK_AC_MACRO],
[dnl Produce the configure.in
AT_CLEANUP_FILES(env-after state*)dnl
AT_DATA([configure.in],
[AC_INIT
AC_CONFIG_AUX_DIR($top_srcdir)
AC_CONFIG_HEADER(config.h:config.hin)
AC_STATE_SAVE(before)
$1
AC_STATE_SAVE(after)
AC_OUTPUT
])
$2
AT_CHECK_AUTOCONF
AT_CHECK_AUTOHEADER
AT_CHECK_CONFIGURE

dnl Some tests might exit prematurely when they find a problem, in
dnl which case `env-after' is probably missing.  Don't check it then.
if test -f state-env.after; then
  cp -f state-env.before expout
  AT_CHECK([cat state-env.after], 0, expout)
  cp -f state-ls.before expout
  AT_CHECK([cat state-ls.after], 0, expout)
fi
])# _AT_CHECK_AC_MACRO


# AT_CHECK_MACRO(NAME-OF-THE-MACRO, [MACRO-USE], [ADDITIONAL-CMDS])
# -----------------------------------------------------------------
# Create a minimalist configure.in running the macro named
# NAME-OF-THE-MACRO, check that autoconf runs on that script,
# and that the shell runs correctly the configure.
# TOP_SRCDIR is needed to set the auxdir (some macros need `install-sh',
# `config.guess' etc.).
AT_DEFINE([AT_CHECK_MACRO],
[AT_SETUP([$1])

_AT_CHECK_AC_MACRO([ifelse([$2],,[$1], [$2])])
$3
AT_CLEANUP()dnl
])# AT_CHECK_MACRO


# AT_CHECK_UPDATE(NAME-OF-THE-MACRO)
# ----------------------------------
# Create a minimalist configure.in running the macro named
# NAME-OF-THE-MACRO, autoupdate this script, check that autoconf runs
# on that script, and that the shell runs correctly the configure.
# TOP_SRCDIR is needed to set the auxdir (some macros need
# `install-sh', `config.guess' etc.).
AT_DEFINE([AT_CHECK_UPDATE],
[AT_SETUP([the autoupdating of $1])

_AT_CHECK_AC_MACRO([$1],
[AT_CHECK([autoupdate --autoconf-dir $at_top_srcdir], 0,
          [], [autoupdate: `configure.in' is updated
])])

AT_CLEANUP()dnl
])# AT_CHECK_UPDATE


# AT_CHECK_DEFINES(CONTENT)
# -------------------------
# Verify that config.h, once stripped is CONTENT.
# Stripping consists of keeping CPP lines (i.e. containing a hash),
# but those of automatically checked features (STDC_HEADERS etc.).
# AT_CHECK_HEADER is a better name, but too close from AC_CHECK_HEADER.
AT_DEFINE(AT_CHECK_DEFINES,
[AT_CHECK([[fgrep '#' config.h | grep -v 'STDC_HEADERS']],, [$1])])
