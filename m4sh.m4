include(m4sugar.m4)#                                        -*- Autoconf -*-
# This file is part of Autoconf.
# M4 sugar for common shell constructs.
# Requires GNU M4 and M4sugar.
# Copyright 2000 Free Software Foundation, Inc.
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
#
# As a special exception, the Free Software Foundation gives unlimited
# permission to copy, distribute and modify the configure scripts that
# are the output of Autoconf.  You need not follow the terms of the GNU
# General Public License when using or distributing such scripts, even
# though portions of the text of Autoconf appear in them.  The GNU
# General Public License (GPL) does govern all other use of the material
# that constitutes the Autoconf program.
#
# Certain portions of the Autoconf source text are designed to be copied
# (in certain cases, depending on the input) into the output of
# Autoconf.  We call these the "data" portions.  The rest of the Autoconf
# source text consists of comments plus executable code that decides which
# of the data portions to output in any given case.  We call these
# comments and executable code the "non-data" portions.  Autoconf never
# copies any of the non-data portions into its output.
#
# This special exception to the GPL applies to versions of Autoconf
# released by the Free Software Foundation.  When you make and
# distribute a modified version of Autoconf, you may extend this special
# exception to the GPL to apply to your modified version as well, *unless*
# your modified version has the potential to copy into its output some
# of the text that was the non-data portion of the version that you started
# with.  (In other words, unless your change moves or copies text from
# the non-data portions to the data portions.)  If your modification has
# such potential, you must delete any notice of this special exception
# to the GPL from your modified version.
#
# Written by Akim Demaille, Pavel Roskin, Alexandre Oliva, Lars J. Aas
# and many other people.


## ------------------------- ##
## 1. Sanitizing the shell.  ##
## ------------------------- ##

# AS_SHELL_SANITIZE
# -----------------
# Try to be as Bourne and/or POSIX as possible.
m4_defun([AS_SHELL_SANITIZE],
[# Be Bourne compatible
if test -n "${ZSH_VERSION+set}" && (emulate sh) >/dev/null 2>&1; then
  emulate sh
  NULLCMD=:
elif test -n "${BASH_VERSION+set}" && (set -o posix) >/dev/null 2>&1; then
  set -o posix
fi

_AS_EXPR_PREPARE
_AS_UNSET_PREPARE

# NLS nuisances.
AS_UNSET([LANG],        [C])
AS_UNSET([LC_ALL],      [C])
AS_UNSET([LC_TIME],     [C])
AS_UNSET([LC_CTYPE],    [C])
AS_UNSET([LANGUAGE],    [C])
AS_UNSET([LC_COLLATE],  [C])
AS_UNSET([LC_NUMERIC],  [C])
AS_UNSET([LC_MESSAGES], [C])

# IFS
# We need space, tab and new line, in precisely that order.
ac_nl='
'
IFS=" 	$ac_nl"

# CDPATH.
AS_UNSET([CDPATH], [:])
])


## ----------------------------- ##
## 2. Wrappers around builtins.  ##
## ----------------------------- ##

# This section is lexicographically sorted.

# AS_EXIT([EXIT-CODE = 1])
# ------------------------
# Exit and set exit code to EXIT-CODE in the way that it's seen
# within "trap 0".
#
# We cannot simply use "exit N" because some shells (zsh and Solaris sh)
# will not set $? to N while running the code set by "trap 0"
# So we set $? by executing "exit N" in the subshell and then exit.
# "false" is used for exit code 1 (default), ":" is used for 0
m4_define([AS_EXIT],
[{ m4_case([$1],
           [0], [:; exit],
           [],  [false; exit],
           [1], [false; exit],
           [(exit $1); exit]); }])


# AS_IFELSE(TEST, [IF-TRUE], [IF-FALSE])
# --------------------------------------
# Expand into
# | if TEST; then
# |   IF-TRUE
# | else
# |   IF-FALSE
# | fi
# with simplifications is IF-TRUE and/or IF-FALSE is empty.
m4_define([AS_IFELSE],
[m4_ifval([$2$3],
[if $1; then
  m4_ifval([$2], [$2], :)
m4_ifvaln([$3],
[else
  $3])dnl
fi
])dnl
])# AS_IFELSE


# _AS_UNSET_PREPARE
# -----------------
# AS_UNSET depends upon $as_unset: compute it.
m4_defun([_AS_UNSET_PREPARE],
[# Support unset when possible.
if (FOO=FOO; unset FOO) >/dev/null 2>&1; then
  as_unset=unset
else
  as_unset=false
fi
])


# AS_UNSET(VAR, [VALUE-IF-UNSET-NOT-SUPPORTED = `'])
# --------------------------------------------------
# Try to unset the env VAR, otherwise set it to
# VALUE-IF-UNSET-NOT-SUPPORTED.  `ac_unset' must have been computed.
m4_defun([AS_UNSET],
[m4_require([_AS_UNSET_PREPARE])dnl
$as_unset $1 || test "${$1+set}" != set || { $1=$2; export $1; }])






## ------------------------------------------ ##
## 3. Error and warnings at the shell level.  ##
## ------------------------------------------ ##

# If AS_MESSAGE_LOG_FD is defined, shell messages are duplicated there
# too.


# _AS_QUOTE_IFELSE(STRING, IF-MODERN-QUOTATION, IF-OLD-QUOTATION)
# ---------------------------------------------------------------
# Compatibility glue between the old AS_MSG suite which did not
# quote anything, and the modern suite which quotes the quotes.
# If STRING contains `\\' or `\$', it's modern.
# If STRING contains `\"' or `\`', it's old.
# Otherwise it's modern.
# We use two quotes in the pattern to keep highlighting tools at peace.
m4_define([_AS_QUOTE_IFELSE],
[ifelse(m4_regexp([$1], [\\[\\$]]),
        [-1], [ifelse(m4_regexp([$1], [\\[`""]]),
                      [-1], [$2],
                      [$3])],
        [$2])])


# _AS_ECHO_UNQUOTED(STRING, [FD = AS_MESSAGE_FD])
# ---------------------------------------------------
# Perform shell expansions on STRING and echo the string to FD.
m4_define([_AS_ECHO_UNQUOTED],
[echo "$1" >&m4_default([$2], [AS_MESSAGE_FD])])


# _AS_QUOTE(STRING)
# -----------------
# If there are quoted (via backslash) backquotes do nothing, else
# backslash all the quotes.
# FIXME: In a distant future (2.51 or +), this warning should be
# classified as `syntax'.  It is classified as `obsolete' to ease
# the transition (for Libtool for instance).
m4_define([_AS_QUOTE],
[_AS_QUOTE_IFELSE([$1],
                  [m4_patsubst([$1], [\([`""]\)], [\\\1])],
                  [m4_warn([obsolete],
           [back quotes and double quotes should not be escaped in: $1])dnl
$1])])


# _AS_ECHO(STRING, [FD = AS_FD_MSG])
# ----------------------------------
# Protect STRING from backquote expansion, echo the result to FD.
m4_define([_AS_ECHO],
[_AS_ECHO_UNQUOTED([_AS_QUOTE([$1])], $2)])


# AS_MESSAGE(STRING, [FD = AS_MESSAGE_FD])
# --------------------------------------------
m4_define([AS_MESSAGE],
[m4_ifset([AS_MESSAGE_LOG_FD],
          [{ _AS_ECHO([$as_me:__oline__: $1], [AS_MESSAGE_LOG_FD])
_AS_ECHO($@);}],
          [_AS_ECHO($@)])[]dnl
])


# AS_WARN(PROBLEM)
# ----------------
m4_define([AS_WARN],
[m4_ifset([AS_MESSAGE_LOG_FD],
          [{ _AS_ECHO([$as_me:__oline__: WARNING: $1], [AS_MESSAGE_LOG_FD])
_AS_ECHO([$as_me: warning: $1], 2); }],
          [_AS_ECHO([$as_me: warning: $1], 2)])[]dnl
])# AS_WARN


# AS_ERROR(ERROR, [EXIT-STATUS = 1])
# ----------------------------------
m4_define([AS_ERROR],
[{m4_ifset([AC_LOG_FD],
           [_AS_ECHO([$as_me:__oline__: error: $1], [AS_MESSAGE_LOG_FD])
])[]dnl
  _AS_ECHO([$as_me: error: $1], 2)
  AS_EXIT([$2]); }[]dnl
])# AS_ERROR



## -------------------------------------- ##
## 4. Portable versions of common tools.  ##
## -------------------------------------- ##

# This section is lexicographically sorted.


# AS_DIRNAME(PATHNAME)
# --------------------
# Simulate running `dirname(1)' on PATHNAME, not all systems have it.
# This macro must be usable from inside ` `.
#
# Prefer expr to echo|sed, since expr is usually faster and it handles
# backslashes and newlines correctly.  However, older expr
# implementations (e.g. SunOS 4 expr and Solaris 8 /usr/ucb/expr) have
# a silly length limit that causes expr to fail if the matched
# substring is longer than 120 bytes.  So fall back on echo|sed if
# expr fails.
#
# FIXME: Please note the following m4_require is quite wrong: if the first
# occurrence of AS_DIRNAME_EXPR is in a backquoted expression, the
# shell will be lost.  We might have to introduce diversions for
# setting up an M4sh script: required macros will then be expanded there.
m4_defun([AS_DIRNAME_EXPR],
[m4_require([_AS_EXPR_PREPARE])dnl
$as_expr X[]$1 : 'X\(.*[[^/]]\)//*[[^/][^/]]*/*$' \| \
         X[]$1 : 'X\(//\)[[^/]]' \| \
         X[]$1 : 'X\(//\)$' \| \
         X[]$1 : 'X\(/\)' \| \
         .     : '\(.\)'])

m4_defun([AS_DIRNAME_SED],
[echo X[]$1 |
    sed ['/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{ s//\1/; q; }
  	  /^X\(\/\/\)[^/].*/{ s//\1/; q; }
  	  /^X\(\/\/\)$/{ s//\1/; q; }
  	  /^X\(\/\).*/{ s//\1/; q; }
  	  s/.*/./; q']])

m4_defun([AS_DIRNAME],
[AS_DIRNAME_EXPR([$1]) 2>/dev/null ||
AS_DIRNAME_SED([$1])])


# _AS_EXPR_PREPARE
# ----------------
# Some expr work properly (i.e. compute and issue the right result),
# but exit with failure.  When a fall back to expr (as in AS_DIRNAME)
# is provided, you get twice the result.  Prevent this.
m4_defun([_AS_EXPR_PREPARE],
[as_expr=`expr a : '\(a\)'`
case $as_expr,$? in
  a,0) as_expr=expr;;
    *) as_expr=false;;
esac[]dnl
])# _AS_EXPR_PREPARE


# AS_MKDIR_P(PATH)
# ----------------
# Emulate `mkdir -p' with plain `mkdir'.
m4_define([AS_MKDIR_P],
[{ case $1 in
  [[\\/]]* | ?:[[\\/]]* ) ac_incr_dir=;;
  *)                      ac_incr_dir=.;;
esac
ac_dummy=$1
for ac_mkdir_dir in `IFS=/; set X $ac_dummy; shift; echo "$[@]"`; do
  ac_incr_dir=$ac_incr_dir/$ac_mkdir_dir
  test -d $ac_incr_dir || mkdir $ac_incr_dir
done; }
])# AS_MKDIR_P



## ------------------ ##
## 5. Common idioms.  ##
## ------------------ ##

# This section is lexicographically sorted.

# AS_TMPDIR(PREFIX)
# -----------------
# Create as safely as possible a temporary directory which name is
# inspired by PREFIX (should be 2-4 chars max), and set trap
# mechanisms to remove it.
m4_define([AS_TMPDIR],
[# Create a temporary directory, and hook for its removal unless debugging.
$debug ||
{
  trap 'exit_status=$?; rm -rf $tmp && exit $exit_status' 0
  trap 'AS_EXIT([$?])' 1 2 13 15
}

# Create a (secure) tmp directory for tmp files.
: ${TMPDIR=/tmp}
{
  tmp=`(umask 077 && mktemp -d -q "$TMPDIR/$1XXXXXX") 2>/dev/null` &&
  test -n "$tmp" && test -d "$tmp"
}  ||
{
  tmp=$TMPDIR/$1$$-$RANDOM
  (umask 077 && mkdir $tmp)
} ||
{
   echo "$me: cannot create a temporary directory in $TMPDIR" >&2
   AS_EXIT
}dnl
])# AS_TMPDIR
