divert(-1)                                                   -*- Autoconf -*-
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


## ----------------------------- ##
## 1. Wrappers around builtins.  ##
## ----------------------------- ##

# This section is lexicographically sorted.

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
[ifval([$2$3],
[if $1; then
  ifval([$2], [$2], :)
m4_ifvanl([$3],
[else
  $3])dnl
fi
])dnl
])# AS_IFELSE


# AS_UNSET(VAR, [VALUE-IF-UNSET-NOT-SUPPORTED = `'])
# --------------------------------------------------
# Try to unset the env VAR, otherwise set it to
# VALUE-IF-UNSET-NOT-SUPPORTED.  `ac_unset' must have been computed.
m4_define([AS_UNSET],
[$ac_unset $1 || test "${$1+set}" != set || { $1=$2; export $1; }])


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




## ------------------------------------------- ##
## 2. Portable versions of common file utils.  ##
## ------------------------------------------- ##

# This section is lexicographically sorted.


# AS_MKDIR_P(PATH)
# ----------------
# Emulate `mkdir -p' with plain `mkdir'.
m4_define([AS_MKDIR_P],
[{ case $1 in
  [[\\/]]* | ?:[[\\/]]* ) ac_incr_dir=;;
  *)                      ac_incr_dir=.;;
esac
ac_dummy="$1"
for ac_mkdir_dir in `IFS=/; set X $ac_dummy; shift; echo "$[@]"`; do
  ac_incr_dir=$ac_incr_dir/$ac_mkdir_dir
  test -d $ac_incr_dir || mkdir $ac_incr_dir
done; }
])# AS_MKDIR_P


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
m4_define([AS_DIRNAME_EXPR],
[expr X[]$1 : 'X\(.*[[^/]]\)//*[[^/][^/]]*/*$' \| \
      X[]$1 : 'X\(//\)[[^/]]' \| \
      X[]$1 : 'X\(//\)$' \| \
      X[]$1 : 'X\(/\)' \| \
      .     : '\(.\)'])

m4_define([AS_DIRNAME_SED],
[echo "X[]$1" |
    sed ['/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{ s//\1/; q; }
  	  /^X\(\/\/\)[^/].*/{ s//\1/; q; }
  	  /^X\(\/\/\)$/{ s//\1/; q; }
  	  /^X\(\/\).*/{ s//\1/; q; }
  	  s/.*/./; q']])

m4_define([AS_DIRNAME],
[AS_DIRNAME_EXPR([$1]) 2>/dev/null ||
AS_DIRNAME_SED([$1])])



## ------------------ ##
## 3. Common idioms.  ##
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
