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

## ------------------------------ ##
## Setting up base layer macros.  ##
## ------------------------------ ##

include(atgeneral.m4)divert(-1)

# Until the day Autotest, Ad'HoC and Autoconf share the same libm4, we
# have to reinstall some m4 builtins that atgeneral.m4 undefined.
AT_DEFINE([m4_shift],
[builtin([shift], $@)])
AT_DEFINE([define],
[builtin([define], $@)])


# m4_for(VARIABLE, FROM, TO, EXPRESSION)
# --------------------------------------
# Expand EXPRESSION defining VARIABLE to FROM, FROM + 1, ..., TO.
# Both limits are included.
AT_DEFINE([m4_for],
[pushdef([$1], [$2])_m4_for([$1], [$2], [$3], [$4])popdef([$1])])

AT_DEFINE([_m4_for],
[$4[]ifelse($1, [$3], [],
            [define([$1], incr($1))_m4_for([$1], [$2], [$3], [$4])])])



# m4_foreach(VARIABLE, LIST, EXPRESSION)
# --------------------------------------
# Expand EXPRESSION assigning to VARIABLE each value of the LIST
# (LIST should have the form `[(item_1, item_2, ..., item_n)]'),
# i.e. the whole list should be *quoted*.  Quote members too if
# you don't want them to be expanded.
#
# This macro is robust to active symbols:
#    define(active, ACTIVE)
#    m4_foreach([Var], [([active], [b], [active])], [-Var-])end
#    => -active--b--active-end
define(m4_foreach,
[pushdef([$1], [])_m4_foreach($@)popdef([$1])])

dnl Low level macros used to define m4_foreach
define(m4_car, [[$1]])
define(_m4_foreach,
[ifelse($2, [()], ,
        [define([$1], [m4_car$2])$3[]_m4_foreach([$1],
                                                 [(m4_shift$2)],
                                                 [$3])])])



## ---------------------------------------- ##
## Macros specialized in testing Autoconf.  ##
## ---------------------------------------- ##


# _AT_CHECK_AC_MACRO(AC-BODY)
# ---------------------------
# Create a minimalist configure.in running the macro named
# NAME-OF-THE-MACRO, check that autoconf runs on that script,
# and that the shell runs correctly the configure.
# TOP_SRCDIR is needed to set the auxdir (some macros need `install-sh',
# `config.guess' etc.).
AT_DEFINE([_AT_CHECK_AC_MACRO],
[dnl Produce the configure.in
AT_DATA([configure.in],
[AC_INIT
AC_CONFIG_AUX_DIR($top_srcdir)
AC_CONFIG_HEADER(config.h:config.hin)
AC_ENV_SAVE(expout)
$1
AC_ENV_SAVE(env-after)
AC_OUTPUT
])

dnl FIXME: Here we just don't consider the stderr from Autoconf.
dnl Maybe some day we could be more precise and filter out warnings.
dnl The problem is that currently some warnings are spread on several
dnl lines, so grepping -v warning is not enough.
AT_CHECK([autoconf --autoconf-dir .. -l $at_srcdir], 0,, ignore)
AT_CHECK([autoheader --autoconf-dir .. -l $at_srcdir], 0,, ignore)
AT_CHECK([top_srcdir=$top_srcdir ./configure], 0, ignore, ignore)
test -n "$at_verbose" && echo "--- config.log" && cat config.log

dnl Some tests might exit prematurely when they find a problem, in
dnl which case `env-after' is probably missing.  Don't check it then.
if test -f env-after; then
  AT_CHECK([cat env-after], 0, expout)
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
AT_CLEANUP(configure config.status config.log config.cache config.hin config.h env-after)dnl
])# AT_CHECK_MACRO


# AT_CHECK_DEFINES(CONTENT)
# -------------------------
# Verify that config.h, once stripped is CONTENT.
# Stripping consists of keeping CPP lines (i.e. containing a hash),
# but those of automatically checked features (STDC_HEADERS etc.).
# AT_CHECK_HEADER is a better name, but too close from AC_CHECK_HEADER.
AT_DEFINE(AT_CHECK_DEFINES,
[AT_CHECK([[fgrep '#' config.h | grep -v 'STDC_HEADERS']],, [$1])])

divert(0)dnl
