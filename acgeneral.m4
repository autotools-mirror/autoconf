# This file is part of Autoconf.                       -*- Autoconf -*-
# Parameterized macros.
# Copyright (C) 1992, 93, 94, 95, 96, 98, 99, 2000
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
# Written by David MacKenzie, with help from
# Franc,ois Pinard, Karl Berry, Richard Pixley, Ian Lance Taylor,
# Roland McGrath, Noah Friedman, david d zuhn, and many others.

m4_namespace_push(autoconf)



## ---------------- ##
## The diversions.  ##
## ---------------- ##


# We heavily use m4's diversions both for the initializations and for
# required macros (see AC_REQUIRE), because in both cases we have to
# issue high in `configure' something which is discovered late.
#
# KILL is only used to suppress output.
#
# The initialization layers of `configure'.  We let m4 undivert them
# by itself, when it reaches the end of `configure.in'.  They are.
#
# - BINSH
#   AC_REQUIRE'd #! /bin/sh line
# - NOTICE
#   copyright notice(s)
# - DEFAULTS
#   early initializations (defaults)
# - INIT_PARSE_ARGS
#   initialization code, option handling loop.
# - HELP_BEGIN
#   Handling `configure --help'.
# - HELP_CANON
#   Help msg for AC_CANONICAL_*
# - HELP_ENABLE
#   Help msg from AC_ARG_ENABLE.
# - HELP_WITH
#   Help msg from AC_ARG_WITH.
# - HELP_VAR
#   Help msg from AC_ARG_VAR.
# - HELP_END
#   Tail of the handling of --help.
# - VERSION_BEGIN
#   Copyright notice for --version.
# - VERSION_END
#   Tail of the handling of --version.
# - INIT_PREPARE
#   Tail of initialization code.
#
#
# These diversions are used by AC_REQUIRE.
#
# - NORMAL_4
#   AC_REQUIRE'd code, 4 level deep
# - NORMAL_3
#   AC_REQUIRE'd code, 3 level deep
# - NORMAL_2
#   AC_REQUIRE'd code, 2 level deep
# - NORMAL_1
#   AC_REQUIRE'd code, 1 level deep
# - NORMAL
#   the tests and output code


# _AC_DIVERT(DIVERSION-NAME)
# --------------------------
# Convert a diversion name into its number.  Otherwise, return
# DIVERSION-NAME which is supposed to be an actual diversion number.
# Of course it would be nicer to use m4_case here, instead of zillions
# of little macros, but it then takes twice longer to run `autoconf'!
define([_AC_DIVERT(KILL)],           -1)

define([_AC_DIVERT(BINSH)],           0)
define([_AC_DIVERT(NOTICE)],          1)
define([_AC_DIVERT(DEFAULTS)],        2)
define([_AC_DIVERT(INIT_PARSE_ARGS)], 3)

define([_AC_DIVERT(HELP_BEGIN)],     10)
define([_AC_DIVERT(HELP_CANON)],     11)
define([_AC_DIVERT(HELP_ENABLE)],    12)
define([_AC_DIVERT(HELP_WITH)],      13)
define([_AC_DIVERT(HELP_VAR)],       14)
define([_AC_DIVERT(HELP_END)],       15)

define([_AC_DIVERT(VERSION_BEGIN)],  20)
define([_AC_DIVERT(VERSION_END)],    21)

define([_AC_DIVERT(INIT_PREPARE)],   30)

define([_AC_DIVERT(NORMAL_4)],       50)
define([_AC_DIVERT(NORMAL_3)],       51)
define([_AC_DIVERT(NORMAL_2)],       52)
define([_AC_DIVERT(NORMAL_1)],       53)
define([_AC_DIVERT(NORMAL)],         54)

define([_AC_DIVERT],
[ifdef([_AC_DIVERT($1)],
       [indir([_AC_DIVERT($1)])],
       [$1])])


# AC_DIVERT_PUSH(DIVERSION-NAME)
# ------------------------------
# Change the diversion stream to DIVERSION-NAME, while stacking old values.
define(AC_DIVERT_PUSH,
[pushdef([AC_DIVERT_DIVERSION], _AC_DIVERT([$1]))dnl
divert(AC_DIVERT_DIVERSION)dnl
])


# AC_DIVERT_POP
# -------------
# Change the diversion stream to its previous value, unstacking it.
define(AC_DIVERT_POP,
[popdef([AC_DIVERT_DIVERSION])dnl
ifndef([AC_DIVERT_DIVERSION], [AC_FATAL([too many AC_DIVERT_POP])])dnl
divert(AC_DIVERT_DIVERSION)dnl
])


# AC_DIVERT(DIVERSION-NAME, CONTENT)
# ----------------------------------
# Output CONTENT into DIVERSION-NAME (which may be a number actually).
# An end of line is appended for free to CONTENT.
define([AC_DIVERT],
[AC_DIVERT_PUSH([$1])dnl
$2
AC_DIVERT_POP()dnl
])


# Initialize the diversion setup.
define([AC_DIVERT_DIVERSION], _AC_DIVERT([NORMAL]))
# Throw away output until AC_INIT is called.
pushdef([AC_DIVERT_DIVERSION], _AC_DIVERT([KILL]))



## ------------------------------- ##
## Defining macros in autoconf::.  ##
## ------------------------------- ##


# AC_PRO(MACRO-NAME)
# ------------------
# The prologue for Autoconf macros.
define(AC_PRO,
[AC_PROVIDE([$1])dnl
ifelse(AC_DIVERT_DIVERSION, _AC_DIVERT([NORMAL]),
       [AC_DIVERT_PUSH(m4_eval(AC_DIVERT_DIVERSION - 1))],
       [pushdef([AC_DIVERT_DIVERSION], AC_DIVERT_DIVERSION)])dnl
])


# AC_EPI
# ------
# The Epilogue for Autoconf macros.
define(AC_EPI,
[AC_DIVERT_POP()dnl
ifelse(AC_DIVERT_DIVERSION, _AC_DIVERT([NORMAL]),
[undivert(_AC_DIVERT([NORMAL_4]))dnl
undivert(_AC_DIVERT([NORMAL_3]))dnl
undivert(_AC_DIVERT([NORMAL_2]))dnl
undivert(_AC_DIVERT([NORMAL_1]))dnl
])dnl
])


# AC_DEFUN(NAME, [REPLACED-FUNCTION, ARGUMENT, ]EXPANSION)
# --------------------------------------------------------
#
# Define a macro which automatically provides itself.  Add machinery
# so the macro automatically switches expansion to the diversion
# stack if it is not already using it.  In this case, once finished,
# it will bring back all the code accumulated in the diversion stack.
# This, combined with AC_REQUIRE, achieves the topological ordering of
# macros.  We don't use this macro to define some frequently called
# macros that are not involved in ordering constraints, to save m4
# processing.
#
# If the REPLACED-FUNCTION and ARGUMENT are defined, then declare that
# NAME is a specialized version of REPLACED-FUNCTION when its first
# argument is ARGUMENT.  For instance AC_TYPE_SIZE_T is a specialization
# of AC_CHECK_TYPE applied to `size_t'.
#
# This feature is not documented on purpose.  It might change in the
# future.
define([AC_DEFUN],
[ifelse([$3],,
        [define([$1], [AC_PRO([$1])$2[]AC_EPI()])],
        [define([$2-$3], [$1])
define([$1], [AC_PRO([$1])$4[]AC_EPI()])])])


# AC_DEFUN_ONCE(NAME, EXPANSION)
# ------------------------------
# As AC_DEFUN, but issues the EXPANSION only once, and warns if used
# several times.
define([AC_DEFUN_ONCE],
[define([$1],
[AC_PROVIDE_IFELSE([$1],
                   [AC_DIAGNOSE([syntax], [$1 invoked multiple times])],
                   [AC_PRO([$1])$2[]AC_EPI()])])])


# AC_DEFUNCT(NAME, COMMENT)
# -------------------------
# Declare the macro NAME no longer exists, and must not be used.
define([AC_DEFUNCT],
[define([$1], [AC_FATAL([$1] is defunct[$2])])])


# AC_OBSOLETE(THIS-MACRO-NAME, [SUGGESTION])
# ------------------------------------------
define(AC_OBSOLETE,
[AC_DIAGNOSE([obsolete], [$1 is obsolete$2])])


# AC_SPECIALIZE(MACRO, ARG1 [, ARGS...])
# --------------------------------------
#
# Basically calls the macro MACRO with arguments ARG1, ARGS... But if
# there exist a specialized version of MACRO for ARG1, use this macro
# instead with arguments ARGS (i.e., ARG1 is *not* given).  See the
# definition of `AC_DEFUN'.
define(AC_SPECIALIZE,
[ifdef([$1-$2],
       [indir([$1-$2], m4_shift(m4_shift($@)))],
       [indir([$1], m4_shift($@))])])




## ----------------------------- ##
## Dependencies between macros.  ##
## ----------------------------- ##


# AC_BEFORE(THIS-MACRO-NAME, CALLED-MACRO-NAME)
# ---------------------------------------------
define(AC_BEFORE,
[AC_PROVIDE_IFELSE([$2], [AC_DIAGNOSE([syntax], [$2 was called before $1])])])


# AC_REQUIRE(MACRO-NAME)
# ----------------------
# If MACRO-NAME has never been expanded, expand it *before* the current
# macro expansion.
define(AC_REQUIRE,
[AC_PROVIDE_IFELSE([$1],
                   [],
                   [AC_DIVERT(m4_eval(AC_DIVERT_DIVERSION - 1), [$1])])dnl
])


# AC_EXPAND_ONCE(TEXT)
# --------------------
# If TEXT has never been expanded, expand it *here*.
define(AC_EXPAND_ONCE,
[AC_PROVIDE_IFELSE([$1],
                   [],
                   [AC_PROVIDE([$1])[]$1])])


# AC_PROVIDE(MACRO-NAME)
# ----------------------
# We use `m4_define' and not `define' to avoid the cost of the name
# space machinery.  It makes no difference for any of the name
# spaces.
define(AC_PROVIDE,
[m4_define([AC_PROVIDE_$1])])


# AC_PROVIDE_IFELSE(MACRO-NAME, IF-PROVIDED, IF-NOT-PROVIDED)
# -----------------------------------------------------------
# If MACRO-NAME is provided do IF-PROVIDED, else IF-NOT-PROVIDED.
# The purpose of this macro is to provide the user with a means to
# check macros which are provided without letting her know how the
# information is coded.
define(AC_PROVIDE_IFELSE,
[ifdef([AC_PROVIDE_$1],
       [$2], [$3])])




## --------------------------------- ##
## Defining macros in autoupdate::.  ##
## --------------------------------- ##


# AU_DEFINE(NAME, GLUE-CODE, [MESSAGE])
# -------------------------------------
#
# Declare `autoupdate::NAME' to be `GLUE-CODE', with all the needed
# wrapping actions required by `autoupdate'.
# We do not define anything in `autoconf::'.
define(AU_DEFINE,
[m4_namespace_define(autoupdate, [$1],
[m4_changequote([, ])m4_dnl
m4_enable(libm4)m4_dnl
m4_warn([Updating use of `$1'. $3])m4_dnl
$2[]m4_dnl
m4_disable(libm4)m4_dnl
m4_changequote(, )m4_dnl
])])


# AU_DEFUN(NAME, NEW-CODE, [MESSAGE])
# -----------------------------------
# Declare that the macro NAME is now obsoleted, and should be replaced
# by NEW-CODE.  Tell the user she should run autoupdate, and include
# the additional MESSAGE.
#
# Also define NAME as a macro which code is NEW-CODE.
#
# This allows to share the same code for both supporting obsoleted macros,
# and to update a configure.in.
# See `acobsolete.m4' for a longer description.
define(AU_DEFUN,
[define([$1],
[AC_DIAGNOSE([obsolete], [The macro `$1' is obsolete.
You should run autoupdate.])dnl
$2])dnl
AU_DEFINE([$1], [$2], [$3])dnl
])



## ------------------------- ##
## Interface to autoheader.  ##
## ------------------------- ##


# AH_OUTPUT(KEY, TEXT)
# --------------------
# Pass TEXT to autoheader.
# This macro is `read' only via `autoconf --trace', it outputs nothing.
define([AH_OUTPUT], [])


# AH_VERBATIM(KEY, TEMPLATE)
# --------------------------
# If KEY is direct (i.e., no indirection such as in KEY=$my_func which
# may occur if there is AC_CHECK_FUNCS($my_func)), issue an autoheader
# TEMPLATE associated to the KEY.  Otherwise, do nothing.  TEMPLATE is
# output as is, with no formating.
define([AH_VERBATIM],
[AC_VAR_IF_INDIR([$1],,
                 [AH_OUTPUT([$1], _AC_SH_QUOTE([[$2]]))])
])


# AH_TEMPLATE(KEY, DESCRIPTION)
# -----------------------------
# Issue an autoheader template for KEY, i.e., a comment composed of
# DESCRIPTION (properly wrapped), and then #undef KEY.
define([AH_TEMPLATE],
[AH_VERBATIM([$1],
             m4_wrap([$2 */], [   ], [/* ])[
#undef $1])])


# AH_TOP(TEXT)
# ------------
# Output TEXT at the top of `config.h.in'.
define([AH_TOP],
[m4_define([_AH_COUNTER], incr(_AH_COUNTER))dnl
AH_VERBATIM([0000]_AH_COUNTER, [$1])])


# AH_BOTTOM(TEXT)
# ---------------
# Output TEXT at the bottom of `config.h.in'.
define([AH_BOTTOM],
[m4_define([_AH_COUNTER], incr(_AH_COUNTER))dnl
AH_VERBATIM([zzzz]_AH_COUNTER, [$1])])

# Initialize.
define([_AH_COUNTER], [0])


## --------------------- ##
## Some /bin/sh idioms.  ##
## --------------------- ##


# AC_SHELL_IFELSE(TEST, [IF-TRUE], [IF-FALSE])
# --------------------------------------------
# Expand into
# | if TEST; then
# |   IF-TRUE
# | else
# |   IF-FALSE
# | fi
# with simplifications is IF-TRUE and/or IF-FALSE is empty.
define([AC_SHELL_IFELSE],
[ifval([$2$3],
[if $1; then
  ifval([$2], [$2], :)
ifval([$3],
[else
  $3
])dnl
fi
])dnl
])# AC_SHELL_IFELSE


# _AC_SHELL_TMPDIR(PREFIX)
# ----------------------
# Create as safely as possible a temporary directory which name is
# inspired by PREFIX (should be 2-4 chars max), and set trap
# mechanisms to remove it.
define([_AC_SHELL_TMPDIR],
[# Create a temporary directory, and hook for its removal unless debugging.
$debug ||
{
  trap 'exit_status=$?; rm -rf $tmp && exit $exit_status' 0
  trap 'exit $?' 1 2 13 15
}

# Create a (secure) tmp directory for tmp files.
: ${TMPDIR=/tmp}
{
  tmp=`(umask 077 && mktemp -d -q "$TMPDIR/$1XXXXXX") 2>/dev/null` &&
  test -n "$tmp"
}  ||
{
  tmp=$TMPDIR/$1$$-$RANDOM && (umask 077 && mkdir $tmp)
} ||
{
   echo "$me: cannot create a temporary directory in $TMPDIR" >&2
   exit 1;
}dnl
])# _AC_SHELL_TMPDIR


## --------------------------------------------------- ##
## Common m4/sh handling of variables (indirections).  ##
## --------------------------------------------------- ##


# The purpose of this section is to provide a uniform API for
# reading/setting sh variables with or without indirection.
# Typically, one can write
#   AC_VAR_SET(var, val)
# or
#   AC_VAR_SET(ac_$var, val)
# and expect the right thing to happen.

# AC_VAR_IF_INDIR(EXPRESSION, IF-INDIR, IF-NOT-INDIR)
# ---------------------------------------------------
# If EXPRESSION has shell indirections ($var or `expr`), expand
# IF-INDIR, else IF-NOT-INDIR.
define(AC_VAR_IF_INDIR,
[ifelse(regexp([$1], [[`$]]),
        -1, [$3],
        [$2])])

# AC_VAR_SET(VARIABLE, VALUE)
# ---------------------------
# Set the VALUE of the shell VARIABLE.
# If the variable contains indirections (e.g. `ac_cv_func_$ac_func')
# perform whenever possible at m4 level, otherwise sh level.
define(AC_VAR_SET,
[AC_VAR_IF_INDIR([$1],
                 [eval "$1=$2"],
                 [$1=$2])])


# AC_VAR_GET(VARIABLE)
# --------------------
# Get the value of the shell VARIABLE.
# Evaluates to $VARIABLE if there are no indirection in VARIABLE,
# else into the appropriate `eval' sequence.
define(AC_VAR_GET,
[AC_VAR_IF_INDIR([$1],
                 [`eval echo '${'patsubst($1, [[\\`]], [\\\&])'}'`],
                 [$[]$1])])


# AC_VAR_TEST_SET(VARIABLE)
# -------------------------
# Expands into the `test' expression which is true if VARIABLE
# is set.  Polymorphic.  Should be dnl'ed.
define(AC_VAR_TEST_SET,
[AC_VAR_IF_INDIR([$1],
           [eval "test \"\${$1+set}\" = set"],
           [test "${$1+set}" = set])])



# AC_VAR_IF_SET(VARIABLE, IF-TRUE, IF-FALSE)
# ------------------------------------------
# Implement a shell `if-then-else' depending whether VARIABLE is set
# or not.  Polymorphic.
define(AC_VAR_IF_SET,
[AC_SHELL_IFELSE([AC_VAR_TEST_SET([$1])], [$2], [$3])])


# AC_VAR_PUSHDEF and AC_VAR_POPDEF
# --------------------------------
#

# Sometimes we may have to handle literals (e.g. `stdlib.h'), while at
# other moments, the same code may have to get the value from a
# variable (e.g., `ac_header').  To have a uniform handling of both
# cases, when a new value is about to be processed, declare a local
# variable, e.g.:
#
#   AC_VAR_PUSHDEF([header], [ac_cv_header_$1])
#
# and then in the body of the macro, use `header' as is.  It is of
# first importance to use `AC_VAR_*' to access this variable.  Don't
# quote its name: it must be used right away by m4.
#
# If the value `$1' was a literal (e.g. `stdlib.h'), then `header' is
# in fact the value `ac_cv_header_stdlib_h'.  If `$1' was indirect,
# then `header's value in m4 is in fact `$ac_header', the shell
# variable that holds all of the magic to get the expansion right.
#
# At the end of the block, free the variable with
#
#   AC_VAR_POPDEF([header])


# AC_VAR_PUSHDEF(VARNAME, VALUE)
# ------------------------------
# Define the m4 macro VARNAME to an accessor to the shell variable
# named VALUE.  VALUE does not need to be a valid shell variable name:
# the transliteration is handled here.  To be dnl'ed.
define(AC_VAR_PUSHDEF,
[AC_VAR_IF_INDIR([$2],
[ac_$1=AC_TR_SH($2)
pushdef([$1], [$ac_[$1]])],
[pushdef([$1], [AC_TR_SH($2)])])])


# AC_VAR_POPDEF(VARNAME)
# ----------------------
# Free the shell variable accessor VARNAME.  To be dnl'ed.
define(AC_VAR_POPDEF,
[popdef([$1])])



## ------------------------------------ ##
## Common m4/sh character translation.  ##
## ------------------------------------ ##

# The point of this section is to provide high level functions
# comparable to m4's `translit' primitive, but m4:sh polymorphic.
# Transliteration of literal strings should be handled by m4, while
# shell variables' content will be translated at runtime (tr or sed).

# AC_TR_CPP(EXPRESSION)
# ---------------------
# Map EXPRESSION to an upper case string which is valid as rhs for a
# `#define'.  sh/m4 polymorphic.  Make sure to update the definition
# of `$ac_tr_cpp' if you change this.
define(AC_TR_CPP,
[AC_VAR_IF_INDIR([$1],
  [`echo "$1" | $ac_tr_cpp`],
  [patsubst(translit([[$1]],
                     [*abcdefghijklmnopqrstuvwxyz],
                     [PABCDEFGHIJKLMNOPQRSTUVWXYZ]),
            [[^A-Z0-9_]], [_])])])


# AC_TR_SH(EXPRESSION)
# --------------------
# Transform EXPRESSION into a valid shell variable name.
# sh/m4 polymorphic.
# Make sure to update the definition of `$ac_tr_sh' if you change this.
define(AC_TR_SH,
[AC_VAR_IF_INDIR([$1],
  [`echo "$1" | $ac_tr_sh`],
  [patsubst(translit([[$1]], [*+], [pp]),
            [[^a-zA-Z0-9_]], [_])])])



## ----------------------------- ##
## Implementing Autoconf loops.  ##
## ----------------------------- ##


# AC_FOREACH(VARIABLE, LIST, EXPRESSION)
# --------------------------------------
#
# Compute EXPRESSION assigning to VARIABLE each value of the LIST.
# LIST is a /bin/sh list, i.e., it has the form ` item_1 item_2
# ... item_n ': white spaces are separators, and leading and trailing
# spaces are meaningless.
#
# This macro is robust to active symbols:
#    AC_FOREACH([Var], [ active
#    b	act\
#    ive  ], [-Var-])end
#    => -active--b--active-end
define([AC_FOREACH],
[m4_foreach([$1], (m4_split(m4_strip(m4_join([$2])))), [$3])])




## ----------------------------------- ##
## Helping macros to display strings.  ##
## ----------------------------------- ##


# AC_HELP_STRING(LHS, RHS, [COLUMN])
# ----------------------------------
#
# Format an Autoconf macro's help string so that it looks pretty when
# the user executes "configure --help".  This macro takes three
# arguments, a "left hand side" (LHS), a "right hand side" (RHS), and
# the COLUMN which is a string of white spaces which leads to the
# the RHS column (default: 26 white spaces).
#
# The resulting string is suitable for use in other macros that require
# a help string (e.g. AC_ARG_WITH).
#
# Here is the sample string from the Autoconf manual (Node: External
# Software) which shows the proper spacing for help strings.
#
#    --with-readline         support fancy command line editing
#  ^ ^                       ^
#  | |                       |
#  | column 2                column 26
#  |
#  column 0
#
# A help string is made up of a "left hand side" (LHS) and a "right
# hand side" (RHS).  In the example above, the LHS is
# "--with-readline", while the RHS is "support fancy command line
# editing".
#
# If the LHS extends past column 24, then the LHS is terminated with a
# newline so that the RHS is on a line of its own beginning in column
# 26.
#
# Therefore, if the LHS were instead "--with-readline-blah-blah-blah",
# then the AC_HELP_STRING macro would expand into:
#
#
#    --with-readline-blah-blah-blah
#  ^ ^                       support fancy command line editing
#  | |                       ^
#  | column 2                |
#  column 0                  column 26
#
define([AC_HELP_STRING],
[pushdef([AC_Prefix], m4_default([$3], [                          ]))dnl
pushdef([AC_Prefix_Format], [  %-]m4_eval(len(AC_Prefix) - 3)[s ])dnl [  %-23s ]
m4_wrap([$2], AC_Prefix, m4_format(AC_Prefix_Format, [$1]))dnl
popdef([AC_Prefix_Format])dnl
popdef([AC_Prefix])dnl
])




## ---------------------------------------------- ##
## Information on the package being Autoconf'ed.  ##
## ---------------------------------------------- ##


# It is suggested that the macros in this section appear before
# AC_INIT in `configure.in'.  Nevertheless, this is just stylistic,
# and from the implementation point of, AC_INIT *must* be expanded
# beforehand: it puts data in diversions which must appear before the
# data provided by the macros of this section.

# The solution is to require AC_INIT in each of these macros.  AC_INIT
# has the needed magic so that it can't be expanded twice.



# AC_PACKAGE(PACKAGE, VERSION, [BUG-REPORT])
# ------------------------------------------
AC_DEFUN(AC_PACKAGE,
[define([AC_PACKAGE_NAME],     [$1])dnl
define([AC_PACKAGE_VERSION],   [$2])dnl
define([AC_PACKAGE_STRING],    [$1 $2])dnl
define([AC_PACKAGE_BUGREPORT], [$3])dnl
])


# AC_COPYRIGHT(TEXT)
# ------------------
# Append Copyright information in the top of `configure'.  TEXT is
# evaluated once, hence TEXT can use macros.  Note that we do not
# prepend `# ' but `@%:@ ', since m4 does not evaluate the comments.
# Had we used `# ', the Copyright sent in the beginning of `configure'
# would have not been evaluated.  Another solution, a bit fragile,
# would have be to use m4_quote to force an evaluation:
#
#     patsubst(m4_quote($1), [^], [# ])
#
# AC_INIT must be run before, exactly like for AC_REVISION.
AC_DEFUN(AC_COPYRIGHT,
[AC_REQUIRE([AC_INIT])dnl
AC_DIVERT([NOTICE],
[patsubst([
$1], [^], [@%:@ ])])dnl
AC_DIVERT([VERSION_BEGIN],
[
$1])dnl
])# _AC_INIT_COPYRIGHT


# AC_REVISION(REVISION-INFO)
# --------------------------
# The quote in the comment below is just to cope with font-lock-mode
# which sees the opening of a string.
AC_DEFUN(AC_REVISION,
[AC_REQUIRE([AC_INIT])dnl
AC_DIVERT([BINSH], [@%:@ From configure.in translit([$1], $")])dnl "
])




## ---------------------------------------- ##
## Requirements over the Autoconf version.  ##
## ---------------------------------------- ##


# _AC_VERSION_UNLETTER(VERSION)
# -----------------------------
# Normalize beta version numbers with letters to numbers only for comparison.
#
#   Nl -> (N+1).-1.(l#)
#
#i.e., 2.14a -> 2.15.-1.1, 2.14b -> 2.15.-1.2, etc.
# This macro is absolutely not robust to active macro, it expects
# reasonable version numbers and is valid up to `z', no double letters.
define(_AC_VERSION_UNLETTER,
[translit(patsubst(patsubst(patsubst([$1],
                                     [\([0-9]+\)\([abcdefghi]\)],
                                     [m4_eval(\1 + 1).-1.\2]),
                            [\([0-9]+\)\([jklmnopqrs]\)],
                            [m4_eval(\1 + 1).-1.1\2]),
          [\([0-9]+\)\([tuvwxyz]\)],
          [m4_eval(\1 + 1).-1.2\2]),
          abcdefghijklmnopqrstuvwxyz,
          12345678901234567890123456)])


# _AC_VERSION_COMPARE(VERSION-1, VERSION-2)
# -----------------------------------------
# Compare the two version numbers and expand into
#  -1 if VERSION-1 < VERSION-2
#   0 if           =
#   1 if           >
define(_AC_VERSION_COMPARE,
[m4_list_cmp((m4_split(_AC_VERSION_UNLETTER([$1]), [\.])),
             (m4_split(_AC_VERSION_UNLETTER([$2]), [\.])))])


# AC_PREREQ(VERSION)
# ------------------
# Complain and exit if the Autoconf version is less than VERSION.
define(AC_PREREQ,
[ifelse(_AC_VERSION_COMPARE(AC_ACVERSION, [$1]), -1,
     [AC_FATAL([Autoconf version $1 or higher is required for this script])])])






## ---------------- ##
## Initialization.  ##
## ---------------- ##


# _AC_INIT_DEFAULTS
# -----------------
# Values which defaults can be set from `configure.in'.
AC_DEFUN(_AC_INIT_DEFAULTS,
[AC_DIVERT_PUSH([DEFAULTS])dnl

#
# Initializations.
#
ac_default_prefix=/usr/local
subdirs=
MFLAGS= MAKEFLAGS=
AC_SUBST(SHELL, ${CONFIG_SHELL-/bin/sh})dnl
# Maximum number of lines to put in a shell here document.
dnl This variable seems obsolete.  It should probably be removed, and
dnl only ac_max_sed_lines should be used.
: ${ac_max_here_lines=48}
# Sed expression to map a string onto a valid sh and CPP variable names.
ac_tr_sh='sed -e y%*+%pp%;s%[[^a-zA-Z0-9_]]%_%g'
ac_tr_cpp='sed -e y%*abcdefghijklmnopqrstuvwxyz%PABCDEFGHIJKLMNOPQRSTUVWXYZ%;s%[[^A-Z0-9_]]%_%g'

# By default always use an empty string as the executable extension.
# Only change it if the script calls AC_EXEEXT.
ac_exeext=
# By default assume that objects files use an extension of .o.  Only
# change it if the script calls AC_OBJEXT.
ac_objext=o
# Factoring default headers for most tests.
dnl If ever you change this variable, please keep autoconf.texi in sync.
ac_includes_default="\
#include <stdio.h>
#include <sys/types.h>
#if STDC_HEADERS
# include <stdlib.h>
# include <stddef.h>
#else
# if HAVE_STDLIB_H
#  include <stdlib.h>
# endif
#endif
#if HAVE_STRING_H
# if !STDC_HEADERS && HAVE_MEMORY_H
#  include <memory.h>
# endif
# include <string.h>
#else
# if HAVE_STRINGS_H
#  include <strings.h>
# endif
#endif
#if HAVE_INTTYPES_H
# include <inttypes.h>
#endif
#if HAVE_UNISTD_H
# include <unistd.h>
#endif"
AC_DIVERT_POP()dnl
])# _AC_INIT_DEFAULTS


# AC_PREFIX_DEFAULT(PREFIX)
# -------------------------
AC_DEFUN(AC_PREFIX_DEFAULT,
[AC_DIVERT([DEFAULTS], [ac_default_prefix=$1])])


# AC_CONFIG_SRCDIR([UNIQUE-FILE-IN-SOURCE-DIR])
# ---------------------------------------------
# UNIQUE-FILE-IN-SOURCE-DIR is a filename unique to this package,
# relative to the directory that configure is in, which we can look
# for to find out if srcdir is correct.
AC_DEFUN([AC_CONFIG_SRCDIR],
[AC_DIVERT([DEFAULTS], [ac_unique_file="$1"])])


# _AC_INIT_SRCDIR
# ---------------
# Compute `srcdir' based on `$ac_unique_file'.
define([_AC_INIT_SRCDIR],
[AC_DIVERT_PUSH([INIT_PARSE_ARGS])dnl

# Find the source files, if location was not specified.
if test -z "$srcdir"; then
  ac_srcdir_defaulted=yes
  # Try the directory containing this script, then its parent.
  ac_prog=[$]0
  ac_confdir=`echo "$ac_prog" | sed 's%/[[^/][^/]]*$%%'`
  test "x$ac_confdir" = "x$ac_prog" && ac_confdir=.
  srcdir=$ac_confdir
  if test ! -r $srcdir/$ac_unique_file; then
    srcdir=..
  fi
else
  ac_srcdir_defaulted=no
fi
if test ! -r $srcdir/$ac_unique_file; then
  if test "$ac_srcdir_defaulted" = yes; then
    AC_MSG_ERROR(cannot find sources in $ac_confdir or ..)
  else
    AC_MSG_ERROR(cannot find sources in $srcdir)
  fi
fi
dnl Double slashes in pathnames in object file debugging info
dnl mess up M-x gdb in Emacs.
srcdir=`echo "$srcdir" | sed 's%\([[^/]]\)/*$%\1%'`
AC_DIVERT_POP()dnl
])# _AC_INIT_SRCDIR


# _AC_INIT_PARSE_ARGS
# -------------------
AC_DEFUN([_AC_INIT_PARSE_ARGS],
[AC_DIVERT_PUSH([INIT_PARSE_ARGS])dnl

# Initialize some variables set by options.
ac_init_help=
ac_init_version=false
# The variables have the same names as the options, with
# dashes changed to underlines.
cache_file=/dev/null
AC_SUBST(exec_prefix, NONE)dnl
no_create=
no_recursion=
AC_SUBST(prefix, NONE)dnl
program_prefix=NONE
program_suffix=NONE
AC_SUBST(program_transform_name, [s,x,x,])dnl
silent=
site=
srcdir=
verbose=
x_includes=NONE
x_libraries=NONE
dnl Installation directory options.
dnl These are left unexpanded so users can "make install exec_prefix=/foo"
dnl and all the variables that are supposed to be based on exec_prefix
dnl by default will actually change.
dnl Use braces instead of parens because sh, perl, etc. also accept them.
AC_SUBST(bindir,         '${exec_prefix}/bin')dnl
AC_SUBST(sbindir,        '${exec_prefix}/sbin')dnl
AC_SUBST(libexecdir,     '${exec_prefix}/libexec')dnl
AC_SUBST(datadir,        '${prefix}/share')dnl
AC_SUBST(sysconfdir,     '${prefix}/etc')dnl
AC_SUBST(sharedstatedir, '${prefix}/com')dnl
AC_SUBST(localstatedir,  '${prefix}/var')dnl
AC_SUBST(libdir,         '${exec_prefix}/lib')dnl
AC_SUBST(includedir,     '${prefix}/include')dnl
AC_SUBST(oldincludedir,  '/usr/include')dnl
AC_SUBST(infodir,        '${prefix}/info')dnl
AC_SUBST(mandir,         '${prefix}/man')dnl

ac_prev=
for ac_option
do
  # If the previous option needs an argument, assign it.
  if test -n "$ac_prev"; then
    eval "$ac_prev=\$ac_option"
    ac_prev=
    continue
  fi

  ac_optarg=`echo "$ac_option" | sed -n 's/^[[^=]]*=//p'`

  # Accept the important Cygnus configure options, so we can diagnose typos.

  case "$ac_option" in

  -bindir | --bindir | --bindi | --bind | --bin | --bi)
    ac_prev=bindir ;;
  -bindir=* | --bindir=* | --bindi=* | --bind=* | --bin=* | --bi=*)
    bindir=$ac_optarg ;;

  -build | --build | --buil | --bui | --bu)
    ac_prev=build ;;
  -build=* | --build=* | --buil=* | --bui=* | --bu=*)
    build=$ac_optarg ;;

  -cache-file | --cache-file | --cache-fil | --cache-fi \
  | --cache-f | --cache- | --cache | --cach | --cac | --ca | --c)
    ac_prev=cache_file ;;
  -cache-file=* | --cache-file=* | --cache-fil=* | --cache-fi=* \
  | --cache-f=* | --cache-=* | --cache=* | --cach=* | --cac=* | --ca=* | --c=*)
    cache_file=$ac_optarg ;;

  -datadir | --datadir | --datadi | --datad | --data | --dat | --da)
    ac_prev=datadir ;;
  -datadir=* | --datadir=* | --datadi=* | --datad=* | --data=* | --dat=* \
  | --da=*)
    datadir=$ac_optarg ;;

  -disable-* | --disable-*)
    ac_feature=`echo "$ac_option"|sed -e 's/-*disable-//'`
    # Reject names that are not valid shell variable names.
    if echo "$ac_feature" | grep '[[^-a-zA-Z0-9_]]' >/dev/null 2>&1; then
      AC_MSG_ERROR(invalid feature: $ac_feature)
    fi
    ac_feature=`echo $ac_feature| sed 's/-/_/g'`
    eval "enable_${ac_feature}=no" ;;

  -enable-* | --enable-*)
    ac_feature=`echo "$ac_option"|sed -e 's/-*enable-//' -e 's/=.*//'`
    # Reject names that are not valid shell variable names.
    if echo "$ac_feature" | grep '[[^-a-zA-Z0-9_]]' >/dev/null 2>&1; then
      AC_MSG_ERROR(invalid feature: $ac_feature)
    fi
    ac_feature=`echo $ac_feature| sed 's/-/_/g'`
    case "$ac_option" in
      *=*) ac_optarg=`echo "$ac_optarg" | sed "s/'/'\\\\\\\\''/g"`;;
      *) ac_optarg=yes ;;
    esac
    eval "enable_${ac_feature}='$ac_optarg'" ;;

  -exec-prefix | --exec_prefix | --exec-prefix | --exec-prefi \
  | --exec-pref | --exec-pre | --exec-pr | --exec-p | --exec- \
  | --exec | --exe | --ex)
    ac_prev=exec_prefix ;;
  -exec-prefix=* | --exec_prefix=* | --exec-prefix=* | --exec-prefi=* \
  | --exec-pref=* | --exec-pre=* | --exec-pr=* | --exec-p=* | --exec-=* \
  | --exec=* | --exe=* | --ex=*)
    exec_prefix=$ac_optarg ;;

  -gas | --gas | --ga | --g)
    # Obsolete; use --with-gas.
    with_gas=yes ;;

  -help | --help | --hel | --he | -h)
    ac_init_help=long ;;
  -help=r* | --help=r* | --hel=r* | --he=r* | -hr*)
    ac_init_help=recursive ;;
  -help=s* | --help=s* | --hel=s* | --he=s* | -hs*)
    ac_init_help=short ;;

  -host | --host | --hos | --ho)
    ac_prev=host ;;
  -host=* | --host=* | --hos=* | --ho=*)
    host=$ac_optarg ;;

  -includedir | --includedir | --includedi | --included | --include \
  | --includ | --inclu | --incl | --inc)
    ac_prev=includedir ;;
  -includedir=* | --includedir=* | --includedi=* | --included=* | --include=* \
  | --includ=* | --inclu=* | --incl=* | --inc=*)
    includedir=$ac_optarg ;;

  -infodir | --infodir | --infodi | --infod | --info | --inf)
    ac_prev=infodir ;;
  -infodir=* | --infodir=* | --infodi=* | --infod=* | --info=* | --inf=*)
    infodir=$ac_optarg ;;

  -libdir | --libdir | --libdi | --libd)
    ac_prev=libdir ;;
  -libdir=* | --libdir=* | --libdi=* | --libd=*)
    libdir=$ac_optarg ;;

  -libexecdir | --libexecdir | --libexecdi | --libexecd | --libexec \
  | --libexe | --libex | --libe)
    ac_prev=libexecdir ;;
  -libexecdir=* | --libexecdir=* | --libexecdi=* | --libexecd=* | --libexec=* \
  | --libexe=* | --libex=* | --libe=*)
    libexecdir=$ac_optarg ;;

  -localstatedir | --localstatedir | --localstatedi | --localstated \
  | --localstate | --localstat | --localsta | --localst \
  | --locals | --local | --loca | --loc | --lo)
    ac_prev=localstatedir ;;
  -localstatedir=* | --localstatedir=* | --localstatedi=* | --localstated=* \
  | --localstate=* | --localstat=* | --localsta=* | --localst=* \
  | --locals=* | --local=* | --loca=* | --loc=* | --lo=*)
    localstatedir=$ac_optarg ;;

  -mandir | --mandir | --mandi | --mand | --man | --ma | --m)
    ac_prev=mandir ;;
  -mandir=* | --mandir=* | --mandi=* | --mand=* | --man=* | --ma=* | --m=*)
    mandir=$ac_optarg ;;

  -nfp | --nfp | --nf)
    # Obsolete; use --without-fp.
    with_fp=no ;;

  -no-create | --no-create | --no-creat | --no-crea | --no-cre \
  | --no-cr | --no-c)
    no_create=yes ;;

  -no-recursion | --no-recursion | --no-recursio | --no-recursi \
  | --no-recurs | --no-recur | --no-recu | --no-rec | --no-re | --no-r)
    no_recursion=yes ;;

  -oldincludedir | --oldincludedir | --oldincludedi | --oldincluded \
  | --oldinclude | --oldinclud | --oldinclu | --oldincl | --oldinc \
  | --oldin | --oldi | --old | --ol | --o)
    ac_prev=oldincludedir ;;
  -oldincludedir=* | --oldincludedir=* | --oldincludedi=* | --oldincluded=* \
  | --oldinclude=* | --oldinclud=* | --oldinclu=* | --oldincl=* | --oldinc=* \
  | --oldin=* | --oldi=* | --old=* | --ol=* | --o=*)
    oldincludedir=$ac_optarg ;;

  -prefix | --prefix | --prefi | --pref | --pre | --pr | --p)
    ac_prev=prefix ;;
  -prefix=* | --prefix=* | --prefi=* | --pref=* | --pre=* | --pr=* | --p=*)
    prefix=$ac_optarg ;;

  -program-prefix | --program-prefix | --program-prefi | --program-pref \
  | --program-pre | --program-pr | --program-p)
    ac_prev=program_prefix ;;
  -program-prefix=* | --program-prefix=* | --program-prefi=* \
  | --program-pref=* | --program-pre=* | --program-pr=* | --program-p=*)
    program_prefix=$ac_optarg ;;

  -program-suffix | --program-suffix | --program-suffi | --program-suff \
  | --program-suf | --program-su | --program-s)
    ac_prev=program_suffix ;;
  -program-suffix=* | --program-suffix=* | --program-suffi=* \
  | --program-suff=* | --program-suf=* | --program-su=* | --program-s=*)
    program_suffix=$ac_optarg ;;

  -program-transform-name | --program-transform-name \
  | --program-transform-nam | --program-transform-na \
  | --program-transform-n | --program-transform- \
  | --program-transform | --program-transfor \
  | --program-transfo | --program-transf \
  | --program-trans | --program-tran \
  | --progr-tra | --program-tr | --program-t)
    ac_prev=program_transform_name ;;
  -program-transform-name=* | --program-transform-name=* \
  | --program-transform-nam=* | --program-transform-na=* \
  | --program-transform-n=* | --program-transform-=* \
  | --program-transform=* | --program-transfor=* \
  | --program-transfo=* | --program-transf=* \
  | --program-trans=* | --program-tran=* \
  | --progr-tra=* | --program-tr=* | --program-t=*)
    program_transform_name=$ac_optarg ;;

  -q | -quiet | --quiet | --quie | --qui | --qu | --q \
  | -silent | --silent | --silen | --sile | --sil)
    silent=yes ;;

  -sbindir | --sbindir | --sbindi | --sbind | --sbin | --sbi | --sb)
    ac_prev=sbindir ;;
  -sbindir=* | --sbindir=* | --sbindi=* | --sbind=* | --sbin=* \
  | --sbi=* | --sb=*)
    sbindir=$ac_optarg ;;

  -sharedstatedir | --sharedstatedir | --sharedstatedi \
  | --sharedstated | --sharedstate | --sharedstat | --sharedsta \
  | --sharedst | --shareds | --shared | --share | --shar \
  | --sha | --sh)
    ac_prev=sharedstatedir ;;
  -sharedstatedir=* | --sharedstatedir=* | --sharedstatedi=* \
  | --sharedstated=* | --sharedstate=* | --sharedstat=* | --sharedsta=* \
  | --sharedst=* | --shareds=* | --shared=* | --share=* | --shar=* \
  | --sha=* | --sh=*)
    sharedstatedir=$ac_optarg ;;

  -site | --site | --sit)
    ac_prev=site ;;
  -site=* | --site=* | --sit=*)
    site=$ac_optarg ;;

  -srcdir | --srcdir | --srcdi | --srcd | --src | --sr)
    ac_prev=srcdir ;;
  -srcdir=* | --srcdir=* | --srcdi=* | --srcd=* | --src=* | --sr=*)
    srcdir=$ac_optarg ;;

  -sysconfdir | --sysconfdir | --sysconfdi | --sysconfd | --sysconf \
  | --syscon | --sysco | --sysc | --sys | --sy)
    ac_prev=sysconfdir ;;
  -sysconfdir=* | --sysconfdir=* | --sysconfdi=* | --sysconfd=* | --sysconf=* \
  | --syscon=* | --sysco=* | --sysc=* | --sys=* | --sy=*)
    sysconfdir=$ac_optarg ;;

  -target | --target | --targe | --targ | --tar | --ta | --t)
    ac_prev=target ;;
  -target=* | --target=* | --targe=* | --targ=* | --tar=* | --ta=* | --t=*)
    target=$ac_optarg ;;

  -v | -verbose | --verbose | --verbos | --verbo | --verb)
    verbose=yes ;;

  -version | --version | --versio | --versi | --vers | -V)
    ac_init_version=: ;;

  -with-* | --with-*)
    ac_package=`echo "$ac_option"|sed -e 's/-*with-//' -e 's/=.*//'`
    # Reject names that are not valid shell variable names.
    if echo "$ac_package" | grep '[[^-a-zA-Z0-9_]]' >/dev/null 2>&1; then
      AC_MSG_ERROR(invalid package: $ac_package)
    fi
    ac_package=`echo $ac_package| sed 's/-/_/g'`
    case "$ac_option" in
      *=*) ac_optarg=`echo "$ac_optarg" | sed "s/'/'\\\\\\\\''/g"`;;
      *) ac_optarg=yes ;;
    esac
    eval "with_${ac_package}='$ac_optarg'" ;;

  -without-* | --without-*)
    ac_package=`echo "$ac_option"|sed -e 's/-*without-//'`
    # Reject names that are not valid shell variable names.
    if echo "$ac_package" | grep '[[^-a-zA-Z0-9_]]' >/dev/null 2>&1; then
      AC_MSG_ERROR(invalid package: $ac_package)
    fi
    ac_package=`echo $ac_package| sed 's/-/_/g'`
    eval "with_${ac_package}=no" ;;

  --x)
    # Obsolete; use --with-x.
    with_x=yes ;;

  -x-includes | --x-includes | --x-include | --x-includ | --x-inclu \
  | --x-incl | --x-inc | --x-in | --x-i)
    ac_prev=x_includes ;;
  -x-includes=* | --x-includes=* | --x-include=* | --x-includ=* | --x-inclu=* \
  | --x-incl=* | --x-inc=* | --x-in=* | --x-i=*)
    x_includes=$ac_optarg ;;

  -x-libraries | --x-libraries | --x-librarie | --x-librari \
  | --x-librar | --x-libra | --x-libr | --x-lib | --x-li | --x-l)
    ac_prev=x_libraries ;;
  -x-libraries=* | --x-libraries=* | --x-librarie=* | --x-librari=* \
  | --x-librar=* | --x-libra=* | --x-libr=* | --x-lib=* | --x-li=* | --x-l=*)
    x_libraries=$ac_optarg ;;

  -*) AC_MSG_ERROR([unrecognized option: $ac_option
Try `configure --help' for more information.])
    ;;

  *=*)
    ac_envvar=`echo "$ac_option" | sed -e 's/=.*//'`
    # Reject names that are not valid shell variable names.
    if echo "$ac_envvar" | grep '[[^a-zA-Z0-9_]]' >/dev/null 2>&1; then
      AC_MSG_ERROR(invalid variable name: $ac_envvar)
    fi
    ac_optarg=`echo "$ac_optarg" | sed "s/'/'\\\\\\\\''/g"`
    eval "$ac_envvar='$ac_optarg'"
    export $ac_envvar ;;

  *)
    if echo "$ac_option" | grep '[[^-a-zA-Z0-9.]]' >/dev/null 2>&1; then
      AC_MSG_WARN([invalid host type: $ac_option])
    fi
    AC_MSG_WARN([you should use --build, --host, --target])
    : ${build=$ac_option} ${host=$ac_option} ${target=$ac_option}
    ;;

  esac
done

if test -n "$ac_prev"; then
  AC_MSG_ERROR(missing argument to --`echo $ac_prev | sed 's/_/-/g'`)
fi

# Be sure to have absolute paths.
for ac_var in bindir sbindir libexecdir datadir sysconfdir sharedstatedir \
              localstatedir libdir includedir oldincludedir infodir mandir \
              exec_prefix prefix
do
  eval ac_val=$`echo $ac_var`
  case $ac_val in
    [[\\/$]]* | ?:[[\\/]]* ) ;;
    NONE ) ;;
    *)  AC_MSG_ERROR([expected an absolute path for --$ac_var: $ac_val]);;
  esac
done
AC_DIVERT_POP()dnl
])# _AC_INIT_PARSE_ARGS


# _AC_INIT_HELP
# -------------
# Handle the `configure --help' message.
define([_AC_INIT_HELP],
[AC_DIVERT_PUSH([HELP_BEGIN])dnl

#
# Report the --help message.
#
if test "$ac_init_help" = "long"; then
  # Omit some internal or obsolete options to make the list less imposing.
  # This message is too long to be a string in the A/UX 3.1 sh.
  cat <<EOF
\`configure' configures ifset([AC_PACKAGE_STRING],
                        [AC_PACKAGE_STRING],
                        [this package]) to adapt to many kinds of systems.

Usage: $[0] [[OPTION]]... [[VAR=VALUE]]...

[To assign environment variables (e.g., CC, CFLAGS...), specify them as
VAR=VALUE.

Defaults for the options are specified in brackets.

Configuration:
  -h, --help              display this help and exit
      --help=short        display options specific to this package
      --help=recursive    display the short help of all the included packages
  -V, --version           display version information and exit
  -q, --quiet, --silent   do not print \`checking...' messages
      --cache-file=FILE   cache test results in FILE [disabled]
  -n, --no-create         do not create output files
      --srcdir=DIR        find the sources in DIR [configure dir or \`..']

EOF

  cat <<EOF
Installation directories:
  --prefix=PREFIX         install architecture-independent files in PREFIX
                          [$ac_default_prefix]
  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                          [PREFIX]

By default, \`make install' will install all the files in
\`$ac_default_prefix/bin', \`$ac_default_prefix/lib' etc.  You can specify
an installation prefix other than \`$ac_default_prefix' using \`--prefix',
for instance \`--prefix=\$HOME'.

For better control, use the options below.

Fine tuning of the installation directories:
  --bindir=DIR           user executables [EPREFIX/bin]
  --sbindir=DIR          system admin executables [EPREFIX/sbin]
  --libexecdir=DIR       program executables [EPREFIX/libexec]
  --datadir=DIR          read-only architecture-independent data [PREFIX/share]
  --sysconfdir=DIR       read-only single-machine data [PREFIX/etc]
  --sharedstatedir=DIR   modifiable architecture-independent data [PREFIX/com]
  --localstatedir=DIR    modifiable single-machine data [PREFIX/var]
  --libdir=DIR           object code libraries [EPREFIX/lib]
  --includedir=DIR       C header files [PREFIX/include]
  --oldincludedir=DIR    C header files for non-gcc [/usr/include]
  --infodir=DIR          info documentation [PREFIX/info]
  --mandir=DIR           man documentation [PREFIX/man]
EOF

  cat <<\EOF]
AC_DIVERT_POP()dnl
dnl The order of the diversions here is
dnl - HELP_BEGIN
dnl   which may be prolongated by extra generic options such as with X or
dnl   AC_ARG_PROGRAM.  Displayed only in long --help.
dnl
dnl - HELP_CANON
dnl   Support for cross compilation (--build, --host and --target).
dnl   Display only in long --help.
dnl
dnl - HELP_ENABLE
dnl   which starts with the trailer of the HELP_BEGIN, HELP_CANON section,
dnl   then implements the header of the non generic options.
dnl
dnl - HELP_WITH
dnl
dnl - HELP_VAR
dnl
dnl - HELP_END
dnl   initialized below, in which we dump the trailer (handling of the
dnl   recursion for instance).
AC_DIVERT_PUSH([HELP_ENABLE])dnl
EOF
fi

if test -n "$ac_init_help"; then
ifset([AC_PACKAGE_STRING],
[  case "$ac_init_help" in
     short | recursive ) echo "Configuration of AC_PACKAGE_STRING:";;
   esac])
  cat <<\EOF
AC_DIVERT_POP()dnl
AC_DIVERT_PUSH([HELP_END])dnl
EOF
fi

if test "$ac_init_help" = "recursive"; then
  # If there are subdirs, report their specific --help.
  ac_popdir=`pwd`
  for ac_subdir in : $subdirs; do test "x$ac_subdir" = x: && continue
    cd $ac_subdir
    # A "../" for each directory in /$ac_subdir.
    ac_dots=`echo $ac_subdir |
             sed -e 's%^\./%%;s%[[^/]]$%&/%;s%[[^/]]*/%../%g'`

    case "$srcdir" in
    .) # No --srcdir option.  We are building in place.
      ac_sub_srcdir=$srcdir ;;
    [[\\/]]* | ?:[[\\/]]* ) # Absolute path.
      ac_sub_srcdir=$srcdir/$ac_subdir ;;
    *) # Relative path.
      ac_sub_srcdir=$ac_dots$srcdir/$ac_subdir ;;
    esac

    # Check for guested configure; otherwise get Cygnus style configure.
    if test -f $ac_sub_srcdir/configure; then
      echo
      $SHELL $ac_sub_srcdir/configure  --help=recursive
    elif test -f $ac_sub_srcdir/configure.in; then
      echo
      $ac_configure --help
    else
      AC_MSG_WARN([no configuration information is in $ac_subdir])
    fi
    cd $ac_popdir
  done
fi

test -n "$ac_init_help" && exit 0
AC_DIVERT_POP()dnl
])# _AC_INIT_HELP


# _AC_INIT_VERSION
# ----------------
# Handle the `configure --version' message.
AC_DEFUN([_AC_INIT_VERSION],
[AC_DIVERT([VERSION_BEGIN],
[if $ac_init_version; then
  cat <<\EOF])dnl
ifset([AC_PACKAGE_STRING],
[AC_DIVERT([VERSION_BEGIN],
           [configure (AC_PACKAGE_STRING) AC_ACVERSION])])
AC_DIVERT([VERSION_END],
[EOF
  exit 0
fi])dnl
])# _AC_INIT_VERSION


# AC_INCLUDE(FILE)
# ----------------
# Wrapper around m4_include.
define(AC_INCLUDE,
[m4_include([$1])])


# AC_INCLUDES((FILE, ...))
# ------------------------
define(AC_INCLUDES,
[m4_foreach([File], [$1], [AC_INCLUDE(File)])])


# _AC_INIT_PREPARE_ENVIRONMENT
# ----------------------------
# Tune the envvar we depend upon: IFS, NLS.
# FIXME: CDPATH.
define([_AC_INIT_PREPARE_ENVIRONMENT],
[# NLS nuisances.
# Only set these to C if already set.  These must not be set unconditionally
# because not all systems understand e.g. LANG=C (notably SCO).
# Fixing LC_MESSAGES prevents Solaris sh from translating var values in `set'!
# Non-C LC_CTYPE values break the ctype check.
if test "${LANG+set}"   = set; then LANG=C;   export LANG;   fi
if test "${LC_ALL+set}" = set; then LC_ALL=C; export LC_ALL; fi
if test "${LC_MESSAGES+set}" = set; then LC_MESSAGES=C; export LC_MESSAGES; fi
if test "${LC_CTYPE+set}"    = set; then LC_CTYPE=C;    export LC_CTYPE;    fi

# IFS
# We need space, tab and new line, in precisely that order.
ac_nl='
'
IFS=" 	$ac_nl"dnl
])

# _AC_INIT_PREPARE
# ----------------
# Called by AC_INIT to build the preamble of the `configure' scripts.
# 1. Trap and clean up various tmp files.
# 2. Set up the fd and output files
# 3. Remember the options given to `configure' for `config.status --recheck'.
# 4. Ensure a correct environment
# 5. Required macros (cache, default AC_SUBST etc.)
AC_DEFUN([_AC_INIT_PREPARE],
[AC_DIVERT_PUSH([INIT_PREPARE])dnl
_AC_INIT_PREPARE_ENVIRONMENT

trap 'rm -fr conftest* confdefs* core core.* *.core $ac_clean_files; exit 1' 1 2 15

# Keep a trace of the command line.
# Strip out --no-create and --no-recursion so they do not pile up.
# Also quote any args containing shell meta-characters.
ac_configure_args=
ac_sep=
for ac_arg
do
  case "$ac_arg" in
  -no-create | --no-create | --no-creat | --no-crea | --no-cre \
  | --no-cr | --no-c) ;;
  -no-recursion | --no-recursion | --no-recursio | --no-recursi \
  | --no-recurs | --no-recur | --no-recu | --no-rec | --no-re | --no-r) ;;
dnl If you change this globbing pattern, test it on an old shell --
dnl it's sensitive.  Putting any kind of quote in it causes syntax errors.
[  *" "*|*"	"*|*[\[\]\~\#\$\^\&\*\(\)\{\}\\\|\;\<\>\?\"\']*)]
    ac_arg=`echo "$ac_arg" | sed "s/'/'\\\\\\\\''/g"`
    ac_configure_args="$ac_configure_args$ac_sep'$ac_arg'"
    ac_sep=" " ;;
  *) ac_configure_args="$ac_configure_args$ac_sep$ac_arg"
     ac_sep=" " ;;
  esac
  # Get rid of the leading space.
done

# File descriptor usage:
# 0 standard input
# 1 file creation
# 2 errors and warnings
# 3 some systems may open it to /dev/tty
# 4 used on the Kubota Titan
define([AC_FD_MSG], 6)dnl
@%:@ AC_FD_MSG checking for... messages and results
define([AC_FD_LOG], 5)dnl
AU_DEFUN([AC_FD_CC], [AC_FD_LOG])dnl That's how it used to be named.
@%:@ AC_FD_LOG compiler messages saved in config.log
if test "$silent" = yes; then
  exec AC_FD_MSG>/dev/null
else
  exec AC_FD_MSG>&1
fi
exec AC_FD_LOG>./config.log

echo "\
This file contains any messages produced by compilers while
running configure, to aid debugging if configure makes a mistake.

It was created by configure ifset([AC_PACKAGE_STRING],
                            [(AC_PACKAGE_STRING)]) AC_ACVERSION, executed with
 > [$]0 $ac_configure_args
" >&AC_FD_LOG

# confdefs.h avoids OS command line length limits that DEFS can exceed.
rm -rf conftest* confdefs.h
# AIX cpp loses on an empty file, so make sure it contains at least a newline.
echo >confdefs.h

dnl Let the site file select an alternate cache file if it wants to.
AC_SITE_LOAD
AC_CACHE_LOAD
AC_LANG(C)

_AC_PROG_ECHO()dnl
dnl Substitute for predefined variables.
AC_SUBST(CFLAGS)dnl
AC_SUBST(CPPFLAGS)dnl
AC_SUBST(CXXFLAGS)dnl
AC_SUBST(FFLAGS)dnl
AC_SUBST(DEFS)dnl
AC_SUBST(LDFLAGS)dnl
AC_SUBST(LIBS)dnl
AC_DIVERT_POP()dnl
])# _AC_INIT_PREPARE


# _AC_INIT
# --------
# Include the user macro files, prepare the diversions, and output the
# preamble of the `configure' script.
define([_AC_INIT],
[m4_sinclude(acsite.m4)dnl
m4_sinclude(./aclocal.m4)dnl
AC_DIVERT([BINSH], [@%:@! /bin/sh])
_AC_INIT_DEFAULTS()dnl
AC_DIVERT_POP()dnl to NORMAL
_AC_INIT_PARSE_ARGS
_AC_INIT_SRCDIR
_AC_INIT_HELP
_AC_INIT_VERSION
_AC_INIT_PREPARE
dnl AC_COPYRIGHT must be called after _AC_INIT_VERSION, since it dumps
dnl into a diversion prepared by _AC_INIT_VERSION.
AC_DIVERT([NOTICE],
[# Guess values for system-dependent variables and create Makefiles.
@%:@ Generated by Autoconf AC_ACVERSION.])dnl
AC_COPYRIGHT(
[Copyright (C) 1992, 93, 94, 95, 96, 98, 99, 2000
Free Software Foundation, Inc.
This configure script is free software; the Free Software Foundation
gives unlimited permission to copy, distribute and modify it.])dnl
])# _AC_INIT


# AC_INIT([UNIQUE-FILE-IN-SOURCE-DIR])
# ------------------------------------
# Wrapper around _AC_INIT which guarantees _AC_INIT is expanded only
# once.
# Note that the order is important: first initialize, then set the
# AC_CONFIG_SRCDIR.
AC_DEFUN([AC_INIT],
[AC_EXPAND_ONCE([_AC_INIT()])dnl
ifval([$1], [AC_CONFIG_SRCDIR([$1])])dnl
])


## ----------------------------- ##
## Selecting optional features.  ##
## ----------------------------- ##


# AC_ARG_ENABLE(FEATURE, HELP-STRING, [ACTION-IF-TRUE], [ACTION-IF-FALSE])
# ------------------------------------------------------------------------
AC_DEFUN(AC_ARG_ENABLE,
[AC_DIVERT_PUSH([HELP_ENABLE])dnl
AC_EXPAND_ONCE([[
Optional Features:
  --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
  --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
]])[]dnl
$2
AC_DIVERT_POP()dnl
# Check whether --enable-$1 or --disable-$1 was given.
if test "[${enable_]patsubst([$1], -, _)+set}" = set; then
  enableval="[$enable_]patsubst([$1], -, _)"
  $3
ifval([$4], [else
  $4
])dnl
fi[]dnl
])# AC_ARG_ENABLE


AU_DEFUN(AC_ENABLE,
[AC_ARG_ENABLE([$1], [  --enable-$1], [$2], [$3])])


## ------------------------------ ##
## Working with optional software ##
## ------------------------------ ##



# AC_ARG_WITH(PACKAGE, HELP-STRING, ACTION-IF-TRUE, [ACTION-IF-FALSE])
# --------------------------------------------------------------------
AC_DEFUN(AC_ARG_WITH,
[AC_DIVERT_PUSH([HELP_WITH])dnl
AC_EXPAND_ONCE([[
Optional Packages:
  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
]])[]dnl
$2
AC_DIVERT_POP()dnl
# Check whether --with-$1 or --without-$1 was given.
if test "[${with_]patsubst([$1], -, _)+set}" = set; then
  withval="[$with_]patsubst([$1], -, _)"
  $3
ifval([$4], [else
  $4
])dnl
fi[]dnl
])# AC_ARG_WITH

AU_DEFUN(AC_WITH,
[AC_ARG_WITH([$1], [  --with-$1], [$2], [$3])])



## ----------------------------------------- ##
## Remembering variables for reconfiguring.  ##
## ----------------------------------------- ##



# AC_ARG_VAR(VARNAME, DOCUMENTATION)
# ----------------------------------
# Register VARNAME as a variable configure should remember, and
# document it in `configure --help'.
AC_DEFUN(AC_ARG_VAR,
[AC_DIVERT_PUSH([HELP_VAR])dnl
AC_EXPAND_ONCE([
Some influent environment variables:
])[]dnl
AC_HELP_STRING([$1], [$2], [              ])
AC_DIVERT_POP()dnl
dnl Register if set and not yet registered.
dnl If there are envvars given as arguments, they are already set,
dnl therefore they won't be set again, which is the right thing.
case "${$1+set} $ac_configure_args" in
 *" $1="* );;
 "set "*) ac_configure_args="$1='[$]$1' $ac_configure_args";;
esac[]dnl
])# AC_ARG_VAR



## ---------------------------- ##
## Transforming program names.  ##
## ---------------------------- ##


# AC_ARG_PROGRAM
# --------------
# This macro is expanded only once, to avoid that `foo' ends up being
# installed as `ggfoo'.
AC_DEFUN_ONCE(AC_ARG_PROGRAM,
[dnl Document the options.
AC_DIVERT_PUSH([HELP_BEGIN])dnl

Program names:
  --program-prefix=PREFIX            prepend PREFIX to installed program names
  --program-suffix=SUFFIX            append SUFFIX to installed program names
  --program-transform-name=PROGRAM   run sed PROGRAM on installed program names
AC_DIVERT_POP()dnl
if test "$program_transform_name" = s,x,x,; then
  program_transform_name=
else
  # Double any \ or $.  echo might interpret backslashes.
  cat <<\EOF >conftestsed
s,\\,\\\\,g; s,\$,$$,g
EOF
  program_transform_name=`echo $program_transform_name | sed -f conftestsed`
  rm -f conftestsed
fi
test "$program_prefix" != NONE &&
  program_transform_name="s,^,${program_prefix},;$program_transform_name"
# Use a double $ so make ignores it.
test "$program_suffix" != NONE &&
  program_transform_name="s,\$\$,${program_suffix},;$program_transform_name"

# sed with no file args requires a program.
test -z "$program_transform_name" && program_transform_name="s,x,x,"
])# AC_ARG_PROGRAM





## ------------------------- ##
## Finding auxiliary files.  ##
## ------------------------- ##


# AC_CONFIG_AUX_DIR(DIR)
# ----------------------
# Find install-sh, config.sub, config.guess, and Cygnus configure
# in directory DIR.  These are auxiliary files used in configuration.
# DIR can be either absolute or relative to $srcdir.
AC_DEFUN(AC_CONFIG_AUX_DIR,
[AC_CONFIG_AUX_DIRS($1 $srcdir/$1)])


# AC_CONFIG_AUX_DIR_DEFAULT
# -------------------------
# The default is `$srcdir' or `$srcdir/..' or `$srcdir/../..'.
# There's no need to call this macro explicitly; just AC_REQUIRE it.
AC_DEFUN(AC_CONFIG_AUX_DIR_DEFAULT,
[AC_CONFIG_AUX_DIRS($srcdir $srcdir/.. $srcdir/../..)])


# AC_CONFIG_AUX_DIRS(DIR ...)
# ---------------------------
# Internal subroutine.
# Search for the configuration auxiliary files in directory list $1.
# We look only for install-sh, so users of AC_PROG_INSTALL
# do not automatically need to distribute the other auxiliary files.
AC_DEFUN(AC_CONFIG_AUX_DIRS,
[ac_aux_dir=
for ac_dir in $1; do
  if test -f $ac_dir/install-sh; then
    ac_aux_dir=$ac_dir
    ac_install_sh="$ac_aux_dir/install-sh -c"
    break
  elif test -f $ac_dir/install.sh; then
    ac_aux_dir=$ac_dir
    ac_install_sh="$ac_aux_dir/install.sh -c"
    break
  elif test -f $ac_dir/shtool; then
    ac_aux_dir=$ac_dir
    ac_install_sh="$ac_aux_dir/shtool install -c"
    break
  fi
done
if test -z "$ac_aux_dir"; then
  AC_MSG_ERROR([cannot find install-sh or install.sh in $1])
fi
ac_config_guess="$SHELL $ac_aux_dir/config.guess"
ac_config_sub="$SHELL $ac_aux_dir/config.sub"
ac_configure="$SHELL $ac_aux_dir/configure" # This should be Cygnus configure.
AC_PROVIDE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
])# AC_CONFIG_AUX_DIRS




## ----------------------------------- ##
## Getting the canonical system type.  ##
## ----------------------------------- ##

# The inputs are:
#    configure --host=HOST --target=TARGET --build=BUILD
#
# The rules are:
# 1. Build defaults to the current host, as determined by config.guess.
# 2. Host defaults to build.
# 3. Target defaults to host.


# AC_CANONICALIZE(THING)
# ----------------------
# Canonicalize the appropriate THING, generating the variables THING,
# THING_{alias cpu vendor os}, and the associated cache entries.
AC_DEFUN([AC_CANONICALIZE],
[AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
ac_cv_$1=`$ac_config_sub $ac_cv_$1_alias` || exit 1
ac_cv_$1_cpu=`echo $ac_cv_$1 | sed 's/^\([[^-]]*\)-\([[^-]]*\)-\(.*\)$/\1/'`
ac_cv_$1_vendor=`echo $ac_cv_$1 | sed 's/^\([[^-]]*\)-\([[^-]]*\)-\(.*\)$/\2/'`
ac_cv_$1_os=`echo $ac_cv_$1 | sed 's/^\([[^-]]*\)-\([[^-]]*\)-\(.*\)$/\3/'`
AC_SUBST([$1],        [$ac_cv_$1])dnl
AC_SUBST([$1_alias],  [$ac_cv_$1_alias])dnl
AC_SUBST([$1_cpu],    [$ac_cv_$1_cpu])dnl
AC_SUBST([$1_vendor], [$ac_cv_$1_vendor])dnl
AC_SUBST([$1_os],     [$ac_cv_$1_os])dnl
])# AC_CANONICALIZE


# _AC_CANONICAL_THING(THING)
# --------------------------
# Worker routine for AC_CANONICAL_SYSTEM.  THING is one of `host',
# `target', or `build'.  Canonicalize the appropriate thing.  We also
# redo the cache entries if the user specifies something different
# from ac_cv_$THING_alias on the command line.
define([_AC_CANONICAL_THING],
[AC_MSG_CHECKING([$1 system type])
if test "x$ac_cv_$1" = "x" ||
   (test "x$$1" != "x" && test "x$$1" != "x$ac_cv_$1_alias"); then

dnl Set $1_alias.
  ac_cv_$1_alias=$$1
  test "x$ac_cv_$1_alias" = "x" &&
    m4_case([$1],
[build],
  [{ ac_cv_build_alias=`$ac_config_guess` ||
      AC_MSG_ERROR(
           [cannot guess build (this machine) type; you must specify one]); }],
[host],
  [ac_cv_host_alias=$build_alias],
[target],
  [ac_cv_target_alias=$host_alias])
else
  echo $ECHO_N "(cached) $ECHO_C" >&AC_FD_MSG
fi
AC_CANONICALIZE([$1])
AC_MSG_RESULT($ac_cv_$1)[]dnl
])# _AC_CANONICAL_THING


# AC_CANONICAL_BUILD
# ------------------
AC_DEFUN_ONCE([AC_CANONICAL_BUILD],
[AC_DIVERT([HELP_CANON],
[[
Hosts type:
  --build=BUILD     configure for building on BUILD [guessed]]])dnl
# Make sure we can run config.sub.
$ac_config_sub sun4 >/dev/null 2>&1 ||
  AC_MSG_ERROR([cannot run $ac_config_sub])

_AC_CANONICAL_THING(build)[]dnl
])# AC_CANONICAL_BUILD


# AC_CANONICAL_HOST
# -----------------
AC_DEFUN_ONCE([AC_CANONICAL_HOST],
[AC_REQUIRE([AC_CANONICAL_BUILD])dnl
AC_DIVERT([HELP_CANON],
[[  --host=HOST       configure for building programs running on HOST [BUILD]]])dnl
_AC_CANONICAL_THING(host)[]dnl
])# AC_CANONICAL_HOST


# AC_CANONICAL_TARGET
# -------------------
AC_DEFUN_ONCE([AC_CANONICAL_TARGET],
[AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_BEFORE([$0], [AC_ARG_PROGRAM])dnl
AC_DIVERT([HELP_CANON],
[[  --target=TARGET   configure for building compilers for TARGET [HOST]]])dnl
_AC_CANONICAL_THING(target)[]dnl

# The aliases save the names the user supplied, while $host etc.
# will get canonicalized.
test "$host_alias" != "$target_alias" &&
  test "$program_prefix$program_suffix$program_transform_name" = \
    NONENONEs,x,x, &&
  program_prefix=${target_alias}-[]dnl
])# AC_CANONICAL_TARGET


AU_DEFUN(AC_CANONICAL_SYSTEM, [AC_CANONICAL_TARGET])


# AC_VALIDATE_CACHED_SYSTEM_TUPLE([CMD])
# --------------------------------------
# If the cache file is inconsistent with the current host,
# target and build system types, execute CMD or print a default
# error message.
AC_DEFUN(AC_VALIDATE_CACHED_SYSTEM_TUPLE,
[AC_REQUIRE([AC_CANONICAL_SYSTEM])dnl
AC_MSG_CHECKING([cached system tuple])
if { test x"${ac_cv_host_system_type+set}" = x"set" &&
     test x"$ac_cv_host_system_type" != x"$host"; } ||
   { test x"${ac_cv_build_system_type+set}" = x"set" &&
     test x"$ac_cv_build_system_type" != x"$build"; } ||
   { test x"${ac_cv_target_system_type+set}" = x"set" &&
     test x"$ac_cv_target_system_type" != x"$target"; }; then
    AC_MSG_RESULT([different])
    m4_default([$1],
               [AC_MSG_ERROR([remove config.cache and re-run configure])])
else
  AC_MSG_RESULT(ok)
fi
ac_cv_host_system_type=$host
ac_cv_build_system_type=$build
ac_cv_target_system_type=$target[]dnl
])


## ---------------------- ##
## Caching test results.  ##
## ---------------------- ##


# AC_SITE_LOAD
# ------------
# Look for site or system specific initialization scripts.
define(AC_SITE_LOAD,
[# Prefer explicitly selected file to automatically selected ones.
if test -z "$CONFIG_SITE"; then
  if test "x$prefix" != xNONE; then
    CONFIG_SITE="$prefix/share/config.site $prefix/etc/config.site"
  else
    CONFIG_SITE="$ac_default_prefix/share/config.site $ac_default_prefix/etc/config.site"
  fi
fi
for ac_site_file in $CONFIG_SITE; do
  if test -r "$ac_site_file"; then
    echo "loading site script $ac_site_file"
    . "$ac_site_file"
  fi
done
])


# AC_CACHE_LOAD
# -------------
define([AC_CACHE_LOAD],
[if test -r "$cache_file"; then
  test "x$cache_file" != "x/dev/null" && echo "loading cache $cache_file"
  dnl Some versions of bash will fail to source /dev/null, so we
  dnl avoid doing that.
  test -f "$cache_file" && . $cache_file
else
  echo "creating cache $cache_file"
  >$cache_file
fi
])# AC_CACHE_LOAD


# _AC_CACHE_DUMP
# --------------
# Dump the cache to stdout.  It can be in a pipe (this is a requirement).
define([_AC_CACHE_DUMP],
[# The following way of writing the cache mishandles newlines in values,
# but we know of no workaround that is simple, portable, and efficient.
# So, don't put newlines in cache variables' values.
# Ultrix sh set writes to stderr and can't be redirected directly,
# and sets the high bit in the cache file unless we assign to the vars.
{
  (set) 2>&1 |
    case `(ac_space=' '; set | grep ac_space) 2>&1` in
    *ac_space=\ *)
      # `set' does not quote correctly, so add quotes (double-quote substitution
      # turns \\\\ into \\, and sed turns \\ into \).
      sed -n \
    	-e "s/'/'\\\\''/g" \
    	-e ["s/^\\([a-zA-Z0-9_]*_cv_[a-zA-Z0-9_]*\\)=\\(.*\\)/\\1='\\2'/p"]
      ;;
    *)
      # `set' quotes correctly as required by POSIX, so do not add quotes.
      sed -n -e '[s/^\([a-zA-Z0-9_]*_cv_[a-zA-Z0-9_]*\)=\(.*\)/\1=\2/p]'
      ;;
    esac;
}dnl
])# _AC_CACHE_DUMP


# AC_CACHE_SAVE
# -------------
# Save the cache.
# Allow a site initialization script to override cache values.
define([AC_CACHE_SAVE],
[cat >confcache <<\EOF
# This file is a shell script that caches the results of configure
# tests run on this system so they can be shared between configure
# scripts and configure runs.  It is not useful on other systems.
# If it contains results you don't want to keep, you may remove or edit it.
#
# By default, configure uses ./config.cache as the cache file,
# creating it if it does not exist already.  You can give configure
# the --cache-file=FILE option to use a different cache file; that is
# what configure does when it calls configure scripts in
# subdirectories, so they share the cache.
# Giving --cache-file=/dev/null disables caching, for debugging configure.
# config.status only pays attention to the cache file if you give it the
# --recheck option to rerun configure.
#
EOF
_AC_CACHE_DUMP() |
  sed -e 's/^\([[^=]]*\)=\(.*\)$/\1=${\1=\2}/' >>confcache
if cmp -s $cache_file confcache; then :; else
  if test -w $cache_file; then
    test "x$cache_file" != "x/dev/null" && echo "updating cache $cache_file"
    cat confcache >$cache_file
  else
    echo "not updating unwritable cache $cache_file"
  fi
fi
rm -f confcache[]dnl
])# AC_CACHE_SAVE


# AC_CACHE_VAL(CACHE-ID, COMMANDS-TO-SET-IT)
# ------------------------------------------
#
# The name of shell var CACHE-ID must contain `_cv_' in order to get saved.
# Should be dnl'ed.
define(AC_CACHE_VAL,
[dnl We used to use the below line, but it fails if the 1st arg is a
dnl shell variable, so we need the eval.
dnl if test "${$1+set}" = set; then
AC_VAR_IF_SET([$1],
              [echo $ECHO_N "(cached) $ECHO_C" >&AC_FD_MSG],
              [$2])])


# AC_CACHE_CHECK(MESSAGE, CACHE-ID, COMMANDS)
# -------------------------------------------
# Do not call this macro with a dnl right behind.
define(AC_CACHE_CHECK,
[AC_MSG_CHECKING([$1])
AC_CACHE_VAL([$2], [$3])dnl
AC_MSG_RESULT_UNQUOTED(AC_VAR_GET([$2]))])



## ---------------------- ##
## Defining CPP symbols.  ##
## ---------------------- ##


# AC_DEFINE(VARIABLE, [VALUE], [DESCRIPTION])
# -------------------------------------------
# Set VARIABLE to VALUE, verbatim, or 1.  Remember the value
# and if VARIABLE is affected the same VALUE, do nothing, else
# die.  The third argument is used by autoheader.
define(AC_DEFINE,
[ifval([$3], [AH_TEMPLATE([$1], [$3])])dnl
cat >>confdefs.h <<\EOF
[#define] $1 ifelse($#, 2, [$2], $#, 3, [$2], 1)
EOF
])



# AC_DEFINE_UNQUOTED(VARIABLE, [VALUE], [DESCRIPTION])
# ----------------------------------------------------
# Similar, but perform shell substitutions $ ` \ once on VALUE.
define(AC_DEFINE_UNQUOTED,
[ifval([$3], [AH_TEMPLATE([$1], [$3])])dnl
cat >>confdefs.h <<EOF
[#define] $1 ifelse($#, 2, [$2], $#, 3, [$2], 1)
EOF
])



## -------------------------- ##
## Setting output variables.  ##
## -------------------------- ##


# _AC_SUBST(VARIABLE, PROGRAM)
# ----------------------------
# If VARIABLE has not already been AC_SUBST'ed, append the sed PROGRAM
# to `_AC_SUBST_SED_PROGRAM'.
define(_AC_SUBST,
[AC_EXPAND_ONCE([m4_append([_AC_SUBST_SED_PROGRAM],
[$2
])])dnl
])

# Initialize.
define([_AC_SUBST_SED_PROGRAM])


# AC_SUBST(VARIABLE, [VALUE])
# ---------------------------
# Create an output variable from a shell VARIABLE.  If VALUE is given
# assign it to VARIABLE.  Use `""' is you want to set VARIABLE to an
# empty value, not an empty second argument.
#
# Beware that if you change this macro, you also have to change the
# sed script at the top of _AC_OUTPUT_FILES.
define([AC_SUBST],
[ifval([$2], [$1=$2
])[]dnl
_AC_SUBST([$1], [s%@$1@%[$]$1%;t t])dnl
])# AC_SUBST


# AC_SUBST_FILE(VARIABLE)
# -----------------------
# Read the comments of the preceding macro.
define(AC_SUBST_FILE,
[_AC_SUBST([$1], [/@$1@/r [$]$1
s%@$1@%%;t t])])



## --------------------------------------- ##
## Printing messages at autoconf runtime.  ##
## --------------------------------------- ##

# In fact, I think we should promote the use of m4_warn and m4_fatal
# directly.  This will also avoid to some people to get it wrong
# between AC_FATAL and AC_MSG_ERROR.


# AC_WARNING_IFELSE(CATEGORY, IF-TRUE, IF-FALSE)
# ----------------------------------------------
# If the CATEGORY of warnings is enabled, expand IF_TRUE otherwise
# IF-FALSE.  CATEGORY is enabled iff `AC_WARNING_ENABLE(CATEGORY)' or
# `AC_WARNING_ENABLE(all)' is defined.
define([AC_WARNING_IFELSE],
[ifdef([AC_WARNING_ENABLE($1)], [$2],
       [ifdef([AC_WARNING_ENABLE(all)], [$2], [$3])])])


# _AC_DIAGNOSE(MESSAGE)
# ---------------------
# Report MESSAGE as a warning, unless the user requested -W error,
# in which case report a fatal error.
define([_AC_DIAGNOSE],
[ifdef([AC_WARNING_ENABLE(error)],
       [m4_fatal([$1])],
       [m4_warn([$1])])])


# AC_DIAGNOSE(CATEGORY, MESSAGE)
# ------------------------------
# Report a MESSAGE to the autoconf user if the CATEGORY of warnings
# is requested (in fact, not disabled).
define([AC_DIAGNOSE],
[AC_WARNING_IFELSE([$1], [_AC_DIAGNOSE([$2])])])


# AC_WARNING(MESSAGE)
# -------------------
# Report a MESSAGE to the user of autoconf if `-W' or `-W all' was
# specified.
define([AC_WARNING], [AC_DIAGNOSE([], [$1])])


# AC_FATAL(MESSAGE, [EXIT-STATUS])
# --------------------------------
define([AC_FATAL], [m4_fatal([$1], [$2])])




## ---------------------------------------- ##
## Printing messages at configure runtime.  ##
## ---------------------------------------- ##


# _AC_SH_QUOTE_IFELSE(STRING, IF-MODERN-QUOTATION, IF-OLD-QUOTATION)
# ------------------------------------------------------------------
# Compatibility glue between the old AC_MSG suite which did not
# quote anything, and the modern suite which quotes the quotes.
# If STRING contains `\\' or `\$', it's modern.
# If STRING contains `\"' or `\`', it's old.
# Otherwise it's modern.
# We use two quotes in the pattern to keep highlighting tools at peace.
define([_AC_SH_QUOTE_IFELSE],
[ifelse(regexp([$1], [\\[\\$]]),
        [-1], [ifelse(regexp([$1], [\\[`""]]),
                      [-1], [$2],
                      [$3])],
        [$2])])


# _AC_SH_QUOTE(STRING)
# --------------------
# If there are quoted (via backslash) backquotes do nothing, else
# backslash all the quotes.
define([_AC_SH_QUOTE],
[_AC_SH_QUOTE_IFELSE([$1],
                     [patsubst([$1], [\([`""]\)], [\\\1])],
                     [AC_DIAGNOSE([syntax],
           [backquotes and double quotes should not be backslashed in: $1])dnl
$1])])


# _AC_ECHO_UNQUOTED(STRING, [FD = AC_FD_MSG])
# -------------------------------------------
# Perform shell expansions on STRING and echo the string to FD.
define([_AC_ECHO_UNQUOTED],
[echo "$1" >&m4_default([$2], [AC_FD_MSG])])


# _AC_ECHO(STRING, [FD = AC_FD_MSG])
# ----------------------------------
# Protect STRING from backquote expansion, echo the result to FD.
define([_AC_ECHO],
[_AC_ECHO_UNQUOTED([_AC_SH_QUOTE([$1])], $2)])


# _AC_ECHO_N(STRING, [FD = AC_FD_MSG])
# ------------------------------------
# Same as _AC_ECHO, but echo doesn't return to a new line.
define([_AC_ECHO_N],
[echo $ECHO_N "_AC_SH_QUOTE([$1])$ECHO_C" >&m4_default([$2], [AC_FD_MSG])])


# AC_MSG_CHECKING(FEATURE)
# ------------------------
define([AC_MSG_CHECKING],
[_AC_ECHO([configure:__oline__: checking $1], AC_FD_LOG)
_AC_ECHO_N([checking $1... ])[]dnl
])


# autoupdate::AC_CHECKING(FEATURE)
# --------------------------------
AU_DEFUN([AC_CHECKING],
[AC_MSG_CHECKING([$1])])


# AC_MSG_RESULT(RESULT)
# ---------------------
define([AC_MSG_RESULT],
[_AC_ECHO([configure:__oline__: result: $1], AC_FD_LOG)
_AC_ECHO([${ECHO_T}$1])[]dnl
])


# AC_MSG_RESULT_UNQUOTED(RESULT)
# ------------------------------
# Likewise, but perform $ ` \ shell substitutions.
define([AC_MSG_RESULT_UNQUOTED],
[_AC_ECHO_UNQUOTED([configure:__oline__: result: $1], AC_FD_LOG)
_AC_ECHO_UNQUOTED([${ECHO_T}$1])[]dnl
])


# autoupdate::AC_VERBOSE(RESULT)
# ------------------------------
AU_DEFUN([AC_VERBOSE],
[AC_MSG_RESULT([	$1])])


# AC_MSG_WARN(PROBLEM)
# --------------------
define([AC_MSG_WARN],
[_AC_ECHO([configure: warning: $1], 2)])


# AC_MSG_ERROR(ERROR, [EXIT-STATUS = 1])
# --------------------------------------
define([AC_MSG_ERROR],
[{ _AC_ECHO([configure: error: $1], 2); exit m4_default([$2], 1); }])







## ---------------------------- ##
## Compiler-running mechanics.  ##
## ---------------------------- ##


# AC_TRY_EVAL(VARIABLE)
# ---------------------
# The purpose of this macro is to "configure:123: command line"
# written into config.log for every test run.
AC_DEFUN(AC_TRY_EVAL,
[{ (eval echo configure:__oline__: \"[$]$1\") >&AC_FD_LOG; dnl
(eval [$]$1) 2>&AC_FD_LOG; }])


# AC_TRY_COMMAND(COMMAND)
# -----------------------
AC_DEFUN(AC_TRY_COMMAND,
[{ ac_try='$1'; AC_TRY_EVAL(ac_try); }])



## ------------------ ##
## Default includes.  ##
## ------------------ ##

# Always use the same set of default headers for all the generic
# macros.  It is easier to document, to extend, and to understand than
# having specific defaults for each macro.

# Of course, one would like to issue these default headers only if
# they were used, i.e.., AC_INCLUDES_DEFAULT was called, and the
# default `branch' was run.  Unfortunately AC_INCLUDES_DEFAULT is
# called unquoted, so it is unsafe to try to divert from there.
# Therefore, the following *is* buggy, but this is the kind of
# tradeoff we accept in order to improve configure.

# See _AC_INIT_PREPARE to see the value of `ac_includes_default'.


# AC_INCLUDES_DEFAULT([INCLUDES])
# -------------------------------
# If INCLUDES is empty, expand in default includes, otherwise in
# INCLUDES.
#
# The end-of-line after `$[1]' below is meant, and it is actually
# because this new line is meant that we don't use m4_default.  The
# problem is that this macro is used *unquoted* in AC_TRY_COMPILE
# etc.  It is used unquoted because unfortunately (this is a real
# pain), AC_TRY_COMPILE is over quoting some of its arguments.  This
# is a sad decision.
#
# Still, there are calls such as this
#
#      AC_TRY_COMPILE(AC_INCLUDES_DEFAULT([#include <pwd.h>]),
#                     AC_BLAH_BLAH..)
#
# Because AC_INCLUDES_DEFAULT *has* to be unquoted, after evaluation,
# if there were no end of line, you'd get
#
#      AC_TRY_COMPILE(#include <pwd.h>,
#                     AC_BLAH_BLAH,
#                     AC_MORE_BLAH_BLAH)
#
# i.e. the first argument given to AC_TRY_COMPILE is
#
#      #include <pwd.h>,
#                     AC_BLAH_BLAH
#
# (note how the comma was swallowed because of the comment mark) and
# the second is
#
#      AC_MORE_BLAH_BLAH
#
# so all the arguments are shifted.
#
# Because I don't see any backward compatible means to fix the
# brokenness of AC_TRY_COMPILE, we are doomed to leave a extra new
# line here.
define(AC_INCLUDES_DEFAULT,
[ifelse([$1], [], [$ac_includes_default], [$1
])])





## -------------------------- ##
## Generic structure checks.  ##
## -------------------------- ##


# AC_CHECK_MEMBER(AGGREGATE.MEMBER,
#                 [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#                 [INCLUDES])
# ---------------------------------------------------------
# AGGREGATE.MEMBER is for instance `struct passwd.pw_gecos', shell
# variables are not a valid argument.
AC_DEFUN(AC_CHECK_MEMBER,
[AC_VAR_IF_INDIR([$1], [AC_FATAL([$0: requires literal arguments])])dnl
ifelse(regexp([$1], [\.]), -1,
       [AC_FATAL([$0: Did not see any dot in `$1'])])dnl
AC_REQUIRE([AC_HEADER_STDC])dnl
AC_VAR_PUSHDEF([ac_Member], [ac_cv_member_$1])dnl
dnl Extract the aggregate name, and the member name
AC_CACHE_CHECK([for $1], ac_Member,
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([AC_INCLUDES_DEFAULT([$4])],
[dnl AGGREGATE foo;
patsubst([$1], [\.[^.]*]) foo;
dnl foo.MEMBER;
foo.patsubst([$1], [.*\.]);])],
                AC_VAR_SET(ac_Member, yes),
                AC_VAR_SET(ac_Member, no))])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_Member) = yes],
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_Member])dnl
])# AC_CHECK_MEMBER


# AC_CHECK_MEMBER((AGGREGATE.MEMBER, ...),
#                 [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND]
#                 [INCLUDES])
# --------------------------------------------------------
# The first argument is an m4 list.  First because we want to
# promote m4 lists, and second because anyway there can be spaces
# in some types (struct etc.).
AC_DEFUN(AC_CHECK_MEMBERS,
[m4_foreach([AC_Member], [$1],
  [AC_SPECIALIZE([AC_CHECK_MEMBER], AC_Member,
         [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_[]AC_Member), 1,
                            [Define if `]patsubst(AC_Member, [.*\.])[' is
                             member of `]patsubst(AC_Member, [\.[^.]*])['.])
$2],
                 [$3],
                 [$4])])])





## ----------------------- ##
## Checking for programs.  ##
## ----------------------- ##


# _AC_WHICH_A(NAME, PATH)
# -----------------------
# Work like `which -a NAME' in PATH, even if NAME is not executable.
# Can be used inside backquotes.
define([_AC_WHICH_A],
[ac_save_ifs=$IFS; IFS=':'
dnl $ac_dummy forces splitting on constant user-supplied paths.
dnl POSIX.2 word splitting is done only on the output of word expansions,
dnl not every word.  This closes a longstanding sh security hole.
ac_dummy="$2"
for ac_dir in $ac_dummy; do
  test -z "$ac_dir" && ac_dir=.
  if test -f $ac_dir/$1; then
    echo "$ac_dir/$1"
  fi
done
IFS=$ac_save_ifs
])


# AC_CHECK_PROG(VARIABLE, PROG-TO-CHECK-FOR,
#               [VALUE-IF-FOUND], [VALUE-IF-NOT-FOUND],
#               [PATH], [REJECT])
# -----------------------------------------------------
AC_DEFUN(AC_CHECK_PROG,
[# Extract the first word of "$2", so it can be a program name with args.
set dummy $2; ac_word=$[2]
AC_MSG_CHECKING([for $ac_word])
AC_CACHE_VAL(ac_cv_prog_$1,
[if test -n "$$1"; then
  ac_cv_prog_$1="$$1" # Let the user override the test.
else
ifval([$6], [  ac_prog_rejected=no
])dnl
  for ac_path in `_AC_WHICH_A([$ac_word], [m4_default([$5], [$PATH])])`; do
ifval([$6],
[    if test "$ac_path" = "$6"; then
      ac_prog_rejected=yes
      continue
    fi
])dnl
    ac_cv_prog_$1="$3"
    break
  done
ifval([$6], [if test $ac_prog_rejected = yes; then
  # We found a bogon in the path, so make sure we never use it.
  set dummy $ac_cv_prog_$1
  shift
  if test $[#] -gt 0; then
    # We chose a different compiler from the bogus one.
    # However, it has the same basename, so the bogon will be chosen
    # first if we set $1 to just the basename; use the full file name.
    shift
    set dummy "$ac_path" ${1+"$[@]"}
    shift
    ac_cv_prog_$1="$[@]"
ifelse([$2], [$4],
[  else
    # Default is a loser.
    AC_MSG_ERROR([$1=$6 unacceptable, but no other $4 found in dnl
m4_default([$5], [\$PATH])])
])dnl
  fi
fi
])dnl
dnl If no 4th arg is given, leave the cache variable unset,
dnl so AC_CHECK_PROGS will keep looking.
ifval([$4], [  test -z "$ac_cv_prog_$1" && ac_cv_prog_$1="$4"
])dnl
fi])dnl
$1=$ac_cv_prog_$1
if test -n "$$1"; then
  AC_MSG_RESULT([$$1])
else
  AC_MSG_RESULT([no])
fi
AC_SUBST($1)dnl
])# AC_CHECK_PROG


# AC_CHECK_PROGS(VARIABLE, PROGS-TO-CHECK-FOR, [VALUE-IF-NOT-FOUND],
#                [PATH])
# ------------------------------------------------------------------
AC_DEFUN(AC_CHECK_PROGS,
[for ac_prog in $2
do
AC_CHECK_PROG([$1], $ac_prog, $ac_prog, , [$4])
test -n "$$1" && break
done
ifval([$3], [test -n "$$1" || $1="$3"
])])


# AC_PATH_PROG(VARIABLE, PROG-TO-CHECK-FOR, [VALUE-IF-NOT-FOUND], [PATH])
# -----------------------------------------------------------------------
AC_DEFUN(AC_PATH_PROG,
[# Extract the first word of "$2", so it can be a program name with args.
set dummy $2; ac_word=[$]2
AC_MSG_CHECKING([for $ac_word])
AC_CACHE_VAL(ac_cv_path_$1,
[case "[$]$1" in
  [[\\/]]* | ?:[[\\/]]*)
  ac_cv_path_$1="[$]$1" # Let the user override the test with a path.
  ;;
  *)
  ac_save_ifs=$IFS; IFS=':'
dnl $ac_dummy forces splitting on constant user-supplied paths.
dnl POSIX.2 word splitting is done only on the output of word expansions,
dnl not every word.  This closes a longstanding sh security hole.
  ac_dummy="m4_default([$4], [$PATH])"
  for ac_dir in $ac_dummy; do
    test -z "$ac_dir" && ac_dir=.
    if test -f "$ac_dir/$ac_word"; then
      ac_cv_path_$1=$ac_dir/$ac_word
      break
    fi
  done
  IFS=$ac_save_ifs
dnl If no 3rd arg is given, leave the cache variable unset,
dnl so AC_PATH_PROGS will keep looking.
ifval([$3], [  test -z "[$]ac_cv_path_$1" && ac_cv_path_$1="$3"
])dnl
  ;;
esac])dnl
$1=$ac_cv_path_$1
if test -n "[$]$1"; then
  AC_MSG_RESULT([$]$1)
else
  AC_MSG_RESULT(no)
fi
AC_SUBST($1)dnl
])# AC_PATH_PROG


# AC_PATH_PROGS(VARIABLE, PROGS-TO-CHECK-FOR, [VALUE-IF-NOT-FOUND],
#               [PATH])
# -----------------------------------------------------------------
AC_DEFUN(AC_PATH_PROGS,
[for ac_prog in $2
do
AC_PATH_PROG($1, [$]ac_prog, , $4)
test -n "[$]$1" && break
done
ifval([$3], [test -n "[$]$1" || $1="$3"
])])




## -------------------- ##
## Checking for tools.  ##
## -------------------- ##


# AC_CHECK_TOOL_PREFIX
# ---------------------
AC_DEFUN(AC_CHECK_TOOL_PREFIX,
[AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_REQUIRE([AC_CANONICAL_BUILD])dnl
if test $host != $build; then
  ac_tool_prefix=${host_alias}-
else
  ac_tool_prefix=
fi
])# AC_CHECK_TOOL_PREFIX


# AC_PATH_TOOL(VARIABLE, PROG-TO-CHECK-FOR, [VALUE-IF-NOT-FOUND], [PATH])
# -----------------------------------------------------------------------
AC_DEFUN(AC_PATH_TOOL,
[AC_REQUIRE([AC_CHECK_TOOL_PREFIX])dnl
AC_PATH_PROG($1, ${ac_tool_prefix}$2, ${ac_tool_prefix}$2,
             ifelse([$3], , [$2]), $4)
ifval([$3], [
if test -z "$ac_cv_prog_$1"; then
  if test -n "$ac_tool_prefix"; then
    AC_PATH_PROG($1, $2, $2, $3)
  else
    $1="$3"
  fi
fi])
])


# AC_CHECK_TOOL(VARIABLE, PROG-TO-CHECK-FOR, [VALUE-IF-NOT-FOUND], [PATH])
# ------------------------------------------------------------------------
AC_DEFUN(AC_CHECK_TOOL,
[AC_REQUIRE([AC_CHECK_TOOL_PREFIX])dnl
AC_CHECK_PROG($1, ${ac_tool_prefix}$2, ${ac_tool_prefix}$2,
	      ifelse([$3], , [$2], ), $4)
ifval([$3], [
if test -z "$ac_cv_prog_$1"; then
  if test -n "$ac_tool_prefix"; then
    AC_CHECK_PROG($1, $2, $2, $3)
  else
    $1="$3"
  fi
fi])
])


# AC_PREFIX_PROGRAM(PROGRAM)
# --------------------------
# Guess the value for the `prefix' variable by looking for
# the argument program along PATH and taking its parent.
# Example: if the argument is `gcc' and we find /usr/local/gnu/bin/gcc,
# set `prefix' to /usr/local/gnu.
# This comes too late to find a site file based on the prefix,
# and it might use a cached value for the path.
# No big loss, I think, since most configures don't use this macro anyway.
AC_DEFUN(AC_PREFIX_PROGRAM,
[dnl Get an upper case version of $[1].
pushdef(AC_Prog, translit($1, a-z, A-Z))dnl
if test "x$prefix" = xNONE; then
dnl We reimplement AC_MSG_CHECKING (mostly) to avoid the ... in the middle.
echo $ECHO_N "checking for prefix by $ECHO_C" >&AC_FD_MSG
AC_PATH_PROG(AC_Prog, $1)
  if test -n "$ac_cv_path_[]AC_Prog"; then
    prefix=`echo $ac_cv_path_[]AC_Prog | [sed 's%/[^/][^/]*//*[^/][^/]*$%%']`
  fi
fi
popdef([AC_Prog])dnl
])# AC_PREFIX_PROGRAM


# AC_TRY_COMPILER(TEST-PROGRAM, WORKING-VAR, CROSS-VAR)
# -----------------------------------------------------
# Try to compile, link and execute TEST-PROGRAM.  Set WORKING-VAR to
# `yes' if the current compiler works, otherwise set it ti `no'.  Set
# CROSS-VAR to `yes' if the compiler and linker produce non-native
# executables, otherwise set it to `no'.  Before calling
# `AC_TRY_COMPILER()', call `AC_LANG_*' to set-up for the right
# language.
AC_DEFUN(AC_TRY_COMPILER,
[AC_LINK_IFELSE([AC_LANG_SOURCE([[$1]])],
[[$2]=yes
  # If we can't run a trivial program, we are probably using a cross compiler.
  if (./conftest; exit) 2>/dev/null; then
    [$3]=no
  else
    [$3]=yes
  fi],
[[$2]=no])[]dnl
])# AC_TRY_COMPILER



## ------------------------ ##
## Checking for libraries.  ##
## ------------------------ ##


# AC_TRY_LINK_FUNC(FUNC, ACTION-IF-FOUND, ACTION-IF-NOT-FOUND)
# ------------------------------------------------------------
# Try to link a program that calls FUNC, handling GCC builtins.  If
# the link succeeds, execute ACTION-IF-FOUND; otherwise, execute
# ACTION-IF-NOT-FOUND.
AC_DEFUN(AC_TRY_LINK_FUNC,
[AC_LINK_IFELSE([AC_LANG_CALL([], [$1])], [$2], [$3])])


# AC_SEARCH_LIBS(FUNCTION, SEARCH-LIBS,
#                [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#                [OTHER-LIBRARIES])
# --------------------------------------------------------
# Search for a library defining FUNC, if it's not already available.
AC_DEFUN(AC_SEARCH_LIBS,
[AC_CACHE_CHECK([for library containing $1], [ac_cv_search_$1],
[ac_func_search_save_LIBS=$LIBS
ac_cv_search_$1=no
AC_TRY_LINK_FUNC([$1], [ac_cv_search_$1="none required"])
test "$ac_cv_search_$1" = no && for ac_lib in $2; do
LIBS="-l$ac_lib $5 $ac_func_search_save_LIBS"
AC_TRY_LINK_FUNC([$1],
[ac_cv_search_$1="-l$ac_lib"
break])
done
LIBS=$ac_func_search_save_LIBS])
AC_SHELL_IFELSE([test "$ac_cv_search_$1" != no],
  [test "$ac_cv_search_$1" = "none required" || LIBS="$ac_cv_search_$1 $LIBS"
  $3],
                [$4])[]dnl
])



# AC_CHECK_LIB(LIBRARY, FUNCTION,
#              [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#              [OTHER-LIBRARIES])
# ------------------------------------------------------
#
# Use a cache variable name containing both the library and function name,
# because the test really is for library $1 defining function $2, not
# just for library $1.  Separate tests with the same $1 and different $2s
# may have different results.
#
# FIXME: This macro is extremely suspicious.  It DEFINEs unconditionnally,
# whatever the FUNCTION, in addition to not being a *S macro.  Note
# that the cache does depend upon the function we are looking for.
AC_DEFUN(AC_CHECK_LIB,
[AH_CHECK_LIB([$1])dnl
AC_VAR_PUSHDEF([ac_Lib], [ac_cv_lib_$1_$2])dnl
AC_CACHE_CHECK([for $2 in -l$1], ac_Lib,
[ac_save_LIBS=$LIBS
LIBS="-l$1 $5 $LIBS"
AC_TRY_LINK_FUNC([$2],
                 [AC_VAR_SET(ac_Lib, yes)],
                 [AC_VAR_SET(ac_Lib, no)])
LIBS=$ac_save_LIBS])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_Lib) = yes],
                [m4_default([$3],
                            [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_LIB$1))
  LIBS="-l$1 $LIBS"
])],
                [$4])dnl
AC_VAR_POPDEF([ac_Lib])dnl
])# AC_CHECK_LIB


# AH_CHECK_LIB(LIBNAME)
# ---------------------
# FIXME: To be rigorous, this should not be systematic: depending
# upon the arguments of AC_CHECK_LIB, we might not AC_DEFINE.
define([AH_CHECK_LIB],
[AH_TEMPLATE(AC_TR_CPP(HAVE_LIB$1),
             [Define if you have the `]$1[' library (-l]$1[).])])


# AC_HAVE_LIBRARY(LIBRARY,
#                 [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#                 [OTHER-LIBRARIES])
# ---------------------------------------------------------
#
# This macro is equivalent to calling `AC_CHECK_LIB' with a FUNCTION
# argument of `main'.  In addition, LIBRARY can be written as any of
# `foo', `-lfoo', or `libfoo.a'.  In all of those cases, the compiler
# is passed `-lfoo'.  However, LIBRARY cannot be a shell variable;
# it must be a literal name.
AU_DEFUN(AC_HAVE_LIBRARY,
[pushdef([AC_Lib_Name],
         patsubst(patsubst([[$1]], [lib\([^\.]*\)\.a], [\1]), [-l], []))dnl
AC_CHECK_LIB(AC_Lib_Name, main, [$2], [$3], [$4])dnl
ac_cv_lib_[]AC_Lib_Name()=ac_cv_lib_[]AC_Lib_Name()_main
popdef([AC_Lib_Name])dnl
])



## ------------------------ ##
## Examining declarations.  ##
## ------------------------ ##


# AC_TRY_CPP(INCLUDES, [ACTION-IF-TRUE], [ACTION-IF-FALSE])
# ---------------------------------------------------------
# INCLUDES are not defaulted.
AC_DEFUN(AC_TRY_CPP,
[AC_REQUIRE_CPP()dnl
cat >conftest.$ac_ext <<EOF
AC_LANG_SOURCE([[$1]])
EOF
dnl Capture the stderr of cpp.  eval is necessary to expand ac_cpp.
dnl We used to copy stderr to stdout and capture it in a variable, but
dnl that breaks under sh -x, which writes compile commands starting
dnl with ` +' to stderr in eval and subshells.
ac_try="$ac_cpp conftest.$ac_ext >/dev/null 2>conftest.out"
AC_TRY_EVAL(ac_try)
ac_err=`grep -v '^ *+' conftest.out | grep -v "^conftest.${ac_ext}\$"`
if test -z "$ac_err"; then
  m4_default([$2], :)
else
  echo "$ac_err" >&AC_FD_LOG
  echo "configure: failed program was:" >&AC_FD_LOG
  cat conftest.$ac_ext >&AC_FD_LOG
  $3
fi
rm -f conftest*])


# AC_EGREP_HEADER(PATTERN, HEADER-FILE,
#                 [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# --------------------------------------------------------
AC_DEFUN(AC_EGREP_HEADER,
[AC_EGREP_CPP([$1],
[#include <$2>
], [$3], [$4])])


# AC_EGREP_CPP(PATTERN, PROGRAM,
#              [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# ------------------------------------------------------
# Because this macro is used by AC_PROG_GCC_TRADITIONAL, which must
# come early, it is not included in AC_BEFORE checks.
AC_DEFUN(AC_EGREP_CPP,
[AC_REQUIRE_CPP()dnl
cat >conftest.$ac_ext <<EOF
AC_LANG_SOURCE([[$2]])
EOF
dnl eval is necessary to expand ac_cpp.
dnl Ultrix and Pyramid sh refuse to redirect output of eval, so use subshell.
if (eval "$ac_cpp conftest.$ac_ext") 2>&AC_FD_LOG |
dnl Prevent m4 from eating character classes:
changequote(, )dnl
  egrep "$1" >/dev/null 2>&1; then
changequote([, ])dnl
  m4_default([$3], :)
ifval([$4], [else
  $4
])dnl
fi
rm -f conftest*
])# AC_EGREP_CPP



## ------------------ ##
## Examining syntax.  ##
## ------------------ ##


# AC_COMPILE_IFELSE(PROGRAM, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# --------------------------------------------------------------------
# Try to compile PROGRAM.
AC_DEFUN([AC_COMPILE_IFELSE],
[cat >conftest.$ac_ext <<EOF
$1
EOF
if AC_TRY_EVAL(ac_compile); then
  m4_default([$2], :)
else
  echo "configure: failed program was:" >&AC_FD_LOG
  cat conftest.$ac_ext >&AC_FD_LOG
ifval([$3],
[  $3
])dnl
fi
rm -f conftest*[]dnl
])# AC_COMPILE_IFELSE


# AC_TRY_COMPILE(INCLUDES, FUNCTION-BODY,
#              [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# --------------------------------------------------------
# FIXME: Should INCLUDES be defaulted here?
AC_DEFUN([AC_TRY_COMPILE],
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[$1]], [[$2]])], [$3], [$4])])



## --------------------- ##
## Examining libraries.  ##
## --------------------- ##


# AC_LINK_IFELSE(PROGRAM, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# -----------------------------------------------------------------
# Try to link PROGRAM.
AC_DEFUN([AC_LINK_IFELSE],
[cat >conftest.$ac_ext <<EOF
$1
EOF
if AC_TRY_EVAL(ac_link) && test -s conftest${ac_exeext}; then
  m4_default([$2], :)
else
  echo "configure: failed program was:" >&AC_FD_LOG
  cat conftest.$ac_ext >&AC_FD_LOG
ifval([$3],
[  $3
])dnl
fi
rm -f conftest*[]dnl
])# AC_LINK_IFELSE


# AC_TRY_LINK(INCLUDES, FUNCTION-BODY,
#             [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# -----------------------------------------------------
# Should the INCLUDES be defaulted here?
# Contrarily to AC_LINK_IFELSE, this macro double quote its first two args.
# FIXME: WARNING: The code to compile was different in the case of
# Fortran between AC_TRY_COMPILE and AC_TRY_LINK, though they should
# equivalent as far as I can tell from the semantics and the docs.  In
# the former, $[2] is used as is, in the latter, it is `call' ed.
# Remove these FIXME: once truth established.
AC_DEFUN([AC_TRY_LINK],
[AC_LINK_IFELSE([AC_LANG_PROGRAM([[$1]], [[$2]])], [$3], [$4])])


# AC_COMPILE_CHECK(ECHO-TEXT, INCLUDES, FUNCTION-BODY,
#                  ACTION-IF-FOUND, [ACTION-IF-NOT-FOUND])
# --------------------------------------------------------
AU_DEFUN(AC_COMPILE_CHECK,
[ifval([$1], [AC_CHECKING([for $1])
])dnl
AC_LINK_IFELSE([AC_LANG_PROGRAM([[$2]], [[$3]])], [$4], [$5])
])




## -------------------------------- ##
## Checking for run-time features.  ##
## -------------------------------- ##


# AC_RUN_IFELSE(PROGRAM, [ACTION-IF-TRUE], [ACTION-IF-FALSE])
# -----------------------------------------------------------
# Compile, link, and run.
AC_DEFUN([AC_RUN_IFELSE],
[cat >conftest.$ac_ext <<EOF
$1
EOF
if AC_TRY_EVAL(ac_link) &&
   test -s conftest${ac_exeext} && (./conftest; exit) 2>/dev/null; then
  m4_default([$2], :)
else
  echo "configure: failed program was:" >&AC_FD_LOG
  cat conftest.$ac_ext >&AC_FD_LOG
ifval([$3],
[  $3
])dnl
fi
rm -f conftest*[]dnl
])# AC_RUN_IFELSE


# AC_TRY_RUN(PROGRAM, [ACTION-IF-TRUE], [ACTION-IF-FALSE],
#            [ACTION-IF-CROSS-COMPILING])
# --------------------------------------------------------
AC_DEFUN([AC_TRY_RUN],
[if test "$cross_compiling" = yes; then
  m4_default([$4],
   [AC_DIAGNOSE([cross],
            [AC_TRY_RUN called without default to allow cross compiling])dnl
AC_MSG_ERROR(cannot run test program while cross compiling)])
else
  AC_RUN_IFELSE([AC_LANG_SOURCE([[$1]])], [$2], [$3])
fi
])# AC_TRY_RUN



## --------------------------- ##
## Checking for header files.  ##
## --------------------------- ##


# AC_CHECK_HEADER(HEADER-FILE, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# ----------------------------------------------------------------------
AC_DEFUN(AC_CHECK_HEADER,
[AC_VAR_PUSHDEF([ac_Header], [ac_cv_header_$1])dnl
AC_CACHE_CHECK([for $1], ac_Header,
[AC_TRY_CPP([#include <$1>
],
AC_VAR_SET(ac_Header, yes), AC_VAR_SET(ac_Header, no))])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_Header) = yes],
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_Header])dnl
])# AC_CHECK_HEADER


define(AH_CHECK_HEADERS,
[AC_FOREACH([AC_Header], [$1],
  [AH_TEMPLATE(AC_TR_CPP(HAVE_[]AC_Header),
               [Define if you have the <]AC_Header[> header file.])])])

# AC_CHECK_HEADERS(HEADER-FILE...
#                  [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# ----------------------------------------------------------
AC_DEFUN(AC_CHECK_HEADERS,
[AH_CHECK_HEADERS([$1])dnl
for ac_header in $1
do
AC_CHECK_HEADER($ac_header,
                [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_$ac_header)) $2],
                [$3])dnl
done
])


## ------------------------------------- ##
## Checking for the existence of files.  ##
## ------------------------------------- ##

# AC_CHECK_FILE(FILE, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# -------------------------------------------------------------
#
# Check for the existence of FILE.
AC_DEFUN(AC_CHECK_FILE,
[AC_DIAGNOSE([cross],
             [Cannot check for file existence when cross compiling])dnl
AC_VAR_PUSHDEF([ac_File], [ac_cv_file_$1])dnl
dnl FIXME: why was there this line? AC_REQUIRE([AC_PROG_CC])dnl
AC_CACHE_CHECK([for $1], ac_File,
[test "$cross_compiling" = yes &&
  AC_MSG_ERROR([Cannot check for file existence when cross compiling])
if test -r "[$1]"; then
  AC_VAR_SET(ac_File, yes)
else
  AC_VAR_SET(ac_File, no)
fi])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_File) = yes],
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_File])dnl
])# AC_CHECK_FILE


# AC_CHECK_FILES(FILE..., [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# -----------------------------------------------------------------
AC_DEFUN(AC_CHECK_FILES,
[AC_FOREACH([AC_FILE_NAME], [$1],
  [AC_SPECIALIZE([AC_CHECK_FILE], AC_FILE_NAME,
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_[]AC_FILE_NAME), 1,
                                   [Define if you have the file `]AC_File['.])
$2],
                 [$3])])])


## ------------------------------- ##
## Checking for declared symbols.  ##
## ------------------------------- ##


# AC_CHECK_DECL(SYMBOL,
#               [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#               [INCLUDES])
# -------------------------------------------------------
# Check if SYMBOL (a variable or a function) is declared.
AC_DEFUN([AC_CHECK_DECL],
[AC_VAR_PUSHDEF([ac_Symbol], [ac_cv_have_decl_$1])dnl
AC_CACHE_CHECK([whether $1 is declared], ac_Symbol,
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([AC_INCLUDES_DEFAULT([$4])],
[#ifndef $1
  char *p = (char *) $1;
#endif
])],
AC_VAR_SET(ac_Symbol, yes), AC_VAR_SET(ac_Symbol, no))])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_Symbol) = yes],
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_Symbol])dnl
])# AC_CHECK_DECL


# AC_CHECK_DECLS(SYMBOL,
#                [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#                [INCLUDES])
# --------------------------------------------------------
# Defines HAVE_DECL_SYMBOL to 1 if declared, 0 otherwise.  See the
# documentation for a detailed explanation of this difference with
# other AC_CHECK_*S macros.
AC_DEFUN([AC_CHECK_DECLS],
[m4_foreach([AC_Symbol], [$1],
  [AC_SPECIALIZE([AC_CHECK_DECL], AC_Symbol,
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP([HAVE_DECL_]AC_Symbol), 1,
                                     [Define to 1 if you have the declaration
                                     of `]AC_Symbol[', and to 0 if you don't.])
$2],
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP([HAVE_DECL_]AC_Symbol), 0)
$3],
                 [$4])])
])# AC_CHECK_DECLS


## -------------------------------- ##
## Checking for library functions.  ##
## -------------------------------- ##


# AC_CHECK_FUNC(FUNCTION, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# -----------------------------------------------------------------
AC_DEFUN(AC_CHECK_FUNC,
[AC_VAR_PUSHDEF([ac_var], [ac_cv_func_$1])dnl
AC_CACHE_CHECK([for $1], ac_var,
[AC_TRY_LINK(
dnl Don't include <ctype.h> because on OSF/1 3.0 it includes <sys/types.h>
dnl which includes <sys/select.h> which contains a prototype for
dnl select.  Similarly for bzero.
[/* System header to define __stub macros and hopefully few prototypes,
    which can conflict with char $1(); below.  */
#include <assert.h>
/* Override any gcc2 internal prototype to avoid an error.  */
#ifdef __cplusplus
extern "C"
#endif
/* We use char because int might match the return type of a gcc2
   builtin and then its argument prototype would still apply.  */
char $1();
char (*f)();
], [
/* The GNU C library defines this for functions which it implements
    to always fail with ENOSYS.  Some functions are actually named
    something starting with __ and the normal name is an alias.  */
#if defined (__stub_$1) || defined (__stub___$1)
choke me
#else
f = $1;
#endif
], AC_VAR_SET(ac_var, yes), AC_VAR_SET(ac_var, no))])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_var) = yes],
               [$2], [$3])dnl
AC_VAR_POPDEF([ac_var])dnl
])# AC_CHECK_FUNC


# AC_CHECK_FUNCS(FUNCTION..., [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# ---------------------------------------------------------------------
# FIXME: Should we die if there are not enough arguments, or just
# ignore?
AC_DEFUN(AC_CHECK_FUNCS,
[AC_FOREACH([AC_Func], [$1],
  [AH_TEMPLATE(AC_TR_CPP(HAVE_[]AC_Func),
               [Define if you have the `]AC_Func[' function.])])dnl
for ac_func in $1
do
AC_CHECK_FUNC($ac_func,
              [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_$ac_func)) $2],
              [$3])dnl
done
])


# AC_LIBOBJ_DECL(FILENAME-NOEXT)
# ------------------------------
# Announce we might need the file `FILENAME-NOEXT.c'.
define([AC_LIBOBJ_DECL], [])


# AC_LIBOBJ(FILENAME-NOEXT)
# -------------------------
# We need `FILENAME-NOEXT.o', save this into `LIBOBJS'.
# We don't use AC_SUBST/2 because it forces an unneeded eol.
define([AC_LIBOBJ],
[AC_VAR_IF_INDIR([$1],
                 [AC_DIAGNOSE(syntax,
                              [$0: you should use literals])],
                 [AC_LIBOBJ_DECL([$1])])dnl
AC_SUBST([LIBOBJS])dnl
LIBOBJS="$LIBOBJS $1.${ac_objext}"])


# AC_REPLACE_FUNCS(FUNCTION...)
# -----------------------------
AC_DEFUN([AC_REPLACE_FUNCS],
[AC_FOREACH([AC_Func], [$1], [AC_LIBOBJ_DECL(AC_Func)])dnl
AC_CHECK_FUNCS([$1], , [AC_LIBOBJ(${ac_func})])
])


## ----------------------------------- ##
## Checking compiler characteristics.  ##
## ----------------------------------- ##


# AC_CHECK_SIZEOF(TYPE, [CROSS-SIZE], [INCLUDES])
# -----------------------------------------------
# This macro will probably be obsoleted by the macros of Kaveh.  In
# addition `CHECK' is not a proper name (is not boolean).
AC_DEFUN(AC_CHECK_SIZEOF,
[AC_VAR_PUSHDEF([ac_Sizeof], [ac_cv_sizeof_$1])dnl
AC_CACHE_CHECK([size of $1], ac_Sizeof,
[AC_TRY_RUN(AC_INCLUDES_DEFAULT([$3])
[int
main ()
{
  FILE *f = fopen ("conftestval", "w");
  if (!f)
    exit (1);
  fprintf (f, "%d\n", sizeof ($1));
  exit (0);
}],
  AC_VAR_SET(ac_Sizeof, `cat conftestval`),
  AC_VAR_SET(ac_Sizeof, 0),
  ifval([$2], AC_VAR_SET(ac_Sizeof, $2)))])
AC_DEFINE_UNQUOTED(AC_TR_CPP(sizeof_$1),
                   AC_VAR_GET(ac_Sizeof),
                   [The number of bytes in a `]$1['.])
AC_VAR_POPDEF([ac_Sizeof])dnl
])



## -------------------- ##
## Checking for types.  ##
## -------------------- ##

# Up to 2.13 included, Autoconf used to provide the macro
#
#    AC_CHECK_TYPE(TYPE, DEFAULT)
#
# Since, it provides another version which fits better with the other
# AC_CHECK_ families:
#
#    AC_CHECK_TYPE(TYPE,
#	           [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#	           [INCLUDES])
#
# In order to provide backward compatibility, the new scheme is
# implemented as _AC_CHECK_TYPE_NEW, the old scheme as _AC_CHECK_TYPE_OLD,
# and AC_CHECK_TYPE branches to one or the other, depending upon its
# arguments.



# _AC_CHECK_TYPE_NEW(TYPE,
#		     [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#		     [INCLUDES])
# ------------------------------------------------------------
# Check whether the type TYPE is supported by the system, maybe via the
# the provided includes.  This macro implements the former task of
# AC_CHECK_TYPE, with one big difference though: AC_CHECK_TYPE was
# grepping in the headers, which, BTW, led to many problems until
# the egrep expression was correct and did not given false positives.
# It turned out there are even portability issues with egrep...
#
# The most obvious way to check for a TYPE is just to compile a variable
# definition:
#
# 	  TYPE my_var;
#
# Unfortunately this does not work for const qualified types in C++,
# where you need an initializer.  So you think of
#
# 	  TYPE my_var = (TYPE) 0;
#
# Unfortunately, again, this is not valid for some C++ classes.
#
# Then you look for another scheme.  For instance you think of declaring
# a function which uses a parameter of type TYPE:
#
# 	  int foo (TYPE param);
#
# but of course you soon realize this does not make it with K&R
# compilers.  And by no ways you want to
#
# 	  int foo (param)
# 	    TYPE param
# 	  { ; }
#
# since this time it's C++ who is not happy.
#
# Don't even think of the return type of a function, since K&R cries
# there too.  So you start thinking of declaring a *pointer* to this TYPE:
#
# 	  TYPE *p;
#
# but you know fairly well that this is legal in C for aggregates which
# are unknown (TYPE = struct does-not-exist).
#
# Then you think of using sizeof to make sure the TYPE is really
# defined:
#
# 	  sizeof (TYPE);
#
# But this succeeds if TYPE is a variable: you get the size of the
# variable's type!!!
#
# This time you tell yourself the last two options *together* will make
# it.  And indeed this is the solution invented by Alexandre Oliva.
#
# Also note that we use
#
# 	  if (sizeof (TYPE))
#
# to `read' sizeof (to avoid warnings), while not depending on its type
# (not necessarily size_t etc.).  Equally, instead of defining an unused
# variable, we just use a cast to avoid warnings from the compiler.
# Suggested by Paul Eggert.
AC_DEFUN([_AC_CHECK_TYPE_NEW],
[AC_REQUIRE([AC_HEADER_STDC])dnl
AC_VAR_PUSHDEF([ac_Type], [ac_cv_type_$1])dnl
AC_CACHE_CHECK([for $1], ac_Type,
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([AC_INCLUDES_DEFAULT([$4])],
[if (($1 *) 0)
  return 0;
if (sizeof ($1))
  return 0;])],
                AC_VAR_SET(ac_Type, yes),
                AC_VAR_SET(ac_Type, no))])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_Type) = yes],
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_Type])dnl
])# _AC_CHECK_TYPE_NEW


# AC_CHECK_TYPES((TYPE, ...),
#                [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#                [INCLUDES])
# --------------------------------------------------------
# TYPEs is an m4 list.  There are no ambiguities here, we mean the newer
# AC_CHECK_TYPE.
AC_DEFUN([AC_CHECK_TYPES],
[m4_foreach([AC_Type], [$1],
  [AC_SPECIALIZE([_AC_CHECK_TYPE_NEW], AC_Type,
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_[]AC_Type), 1,
                                     [Define if the system has the type
                                      `]AC_Type['.])
$2],
                 [$3],
                 [$4])])])


# _AC_CHECK_TYPE_OLD(TYPE, DEFAULT)
# ---------------------------------
# FIXME: This is an extremely badly chosen name, since this
# macro actually performs an AC_REPLACE_TYPE.  Some day we
# have to clean this up.
AC_DEFUN([_AC_CHECK_TYPE_OLD],
[_AC_CHECK_TYPE_NEW([$1],,
   [AC_DEFINE_UNQUOTED([$1], [$2],
                       [Define to `$2' if <sys/types.h> does not define.])])dnl
])# _AC_CHECK_TYPE_OLD


# _AC_CHECK_TYPE_BUILTIN_P(STRING)
# --------------------------------
# Return `1' if STRING seems to be a builtin C/C++ type, i.e., if it
# starts with `_Bool', `bool', `char', `double', `float', `int',
# `long', `short', `signed', or `unsigned' followed by characters
# that are defining types.
define([_AC_CHECK_TYPE_BUILTIN_P],
[ifelse(regexp([$1], [^\(_Bool\|bool|\char\|double\|float\|int\|long\|short\|\(un\)?signed\)\([_a-zA-Z0-9() *]\|\[\|\]\)*$]),
	0, 1, 0)dnl
])# _AC_CHECK_TYPE_BUILTIN_P


# AC_CHECK_TYPE(TYPE, DEFAULT)
#  or
# AC_CHECK_TYPE(TYPE,
#	        [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#	        [INCLUDES])
# -------------------------------------------------------
#
# Dispatch respectively to _AC_CHECK_TYPE_OLD or _AC_CHECK_TYPE_NEW.
# 1. More than two arguments     => NEW
# 2. $2 seems to be builtin type => OLD
# 3. $2 seems to be a type       => NEW plus a warning
# 4. default                     => NEW
AC_DEFUN([AC_CHECK_TYPE],
[ifelse($#, 3, [_AC_CHECK_TYPE_NEW($@)],
        $#, 4, [_AC_CHECK_TYPE_NEW($@)],
        _AC_CHECK_TYPE_BUILTIN_P([$2]), 1, [_AC_CHECK_TYPE_OLD($@)],
        regexp([$2], [^[_a-zA-Z0-9 ]+\([_a-zA-Z0-9() *]\|\[\|\]\)*$]), 0, [m4_warn([$0: assuming `$2' is not a type])_AC_CHECK_TYPE_NEW($@)],
        [_AC_CHECK_TYPE_NEW($@)])[]dnl
])# AC_CHECK_TYPE



## ----------------------- ##
## Creating output files.  ##
## ----------------------- ##


# This section handles about all the preparation aspects for
# `config.status': registering the configuration files, the headers,
# the links, and the commands `config.status' will run.  There is a
# little mixture though of things actually handled by `configure',
# such as running the `configure' in the sub directories.  Minor
# detail.
#
# There are two kinds of commands:
#
# COMMANDS:
#
#   They are output into `config.status' via a quoted here doc.  These
#   commands are always associated to a tag which the user can use to
#   tell `config.status' what are the commands she wants to run.
#
# INIT-CMDS:
#
#   They are output via an *unquoted* here-doc.  As a consequence $var
#   will be output as the value of VAR.  This is typically used by
#   `configure' to give `config,.status' some variables it needs to run
#   the COMMANDS.  At the difference of `COMMANDS', the INIT-CMDS are
#   always run.
#
#
# Some uniformity exists around here, please respect it!
#
# A macro named AC_CONFIG_FOOS has three args: the `TAG...' (or
# `FILE...'  when it applies), the `COMMANDS' and the `INIT-CMDS'.  It
# first checks that TAG was not registered elsewhere thanks to
# AC_CONFIG_UNIQUE.  Then it registers `TAG...' in AC_LIST_FOOS, and for
# each `TAG', a special line in AC_LIST_FOOS_COMMANDS which is used in
# `config.status' like this:
#
# 	  case $ac_tag in
# 	    AC_LIST_FOOS_COMMANDS
# 	  esac
#
# Finally, the `INIT-CMDS' are dumped into a special diversion, via
# `_AC_CONFIG_COMMANDS_INIT'.  While `COMMANDS' are output once per TAG,
# `INIT-CMDS' are dumpdef only once per call to AC_CONFIG_FOOS.
#
# AC_CONFIG_FOOS can be called several times (with different TAGs of
# course).
#
# Because these macros should not output anything, there should be `dnl'
# everywhere.  A pain my friend, a pain.  So instead in each macro we
# divert(-1) and restore the diversion at the end.
#
#
# Honorable members of this family are AC_CONFIG_FILES,
# AC_CONFIG_HEADERS, AC_CONFIG_LINKS and AC_CONFIG_COMMANDS.  Bad boys
# are AC_LINK_FILES, AC_OUTPUT_COMMANDS and AC_OUTPUT when used with
# arguments.  False members are AC_CONFIG_SRCDIR, AC_CONFIG_SUBDIRS
# and AC_CONFIG_AUX_DIR.  Cousins are AC_CONFIG_COMMANDS_PRE and
# AC_CONFIG_COMMANDS_POST.



# AC_CONFIG_IF_MEMBER(DEST, LIST, ACTION-IF-TRUE, ACTION-IF-FALSE)
# ----------------------------------------------------------------
# If DEST is member of LIST, expand to ACTION-IF-TRUE, else ACTION-IF-FALSE.
#
# LIST is an AC_CONFIG list, i.e., a list of DEST[:SOURCE], separated
# with spaces.
#
# FIXME: This macro is badly designed, but I'm not guilty: m4 is.  There
# is just no way to simply compare two strings in m4, but to use pattern
# matching.  The big problem is then that the active characters should
# be quoted.  Currently `+*.' are quoted.
define(AC_CONFIG_IF_MEMBER,
[ifelse(regexp($2, [\(^\| \)]patsubst([$1],
                                      [\([+*.]\)], [\\\1])[\(:\| \|$\)]),
        -1, [$4], [$3])])


# _AC_CONFIG_UNIQUE(DEST[:SOURCE]...)
# -----------------------------------
#
# Verify that there is no double definition of an output file
# (precisely, guarantees there is no common elements between
# CONFIG_HEADERS, CONFIG_FILES, CONFIG_LINKS, and CONFIG_SUBDIRS).
#
# Note that this macro does not check if the list $[1] itself
# contains doubles.
define(_AC_CONFIG_UNIQUE,
[AC_DIVERT_PUSH([KILL])
AC_FOREACH([AC_File], [$1],
[pushdef([AC_Dest], patsubst(AC_File, [:.*]))
AC_CONFIG_IF_MEMBER(AC_Dest, [AC_LIST_HEADERS],
     [AC_FATAL(`AC_Dest' [is already registered with AC_CONFIG_HEADER or AC_CONFIG_HEADERS.])])
  AC_CONFIG_IF_MEMBER(AC_Dest, [AC_LIST_LINKS],
     [AC_FATAL(`AC_Dest' [is already registered with AC_CONFIG_LINKS.])])
  AC_CONFIG_IF_MEMBER(AC_Dest, [AC_LIST_SUBDIRS],
     [AC_FATAL(`AC_Dest' [is already registered with AC_CONFIG_SUBDIRS.])])
  AC_CONFIG_IF_MEMBER(AC_Dest, [AC_LIST_COMMANDS],
     [AC_FATAL(`AC_Dest' [is already registered with AC_CONFIG_COMMANDS.])])
  AC_CONFIG_IF_MEMBER(AC_Dest, [AC_LIST_FILES],
     [AC_FATAL(`AC_Dest' [is already registered with AC_CONFIG_FILES or AC_OUTPUT.])])
popdef([AC_Dest])])
AC_DIVERT_POP()dnl
])


# _AC_CONFIG_COMMANDS_INIT([INIT-COMMANDS])
# -----------------------------------------
#
# Register INIT-COMMANDS as command pasted *unquoted* in
# `config.status'.  This is typically used to pass variables from
# `configure' to `config.status'.  Note that $[1] is not over quoted as
# was the case in AC_OUTPUT_COMMANDS.
define(_AC_CONFIG_COMMANDS_INIT,
[ifval([$1],
[m4_append([_AC_OUTPUT_COMMANDS_INIT], [$1
])])])

# Initialize.
define([_AC_OUTPUT_COMMANDS_INIT])


# AC_CONFIG_COMMANDS(NAME...,[COMMANDS], [INIT-CMDS])
# ---------------------------------------------------
#
# Specify additional commands to be run by config.status.  This
# commands must be associated with a NAME, which should be thought
# as the name of a file the COMMANDS create.
AC_DEFUN([AC_CONFIG_COMMANDS],
[AC_DIVERT_PUSH([KILL])
_AC_CONFIG_UNIQUE([$1])
m4_append([AC_LIST_COMMANDS], [ $1])

ifelse([$2],,, [AC_FOREACH([AC_Name], [$1],
[m4_append([AC_LIST_COMMANDS_COMMANDS],
[    ]patsubst(AC_Name, [:.*])[ ) $2 ;;
])])])
_AC_CONFIG_COMMANDS_INIT([$3])
AC_DIVERT_POP()dnl
])dnl

# Initialize the lists.
define([AC_LIST_COMMANDS])
define([AC_LIST_COMMANDS_COMMANDS])


# AC_OUTPUT_COMMANDS(EXTRA-CMDS, INIT-CMDS)
# -----------------------------------------
#
# Add additional commands for AC_OUTPUT to put into config.status.
#
# This macro is an obsolete version of AC_CONFIG_COMMANDS.  The only
# difficulty in mapping AC_OUTPUT_COMMANDS to AC_CONFIG_COMMANDS is
# to give a unique key.  The scheme we have chosen is `default-1',
# `default-2' etc. for each call.
#
# Unfortunately this scheme is fragile: bad things might happen
# if you update an included file and configure.in: you might have
# clashes :(  On the other hand, I'd like to avoid weird keys (e.g.,
# depending upon __file__ or the pid).
AU_DEFUN(AC_OUTPUT_COMMANDS,
[define([AC_OUTPUT_COMMANDS_CNT], incr(AC_OUTPUT_COMMANDS_CNT))dnl
dnl Double quoted since that was the case in the original macro.
AC_CONFIG_COMMANDS([default-]AC_OUTPUT_COMMANDS_CNT, [[$1]], [[$2]])dnl
])

# Initialize both in `autoconf::' and `autoupdate::'.
define(AC_OUTPUT_COMMANDS_CNT, 0)
m4_namespace_define(autoupdate,
                    [AC_OUTPUT_COMMANDS_CNT], 0)


# AC_CONFIG_COMMANDS_PRE(CMDS)
# ----------------------------
# Commands to run right before config.status is created. Accumulates.
AC_DEFUN([AC_CONFIG_COMMANDS_PRE],
[m4_append([AC_OUTPUT_COMMANDS_PRE], [$1
])])

# Initialize.
define([AC_OUTPUT_COMMANDS_PRE])


# AC_CONFIG_COMMANDS_POST(CMDS)
# -----------------------------
# Commands to run after config.status was created.  Accumulates.
AC_DEFUN([AC_CONFIG_COMMANDS_POST],
[m4_append([AC_OUTPUT_COMMANDS_POST], [$1
])])

# Initialize.
define([AC_OUTPUT_COMMANDS_POST])


# AC_CONFIG_HEADERS(HEADERS..., [COMMANDS], [INIT-CMDS])
# ------------------------------------------------------
# Specify that the HEADERS are to be created by instantiation of the
# AC_DEFINEs.  Associate the COMMANDS to the HEADERS.  This macro
# accumulates if called several times.
#
# The commands are stored in a growing string AC_LIST_HEADERS_COMMANDS
# which should be used like this:
#
#      case $ac_file in
#        AC_LIST_HEADERS_COMMANDS
#      esac
AC_DEFUN([AC_CONFIG_HEADERS],
[AC_DIVERT_PUSH([KILL])
_AC_CONFIG_UNIQUE([$1])
m4_append([AC_LIST_HEADERS], [ $1])
dnl Register the commands
ifelse([$2],,, [AC_FOREACH([AC_File], [$1],
[m4_append([AC_LIST_HEADERS_COMMANDS],
[    ]patsubst(AC_File, [:.*])[ ) $2 ;;
])])])
_AC_CONFIG_COMMANDS_INIT([$3])
AC_DIVERT_POP()dnl
])dnl

# Initialize to empty.  It is much easier and uniform to have a config
# list expand to empty when undefined, instead of special casing when
# not defined (since in this case, AC_CONFIG_FOO expands to AC_CONFIG_FOO).
define([AC_LIST_HEADERS])
define([AC_LIST_HEADERS_COMMANDS])


# AC_CONFIG_HEADER(HEADER-TO-CREATE ...)
# --------------------------------------
# FIXME: Make it obsolete?
AC_DEFUN(AC_CONFIG_HEADER,
[AC_CONFIG_HEADERS([$1])])


# AC_CONFIG_LINKS(DEST:SOURCE..., [COMMANDS], [INIT-CMDS])
# --------------------------------------------------------
# Specify that config.status should establish a (symbolic if possible)
# link from TOP_SRCDIR/SOURCE to TOP_SRCDIR/DEST.
# Reject DEST=., because it is makes it hard for ./config.status
# to guess the links to establish (`./config.status .').
AC_DEFUN(AC_CONFIG_LINKS,
[AC_DIVERT_PUSH([KILL])
_AC_CONFIG_UNIQUE([$1])
ifelse(regexp([$1], [^\.:\| \.:]), -1,,
       [AC_FATAL([$0: invalid destination: `.'])])
m4_append([AC_LIST_LINKS], [ $1])
dnl Register the commands
ifelse([$2],,, [AC_FOREACH([AC_File], [$1],
[m4_append([AC_LIST_LINKS_COMMANDS],
[    ]patsubst(AC_File, [:.*])[ ) $2 ;;
])])])
_AC_CONFIG_COMMANDS_INIT([$3])
AC_DIVERT_POP()dnl
])dnl


# Initialize the list.
define([AC_LIST_LINKS])
define([AC_LIST_LINKS_COMMANDS])


# AC_LINK_FILES(SOURCE..., DEST...)
# ---------------------------------
# Link each of the existing files SOURCE... to the corresponding
# link name in DEST...
#
# Unfortunately we can't provide a very good autoupdate service here,
# since in `AC_LINK_FILES($from, $to)' it is possible that `$from'
# and `$to' are actually lists.  It would then be completely wrong to
# replace it with `AC_CONFIG_LINKS($to:$from).  It is possible in the
# case of literal values though, but because I don't think there is any
# interest in creating config links with literal values, no special
# mechanism is implemented to handle them.
#
# _AC_LINK_CNT is used to be robust to multiple calls.
AU_DEFUN([AC_LINK_FILES],
[ifelse($#, 2, ,
        [m4_fatal([$0: incorrect number of arguments])])dnl
define([_AC_LINK_FILES_CNT], incr(_AC_LINK_FILES_CNT))dnl
ac_sources="$1"
ac_dests="$2"
while test -n "$ac_sources"; do
  set $ac_dests; ac_dest=[$]1; shift; ac_dests=[$]*
  set $ac_sources; ac_source=[$]1; shift; ac_sources=[$]*
  [ac_config_links_]_AC_LINK_FILES_CNT="$[ac_config_links_]_AC_LINK_FILES_CNT $ac_dest:$ac_source"
done
AC_CONFIG_LINKS($[ac_config_links_]_AC_LINK_FILES_CNT)dnl
],
[
  It is technically impossible to `autoupdate' cleanly from AC_LINK_FILES
  to AC_CONFIG_FILES.  `autoupdate' provides a functional but inelegant
  update, you should probably tune the result yourself.])# AC_LINK_FILES


# Initialize both in `autoconf::' and `autoupdate::'.
define(_AC_LINK_FILES_CNT, 0)
m4_namespace_define(autoupdate,
                    [_AC_LINK_FILES_CNT], 0)



# AC_CONFIG_FILES(FILE..., [COMMANDS], [INIT-CMDS])
# -------------------------------------------------
# Specify output files, as with AC_OUTPUT, i.e., files that are
# configured with AC_SUBST.  Associate the COMMANDS to each FILE,
# i.e., when config.status creates FILE, run COMMANDS afterwards.
#
# The commands are stored in a growing string AC_LIST_FILES_COMMANDS
# which should be used like this:
#
#      case $ac_file in
#        AC_LIST_FILES_COMMANDS
#      esac
AC_DEFUN([AC_CONFIG_FILES],
[AC_DIVERT_PUSH([KILL])
_AC_CONFIG_UNIQUE([$1])
m4_append([AC_LIST_FILES], [ $1])
dnl Register the commands.
ifelse([$2],,, [AC_FOREACH([AC_File], [$1],
[m4_append([AC_LIST_FILES_COMMANDS],
[    ]patsubst(AC_File, [:.*])[ ) $2 ;;
])])])
_AC_CONFIG_COMMANDS_INIT([$3])
AC_DIVERT_POP()dnl
])dnl

# Initialize the lists.
define([AC_LIST_FILES])
define([AC_LIST_FILES_COMMANDS])


# AC_CONFIG_SUBDIRS(DIR ...)
# --------------------------
# FIXME: `subdirs=' should not be here.
AC_DEFUN(AC_CONFIG_SUBDIRS,
[_AC_CONFIG_UNIQUE([$1])dnl
AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
m4_append([AC_LIST_SUBDIRS], [ $1])dnl
subdirs="AC_LIST_SUBDIRS"
AC_SUBST(subdirs)dnl
])

# Initialize the list.
define([AC_LIST_SUBDIRS])


# AC_OUTPUT([CONFIG_FILES...], [EXTRA-CMDS], [INIT-CMDS])
# -------------------------------------------------------
# The big finish.
# Produce config.status, config.h, and links; and configure subdirs.
# The CONFIG_HEADERS are defined in the m4 variable AC_LIST_HEADERS.
# Pay special attention not to have too long here docs: some old
# shells die.  Unfortunately the limit is not known precisely...
define(AC_OUTPUT,
[dnl Dispatch the extra arguments to their native macros.
ifval([$1],
      [AC_CONFIG_FILES([$1])])dnl
ifval([$2$3],
      [AC_CONFIG_COMMANDS(default, [$2], [$3])])dnl
trap '' 1 2 15
AC_CACHE_SAVE
trap 'rm -fr conftest* confdefs* core core.* *.core $ac_clean_files; exit 1' 1 2 15

test "x$prefix" = xNONE && prefix=$ac_default_prefix
# Let make expand exec_prefix.
test "x$exec_prefix" = xNONE && exec_prefix='${prefix}'

# Any assignment to VPATH causes Sun make to only execute
# the first set of double-colon rules, so remove it if not needed.
# If there is a colon in the path, we need to keep it.
if test "x$srcdir" = x.; then
  ac_vpsub=['/^[ 	]*VPATH[ 	]*=[^:]*$/d']
fi

ifset([AC_LIST_HEADERS], [DEFS=-DHAVE_CONFIG_H], [AC_OUTPUT_MAKE_DEFS()])

dnl Commands to run before creating config.status.
AC_OUTPUT_COMMANDS_PRE()dnl

# Save into config.log some information that might help in debugging.
echo >&AC_FD_LOG
echo "Cache variables:" >&AC_FD_LOG
_AC_CACHE_DUMP | sed -e 's/^/| /' >&AC_FD_LOG
echo >&AC_FD_LOG
echo "confdefs.h:" >&AC_FD_LOG
cat confdefs.h | sed -e 's/^/| /' >&AC_FD_LOG

: ${CONFIG_STATUS=./config.status}
trap 'rm -f $CONFIG_STATUS conftest*; exit 1' 1 2 15
_AC_OUTPUT_CONFIG_STATUS()dnl
rm -fr confdefs* $ac_clean_files
trap 'exit 1' 1 2 15

dnl Commands to run after config.status was created
AC_OUTPUT_COMMANDS_POST()dnl

test "$no_create" = yes || $SHELL $CONFIG_STATUS || exit 1
dnl config.status should not do recursion.
ifset([AC_LIST_SUBDIRS], [_AC_OUTPUT_SUBDIRS()])dnl
])# AC_OUTPUT


# autoupdate::AC_OUTPUT([CONFIG_FILES...], [EXTRA-CMDS], [INIT-CMDS])
# -------------------------------------------------------------------
#
# If there are arguments given to AC_OUTPUT, dispatch them to the
# proper modern macros.

AU_DEFINE([AC_OUTPUT],
[ifval([$1],
      [AC_CONFIG_FILES([$1])
])dnl
ifval([$2$3],
      [AC_CONFIG_COMMANDS(default, [[$2]], [[$3]])
])dnl
[AC_OUTPUT]],
[`AC_OUTPUT' should be used without arguments.])


# _AC_OUTPUT_CONFIG_STATUS
# ------------------------
# Produce config.status.  Called by AC_OUTPUT.
# Pay special attention not to have too long here docs: some old
# shells die.  Unfortunately the limit is not known precisely...
define([_AC_OUTPUT_CONFIG_STATUS],
[echo creating $CONFIG_STATUS
cat >$CONFIG_STATUS <<EOF
#! /bin/sh
# Generated automatically by configure.
# Run this file to recreate the current configuration.
# Compiler output produced by configure, useful for debugging
# configure, is in ./config.log if it exists.

configure=$[0]
configure_args=$ac_configure_args
debug=false
EOF

cat >>$CONFIG_STATUS <<\EOF
me=`echo "$[0]" | sed -e 's,.*/,,'`
SHELL=${CONFIG_SHELL-/bin/sh}

# Files that config.status was made for.
ifset([AC_LIST_FILES], [config_files="\
m4_wrap(AC_LIST_FILES, [  ])"
])dnl
ifset([AC_LIST_HEADERS], [config_headers="\
m4_wrap(AC_LIST_HEADERS, [  ])"
])dnl
ifset([AC_LIST_LINKS], [config_links="\
m4_wrap(AC_LIST_LINKS, [  ])"
])dnl
ifset([AC_LIST_COMMANDS], [config_commands="\
m4_wrap(AC_LIST_COMMANDS, [  ])"
])dnl

ac_cs_usage="\
\`$me' instantiates files from templates according to the
current configuration.

Usage: $[0] [[OPTIONS]] FILE...

  -h, --help       print this help, then exit
  -V, --version    print version number, then exit
  -d, --debug      don't remove temporary files
      --recheck    update $me by reconfiguring in the same conditions
ifset([AC_LIST_FILES],
[[  --file=FILE[:TEMPLATE]
                   instantiate the configuration file FILE
]])dnl
ifset([AC_LIST_HEADERS],
[[  --header=FILE[:TEMPLATE]
                   instantiate the configuration header FILE
]])dnl

ifset([AC_LIST_FILES],
[Configuration files:
$config_files

])dnl
ifset([AC_LIST_HEADERS],
[Configuration headers:
$config_headers

])dnl
ifset([AC_LIST_LINKS],
[Configuration links:
$config_links

])dnl
ifset([AC_LIST_COMMANDS],
[Configuration commands:
$config_commands

])dnl
Report bugs to <bug-autoconf@gnu.org>."
EOF

dnl hostname on some systems (SVR3.2, Linux) returns a bogus exit status,
dnl so uname gets run too.
cat >>$CONFIG_STATUS <<EOF
ac_cs_version="\\
$CONFIG_STATUS generated by autoconf version AC_ACVERSION.
Configured on host `(hostname || uname -n) 2>/dev/null | sed 1q` by
  $configure $configure_arg"

ac_given_srcdir=$srcdir
AC_PROVIDE_IFELSE([AC_PROG_INSTALL],
[dnl Leave those double quotes here: this $INSTALL is evaluated in a
dnl here document, wbich might result in `ac_given_srcdir=/bin/install -c'.
ac_given_INSTALL="$INSTALL"
])dnl
EOF

cat >>$CONFIG_STATUS <<\EOF
# If no file are specified by the user, then we need to provide default
# value.  By we need to know if files were specified by the user.
ac_need_defaults=:
while test $[#] != 0
do
  case "$[1]" in
  --*=*)
    ac_option=`echo "$[1]" | sed -e 's/=.*//'`
    ac_optarg=`echo "$[1]" | sed -e ['s/[^=]*=//']`
    shift
    set dummy "[\$]ac_option" "$ac_optarg" ${1+"$[@]"}
    shift
    ;;
  -*);;
  *) # This is not an option, so the user has probably given explicit
     # arguments.
     ac_need_defaults=false;;
  esac

  case "$[1]" in

  # Handling of the options.
  -recheck | --recheck | --rechec | --reche | --rech | --rec | --re | --r)
dnl The following line is extremely suspicious: there are double quotes
dnl inside a "`...`" (which is not portable).  But it is actually safe,
dnl since we are in an unquoted here doc, which will skip the outer pair
dnl of double quotes, and only eval the back quotes.
    echo "running $SHELL $configure $configure_args --no-create --no-recursion"
    exec $SHELL $configure $configure_args --no-create --no-recursion ;;
  --version | --vers* | -V )
    echo "$ac_cs_version"; exit 0 ;;
  --he | --h)
    # Conflict between --help and --header
    echo "$me: ambiguous option: $ac_option
Try \`$me --help' for more information."; exit 1 ;;
  --help | --hel | -h )
    echo "$ac_cs_usage"; exit 0 ;;
  --debug | --d* | -d )
    debug=:; shift ;;
  --file | --fil | --fi | --f )
    shift
    CONFIG_FILES="$CONFIG_FILES $[1]"
    ac_need_defaults=false;;
  --header | --heade | --head | --hea )
    shift
    CONFIG_HEADERS="$CONFIG_HEADERS $[1]"
    ac_need_defaults=false;;

  # Handling of arguments.
AC_FOREACH([AC_File], AC_LIST_FILES,
[  'patsubst(AC_File, [:.*])' )dnl
 CONFIG_FILES="$CONFIG_FILES AC_File" ;;
])dnl
AC_FOREACH([AC_File], AC_LIST_LINKS,
[  'patsubst(AC_File, [:.*])' )dnl
 CONFIG_LINKS="$CONFIG_LINKS AC_File" ;;
])dnl
AC_FOREACH([AC_File], AC_LIST_COMMANDS,
[  'patsubst(AC_File, [:.*])' )dnl
 CONFIG_COMMANDS="$CONFIG_COMMANDS AC_File" ;;
])dnl
AC_FOREACH([AC_File], AC_LIST_HEADERS,
[  'patsubst(AC_File, [:.*])' )dnl
 CONFIG_HEADERS="$CONFIG_HEADERS AC_File" ;;
])dnl

  # This is an error.
  -*) echo "$me: unrecognized option: $[1]
Try \`$me --help' for more information."; exit 1 ;;
  *) echo "$me: invalid argument: $[1]"; exit 1 ;;
  esac
  shift
done

EOF

dnl Issue this section only if there were actually config files.
dnl This checks if one of AC_LIST_HEADERS, AC_LIST_FILES, AC_LIST_COMMANDS,
dnl or AC_LIST_LINKS is set.
ifval(AC_LIST_HEADERS()AC_LIST_LINKS()AC_LIST_FILES()AC_LIST_COMMANDS(),
[cat >>$CONFIG_STATUS <<\EOF
# If the user did not use the arguments to specify the items to instantiate,
# then the envvar interface is used.  Set only those that are not.
if $ac_need_defaults; then
ifset([AC_LIST_FILES], [  : ${CONFIG_FILES=$config_files}
])dnl
ifset([AC_LIST_HEADERS], [  : ${CONFIG_HEADERS=$config_headers}
])dnl
ifset([AC_LIST_LINKS], [  : ${CONFIG_LINKS=$config_links}
])dnl
ifset([AC_LIST_COMMANDS], [  : ${CONFIG_COMMANDS=$config_commands}
])dnl
fi

_AC_SHELL_TMPDIR(cs)

EOF
])[]dnl ifval

dnl We output the INIT-CMDS first for obvious reasons :)
ifset([_AC_OUTPUT_COMMANDS_INIT],
[cat >>$CONFIG_STATUS <<EOF
#
# INIT-COMMANDS section.
#

_AC_OUTPUT_COMMANDS_INIT()
EOF])


dnl The following four sections are in charge of their own here
dnl documenting into $CONFIG_STATUS.
ifset([AC_LIST_FILES],    [_AC_OUTPUT_FILES()])dnl
ifset([AC_LIST_HEADERS],  [_AC_OUTPUT_HEADERS()])dnl
ifset([AC_LIST_LINKS],    [_AC_OUTPUT_LINKS()])dnl
ifset([AC_LIST_COMMANDS], [_AC_OUTPUT_COMMANDS()])dnl

cat >>$CONFIG_STATUS <<\EOF

exit 0
EOF
chmod +x $CONFIG_STATUS
])# _AC_OUTPUT_CONFIG_STATUS


# AC_OUTPUT_MAKE_DEFS
# -------------------
# Set the DEFS variable to the -D options determined earlier.
# This is a subroutine of AC_OUTPUT.
# It is called inside configure, outside of config.status.
# Using a here document instead of a string reduces the quoting nightmare.
define(AC_OUTPUT_MAKE_DEFS,
[[# Transform confdefs.h into DEFS.
# Protect against shell expansion while executing Makefile rules.
# Protect against Makefile macro expansion.
#
# If the first sed substitution is executed (which looks for macros that
# take arguments), then we branch to the cleanup section.  Otherwise,
# look for a macro that doesn't take arguments.
cat >confdef2opt.sed <<\EOF
s%^[ 	]*#[ 	]*define[ 	][ 	]*\([^ 	(][^ 	(]*([^)]*)\)[ 	]*\(.*\)%-D\1=\2%g
t cleanup
s%^[ 	]*#[ 	]*define[ 	][ 	]*\([^ 	][^ 	]*\)[ 	]*\(.*\)%-D\1=\2%g
: cleanup
s%[ 	`~#$^&*(){}\\|;'"<>?]%\\&%g
s%\[%\\&%g
s%\]%\\&%g
s%\$%$$%g
EOF
# We use echo to avoid assuming a particular line-breaking character.
# The extra dot is to prevent the shell from consuming trailing
# line-breaks from the sub-command output.  A line-break within
# single-quotes doesn't work because, if this script is created in a
# platform that uses two characters for line-breaks (e.g., DOS), tr
# would break.
ac_LF_and_DOT=`echo; echo .`
DEFS=`sed -f confdef2opt.sed confdefs.h | tr "$ac_LF_and_DOT" ' .'`
rm -f confdef2opt.sed
]])# AC_OUTPUT_MAKE_DEFS


# _AC_OUTPUT_FILES
# ----------------
# Do the variable substitutions to create the Makefiles or whatever.
# This is a subroutine of AC_OUTPUT.
#
# It has to send itself into $CONFIG_STATUS (eg, via here documents).
# Upon exit, no here document shall be opened.
define(_AC_OUTPUT_FILES,
[cat >>$CONFIG_STATUS <<EOF

#
# CONFIG_FILES section.
#

# No need to generate the scripts if there are no CONFIG_FILES.
# This happens for instance when ./config.status config.h
if test -n "\$CONFIG_FILES"; then
  # Protect against being on the right side of a sed subst in config.status.
dnl Please, pay attention that this sed code depends a lot on the shape
dnl of the sed commands issued by AC_SUBST.  So if you change one, change
dnl the other too.
[  sed 's/%@/@@/; s/@%/@@/; s/%;t t\$/@;t t/; /@;t t\$/s/[\\\\&%]/\\\\&/g;
   s/@@/%@/; s/@@/@%/; s/@;t t\$/%;t t/' >\$tmp/subs.sed <<\\CEOF]
dnl These here document variables are unquoted when configure runs
dnl but quoted when config.status runs, so variables are expanded once.
dnl Insert the sed substitutions of variables.
_AC_SUBST_SED_PROGRAM()dnl
CEOF

EOF

  cat >>$CONFIG_STATUS <<\EOF
  # Split the substitutions into bite-sized pieces for seds with
  # small command number limits, like on Digital OSF/1 and HP-UX.
dnl One cannot portably go further than 100 commands because of HP-UX.
dnl Here, there are 2 cmd per line, and two cmd are added later.
  ac_max_sed_lines=48
  ac_sed_frag=1 # Number of current file.
  ac_beg=1 # First line for current file.
  ac_end=$ac_max_sed_lines # Line after last line for current file.
  ac_more_lines=:
  ac_sed_cmds=
  while $ac_more_lines; do
    if test $ac_beg -gt 1; then
      sed "1,${ac_beg}d; ${ac_end}q" $tmp/subs.sed >$tmp/subs.frag
    else
      sed "${ac_end}q" $tmp/subs.sed >$tmp/subs.frag
    fi
    if test ! -s $tmp/subs.frag; then
      ac_more_lines=false
    else
      # The purpose of the label and of the branching condition is to
      # speed up the sed processing (if there are no `@' at all, there
      # is no need to browse any of the substitutions).
      # These are the two extra sed commands mentioned above.
      (echo [':t
  /@[a-zA-Z_][a-zA-Z_0-9]*@/!b'] && cat $tmp/subs.frag) >$tmp/subs-$ac_sed_frag.sed
      if test -z "$ac_sed_cmds"; then
  	ac_sed_cmds="sed -f $tmp/subs-$ac_sed_frag.sed"
      else
  	ac_sed_cmds="$ac_sed_cmds | sed -f $tmp/subs-$ac_sed_frag.sed"
      fi
      ac_sed_frag=`expr $ac_sed_frag + 1`
      ac_beg=$ac_end
      ac_end=`expr $ac_end + $ac_max_sed_lines`
    fi
  done
  if test -z "$ac_sed_cmds"; then
    ac_sed_cmds=cat
  fi
fi # test -n "$CONFIG_FILES"

EOF
cat >>$CONFIG_STATUS <<\EOF
for ac_file in : $CONFIG_FILES; do test "x$ac_file" = x: && continue
  # Support "outfile[:infile[:infile...]]", defaulting infile="outfile.in".
  case "$ac_file" in
  *:*) ac_file_in=`echo "$ac_file" | sed 's%[[^:]]*:%%'`
       ac_file=`echo "$ac_file" | sed 's%:.*%%'` ;;
  *) ac_file_in=$ac_file.in ;;
  esac

  # Adjust a relative srcdir, top_srcdir, and INSTALL for subdirectories.

  # Remove last slash and all that follows it.  Not all systems have dirname.
  ac_dir=`echo "$ac_file" | sed 's%/[[^/][^/]]*$%%'`
  if test "$ac_dir" != "$ac_file" && test "$ac_dir" != .; then
    # The file is in a subdirectory.
dnl FIXME: should actually be mkinstalldirs (parents may have
dnl to be created too).
    test ! -d "$ac_dir" && mkdir "$ac_dir"
    ac_dir_suffix="/`echo $ac_dir|sed 's%^\./%%'`"
    # A "../" for each directory in $ac_dir_suffix.
    ac_dots=`echo "$ac_dir_suffix" | sed 's%/[[^/]]*%../%g'`
  else
    ac_dir_suffix= ac_dots=
  fi

  case "$ac_given_srcdir" in
  .)  srcdir=.
      if test -z "$ac_dots"; then top_srcdir=.
      else top_srcdir=`echo $ac_dots | sed 's%/$%%'`; fi ;;
  [[\\/]]* | ?:[[\\/]]* )
      srcdir=$ac_given_srcdir$ac_dir_suffix;
      top_srcdir=$ac_given_srcdir ;;
  *) # Relative path.
    srcdir=$ac_dots$ac_given_srcdir$ac_dir_suffix
    top_srcdir=$ac_dots$ac_given_srcdir ;;
  esac

AC_PROVIDE_IFELSE([AC_PROG_INSTALL],
[  case "$ac_given_INSTALL" in
  [[\\/$]]* | ?:[[\\/]]* ) INSTALL=$ac_given_INSTALL ;;
  *) INSTALL=$ac_dots$ac_given_INSTALL ;;
  esac
])dnl

  echo creating "$ac_file"
  rm -f "$ac_file"
  configure_input="Generated automatically from `echo $ac_file_in |
                                                 sed 's%.*/%%'` by configure."

  # Don't redirect the output to AC_FILE directly: use `mv' so that
  # updating is atomic, and doesn't need trapping.
  ac_file_inputs=`echo "$ac_file_in" |
                  sed -e "s%^%$ac_given_srcdir/%;s%:% $ac_given_srcdir/%g"`
  for ac_file_input in $ac_file_inputs;
  do
    test -f "$ac_file_input" ||
        AC_MSG_ERROR(cannot find input file `$ac_file_input')
  done
EOF
cat >>$CONFIG_STATUS <<EOF
dnl Neutralize VPATH when `$srcdir' = `.'.
  sed -e "$ac_vpsub
dnl Shell code in configure.in might set extrasub.
dnl FIXME: do we really want to maintain this feature?
$extrasub
EOF
cat >>$CONFIG_STATUS <<\EOF
:t
[/@[a-zA-Z_][a-zA-Z_0-9]*@/!b]
s%@configure_input@%$configure_input%;t t
s%@srcdir@%$srcdir%;t t
s%@top_srcdir@%$top_srcdir%;t t
AC_PROVIDE_IFELSE([AC_PROG_INSTALL], [s%@INSTALL@%$INSTALL%;t t
])dnl
dnl The parens around the eval prevent an "illegal io" in Ultrix sh.
" $ac_file_inputs | (eval "$ac_sed_cmds") >$tmp/out
dnl This would break Makefile dependencies.
dnl  if cmp -s $ac_file $tmp/out 2>/dev/null; then
dnl    echo "$ac_file is unchanged"
dnl   else
dnl     rm -f $ac_file
dnl    mv $tmp/out $ac_file
dnl  fi
  mv $tmp/out $ac_file

ifset([AC_LIST_FILES_COMMANDS],
[  # Run the commands associated with the file.
  case "$ac_file" in
AC_LIST_FILES_COMMANDS()dnl
  esac
])dnl
done
EOF
])# _AC_OUTPUT_FILES


# _AC_OUTPUT_HEADERS
# ------------------
#
# Output the code which instantiates the `config.h' files from their
# `config.h.in'.
#
# This is a subroutine of _AC_OUTPUT_CONFIG_STATUS.  It has to send
# itself into $CONFIG_STATUS (eg, via here documents).  Upon exit, no
# here document shall be opened.
#
#
# The code produced used to be extremely costly: there are was a
# single sed script (n lines) handling both `#define' templates,
# `#undef' templates with trailing space, and `#undef' templates
# without trailing spaces.  The full script was run on each of the m
# lines of `config.h.in', i.e., about n x m.
#
# Now there are two scripts: `conftest.defines' for the `#define'
# templates, and `conftest.undef' for the `#undef' templates.
#
# Optimization 1.  It is incredibly costly to run two `#undef'
# scripts, so just remove trailing spaces first.  Removes about a
# third of the cost.
#
# Optimization 2.  Since `#define' are rare and obsoleted,
# `conftest.defines' is built and run only if grep says there are
# `#define'.  Improves by at least a factor 2, since in addition we
# avoid the cost of *producing* the sed script.
#
# Optimization 3.  In each script, first check that the current input
# line is a template.  This avoids running the full sed script on
# empty lines and comments (divides the cost by about 3 since each
# template chunk is typically a comment, a template, an empty line).
#
# Optimization 4.  Once a substitution performed, since there can be
# only one per line, immediately restart the script on the next input
# line (using the `t' sed instruction).  Divides by about 2.
# *Note:* In the case of the AC_SUBST sed script (_AC_OUTPUT_FILES)
# this optimization cannot be applied as is, because there can be
# several substitutions per line.
#
#
# The result is about, hm, ... times blah... plus....  Ahem.  The
# result is about much faster.
define(_AC_OUTPUT_HEADERS,
[cat >>$CONFIG_STATUS <<\EOF

#
# CONFIG_HEADER section.
#

# These sed commands are passed to sed as "A NAME B NAME C VALUE D", where
# NAME is the cpp macro being defined and VALUE is the value it is being given.
#
# ac_d sets the value in "#define NAME VALUE" lines.
dnl Double quote for the `[ ]' and `define'.
[ac_dA='s%^\([ 	]*\)#\([ 	]*define[ 	][ 	]*\)'
ac_dB='[ 	].*$%\1#\2'
ac_dC=' '
ac_dD='%;t'
# ac_u turns "#undef NAME" without trailing blanks into "#define NAME VALUE".
ac_uA='s%^\([ 	]*\)#\([ 	]*\)undef\([ 	][ 	]*\)'
ac_uB='$%\1#\2define\3'
ac_uC=' '
ac_uD='%;t']

for ac_file in : $CONFIG_HEADERS; do test "x$ac_file" = x: && continue
  # Support "outfile[:infile[:infile...]]", defaulting infile="outfile.in".
  case "$ac_file" in
  *:*) ac_file_in=`echo "$ac_file" | sed 's%[[^:]]*:%%'`
       ac_file=`echo "$ac_file" | sed 's%:.*%%'` ;;
  *) ac_file_in=$ac_file.in ;;
  esac

  echo creating $ac_file

  ac_file_inputs=`echo "$ac_file_in" |
                  sed -e "s%^%$ac_given_srcdir/%;s%:% $ac_given_srcdir/%g"`
  for ac_file_input in $ac_file_inputs;
  do
    test -f "$ac_file_input" ||
        AC_MSG_ERROR(cannot find input file `$ac_file_input')
  done
  # Remove the trailing spaces.
  sed -e 's/[[ 	]]*$//' $ac_file_inputs >$tmp/in

EOF

# Transform confdefs.h into two sed scripts, `conftest.defines' and
# `conftest.undefs', that substitutes the proper values into
# config.h.in to produce config.h.  The first handles `#define'
# templates, and the second `#undef' templates.
# And first: Protect against being on the right side of a sed subst in
# config.status.  Protect against being in an unquoted here document
# in config.status.
rm -f conftest.defines conftest.undefs
dnl Using a here document instead of a string reduces the quoting nightmare.
dnl Putting comments in sed scripts is not portable.
dnl
dnl There are two labels in the following scripts, `cleanup' and `clear'.
dnl
dnl `cleanup' is used to avoid that the second main sed command (meant for
dnl 0-ary CPP macros) applies to n-ary macro definitions.  So we use
dnl `t cleanup' to jump over the second main sed command when it succeeded.
dnl
dnl But because in sed the `t' flag is set when there is a substitution
dnl that succeeded before, and not *right* before (i.e., included the
dnl first two small commands), we need to clear the `t' flag.  This is the
dnl purpose of `t clear; : clear'.
dnl
dnl Additionally, this works around a bug of IRIX' sed which does not
dnl clear the `t' flag between two cycles.
cat >confdef2sed.sed <<\EOF
dnl Double quote for `[ ]' and `define'.
[s/[\\&%]/\\&/g
s%[\\$`]%\\&%g
t clear
: clear
s%^[ 	]*#[ 	]*define[ 	][ 	]*\(\([^ 	(][^ 	(]*\)([^)]*)\)[ 	]*\(.*\)$%${ac_dA}\2${ac_dB}\1${ac_dC}\3${ac_dD}%gp
t cleanup
s%^[ 	]*#[ 	]*define[ 	][ 	]*\([^ 	][^ 	]*\)[ 	]*\(.*\)$%${ac_dA}\1${ac_dB}\1${ac_dC}\2${ac_dD}%gp
: cleanup]
EOF
# If some macros were called several times there might be several times
# the same #defines, which is useless.  Nevertheless, we may not want to
# sort them, since we want the *last* AC_DEFINE to be honored.
uniq confdefs.h | sed -n -f confdef2sed.sed >conftest.defines
sed -e 's/ac_d/ac_u/g' conftest.defines >conftest.undefs
rm -f confdef2sed.sed

# This sed command replaces #undef with comments.  This is necessary, for
# example, in the case of _POSIX_SOURCE, which is predefined and required
# on some systems where configure will not decide to define it.
cat >>conftest.undefs <<\EOF
[s%^[ 	]*#[ 	]*undef[ 	][ 	]*[a-zA-Z_][a-zA-Z_0-9]*%/* & */%]
EOF

# Break up conftest.defines because some shells have a limit on the size
# of here documents, and old seds have small limits too (100 cmds).
echo '  # Handle all the #define templates only if necessary.' >>$CONFIG_STATUS
echo '  if egrep ["^[ 	]*#[ 	]*define"] $tmp/in >/dev/null; then' >>$CONFIG_STATUS
echo '  # If there are no defines, we may have an empty if/fi' >>$CONFIG_STATUS
echo '  :' >>$CONFIG_STATUS
rm -f conftest.tail
while grep . conftest.defines >/dev/null
do
  # Write a limited-size here document to $tmp/frag.
  echo '  cat >$tmp/frag <<CEOF' >>$CONFIG_STATUS
dnl Speed up: don't consider the non `#define' lines.
  echo ['/^[ 	]*#[ 	]*define/!b'] >>$CONFIG_STATUS
  sed ${ac_max_here_lines}q conftest.defines >>$CONFIG_STATUS
  echo 'CEOF
  sed -f $tmp/frag $tmp/in >$tmp/out
  rm -f $tmp/in
  mv $tmp/out $tmp/in
' >>$CONFIG_STATUS
  sed 1,${ac_max_here_lines}d conftest.defines >conftest.tail
  rm -f conftest.defines
  mv conftest.tail conftest.defines
done
rm -f conftest.defines
echo '  fi # egrep' >>$CONFIG_STATUS
echo >>$CONFIG_STATUS

# Break up conftest.undefs because some shells have a limit on the size
# of here documents, and old seds have small limits too (100 cmds).
echo '  # Handle all the #undef templates' >>$CONFIG_STATUS
rm -f conftest.tail
while grep . conftest.undefs >/dev/null
do
  # Write a limited-size here document to $tmp/frag.
  echo '  cat >$tmp/frag <<CEOF' >>$CONFIG_STATUS
dnl Speed up: don't consider the non `#undef'
  echo ['/^[ 	]*#[ 	]*undef/!b'] >>$CONFIG_STATUS
  sed ${ac_max_here_lines}q conftest.undefs >>$CONFIG_STATUS
  echo 'CEOF
  sed -f $tmp/frag $tmp/in >$tmp/out
  rm -f $tmp/in
  mv $tmp/out $tmp/in
' >>$CONFIG_STATUS
  sed 1,${ac_max_here_lines}d conftest.undefs >conftest.tail
  rm -f conftest.undefs
  mv conftest.tail conftest.undefs
done
rm -f conftest.undefs

dnl Now back to your regularly scheduled config.status.
cat >>$CONFIG_STATUS <<\EOF
  echo "/* $ac_file.  Generated automatically by configure.  */" >$tmp/config.h
  cat $tmp/in >>$tmp/config.h
  rm -f $tmp/in
  if cmp -s $ac_file $tmp/config.h 2>/dev/null; then
    echo "$ac_file is unchanged"
  else
    # Remove last slash and all that follows it.  Not all systems have dirname.
    ac_dir=`echo "$ac_file" | sed 's%/[[^/][^/]]*$%%'`
    if test "$ac_dir" != "$ac_file" && test "$ac_dir" != .; then
      # The file is in a subdirectory.
dnl FIXME: should actually be mkinstalldirs (parents may have
dnl to be created too).
      test ! -d "$ac_dir" && mkdir "$ac_dir"
    fi
    rm -f $ac_file
    mv $tmp/config.h $ac_file
  fi
ifset([AC_LIST_HEADERS_COMMANDS],
[  # Run the commands associated with the file.
  case "$ac_file" in
AC_LIST_HEADERS_COMMANDS()dnl
  esac
])dnl
done
EOF
])# _AC_OUTPUT_HEADERS


# _AC_OUTPUT_LINKS
# ----------------
# This is a subroutine of AC_OUTPUT.
#
# It has to send itself into $CONFIG_STATUS (eg, via here documents).
# Upon exit, no here document shall be opened.
define(_AC_OUTPUT_LINKS,
[cat >>$CONFIG_STATUS <<\EOF

#
# CONFIG_LINKS section.
#
srcdir=$ac_given_srcdir

dnl Here we use : instead of .. because if AC_LINK_FILES was used
dnl with empty parameters (as in gettext.m4), then we obtain here
dnl `:', which we want to skip.  So let's keep a single exception: `:'.
for ac_file in : $CONFIG_LINKS; do test "x$ac_file" = x: && continue
  ac_dest=`echo "$ac_file" | sed 's%:.*%%'`
  ac_source=`echo "$ac_file" | sed 's%[[^:]]*:%%'`

  echo "linking $srcdir/$ac_source to $ac_dest"

  if test ! -r $srcdir/$ac_source; then
    AC_MSG_ERROR($srcdir/$ac_source: File not found)
  fi
  rm -f $ac_dest

  # Make relative symlinks.
  # Remove last slash and all that follows it.  Not all systems have dirname.
  ac_dest_dir=`echo $ac_dest | sed 's%/[[^/][^/]]*$%%'`
  if test "$ac_dest_dir" != "$ac_dest" && test "$ac_dest_dir" != .; then
    # The dest file is in a subdirectory.
dnl FIXME: should actually be mkinstalldirs (parents may have
dnl to be created too).
    test ! -d "$ac_dest_dir" && mkdir "$ac_dest_dir"
    ac_dest_dir_suffix="/`echo $ac_dest_dir|sed 's%^\./%%'`"
    # A "../" for each directory in $ac_dest_dir_suffix.
    ac_dots=`echo $ac_dest_dir_suffix|sed 's%/[[^/]]*%../%g'`
  else
    ac_dest_dir_suffix= ac_dots=
  fi

  case "$srcdir" in
  [[\\/$]]* | ?:[[\\/]]* ) ac_rel_source=$srcdir/$ac_source ;;
      *) ac_rel_source=$ac_dots$srcdir/$ac_source ;;
  esac

  # Make a symlink if possible; otherwise try a hard link.
  if ln -s $ac_rel_source $ac_dest 2>/dev/null ||
     ln $srcdir/$ac_source $ac_dest; then :
  else
    AC_MSG_ERROR(cannot link $ac_dest to $srcdir/$ac_source)
  fi
ifset([AC_LIST_LINKS_COMMANDS],
[  # Run the commands associated with the file.
  case "$ac_file" in
AC_LIST_LINKS_COMMANDS()dnl
  esac
])dnl
done
EOF
])# _AC_OUTPUT_LINKS


# _AC_OUTPUT_COMMANDS
# -------------------
# This is a subroutine of AC_OUTPUT, in charge of issuing the code
# related to AC_CONFIG_COMMANDS.
#
# It has to send itself into $CONFIG_STATUS (eg, via here documents).
# Upon exit, no here document shall be opened.
define(_AC_OUTPUT_COMMANDS,
[cat >>$CONFIG_STATUS <<\EOF

#
# CONFIG_COMMANDS section.
#
for ac_file in : $CONFIG_COMMANDS; do test "x$ac_file" = x: && continue
  ac_dest=`echo "$ac_file" | sed 's%:.*%%'`
  ac_source=`echo "$ac_file" | sed 's%[[^:]]*:%%'`

dnl FIXME: Until Automake uses the new features of config.status, we
dnl should keep this silent.  Otherwise, because Automake runs this in
dnl each directory, it quickly becomes annoying.
dnl  echo "executing commands of $ac_dest"
  case "$ac_dest" in
AC_LIST_COMMANDS_COMMANDS()dnl
  esac
done
EOF
])# _AC_OUTPUT_COMMANDS


# _AC_OUTPUT_SUBDIRS
# ------------------
# This is a subroutine of AC_OUTPUT, but it does not go into
# config.status, rather, it is called after running config.status.
define([_AC_OUTPUT_SUBDIRS],
[
#
# CONFIG_SUBDIRS section.
#
if test "$no_recursion" != yes; then

  # Remove --cache-file and --srcdir arguments so they do not pile up.
  ac_sub_configure_args=
  ac_prev=
  for ac_arg in $ac_configure_args; do
    if test -n "$ac_prev"; then
      ac_prev=
      continue
    fi
    case "$ac_arg" in
    -cache-file | --cache-file | --cache-fil | --cache-fi \
    | --cache-f | --cache- | --cache | --cach | --cac | --ca | --c)
      ac_prev=cache_file ;;
    -cache-file=* | --cache-file=* | --cache-fil=* | --cache-fi=* \
    | --cache-f=* | --cache-=* | --cache=* | --cach=* | --cac=* | --ca=* \
    | --c=*)
      ;;
    -srcdir | --srcdir | --srcdi | --srcd | --src | --sr)
      ac_prev=srcdir ;;
    -srcdir=* | --srcdir=* | --srcdi=* | --srcd=* | --src=* | --sr=*)
      ;;
    *) ac_sub_configure_args="$ac_sub_configure_args $ac_arg" ;;
    esac
  done

AC_PROVIDE_IFELSE([AC_PROG_INSTALL], [  ac_given_INSTALL=$INSTALL
])dnl

  for ac_subdir in AC_LIST_SUBDIRS; do

    # Do not complain, so a configure script can configure whichever
    # parts of a large source tree are present.
    if test ! -d $srcdir/$ac_subdir; then
      continue
    fi

    echo configuring in $ac_subdir

    case "$srcdir" in
    .) ;;
    *)
dnl FIXME: should actually be mkinstalldirs (parents may have
dnl to be created too).
      if test -d ./$ac_subdir || mkdir ./$ac_subdir; then :;
      else
        AC_MSG_ERROR(cannot create `pwd`/$ac_subdir)
      fi
      ;;
    esac

    ac_popdir=`pwd`
    cd $ac_subdir

    # A "../" for each directory in /$ac_subdir.
    ac_dots=`echo $ac_subdir |
             sed -e 's%^\./%%;s%[[^/]]$%&/%;s%[[^/]]*/%../%g'`

    case "$srcdir" in
    .) # No --srcdir option.  We are building in place.
      ac_sub_srcdir=$srcdir ;;
    [[\\/]]* | ?:[[\\/]]* ) # Absolute path.
      ac_sub_srcdir=$srcdir/$ac_subdir ;;
    *) # Relative path.
      ac_sub_srcdir=$ac_dots$srcdir/$ac_subdir ;;
    esac

    # Check for guested configure; otherwise get Cygnus style configure.
    if test -f $ac_sub_srcdir/configure; then
      ac_sub_configure="$SHELL $ac_sub_srcdir/configure"
    elif test -f $ac_sub_srcdir/configure.in; then
      ac_sub_configure=$ac_configure
    else
      AC_MSG_WARN(no configuration information is in $ac_subdir)
      ac_sub_configure=
    fi

    # The recursion is here.
    if test -n "$ac_sub_configure"; then

      # Make the cache file name correct relative to the subdirectory.
      case "$cache_file" in
      [[\\/]]* | ?:[[\\/]]* ) ac_sub_cache_file=$cache_file ;;
      *) # Relative path.
        ac_sub_cache_file=$ac_dots$cache_file ;;
      esac
AC_PROVIDE_IFELSE([AC_PROG_INSTALL],
[      case "$ac_given_INSTALL" in
        [[\\/$]]* | ?:[[\\/]]*) INSTALL=$ac_given_INSTALL ;;
        *) INSTALL=$ac_dots$ac_given_INSTALL ;;
      esac
])dnl

      echo "[running $ac_sub_configure $ac_sub_configure_args --cache-file=$ac_sub_cache_file] --srcdir=$ac_sub_srcdir"
      # The eval makes quoting arguments work.
      if eval $ac_sub_configure $ac_sub_configure_args --cache-file=$ac_sub_cache_file --srcdir=$ac_sub_srcdir
      then :
      else
        AC_MSG_ERROR($ac_sub_configure failed for $ac_subdir)
      fi
    fi

    cd $ac_popdir
  done
fi
])# _AC_OUTPUT_SUBDIRS


# AC_LINKER_OPTION(LINKER-OPTIONS, SHELL-VARIABLE)
# ------------------------------------------------
#
# Specifying options to the compiler (whether it be the C, C++ or
# Fortran 77 compiler) that are meant for the linker is compiler
# dependent.  This macro lets you give options to the compiler that
# are meant for the linker in a portable, compiler-independent way.
#
# This macro take two arguments, a list of linker options that the
# compiler should pass to the linker (LINKER-OPTIONS) and the name of
# a shell variable (SHELL-VARIABLE).  The list of linker options are
# appended to the shell variable in a compiler-dependent way.
#
# For example, if the selected language is C, then this:
#
#   AC_LINKER_OPTION([-R /usr/local/lib/foo], foo_LDFLAGS)
#
# will expand into this if the selected C compiler is gcc:
#
#   foo_LDFLAGS="-Xlinker -R -Xlinker /usr/local/lib/foo"
#
# otherwise, it will expand into this:
#
#   foo_LDFLAGS"-R /usr/local/lib/foo"
#
# You are encouraged to add support for compilers that this macro
# doesn't currently support.
# FIXME: Get rid of this macro.
AC_DEFUN(AC_LINKER_OPTION,
[AC_LANG_CASE([C],         [test x"$GCC" = xyes && using_gnu_compiler=yes],
              [C++],       [test x"$GXX" = xyes && using_gnu_compiler=yes],
              [FORTRAN77], [test x"$G77" = xyes && using_gnu_compiler=yes],
                           [using_gnu_compiler=])

dnl I don't understand the point of having the test inside of the
dnl loop.
for ac_link_opt in $1; do
  if test x"$using_gnu_compiler" = xyes; then
    $2="[$]$2 -Xlinker $ac_link_opt"
  else
    $2="[$]$2 $ac_link_opt"
  fi
done])


# AC_LIST_MEMBER_OF(ELEMENT, LIST, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# --------------------------------------------------------------------------
#
# Processing the elements of a list is tedious in shell programming,
# as lists tend to be implemented as space delimited strings.
#
# This macro searches LIST for ELEMENT, and executes ACTION-IF-FOUND
# if ELEMENT is a member of LIST, otherwise it executes
# ACTION-IF-NOT-FOUND.
AC_DEFUN(AC_LIST_MEMBER_OF,
[dnl Do some sanity checking of the arguments.
ifelse([$1], , [AC_FATAL([$0]: missing argument 1)])dnl
ifelse([$2], , [AC_FATAL([$0]: missing argument 2)])dnl

  ac_exists=false
  for ac_i in $2; do
    if test x"$1" = x"$ac_i"; then
      ac_exists=true
      break
    fi
  done

  AC_SHELL_IFELSE([test x"$ac_exists" = xtrue], [$3], [$4])
])
