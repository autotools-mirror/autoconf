# This file is part of Autoconf.                       -*- Autoconf -*-
# Parameterized macros.
# Requires GNU m4.
# Copyright (C) 1992, 93, 94, 95, 96, 98, 1999 Free Software Foundation, Inc.
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
#


## ----------------- ##
## Defining macros.  ##
## ----------------- ##


# m4 output diversions.  We let m4 output them all in order at the end,
# except that we explicitly undivert AC_DIVERSION_SED, AC_DIVERSION_CMDS,
# and AC_DIVERSION_ICMDS.

define(AC_DIVERSION_KILL, -1)dnl	suppress output
define(AC_DIVERSION_BINSH, 0)dnl	AC_REQUIRE'd #! /bin/sh line
define(AC_DIVERSION_NOTICE, 1)dnl	copyright notice & option help strings
define(AC_DIVERSION_INIT, 2)dnl		initialization code
define(AC_DIVERSION_NORMAL_4, 3)dnl	AC_REQUIRE'd code, 4 level deep
define(AC_DIVERSION_NORMAL_3, 4)dnl	AC_REQUIRE'd code, 3 level deep
define(AC_DIVERSION_NORMAL_2, 5)dnl	AC_REQUIRE'd code, 2 level deep
define(AC_DIVERSION_NORMAL_1, 6)dnl	AC_REQUIRE'd code, 1 level deep
define(AC_DIVERSION_NORMAL, 7)dnl	the tests and output code
define(AC_DIVERSION_SED, 8)dnl		variable substitutions in config.status
define(AC_DIVERSION_CMDS, 9)dnl		extra shell commands in config.status
define(AC_DIVERSION_ICMDS, 10)dnl	extra initialization in config.status


# AC_DIVERT_PUSH(STREAM)
# ----------------------
# Change the diversion stream to STREAM, while stacking old values.
define(AC_DIVERT_PUSH,
[pushdef([AC_DIVERSION_CURRENT], $1)dnl
divert(AC_DIVERSION_CURRENT)dnl
])


# AC_DIVERT_POP
# -------------
# Change the diversion stream to its previous value, unstacking it.
define(AC_DIVERT_POP,
[popdef([AC_DIVERSION_CURRENT])dnl
divert(AC_DIVERSION_CURRENT)dnl
])


# Initialize the diversion setup.
define([AC_DIVERSION_CURRENT], AC_DIVERSION_NORMAL)
# Throw away output until AC_INIT is called.
pushdef([AC_DIVERSION_CURRENT], AC_DIVERSION_KILL)


# AC_PRO(MACRO-NAME)
# ------------------
# The prologue for Autoconf macros.
define(AC_PRO,
[define([AC_PROVIDE_$1], )dnl
ifelse(AC_DIVERSION_CURRENT, AC_DIVERSION_NORMAL,
       [AC_DIVERT_PUSH(m4_eval(AC_DIVERSION_CURRENT - 1))],
       [pushdef([AC_DIVERSION_CURRENT], AC_DIVERSION_CURRENT)])dnl
])

# AC_EPI
# ------
# The Epilogue for Autoconf macros.
define(AC_EPI,
[AC_DIVERT_POP()dnl
ifelse(AC_DIVERSION_CURRENT, AC_DIVERSION_NORMAL,
[undivert(AC_DIVERSION_NORMAL_4)dnl
undivert(AC_DIVERSION_NORMAL_3)dnl
undivert(AC_DIVERSION_NORMAL_2)dnl
undivert(AC_DIVERSION_NORMAL_1)dnl
])dnl
])


# AC_DEFUN(NAME, [REPLACED-FUNCTION, ARGUMENT, ]EXPANSION)
# --------------------------------------------------------
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


# AC_DEFUNCT(NAME, COMMENT)
# -------------------------
# Declare the macro NAME no longer exists, and must not be used.
define([AC_DEFUNCT],
[define([$1], [AC_FATAL([$1] is defunct[$2])])])


# AC_OBSOLETE(THIS-MACRO-NAME, [SUGGESTION])
# ------------------------------------------
define(AC_OBSOLETE,
[AC_WARNING([$1 is obsolete$2])])


## ----------------------------- ##
## Dependencies between macros.  ##
## ----------------------------- ##


# AC_BEFORE(THIS-MACRO-NAME, CALLED-MACRO-NAME)
# ---------------------------------------------
define(AC_BEFORE,
[ifdef([AC_PROVIDE_$2], [AC_WARNING([$2 was called before $1])])])


# AC_REQUIRE(MACRO-NAME)
# ----------------------
define(AC_REQUIRE,
[ifdef([AC_PROVIDE_$1], ,
[AC_DIVERT_PUSH(m4_eval(AC_DIVERSION_CURRENT - 1))dnl
indir([$1])
AC_DIVERT_POP()dnl
])])


# AC_PROVIDE(MACRO-NAME)
# ----------------------
define(AC_PROVIDE,
[define([AC_PROVIDE_$1], )])




## --------------------- ##
## Some /bin/sh idioms.  ##
## --------------------- ##


# AC_SHELL_IFELSE(TEST[, IF-TRUE[, IF-FALSE]])
# -------------------------------------------
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
])])



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

# The idea behind these macros is that we may sometimes have to handle
# manifest values (e.g. `stdlib.h'), while at other moments, the same
# code may have to get the value from a variable (e.g., `ac_header').
# To have a uniform handling of both case, when a new value is about to
# be processed, declare a local variable, e.g.:
#
#   AC_VAR_PUSHDEF([header], [ac_cv_header_$1])
#
# and then in the body of the macro, use `header' as is.  It is of first
# importance to use `AC_VAR_*' to access this variable.  Don't quote its
# name: it must be used right away by m4.
#
# If the value `$1' was manifest (e.g. `stdlib.h'), then `header' is in
# fact the value `ac_cv_header_stdlib_h'.  If `$1' was indirect, then
# `header's value in m4 is in fact `$ac_header', the shell variable that
# holds all of the magic to get the expansion right.
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
# Transliteration of manifest strings should be handled by m4, while
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


# AC_SPECIALIZE(MACRO, ARG1 [, ARGS...])
# --------------------------------------
#
# Basically calls the macro MACRO with arguments ARG1, ARGS... But if
# there exist a specialized version of MACRO for ARG1, use this macro
# instead with arguments ARGS (i.e., ARG1 is *not* given).  See the
# definition of `AC_DEFUN'.
AC_DEFUN(AC_SPECIALIZE,
[ifdef([$1-$2],
       [indir([$1-$2], m4_shift(m4_shift($@)))],
       [indir([$1], m4_shift($@))])])


## ----------------------------------- ##
## Helping macros to display strings.  ##
## ----------------------------------- ##


# AC_HELP_STRING(LHS, RHS[, COLUMN])
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



## ---------------- ##
## Initialization.  ##
## ---------------- ##


# AC_INIT_NOTICE
# --------------
AC_DEFUN(AC_INIT_NOTICE,
[# Guess values for system-dependent variables and create Makefiles.
# Generated automatically using Autoconf version ]AC_ACVERSION[
# Copyright (C) 1992, 93, 94, 95, 96, 98, 1999 Free Software Foundation, Inc.
#
# This configure script is free software; the Free Software Foundation
# gives unlimited permission to copy, distribute and modify it.

# Defaults:
ac_arg_with_help=
ac_arg_enable_help=
ac_arg_var_help=
ac_default_prefix=/usr/local
@PND@ Any additions from configure.in:])


# AC_PREFIX_DEFAULT(PREFIX)
# -------------------------
AC_DEFUN(AC_PREFIX_DEFAULT,
[AC_DIVERT_PUSH(AC_DIVERSION_NOTICE)dnl
ac_default_prefix=$1
AC_DIVERT_POP()])


# AC_INIT_PARSE_ARGS
# ------------------
AC_DEFUN(AC_INIT_PARSE_ARGS,
[
# Initialize some variables set by options.
# The variables have the same names as the options, with
# dashes changed to underlines.
build=NONE
cache_file=./config.cache
exec_prefix=NONE
host=NONE
no_create=
nonopt=NONE
no_recursion=
prefix=NONE
program_prefix=NONE
program_suffix=NONE
program_transform_name=s,x,x,
silent=
site=
srcdir=
target=NONE
verbose=
x_includes=NONE
x_libraries=NONE
dnl Installation directory options.
dnl These are left unexpanded so users can "make install exec_prefix=/foo"
dnl and all the variables that are supposed to be based on exec_prefix
dnl by default will actually change.
dnl Use braces instead of parens because sh, perl, etc. also accept them.
bindir='${exec_prefix}/bin'
sbindir='${exec_prefix}/sbin'
libexecdir='${exec_prefix}/libexec'
datadir='${prefix}/share'
sysconfdir='${prefix}/etc'
sharedstatedir='${prefix}/com'
localstatedir='${prefix}/var'
libdir='${exec_prefix}/lib'
includedir='${prefix}/include'
oldincludedir='/usr/include'
infodir='${prefix}/info'
mandir='${prefix}/man'

# Initialize some other variables.
subdirs=
MFLAGS= MAKEFLAGS=
SHELL=${CONFIG_SHELL-/bin/sh}
# Maximum number of lines to put in a shell here document.
dnl This variable seems obsolete.  It should probably be removed, and
dnl only ac_max_sed_lines should be used.
: ${ac_max_here_lines=48}
# Sed expression to map a string onto a valid sh and CPP variable names.
changequote(, )dnl
ac_tr_sh='sed -e y%*+%pp%;s%[^a-zA-Z0-9_]%_%g'
ac_tr_cpp='sed -e y%*abcdefghijklmnopqrstuvwxyz%PABCDEFGHIJKLMNOPQRSTUVWXYZ%;s%[^A-Z0-9_]%_%g'
changequote([, ])dnl

ac_prev=
for ac_option
do
  # If the previous option needs an argument, assign it.
  if test -n "$ac_prev"; then
    eval "$ac_prev=\$ac_option"
    ac_prev=
    continue
  fi

  case "$ac_option" in
changequote(, )dnl
  -*=*) ac_optarg=`echo "$ac_option" | sed 's/[-_a-zA-Z0-9]*=//'` ;;
changequote([, ])dnl
  *) ac_optarg= ;;
  esac

  # Accept the important Cygnus configure options, so we can diagnose typos.

  case "$ac_option" in

  -bindir | --bindir | --bindi | --bind | --bin | --bi)
    ac_prev=bindir ;;
  -bindir=* | --bindir=* | --bindi=* | --bind=* | --bin=* | --bi=*)
    bindir="$ac_optarg" ;;

  -build | --build | --buil | --bui | --bu)
    ac_prev=build ;;
  -build=* | --build=* | --buil=* | --bui=* | --bu=*)
    build="$ac_optarg" ;;

  -cache-file | --cache-file | --cache-fil | --cache-fi \
  | --cache-f | --cache- | --cache | --cach | --cac | --ca | --c)
    ac_prev=cache_file ;;
  -cache-file=* | --cache-file=* | --cache-fil=* | --cache-fi=* \
  | --cache-f=* | --cache-=* | --cache=* | --cach=* | --cac=* | --ca=* | --c=*)
    cache_file="$ac_optarg" ;;

  -datadir | --datadir | --datadi | --datad | --data | --dat | --da)
    ac_prev=datadir ;;
  -datadir=* | --datadir=* | --datadi=* | --datad=* | --data=* | --dat=* \
  | --da=*)
    datadir="$ac_optarg" ;;

  -disable-* | --disable-*)
    ac_feature=`echo "$ac_option"|sed -e 's/-*disable-//'`
    # Reject names that are not valid shell variable names.
changequote(, )dnl
    if echo "$ac_feature" | grep '[^-a-zA-Z0-9_]' >/dev/null 2>&1; then
changequote([, ])dnl
      AC_MSG_ERROR($ac_feature: invalid feature name)
    fi
    ac_feature=`echo $ac_feature| sed 's/-/_/g'`
    eval "enable_${ac_feature}=no" ;;

  -enable-* | --enable-*)
    ac_feature=`echo "$ac_option"|sed -e 's/-*enable-//' -e 's/=.*//'`
    # Reject names that are not valid shell variable names.
changequote(, )dnl
    if echo "$ac_feature" | grep '[^-a-zA-Z0-9_]' >/dev/null 2>&1; then
changequote([, ])dnl
      AC_MSG_ERROR($ac_feature: invalid feature name)
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
    exec_prefix="$ac_optarg" ;;

  -gas | --gas | --ga | --g)
    # Obsolete; use --with-gas.
    with_gas=yes ;;

  -help | --help | --hel | --he)
    # Omit some internal or obsolete options to make the list less imposing.
    # This message is too long to be a string in the A/UX 3.1 sh.
changequote(, )dnl
    cat <<\EOF
`configure' configures software source code packages to adapt to many kinds
of systems.

Usage: configure [OPTION]... [VAR=VALUE]... [HOST]

To safely assign special values to environment variables (e.g., CC,
CFLAGS...), give to `configure' the definition as VAR=VALUE.

Defaults for the options are specified in brackets.

Configuration:
  --cache-file=FILE   cache test results in FILE
  --help              print this message
  --no-create         do not create output files
  --quiet, --silent   do not print \`checking...' messages
  --version           print the version of autoconf that created configure

Directories:
  --prefix=PREFIX         install architecture-independent files in PREFIX
                          [$ac_default_prefix]
  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                          [same as prefix]
  --bindir=DIR            user executables in DIR [EPREFIX/bin]
  --sbindir=DIR           system admin executables in DIR [EPREFIX/sbin]
  --libexecdir=DIR        program executables in DIR [EPREFIX/libexec]
  --datadir=DIR           read-only architecture-independent data in DIR
                          [PREFIX/share]
  --sysconfdir=DIR        read-only single-machine data in DIR [PREFIX/etc]
  --sharedstatedir=DIR    modifiable architecture-independent data in DIR
                          [PREFIX/com]
  --localstatedir=DIR     modifiable single-machine data in DIR [PREFIX/var]
  --libdir=DIR            object code libraries in DIR [EPREFIX/lib]
  --includedir=DIR        C header files in DIR [PREFIX/include]
  --oldincludedir=DIR     C header files for non-gcc in DIR [/usr/include]
  --infodir=DIR           info documentation in DIR [PREFIX/info]
  --mandir=DIR            man documentation in DIR [PREFIX/man]
  --srcdir=DIR            find the sources in DIR [configure dir or ..]

Program names:
  --program-prefix=PREFIX prepend PREFIX to installed program names
  --program-suffix=SUFFIX append SUFFIX to installed program names
  --program-transform-name=PROGRAM
                          run sed PROGRAM on installed program names

EOF
    cat <<\EOF
Host type:
  --build=BUILD      configure for building on BUILD [BUILD=HOST]
  --host=HOST        configure for HOST [guessed]
  --target=TARGET    configure for TARGET [TARGET=HOST]

X features:
  --x-includes=DIR    X include files are in DIR
  --x-libraries=DIR   X library files are in DIR
EOF
changequote([, ])dnl
dnl It would be great to sort, unfortunately, since each entry maybe
dnl split on several lines, it is not as evident as a simple `| sort'.
    test -n "$ac_arg_enable_help" && echo "
Optional features:
  --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
  --enable-FEATURE@BKL@=ARG@BKR@  include FEATURE @BKL@ARG=yes@BKR@\
$ac_arg_enable_help"
    test -n "$ac_arg_with_help" && echo "
Optional packages:
  --with-PACKAGE@BKL@=ARG@BKR@    use PACKAGE @BKL@ARG=yes@BKR@
  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)\
$ac_arg_with_help"
    test -n "$ac_arg_var_help" && echo "
Some influent environment variables:$ac_arg_var_help"
    exit 0 ;;

  -host | --host | --hos | --ho)
    ac_prev=host ;;
  -host=* | --host=* | --hos=* | --ho=*)
    host="$ac_optarg" ;;

  -includedir | --includedir | --includedi | --included | --include \
  | --includ | --inclu | --incl | --inc)
    ac_prev=includedir ;;
  -includedir=* | --includedir=* | --includedi=* | --included=* | --include=* \
  | --includ=* | --inclu=* | --incl=* | --inc=*)
    includedir="$ac_optarg" ;;

  -infodir | --infodir | --infodi | --infod | --info | --inf)
    ac_prev=infodir ;;
  -infodir=* | --infodir=* | --infodi=* | --infod=* | --info=* | --inf=*)
    infodir="$ac_optarg" ;;

  -libdir | --libdir | --libdi | --libd)
    ac_prev=libdir ;;
  -libdir=* | --libdir=* | --libdi=* | --libd=*)
    libdir="$ac_optarg" ;;

  -libexecdir | --libexecdir | --libexecdi | --libexecd | --libexec \
  | --libexe | --libex | --libe)
    ac_prev=libexecdir ;;
  -libexecdir=* | --libexecdir=* | --libexecdi=* | --libexecd=* | --libexec=* \
  | --libexe=* | --libex=* | --libe=*)
    libexecdir="$ac_optarg" ;;

  -localstatedir | --localstatedir | --localstatedi | --localstated \
  | --localstate | --localstat | --localsta | --localst \
  | --locals | --local | --loca | --loc | --lo)
    ac_prev=localstatedir ;;
  -localstatedir=* | --localstatedir=* | --localstatedi=* | --localstated=* \
  | --localstate=* | --localstat=* | --localsta=* | --localst=* \
  | --locals=* | --local=* | --loca=* | --loc=* | --lo=*)
    localstatedir="$ac_optarg" ;;

  -mandir | --mandir | --mandi | --mand | --man | --ma | --m)
    ac_prev=mandir ;;
  -mandir=* | --mandir=* | --mandi=* | --mand=* | --man=* | --ma=* | --m=*)
    mandir="$ac_optarg" ;;

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
    oldincludedir="$ac_optarg" ;;

  -prefix | --prefix | --prefi | --pref | --pre | --pr | --p)
    ac_prev=prefix ;;
  -prefix=* | --prefix=* | --prefi=* | --pref=* | --pre=* | --pr=* | --p=*)
    prefix="$ac_optarg" ;;

  -program-prefix | --program-prefix | --program-prefi | --program-pref \
  | --program-pre | --program-pr | --program-p)
    ac_prev=program_prefix ;;
  -program-prefix=* | --program-prefix=* | --program-prefi=* \
  | --program-pref=* | --program-pre=* | --program-pr=* | --program-p=*)
    program_prefix="$ac_optarg" ;;

  -program-suffix | --program-suffix | --program-suffi | --program-suff \
  | --program-suf | --program-su | --program-s)
    ac_prev=program_suffix ;;
  -program-suffix=* | --program-suffix=* | --program-suffi=* \
  | --program-suff=* | --program-suf=* | --program-su=* | --program-s=*)
    program_suffix="$ac_optarg" ;;

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
    program_transform_name="$ac_optarg" ;;

  -q | -quiet | --quiet | --quie | --qui | --qu | --q \
  | -silent | --silent | --silen | --sile | --sil)
    silent=yes ;;

  -sbindir | --sbindir | --sbindi | --sbind | --sbin | --sbi | --sb)
    ac_prev=sbindir ;;
  -sbindir=* | --sbindir=* | --sbindi=* | --sbind=* | --sbin=* \
  | --sbi=* | --sb=*)
    sbindir="$ac_optarg" ;;

  -sharedstatedir | --sharedstatedir | --sharedstatedi \
  | --sharedstated | --sharedstate | --sharedstat | --sharedsta \
  | --sharedst | --shareds | --shared | --share | --shar \
  | --sha | --sh)
    ac_prev=sharedstatedir ;;
  -sharedstatedir=* | --sharedstatedir=* | --sharedstatedi=* \
  | --sharedstated=* | --sharedstate=* | --sharedstat=* | --sharedsta=* \
  | --sharedst=* | --shareds=* | --shared=* | --share=* | --shar=* \
  | --sha=* | --sh=*)
    sharedstatedir="$ac_optarg" ;;

  -site | --site | --sit)
    ac_prev=site ;;
  -site=* | --site=* | --sit=*)
    site="$ac_optarg" ;;

  -srcdir | --srcdir | --srcdi | --srcd | --src | --sr)
    ac_prev=srcdir ;;
  -srcdir=* | --srcdir=* | --srcdi=* | --srcd=* | --src=* | --sr=*)
    srcdir="$ac_optarg" ;;

  -sysconfdir | --sysconfdir | --sysconfdi | --sysconfd | --sysconf \
  | --syscon | --sysco | --sysc | --sys | --sy)
    ac_prev=sysconfdir ;;
  -sysconfdir=* | --sysconfdir=* | --sysconfdi=* | --sysconfd=* | --sysconf=* \
  | --syscon=* | --sysco=* | --sysc=* | --sys=* | --sy=*)
    sysconfdir="$ac_optarg" ;;

  -target | --target | --targe | --targ | --tar | --ta | --t)
    ac_prev=target ;;
  -target=* | --target=* | --targe=* | --targ=* | --tar=* | --ta=* | --t=*)
    target="$ac_optarg" ;;

  -v | -verbose | --verbose | --verbos | --verbo | --verb)
    verbose=yes ;;

  -version | --version | --versio | --versi | --vers)
    echo "configure generated by autoconf version AC_ACVERSION"
    exit 0 ;;

  -with-* | --with-*)
    ac_package=`echo "$ac_option"|sed -e 's/-*with-//' -e 's/=.*//'`
    # Reject names that are not valid shell variable names.
changequote(, )dnl
    if echo "$ac_feature" | grep '[^-a-zA-Z0-9_]' >/dev/null 2>&1; then
changequote([, ])dnl
      AC_MSG_ERROR($ac_package: invalid package name)
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
changequote(, )dnl
    if echo "$ac_feature" | grep '[^-a-zA-Z0-9_]' >/dev/null 2>&1; then
changequote([, ])dnl
      AC_MSG_ERROR($ac_package: invalid package name)
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
    x_includes="$ac_optarg" ;;

  -x-libraries | --x-libraries | --x-librarie | --x-librari \
  | --x-librar | --x-libra | --x-libr | --x-lib | --x-li | --x-l)
    ac_prev=x_libraries ;;
  -x-libraries=* | --x-libraries=* | --x-librarie=* | --x-librari=* \
  | --x-librar=* | --x-libra=* | --x-libr=* | --x-lib=* | --x-li=* | --x-l=*)
    x_libraries="$ac_optarg" ;;

  -*) AC_MSG_ERROR([$ac_option: invalid option; use --help to show usage])
    ;;

  *=*)
    ac_envvar=`echo $ac_option|sed -e 's/=.*//'`
    # Reject names that are not valid shell variable names.
changequote(, )dnl
    if test -n "`echo $ac_envvar| sed 's/[_a-zA-Z0-9]//g'`"; then
changequote([, ])dnl
      AC_MSG_ERROR($ac_envvar: invalid variable name)
    fi
    eval "${ac_envvar}='$ac_optarg'"
    export $ac_envvar ;;

  *)
changequote(, )dnl
    if echo "$ac_feature" | grep '[^-a-zA-Z0-9.]' >/dev/null 2>&1; then
changequote([, ])dnl
      AC_MSG_WARN($ac_option: invalid host type)
    fi
    if test "x$nonopt" != xNONE; then
      AC_MSG_ERROR(can only configure for one host and one target at a time)
    fi
    nonopt="$ac_option"
    ;;

  esac
done

if test -n "$ac_prev"; then
  AC_MSG_ERROR(missing argument to --`echo $ac_prev | sed 's/_/-/g'`)
fi
])dnl AC_INIT_PARSE_ARGS


# AC_INIT_BINSH
# -------------
# Try to have only one #! line, so the script doesn't look funny
# for users of AC_REVISION.
AC_DEFUN(AC_INIT_BINSH,
[AC_DIVERT_PUSH(AC_DIVERSION_BINSH)dnl
#! /bin/sh
AC_DIVERT_POP()dnl to KILL
])


# AC_INCLUDE(FILE)
# ----------------
# Wrapper around m4_include.
define(AC_INCLUDE,
[m4_include([$1])])

# AC_INCLUDES((FILE, ...))
# ------------------------
define(AC_INCLUDES,
[m4_foreach([File], [$1], [AC_INCLUDE(File)])])


# AC_INIT(UNIQUE-FILE-IN-SOURCE-DIR)
# ----------------------------------
# Output the preamble of the `configure' script.
AC_DEFUN(AC_INIT,
[m4_sinclude(acsite.m4)dnl
m4_sinclude(./aclocal.m4)dnl
AC_REQUIRE([AC_INIT_BINSH])dnl
AC_DIVERT_PUSH(AC_DIVERSION_NOTICE)dnl
AC_INIT_NOTICE
AC_DIVERT_POP()dnl to KILL
AC_DIVERT_POP()dnl to NORMAL
AC_DIVERT_PUSH(AC_DIVERSION_INIT)dnl
AC_INIT_PARSE_ARGS
AC_INIT_PREPARE($1)dnl
AC_DIVERT_POP()dnl to NORMAL
])



# AC_INIT_PREPARE(UNIQUE-FILE-IN-SOURCE-DIR)
# ------------------------------------------
# Called by AC_INIT to build the preamble of the `configure' scripts.
# 1. Trap and clean up various tmp files.
# 2. Set up the fd and output files
# 3. Remember the options given to `configure' for `config.status --recheck'.
# 4. Ensure a correct environment
# 5. Find `$srcdir', and check its validity by verifying the presence of
#    UNIQUE-FILE-IN-SOURCE-DIR.
# 6. Required macros (cache, default AC_SUBST etc.)
AC_DEFUN(AC_INIT_PREPARE,
[trap 'rm -fr conftest* confdefs* core core.* *.core $ac_clean_files; exit 1' 1 2 15

# File descriptor usage:
# 0 standard input
# 1 file creation
# 2 errors and warnings
# 3 some systems may open it to /dev/tty
# 4 used on the Kubota Titan
define(AC_FD_MSG, 6)dnl
@PND@ AC_FD_MSG checking for... messages and results
define(AC_FD_CC, 5)dnl
@PND@ AC_FD_CC compiler messages saved in config.log
if test "$silent" = yes; then
  exec AC_FD_MSG>/dev/null
else
  exec AC_FD_MSG>&1
fi
exec AC_FD_CC>./config.log

echo "\
This file contains any messages produced by compilers while
running configure, to aid debugging if configure makes a mistake.
" 1>&AC_FD_CC

# Strip out --no-create and --no-recursion so they do not pile up.
# Also quote any args containing shell meta-characters.
ac_configure_args=
for ac_arg
do
  case "$ac_arg" in
  -no-create | --no-create | --no-creat | --no-crea | --no-cre \
  | --no-cr | --no-c) ;;
  -no-recursion | --no-recursion | --no-recursio | --no-recursi \
  | --no-recurs | --no-recur | --no-recu | --no-rec | --no-re | --no-r) ;;
changequote(<<, >>)dnl
dnl If you change this globbing pattern, test it on an old shell --
dnl it's sensitive.  Putting any kind of quote in it causes syntax errors.
  *" "*|*"	"*|*[\[\]\~\<<#>>\$\^\&\*\(\)\{\}\\\|\;\<\>\?]*)
  ac_arg=`echo "$ac_arg"|sed "s/'/'\\\\\\\\''/g"`
  ac_configure_args="$ac_configure_args '$ac_arg'" ;;
changequote([, ])dnl
  *) ac_configure_args="$ac_configure_args $ac_arg" ;;
  esac
done

# NLS nuisances.
# Only set these to C if already set.  These must not be set unconditionally
# because not all systems understand e.g. LANG=C (notably SCO).
# Fixing LC_MESSAGES prevents Solaris sh from translating var values in `set'!
# Non-C LC_CTYPE values break the ctype check.
if test "${LANG+set}"   = set; then LANG=C;   export LANG;   fi
if test "${LC_ALL+set}" = set; then LC_ALL=C; export LC_ALL; fi
if test "${LC_MESSAGES+set}" = set; then LC_MESSAGES=C; export LC_MESSAGES; fi
if test "${LC_CTYPE+set}"    = set; then LC_CTYPE=C;    export LC_CTYPE;    fi

# confdefs.h avoids OS command line length limits that DEFS can exceed.
rm -rf conftest* confdefs.h
# AIX cpp loses on an empty file, so make sure it contains at least a newline.
echo >confdefs.h

# A filename unique to this package, relative to the directory that
# configure is in, which we can look for to find out if srcdir is correct.
ac_unique_file=$1

# Find the source files, if location was not specified.
if test -z "$srcdir"; then
  ac_srcdir_defaulted=yes
  # Try the directory containing this script, then its parent.
  ac_prog=[$]0
changequote(, )dnl
  ac_confdir=`echo "$ac_prog"|sed 's%/[^/][^/]*$%%'`
changequote([, ])dnl
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
changequote(, )dnl
srcdir=`echo "${srcdir}" | sed 's%\([^/]\)/*$%\1%'`
changequote([, ])dnl

dnl Let the site file select an alternate cache file if it wants to.
AC_SITE_LOAD
AC_CACHE_LOAD
AC_LANG_C
dnl By default always use an empty string as the executable
dnl extension.  Only change it if the script calls AC_EXEEXT.
ac_exeext=
dnl By default assume that objects files use an extension of .o.  Only
dnl change it if the script calls AC_OBJEXT.
ac_objext=o
AC_PROG_ECHO_N
dnl Substitute for predefined variables.
AC_SUBST(SHELL)dnl
AC_SUBST(CFLAGS)dnl
AC_SUBST(CPPFLAGS)dnl
AC_SUBST(CXXFLAGS)dnl
AC_SUBST(FFLAGS)dnl
AC_SUBST(DEFS)dnl
AC_SUBST(LDFLAGS)dnl
AC_SUBST(LIBS)dnl
AC_SUBST(exec_prefix)dnl
AC_SUBST(prefix)dnl
AC_SUBST(program_transform_name)dnl
dnl Installation directory options.
AC_SUBST(bindir)dnl
AC_SUBST(sbindir)dnl
AC_SUBST(libexecdir)dnl
AC_SUBST(datadir)dnl
AC_SUBST(sysconfdir)dnl
AC_SUBST(sharedstatedir)dnl
AC_SUBST(localstatedir)dnl
AC_SUBST(libdir)dnl
AC_SUBST(includedir)dnl
AC_SUBST(oldincludedir)dnl
AC_SUBST(infodir)dnl
AC_SUBST(mandir)dnl
])


dnl ### Selecting optional features


# AC_ARG_ENABLE(FEATURE, HELP-STRING, ACTION-IF-TRUE [, ACTION-IF-FALSE])
# -----------------------------------------------------------------------
AC_DEFUN(AC_ARG_ENABLE,
[AC_DIVERT_PUSH(AC_DIVERSION_NOTICE)dnl
ac_arg_enable_help="$ac_arg_enable_help
[$2]"
AC_DIVERT_POP()dnl
@PND@ Check whether --enable-[$1] or --disable-[$1] was given.
if test "[${enable_]patsubst([$1], -, _)+set}" = set; then
  enableval="[$enable_]patsubst([$1], -, _)"
  ifelse([$3], , :, [$3])
ifelse([$4], , , [else
  $4
])dnl
fi
])

AC_DEFUN(AC_ENABLE,
[AC_OBSOLETE([$0], [; instead use AC_ARG_ENABLE])dnl
AC_ARG_ENABLE([$1], [  --enable-$1], [$2], [$3])dnl
])


## ------------------------------ ##
## Working with optional software ##
## ------------------------------ ##


# AC_ARG_WITH(PACKAGE, HELP-STRING, ACTION-IF-TRUE [, ACTION-IF-FALSE])
# ---------------------------------------------------------------------
AC_DEFUN(AC_ARG_WITH,
[AC_DIVERT_PUSH(AC_DIVERSION_NOTICE)dnl
ac_arg_with_help="$ac_arg_with_help
[$2]"
AC_DIVERT_POP()dnl
@PND@ Check whether --with-[$1] or --without-[$1] was given.
if test "[${with_]patsubst([$1], -, _)+set}" = set; then
  withval="[$with_]patsubst([$1], -, _)"
  ifelse([$3], , :, [$3])
ifelse([$4], , , [else
  $4
])dnl
fi
])

AC_DEFUN(AC_WITH,
[AC_OBSOLETE([$0], [; instead use AC_ARG_WITH])dnl
AC_ARG_WITH([$1], [  --with-$1], [$2], [$3])dnl
])



## -------------------------------------- ##
## Remembering env vars for reconfiguring ##
## -------------------------------------- ##


# AC_ARG_VAR(VARNAME, DOCUMENTATION)
# ----------------------------------
# Register VARNAME as a variable configure should remember, and
# document it in --help.
AC_DEFUN(AC_ARG_VAR,
[AC_DIVERT_PUSH(AC_DIVERSION_NOTICE)dnl
ac_arg_var_help="$ac_arg_var_help
AC_HELP_STRING([$1], [$2], [              ])"
AC_DIVERT_POP()dnl
dnl Register if set and not yet registered.
dnl If there are envvars given as arguments, they are already set,
dnl therefore they won't be set again, which is the right thing.
case "${$1+set} $ac_configure_args" in
 *" $1="* );;
 "set "*) ac_configure_args="$1='[$]$1' $ac_configure_args";;
esac])



## ---------------------------- ##
## Transforming program names.  ##
## ---------------------------- ##


# AC_ARG_PROGRAM()
# ----------------
# FIXME: Must be run only once.  Introduce AC_DEFUN_ONCE?
AC_DEFUN(AC_ARG_PROGRAM,
[if test "$program_transform_name" = s,x,x,; then
  program_transform_name=
else
  # Double any \ or $.  echo might interpret backslashes.
  cat <<\EOF_SED >conftestsed
s,\\,\\\\,g; s,\$,$$,g
EOF_SED
  program_transform_name=`echo $program_transform_name|sed -f conftestsed`
  rm -f conftestsed
fi
test "$program_prefix" != NONE &&
  program_transform_name="s,^,${program_prefix},;$program_transform_name"
# Use a double $ so make ignores it.
test "$program_suffix" != NONE &&
  program_transform_name="s,\$\$,${program_suffix},;$program_transform_name"

# sed with no file args requires a program.
test "$program_transform_name" = "" && program_transform_name="s,x,x,"
])


## --------------- ##
## Version numbers ##
## --------------- ##


# AC_REVISION(REVISION-INFO)
AC_DEFUN(AC_REVISION,
[AC_REQUIRE([AC_INIT_BINSH])dnl
AC_DIVERT_PUSH(AC_DIVERSION_BINSH)dnl
[# From configure.in] translit([$1], $")
AC_DIVERT_POP()dnl to KILL
])

# Subroutines of AC_PREREQ.

# m4_compare(VERSION-1, VERSION-2)
# --------------------------------
# Compare the two version numbers and expand into
#  -1 if VERSION-1 < VERSION-2
#   0 if           =
#   1 if           >
# The handling of the special values [[]] is a pain, but seems necessary.
# This macro is a excellent tutorial on the order of evaluation of ifelse.
define(m4_compare,
[ifelse([$1],,      [ifelse([$2],,      0,
                            [$2], [[]], 0,
                            1)],
        [$1], [[]], [ifelse([$2],, 0,
                            [$2], [[]], 0,
                            1)],
        [$2],,      -1,
        [$2], [[]], -1,
        [ifelse(m4_eval(m4_car($1) < m4_car($2)), 1, 1,
                [ifelse(m4_eval(m4_car($1) > m4_car($2)), 1, -1,
                        [m4_compare(m4_quote(m4_shift($1)),
                                    m4_quote(m4_shift($2)))])])])])


# AC_UNGNITS(VERSION)
# -------------------
# Replace .a, .b etc. by .0.1, .0.2 in VERSION.  For instance, version
# 2.14a is understood as 2.14.0.1 for version comparison.
# This macro is absolutely not robust to active macro, it expects
# reasonable version numbers.
# Warning: Valid up to `z', no double letters.
define(AC_UNGNITS,
[translit(patsubst(patsubst(patsubst([$1],
                                     [\([abcdefghi]\)], [.0.\1]),
                            [\([jklmnopqrs]\)], [.0.1\1]),
          [\([tuvwxyz]\)], [.0.2\1]),
          abcdefghijklmnopqrstuvwxyz,
          12345678901234567890123456)])


# AC_PREREQ(VERSION)
# ------------------
# Complain and exit if the Autoconf version is less than VERSION.
define(AC_PREREQ,
[ifelse(m4_compare(m4_split(AC_UNGNITS([$1]),         [\.]),
                   m4_split(AC_UNGNITS(AC_ACVERSION), [\.])), -1,
       [AC_FATAL(Autoconf version $1 or higher is required for this script)])])




## --------------------------------- ##
## Getting the canonical system type ##
## --------------------------------- ##


# AC_CONFIG_AUX_DIR(DIR)
# ----------------------
# Find install-sh, config.sub, config.guess, and Cygnus configure
# in directory DIR.  These are auxiliary files used in configuration.
# DIR can be either absolute or relative to $srcdir.
AC_DEFUN(AC_CONFIG_AUX_DIR,
[AC_CONFIG_AUX_DIRS($1 $srcdir/$1)])

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
])dnl AC_CONFIG_AUX_DIRS


# Canonicalize the host, target, and build system types.
AC_DEFUN(AC_CANONICAL_SYSTEM,
[AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_REQUIRE([AC_CANONICAL_TARGET])dnl
AC_REQUIRE([AC_CANONICAL_BUILD])dnl
AC_BEFORE([$0], [AC_ARG_PROGRAM])
# Do some error checking and defaulting for the host and target type.
# The inputs are:
#    configure --host=HOST --target=TARGET --build=BUILD NONOPT
#
# The rules are:
# 1. You are not allowed to specify --host, --target, and nonopt at the
#    same time.
# 2. Host defaults to nonopt.
# 3. If nonopt is not specified, then host defaults to the current host,
#    as determined by config.guess.
# 4. Target and build default to nonopt.
# 5. If nonopt is not specified, then target and build default to host.

# The aliases save the names the user supplied, while $host etc.
# will get canonicalized.
case $host---$target---$nonopt in
NONE---*---* | *---NONE---* | *---*---NONE) ;;
*) AC_MSG_ERROR(can only configure for one host and one target at a time) ;;
esac

test "$host_alias" != "$target_alias" &&
  test "$program_prefix$program_suffix$program_transform_name" = \
    NONENONEs,x,x, &&
  program_prefix=${target_alias}-
])



# Subroutines of AC_CANONICAL_SYSTEM.

# AC_CANONICAL_THING(THING)
# -------------------------
# Worker routine for AC_CANONICAL_{HOST TARGET BUILD}.  THING is one of
# `host', `target', or `build'.  Canonicalize the appropriate thing,
# generating the variables THING, THING_{alias cpu vendor os}, and the
# associated cache entries.  We also redo the cache entries if the user
# specifies something different from ac_cv_$THING_alias on the command line.
define(AC_CANONICAL_THING,
[AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
ifelse([$1], [host], , [AC_REQUIRE([AC_CANONICAL_HOST])])dnl
AC_MSG_CHECKING([$1 system type])
if test "x$ac_cv_$1" = "x" || (test "x$$1" != "xNONE" && test "x$$1" != "x$ac_cv_$1_alias"); then

  # Make sure we can run config.sub.
  if $ac_config_sub sun4 >/dev/null 2>&1; then :; else
    AC_MSG_ERROR(cannot run $ac_config_sub)
  fi

dnl Set $1_alias.
  ac_cv_$1_alias=$$1
  case "$ac_cv_$1_alias" in
  NONE)
    case $nonopt in
    NONE)
ifelse([$1], [host],[dnl
      if ac_cv_$1_alias=`$ac_config_guess`; then :
      else AC_MSG_ERROR(cannot guess $1 type; you must specify one)
      fi ;;],[dnl
      ac_cv_$1_alias=$host_alias ;;
])dnl
    *) ac_cv_$1_alias=$nonopt ;;
    esac ;;
  esac

dnl Set the other $[1] vars.  Propagate the failures of config.sub.
  ac_cv_$1=`$ac_config_sub $ac_cv_$1_alias` || exit 1
  ac_cv_$1_cpu=`echo $ac_cv_$1 | sed 's/^\([[^-]]*\)-\([[^-]]*\)-\(.*\)$/\1/'`
  ac_cv_$1_vendor=`echo $ac_cv_$1 | sed 's/^\([[^-]]*\)-\([[^-]]*\)-\(.*\)$/\2/'`
  ac_cv_$1_os=`echo $ac_cv_$1 | sed 's/^\([[^-]]*\)-\([[^-]]*\)-\(.*\)$/\3/'`
else
  echo $ac_n "(cached) $ac_c" 1>&AC_FD_MSG
fi

AC_MSG_RESULT($ac_cv_$1)

$1=$ac_cv_$1
$1_alias=$ac_cv_$1_alias
$1_cpu=$ac_cv_$1_cpu
$1_vendor=$ac_cv_$1_vendor
$1_os=$ac_cv_$1_os
AC_SUBST($1)dnl
AC_SUBST($1_alias)dnl
AC_SUBST($1_cpu)dnl
AC_SUBST($1_vendor)dnl
AC_SUBST($1_os)dnl
])dnl AC_CANONICAL_THING

AC_DEFUN(AC_CANONICAL_HOST, [AC_CANONICAL_THING([host])])

# Internal use only.
AC_DEFUN(AC_CANONICAL_TARGET, [AC_CANONICAL_THING([target])])
AC_DEFUN(AC_CANONICAL_BUILD, [AC_CANONICAL_THING([build])])


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
ac_cv_host_system_type="$host"
ac_cv_build_system_type="$build"
ac_cv_target_system_type="$target"dnl
])


## -------------------- ##
## Caching test results ##
## -------------------- ##


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
define(AC_CACHE_LOAD,
[if test -r "$cache_file"; then
  echo "loading cache $cache_file"
  dnl Some versions of bash will fail to source /dev/null, so we
  dnl avoid doing that.
  test -f "$cache_file" && . $cache_file
else
  echo "creating cache $cache_file"
  >$cache_file
fi
])


# AC_CACHE_SAVE
# -------------
define(AC_CACHE_SAVE,
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
dnl Allow a site initialization script to override cache values.
# The following way of writing the cache mishandles newlines in values,
# but we know of no workaround that is simple, portable, and efficient.
# So, don't put newlines in cache variables' values.
# Ultrix sh set writes to stderr and can't be redirected directly,
# and sets the high bit in the cache file unless we assign to the vars.
changequote(, )dnl
(set) 2>&1 |
  case `(ac_space=' '; set | grep ac_space) 2>&1` in
  *ac_space=\ *)
    # `set' does not quote correctly, so add quotes (double-quote substitution
    # turns \\\\ into \\, and sed turns \\ into \).
    sed -n \
      -e "s/'/'\\\\''/g" \
      -e "s/^\\([a-zA-Z0-9_]*_cv_[a-zA-Z0-9_]*\\)=\\(.*\\)/\\1=\${\\1='\\2'}/p"
    ;;
  *)
    # `set' quotes correctly as required by POSIX, so do not add quotes.
    sed -n -e 's/^\([a-zA-Z0-9_]*_cv_[a-zA-Z0-9_]*\)=\(.*\)/\1=${\1=\2}/p'
    ;;
  esac >>confcache
changequote([, ])dnl
if cmp -s $cache_file confcache; then :; else
  if test -w $cache_file; then
    echo "updating cache $cache_file"
    cat confcache >$cache_file
  else
    echo "not updating unwritable cache $cache_file"
  fi
fi
rm -f confcache
])

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
              [echo $ac_n "(cached) $ac_c" 1>&AC_FD_MSG],
              [$2])])


# AC_CACHE_CHECK(MESSAGE, CACHE-ID, COMMANDS)
# -------------------------------------------
# Do not call this macro with a dnl right behind.
define(AC_CACHE_CHECK,
[AC_MSG_CHECKING([$1])
AC_CACHE_VAL([$2], [$3])dnl
AC_MSG_RESULT_UNQUOTED(AC_VAR_GET([$2]))])


## ---------------- ##
## Defining symbols ##
## ---------------- ##


# AC_DEFINE(VARIABLE, [VALUE], [DESCRIPTION])
# -------------------------------------------
# Set VARIABLE to VALUE, verbatim, or 1.  Remember the value
# and if VARIABLE is affected the same VALUE, do nothing, else
# die.  The third argument is used by autoheader.
define(AC_DEFINE,
[cat >>confdefs.h <<\EOF
[#define] $1 ifelse($#, 2, [$2], $#, 3, [$2], 1)
EOF
])



# AC_DEFINE_UNQUOTED(VARIABLE, [VALUE], [DESCRIPTION])
# ----------------------------------------------------
# Similar, but perform shell substitutions $ ` \ once on VALUE.
define(AC_DEFINE_UNQUOTED,
[cat >>confdefs.h <<EOF
[#define] $1 ifelse($#, 2, [$2], $#, 3, [$2], 1)
EOF
])



## ------------------------ ##
## Setting output variables ##
## ------------------------ ##


# AC_SUBST(VARIABLE)
# ------------------
# This macro protects VARIABLE from being diverted twice
# if this macro is called twice for it.
# Beware that if you change this macro, you also have to change the
# sed script at the top of AC_OUTPUT_FILES.
define(AC_SUBST,
[ifdef([AC_SUBST_$1], ,
[define([AC_SUBST_$1], )dnl
AC_DIVERT_PUSH(AC_DIVERSION_SED)dnl
s%@$1@%[$]$1%;t t
AC_DIVERT_POP()dnl
])])

# AC_SUBST_FILE(VARIABLE)
# -----------------------
# Read the comments of the preceding macro.
define(AC_SUBST_FILE,
[ifdef([AC_SUBST_$1], ,
[define([AC_SUBST_$1], )dnl
AC_DIVERT_PUSH(AC_DIVERSION_SED)dnl
/@$1@/r [$]$1
s%@$1@%%;t t
AC_DIVERT_POP()dnl
])])



## ------------------------------------- ##
## Printing messages at autoconf runtime ##
## ------------------------------------- ##

# AC_WARNING(MESSAGE)
define(AC_WARNING, [m4_warn([$1])])

# AC_FATAL(MESSAGE, [EXIT-STATUS])
define(AC_FATAL, [m4_fatal([$1], [$2])])



## -------------------------------------- ##
## Printing messages at configure runtime ##
## -------------------------------------- ##

# _AC_SH_QUOTE(STRING)
# --------------------
# If there are quoted (via backslash) backquotes do nothing, else
# backslash all the quotes.  This macro is robust to active symbols.
# Both cases (with or without back quotes) *must* evaluate STRING the
# same number of times.
#
#   | define(active, ACTIVE)
#   | _AC_SH_QUOTE([`active'])
#   | => \`active'
#   | _AC_SH_QUOTE([\`active'])
#   | => \`active'
#   | error-->c.in:8: warning: backquotes should not be backslashed\
#   ...                        in: \`active'
#
define(_AC_SH_QUOTE,
[ifelse(regexp([[$1]], [\\`]),
        -1, [patsubst([[$1]], [`], [\\`])],
        [AC_WARNING([backquotes should not be backslashed in: $1])dnl
[$1]])])

# _AC_ECHO_UNQUOTED(STRING [ , FD ])
# Expands into a sh call to echo onto FD (default is AC_FD_MSG).
# The shell performs its expansions on STRING.
define([_AC_ECHO_UNQUOTED],
[echo "[$1]" 1>&ifelse($2,, AC_FD_MSG, $2)])

# _AC_ECHO(STRING [ , FD ])
# Expands into a sh call to echo onto FD (default is AC_FD_MSG),
# protecting STRING from backquote expansion.
define([_AC_ECHO],
[_AC_ECHO_UNQUOTED(_AC_SH_QUOTE([$1]), $2)])

# _AC_ECHO_N(STRING [ , FD ])
# Same as _AC_ECHO, but echo doesn't return to a new line.
define(_AC_ECHO_N,
[echo $ac_n "_AC_SH_QUOTE($1)$ac_c" 1>&ifelse($2,,AC_FD_MSG,$2)])

# AC_MSG_CHECKING(FEATURE-DESCRIPTION)
define(AC_MSG_CHECKING,
[_AC_ECHO_N([checking $1... ])
_AC_ECHO([configure:__oline__: checking $1], AC_FD_CC)])

# AC_CHECKING(FEATURE-DESCRIPTION)
define(AC_CHECKING,
[_AC_ECHO([checking $1])
_AC_ECHO([configure:__oline__: checking $1], AC_FD_CC)])

# AC_MSG_RESULT(RESULT-DESCRIPTION)
define(AC_MSG_RESULT,
[_AC_ECHO([$ac_t""$1])])

# AC_MSG_RESULT_UNQUOTED(RESULT-DESCRIPTION)
# Likewise, but perform $ ` \ shell substitutions.
define(AC_MSG_RESULT_UNQUOTED,
[_AC_ECHO_UNQUOTED([$ac_t""$1])])

# AC_VERBOSE(RESULT-DESCRIPTION)
define(AC_VERBOSE,
[AC_OBSOLETE([$0], [; instead use AC_MSG_RESULT])dnl
_AC_ECHO([    $1])])

# AC_MSG_WARN(PROBLEM-DESCRIPTION)
define(AC_MSG_WARN,
[_AC_ECHO([configure: warning: $1], 2)])

# AC_MSG_ERROR(ERROR-DESCRIPTION, [EXIT-STATUS])
define(AC_MSG_ERROR,
[{ _AC_ECHO([configure: error: $1], 2); exit m4_default([$2], 1); }])

# AC_MSG_ERROR_UNQUOTED(ERROR-DESCRIPTION, [EXIT-STATUS])
define(AC_MSG_ERROR_UNQUOTED,
[{ _AC_ECHO_UNQUOTED([configure: error: $1], 2); exit m4_default([$2], 1); }])


## ------------------------------------------- ##
## Selecting which language to use for testing ##
## ------------------------------------------- ##


# The current scheme is really not beautiful.  It'd be better to have
# AC_LANG_PUSH(C), AC_LANG_POP.  In addition, that's easy to do.  FIXME:
# do it yet for 2.16?

# AC_LANG_CASE(LANG1, IF-LANG1, LANG2, IF-LANG2, ..., DEFAULT)
# ------------------------------------------------------------
# Expand into IF-LANG1 if the current language is LANG1 etc. else
# into default.
define(AC_LANG_CASE,
[m4_case(AC_LANG, $@)])

# AC_LANG_C
# ---------
AC_DEFUN(AC_LANG_C,
[define([AC_LANG], [C])dnl
ac_ext=c
# CFLAGS is not in ac_cpp because -g, -O, etc. are not valid cpp options.
ac_cpp='$CPP $CPPFLAGS'
ac_compile='${CC-cc} -c $CFLAGS $CPPFLAGS conftest.$ac_ext 1>&AC_FD_CC'
ac_link='${CC-cc} -o conftest${ac_exeext} $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS 1>&AC_FD_CC'
cross_compiling=$ac_cv_prog_cc_cross
])

# AC_LANG_CPLUSPLUS
# -----------------
AC_DEFUN(AC_LANG_CPLUSPLUS,
[define([AC_LANG], [CPLUSPLUS])dnl
ac_ext=C
# CXXFLAGS is not in ac_cpp because -g, -O, etc. are not valid cpp options.
ac_cpp='$CXXCPP $CPPFLAGS'
ac_compile='${CXX-g++} -c $CXXFLAGS $CPPFLAGS conftest.$ac_ext 1>&AC_FD_CC'
ac_link='${CXX-g++} -o conftest${ac_exeext} $CXXFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS 1>&AC_FD_CC'
cross_compiling=$ac_cv_prog_cxx_cross
])

# AC_LANG_FORTRAN77
# -----------------
AC_DEFUN(AC_LANG_FORTRAN77,
[define([AC_LANG], [FORTRAN77])dnl
ac_ext=f
ac_compile='${F77-f77} -c $FFLAGS conftest.$ac_ext 1>&AC_FD_CC'
ac_link='${F77-f77} -o conftest${ac_exeext} $FFLAGS $LDFLAGS conftest.$ac_ext $LIBS 1>&AC_FD_CC'
cross_compiling=$ac_cv_prog_f77_cross
])

# AC_LANG_SAVE
# ------------
# Push the current language on a stack.
define(AC_LANG_SAVE,
[pushdef([AC_LANG_STACK], AC_LANG)])

# AC_LANG_RESTORE
# ---------------
# Restore the current language from the stack.
pushdef([AC_LANG_RESTORE],
[m4_case(AC_LANG_STACK,
         [C],         [AC_LANG_C()],
         [CPLUSPLUS], [AC_LANG_CPLUSPLUS()],
         [FORTRAN77], [AC_LANG_FORTRAN77()])dnl
popdef([AC_LANG_STACK])])


## ---------------------------- ##
## Compiler-running mechanics.  ##
## ---------------------------- ##


# AC_TRY_EVAL(VARIABLE)
# ---------------------
# The purpose of this macro is to "configure:123: command line"
# written into config.log for every test run.
AC_DEFUN(AC_TRY_EVAL,
[{ (eval echo configure:__oline__: \"[$]$1\") 1>&AC_FD_CC; dnl
(eval [$]$1) 2>&AC_FD_CC; }])

# AC_TRY_COMMAND(COMMAND)
# -----------------------
AC_DEFUN(AC_TRY_COMMAND,
[{ ac_try='$1'; AC_TRY_EVAL(ac_try); }])



## ----------------- ##
## Default headers.  ##
## ----------------- ##

# Always use the same set of default headers for all the generic
# macros.  It is easier to document, to extend, and to understand than
# having specific defaults for each macro.

# Of course, one would like to issue these default headers only if
# they were used, i.e.., AC_INCLUDES_DEFAULT was called, and the
# default `branch' was run.  Unfortunately AC_INCLUDES_DEFAULT is
# called unquoted, so it is unsafe to try to divert from there.
# Therefore, the following *is* buggy, but this is the kind of
# tradeoff we accept in order to improve configure.

AC_DIVERT_PUSH(AC_DIVERSION_INIT)dnl
# Factorizing default headers for most tests.
# Mandatory included if its is not used.
ac_includes_default='\
#include <stdio.h>
#include <sys/types.h>
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
#if STDC_HEADERS
# include <stdlib.h>
# include <stddef.h>
#else
# if HAVE_STDLIB_H
#  include <stdlib.h>
# endif
#endif
#if HAVE_UNISTD_H
# include <unistd.h>
#endif'
AC_DIVERT_POP()


# AC_INCLUDES_DEFAULT([INCLUDES])
# -------------------------------
# If INCLUDES is empty, expand in default includes, otherwise in
# INCLUDES.
define(AC_INCLUDES_DEFAULT,
[m4_default([$1], [$ac_includes_default])])


## ------------------------ ##
## Generic structure checks ##
## ------------------------ ##

# AC_CHECK_MEMBER(AGGREGATE.MEMBER,
#                 [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#                 [INCLUDES])
# ---------------------------------------------------------
# AGGREGATE.MEMBER is for instance `struct passwd.pw_gecos', shell
# variables are not a valid argument.
AC_DEFUN(AC_CHECK_MEMBER,
[AC_REQUIRE([AC_HEADER_STDC])dnl
AC_VAR_PUSHDEF([ac_Member], [ac_cv_member_$1])dnl
dnl Extract the aggregate name, and the member name
AC_VAR_IF_INDIR([$1],
[AC_FATAL([$0: requires manifest arguments])])
ifelse(regexp([$1], [\.]), -1,
       [AC_FATAL([$0: Did not see any dot in `$1'])])dnl
AC_CACHE_CHECK([for $1], ac_Member,
[AC_TRY_COMPILE(AC_INCLUDES_DEFAULT([$4]),
dnl AGGREGATE foo;
patsubst([$1], [\.[^.]*]) foo;
dnl foo.MEMBER;
foo.patsubst([$1], [.*\.]);,
                AC_VAR_SET(ac_Member, yes),
                AC_VAR_SET(ac_Member, no))])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_Member) = yes],
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_Member])dnl
])dnl AC_CHECK_MEMBER


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
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_[]AC_Member))
$2],
                 [$3],
                 [$4])])])





## --------------------- ##
## Checking for programs ##
## --------------------- ##


# AC_CHECK_PROG(VARIABLE, PROG-TO-CHECK-FOR,
#               [VALUE-IF-FOUND], [VALUE-IF-NOT-FOUND],
#               [PATH], [REJECT])
# -----------------------------------------------------
AC_DEFUN(AC_CHECK_PROG,
[# Extract the first word of "$2", so it can be a program name with args.
set dummy $2; ac_word=[$]2
AC_MSG_CHECKING([for $ac_word])
AC_CACHE_VAL(ac_cv_prog_$1,
[if test -n "[$]$1"; then
  ac_cv_prog_$1="[$]$1" # Let the user override the test.
else
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS=":"
ifelse([$6], , , [  ac_prog_rejected=no
])dnl
dnl $ac_dummy forces splitting on constant user-supplied paths.
dnl POSIX.2 word splitting is done only on the output of word expansions,
dnl not every word.  This closes a longstanding sh security hole.
  ac_dummy="ifelse([$5], , $PATH, [$5])"
  for ac_dir in $ac_dummy; do
    test -z "$ac_dir" && ac_dir=.
    if test -f $ac_dir/$ac_word; then
ifelse([$6], , , dnl
[      if test "[$ac_dir/$ac_word]" = "$6"; then
        ac_prog_rejected=yes
	continue
      fi
])dnl
      ac_cv_prog_$1="$3"
      break
    fi
  done
  IFS="$ac_save_ifs"
ifelse([$6], , , [if test $ac_prog_rejected = yes; then
  # We found a bogon in the path, so make sure we never use it.
  set dummy [$]ac_cv_prog_$1
  shift
  if test [$]# -gt 0; then
    # We chose a different compiler from the bogus one.
    # However, it has the same basename, so the bogon will be chosen
    # first if we set $1 to just the basename; use the full file name.
    shift
    set dummy "$ac_dir/$ac_word" "[$]@"
    shift
    ac_cv_prog_$1="[$]@"
ifelse([$2], [$4], dnl
[  else
    # Default is a loser.
    AC_MSG_ERROR([$1=$6 unacceptable, but no other $4 found in dnl
ifelse([$5], , [\$]PATH, [$5])])
])dnl
  fi
fi
])dnl
dnl If no 4th arg is given, leave the cache variable unset,
dnl so AC_CHECK_PROGS will keep looking.
ifelse([$4], , , [  test -z "[$]ac_cv_prog_$1" && ac_cv_prog_$1="$4"
])dnl
fi])dnl
$1="$ac_cv_prog_$1"
if test -n "[$]$1"; then
  AC_MSG_RESULT([$]$1)
else
  AC_MSG_RESULT(no)
fi
AC_SUBST($1)dnl
])dnl AC_CHECK_PROG


# AC_CHECK_PROGS(VARIABLE, PROGS-TO-CHECK-FOR [, VALUE-IF-NOT-FOUND
#                [, PATH]])
# -----------------------------------------------------------------
AC_DEFUN(AC_CHECK_PROGS,
[for ac_prog in $2
do
AC_CHECK_PROG($1, [$]ac_prog, [$]ac_prog, , $4)
test -n "[$]$1" && break
done
ifelse([$3], , , [test -n "[$]$1" || $1="$3"
])])


# AC_PATH_PROG(VARIABLE, PROG-TO-CHECK-FOR [, VALUE-IF-NOT-FOUND [, PATH]])
# -------------------------------------------------------------------------
AC_DEFUN(AC_PATH_PROG,
[# Extract the first word of "$2", so it can be a program name with args.
set dummy $2; ac_word=[$]2
AC_MSG_CHECKING([for $ac_word])
AC_CACHE_VAL(ac_cv_path_$1,
[case "[$]$1" in
dnl Second pattern matches DOS absolute paths.
  /* | ?:/*)
  ac_cv_path_$1="[$]$1" # Let the user override the test with a path.
  ;;
  *)
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS=":"
dnl $ac_dummy forces splitting on constant user-supplied paths.
dnl POSIX.2 word splitting is done only on the output of word expansions,
dnl not every word.  This closes a longstanding sh security hole.
  ac_dummy="ifelse([$4], , $PATH, [$4])"
  for ac_dir in $ac_dummy; do
    test -z "$ac_dir" && ac_dir=.
    if test -f "$ac_dir/$ac_word"; then
      ac_cv_path_$1="$ac_dir/$ac_word"
      break
    fi
  done
  IFS="$ac_save_ifs"
dnl If no 3rd arg is given, leave the cache variable unset,
dnl so AC_PATH_PROGS will keep looking.
ifelse([$3], , , [  test -z "[$]ac_cv_path_$1" && ac_cv_path_$1="$3"
])dnl
  ;;
esac])dnl
$1="$ac_cv_path_$1"
if test -n "[$]$1"; then
  AC_MSG_RESULT([$]$1)
else
  AC_MSG_RESULT(no)
fi
AC_SUBST($1)dnl
])dnl AC_PATH_PROG


# AC_PATH_PROGS(VARIABLE, PROGS-TO-CHECK-FOR [, VALUE-IF-NOT-FOUND
#               [, PATH]])
# ----------------------------------------------------------------
AC_DEFUN(AC_PATH_PROGS,
[for ac_prog in $2
do
AC_PATH_PROG($1, [$]ac_prog, , $4)
test -n "[$]$1" && break
done
ifelse([$3], , , [test -n "[$]$1" || $1="$3"
])])




## ------------------ ##
## Checking for tools ##
## ------------------ ##

# Internal subroutine.
AC_DEFUN(AC_CHECK_TOOL_PREFIX,
[AC_REQUIRE([AC_CANONICAL_HOST])AC_REQUIRE([AC_CANONICAL_BUILD])dnl
if test $host != $build; then
  ac_tool_prefix=${host_alias}-
else
  ac_tool_prefix=
fi
])

# AC_PATH_TOOL(VARIABLE, PROG-TO-CHECK-FOR[, VALUE-IF-NOT-FOUND [, PATH]])
# ------------------------------------------------------------------------
AC_DEFUN(AC_PATH_TOOL,
[AC_REQUIRE([AC_CHECK_TOOL_PREFIX])dnl
AC_PATH_PROG($1, ${ac_tool_prefix}$2, ${ac_tool_prefix}$2,
             ifelse([$3], , [$2], ), $4)
ifelse([$3], , , [
if test -z "$ac_cv_prog_$1"; then
  if test -n "$ac_tool_prefix"; then
    AC_PATH_PROG($1, $2, $2, $3)
  else
    $1="$3"
  fi
fi])
])

# AC_CHECK_TOOL(VARIABLE, PROG-TO-CHECK-FOR[, VALUE-IF-NOT-FOUND [, PATH]])
# -------------------------------------------------------------------------
AC_DEFUN(AC_CHECK_TOOL,
[AC_REQUIRE([AC_CHECK_TOOL_PREFIX])dnl
AC_CHECK_PROG($1, ${ac_tool_prefix}$2, ${ac_tool_prefix}$2,
	      ifelse([$3], , [$2], ), $4)
ifelse([$3], , , [
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
echo $ac_n "checking for prefix by $ac_c" 1>&AC_FD_MSG
AC_PATH_PROG(AC_Prog, $1)
changequote(<<, >>)dnl
  if test -n "$ac_cv_path_<<>>AC_Prog"; then
    prefix=`echo $ac_cv_path_<<>>AC_Prog|sed 's%/[^/][^/]*//*[^/][^/]*$%%'`
changequote([, ])dnl
  fi
fi
popdef([AC_Prog])dnl
])dnl AC_PREFIX_PROGRAM


# AC_TRY_COMPILER(TEST-PROGRAM, WORKING-VAR, CROSS-VAR)
# -----------------------------------------------------
# Try to compile, link and execute TEST-PROGRAM.  Set WORKING-VAR to
# `yes' if the current compiler works, otherwise set it ti `no'.  Set
# CROSS-VAR to `yes' if the compiler and linker produce non-native
# executables, otherwise set it to `no'.  Before calling
# `AC_TRY_COMPILER()', call `AC_LANG_*' to set-up for the right
# language.
AC_DEFUN(AC_TRY_COMPILER,
[cat >conftest.$ac_ext <<EOF
ifelse(AC_LANG, [FORTRAN77], ,
[
@PND@line __oline__ "configure"
#include "confdefs.h"
])
[$1]
EOF
if AC_TRY_EVAL(ac_link) && test -s conftest${ac_exeext}; then
  [$2]=yes
  # If we can't run a trivial program, we are probably using a cross compiler.
  if (./conftest; exit) 2>/dev/null; then
    [$3]=no
  else
    [$3]=yes
  fi
else
  echo "configure: failed program was:" >&AC_FD_CC
  cat conftest.$ac_ext >&AC_FD_CC
  [$2]=no
fi
rm -fr conftest*])


## ---------------------- ##
## Checking for libraries ##
## ---------------------- ##


# AC_TRY_LINK_FUNC(func, action-if-found, action-if-not-found)
# ------------------------------------------------------------
# Try to link a program that calls FUNC, handling GCC builtins.  If
# the link succeeds, execute ACTION-IF-FOUND; otherwise, execute
# ACTION-IF-NOT-FOUND.

AC_DEFUN(AC_TRY_LINK_FUNC,
AC_TRY_LINK(dnl
ifelse(AC_LANG, [FORTRAN77], ,
ifelse([$1], [main], , dnl Avoid conflicting decl of main.
[/* Override any gcc2 internal prototype to avoid an error.  */
]ifelse(AC_LANG, CPLUSPLUS, [#ifdef __cplusplus
extern "C"
#endif
])dnl
[/* We use char because int might match the return type of a gcc2
    builtin and then its argument prototype would still apply.  */
char $1();
])),
[$1()],
[$2],
[$3]))


# AC_SEARCH_LIBS(FUNCTION, SEARCH-LIBS,
#                [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#                [OTHER-LIBRARIES])
# --------------------------------------------------------
# Search for a library defining FUNC, if it's not already available.
AC_DEFUN(AC_SEARCH_LIBS,
[AC_CACHE_CHECK([for library containing $1], [ac_cv_search_$1],
[ac_func_search_save_LIBS="$LIBS"
ac_cv_search_$1="no"
AC_TRY_LINK_FUNC([$1], [ac_cv_search_$1="none required"])
test "$ac_cv_search_$1" = "no" && for ac_lib in $2; do
LIBS="-l$ac_lib $5 $ac_func_search_save_LIBS"
AC_TRY_LINK_FUNC([$1],
[ac_cv_search_$1="-l$ac_lib"
break])
done
LIBS="$ac_func_search_save_LIBS"])
if test "$ac_cv_search_$1" != "no"; then
  test "$ac_cv_search_$1" = "none required" || LIBS="$ac_cv_search_$1 $LIBS"
  $3
else :
  $4
fi])



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
[AC_VAR_PUSHDEF([ac_Lib], [ac_cv_lib_$1_$2])dnl
AC_CACHE_CHECK([for $2 in -l$1], ac_Lib,
[ac_save_LIBS="$LIBS"
LIBS="-l$1 $5 $LIBS"
AC_TRY_LINK(dnl
ifelse(AC_LANG, [FORTRAN77], ,
ifelse([$2], [main], , dnl Avoid conflicting decl of main.
[/* Override any gcc2 internal prototype to avoid an error.  */
]ifelse(AC_LANG, CPLUSPLUS, [#ifdef __cplusplus
extern "C"
#endif
])dnl
[/* We use char because int might match the return type of a gcc2
    builtin and then its argument prototype would still apply.  */
char $2();
])),
[$2()],
AC_VAR_SET(ac_Lib, yes), AC_VAR_SET(ac_Lib, no))
LIBS="$ac_save_LIBS"])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_Lib) = yes],
                m4_default([$3],
                           [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_LIB$1))
  LIBS="-l$1 $LIBS"
]),
                [$4])dnl
AC_VAR_POPDEF([ac_Lib])dnl
])dnl AC_CHECK_LIB



# AC_HAVE_LIBRARY
# ---------------
AC_DEFUNCT(AC_HAVE_LIBRARY, [; instead use AC_CHECK_LIB])


## ---------------------- ##
## Examining declarations ##
## ---------------------- ##


# AC_TRY_CPP(INCLUDES, [ACTION-IF-TRUE [, ACTION-IF-FALSE]])
# ----------------------------------------------------------
# INCLUDES are not defaulted.
AC_DEFUN(AC_TRY_CPP,
[AC_REQUIRE_CPP()dnl
cat >conftest.$ac_ext <<EOF
@PND@line __oline__ "configure"
#include "confdefs.h"
[$1]
EOF
dnl Capture the stderr of cpp.  eval is necessary to expand ac_cpp.
dnl We used to copy stderr to stdout and capture it in a variable, but
dnl that breaks under sh -x, which writes compile commands starting
dnl with ` +' to stderr in eval and subshells.
ac_try="$ac_cpp conftest.$ac_ext >/dev/null 2>conftest.out"
AC_TRY_EVAL(ac_try)
ac_err=`grep -v '^ *+' conftest.out | grep -v "^conftest.${ac_ext}\$"`
if test -z "$ac_err"; then
  ifelse([$2], , :, [rm -rf conftest*
  $2])
else
  echo "$ac_err" >&AC_FD_CC
  echo "configure: failed program was:" >&AC_FD_CC
  cat conftest.$ac_ext >&AC_FD_CC
ifelse([$3], , , [  rm -rf conftest*
  $3
])dnl
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
@PND@line __oline__ "configure"
#include "confdefs.h"
[$2]
EOF
dnl eval is necessary to expand ac_cpp.
dnl Ultrix and Pyramid sh refuse to redirect output of eval, so use subshell.
if (eval "$ac_cpp conftest.$ac_ext") 2>&AC_FD_CC |
dnl Prevent m4 from eating character classes:
changequote(, )dnl
  egrep "$1" >/dev/null 2>&1; then
changequote([, ])dnl
  ifelse([$3], , :, [rm -rf conftest*
  $3])
ifelse([$4], , , [else
  rm -rf conftest*
  $4
])dnl
fi
rm -f conftest*
])dnl AC_EGREP_CPP


## ---------------- ##
## Examining syntax ##
## ---------------- ##


# AC_TRY_COMPILE(INCLUDES, FUNCTION-BODY,
#		 [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# --------------------------------------------------------
# FIXME: Should INCLUDES be defaulted here?
AC_DEFUN(AC_TRY_COMPILE,
[cat >conftest.$ac_ext <<EOF
ifelse(AC_LANG, [FORTRAN77],
[      program main
[$2]
      end],
[dnl This sometimes fails to find confdefs.h, for some reason.
dnl @PND@line __oline__ "[$]0"
@PND@line __oline__ "configure"
#include "confdefs.h"
[$1]
int
main ()
{
dnl Do *not* indent the following line: there may be CPP directives.
dnl Don't move the `;' right after for the same reason.
[$2]
  ;
  return 0;
}
])EOF
if AC_TRY_EVAL(ac_compile); then
  ifelse([$3], , :, [rm -rf conftest*
  $3])
else
  echo "configure: failed program was:" >&AC_FD_CC
  cat conftest.$ac_ext >&AC_FD_CC
ifelse([$4], , , [  rm -rf conftest*
  $4
])dnl
fi
rm -f conftest*])


## ------------------- ##
## Examining libraries ##
## ------------------- ##


# AC_COMPILE_CHECK(ECHO-TEXT, INCLUDES, FUNCTION-BODY,
#                  ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
# ---------------------------------------------------------
AC_DEFUN(AC_COMPILE_CHECK,
[AC_OBSOLETE([$0], [; instead use AC_TRY_COMPILE or AC_TRY_LINK, and AC_MSG_CHECKING and AC_MSG_RESULT])dnl
ifelse([$1], , , [AC_CHECKING([for $1])
])dnl
AC_TRY_LINK([$2], [$3], [$4], [$5])
])

# AC_TRY_LINK(INCLUDES, FUNCTION-BODY,
#             [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# -----------------------------------------------------
# Should the INCLUDES be defaulted here?
AC_DEFUN(AC_TRY_LINK,
[cat >conftest.$ac_ext <<EOF
ifelse(AC_LANG, [FORTRAN77],
[
      program main
      call [$2]
      end
],
[dnl This sometimes fails to find confdefs.h, for some reason.
dnl @PND@line __oline__ "[$]0"
@PND@line __oline__ "configure"
#include "confdefs.h"
[$1]
int
main()
{
dnl Do *not* indent the following line: there may be CPP directives.
dnl Don't move the `;' right after for the same reason.
[$2]
  ;
  return 0;
}
])EOF
if AC_TRY_EVAL(ac_link) && test -s conftest${ac_exeext}; then
  ifelse([$3], , :, [rm -rf conftest*
  $3])
else
  echo "configure: failed program was:" >&AC_FD_CC
  cat conftest.$ac_ext >&AC_FD_CC
ifelse([$4], , , [  rm -rf conftest*
  $4
])dnl
fi
rm -f conftest*
])dnl AC_TRY_LINK


## -------------------------------- ##
## Checking for run-time features.  ##
## -------------------------------- ##


# AC_TRY_RUN(PROGRAM, [ACTION-IF-TRUE], [ACTION-IF-FALSE],
#            [ACTION-IF-CROSS-COMPILING])
# --------------------------------------------------------
AC_DEFUN(AC_TRY_RUN,
[if test "$cross_compiling" = yes; then
  ifelse([$4], ,
    [AC_WARNING([AC_TRY_RUN called without default to allow cross compiling])dnl
  AC_MSG_ERROR(cannot run test program while cross compiling)],
  [$4])
else
  AC_TRY_RUN_NATIVE([$1], [$2], [$3])
fi
])


# AC_TRY_RUN_NATIVE(PROGRAM, [ACTION-IF-TRUE], [ACTION-IF-FALSE])
# ---------------------------------------------------------------
# Like AC_TRY_RUN but assumes a native-environment (non-cross) compiler.
AC_DEFUN(AC_TRY_RUN_NATIVE,
[cat >conftest.$ac_ext <<EOF
@PND@line __oline__ "configure"
#include "confdefs.h"
ifelse(AC_LANG, CPLUSPLUS, [#ifdef __cplusplus
extern "C" void exit(int);
#endif
])dnl
[$1]
EOF
if AC_TRY_EVAL(ac_link) && test -s conftest${ac_exeext} && (./conftest; exit) 2>/dev/null
then
dnl Don't remove the temporary files here, so they can be examined.
  ifelse([$2], , :, [$2])
else
  echo "configure: failed program was:" >&AC_FD_CC
  cat conftest.$ac_ext >&AC_FD_CC
ifelse([$3], , , [  rm -fr conftest*
  $3
])dnl
fi
rm -fr conftest*
])dnl AC_TRY_RUN_NATIVE


## --------------------------- ##
## Checking for header files.  ##
## --------------------------- ##


# AC_CHECK_HEADER(HEADER-FILE, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# -----------------------------------------------------------------------
AC_DEFUN(AC_CHECK_HEADER,
[AC_VAR_PUSHDEF([ac_Header], [ac_cv_header_$1])dnl
AC_CACHE_CHECK([for $1], ac_Header,
[AC_TRY_CPP([#include <$1>
],
AC_VAR_SET(ac_Header, yes), AC_VAR_SET(ac_Header, no))])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_Header) = yes],
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_Header])dnl
])dnl AC_CHECK_HEADER


# AC_CHECK_HEADERS(HEADER-FILE...
#                  [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# ----------------------------------------------------------
AC_DEFUN(AC_CHECK_HEADERS,
[for ac_header in $1
do
AC_CHECK_HEADER($ac_header,
                [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_$ac_header)) $2],
                [$3])dnl
done
])


## ----------------------------------- ##
## Checking for the existence of files ##
## ----------------------------------- ##

# AC_CHECK_FILE(FILE, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# --------------------------------------------------------------
#
# Check for the existence of FILE.
AC_DEFUN(AC_CHECK_FILE,
[AC_VAR_PUSHDEF([ac_var], [ac_cv_file_$1])dnl
dnl FIXME: why was there this line? AC_REQUIRE([AC_PROG_CC])dnl
AC_MSG_CHECKING([for $1])
AC_CACHE_VAL(ac_var,
[if test "$cross_compiling" = yes; then
  AC_WARNING([Cannot check for file existence when cross compiling])dnl
  AC_MSG_ERROR([Cannot check for file existence when cross compiling])
fi
if test -r "[$1]"; then
  AC_VAR_SET(ac_var, yes)
else
  AC_VAR_SET(ac_var, no)
fi])dnl
if test AC_VAR_GET(ac_var) = yes; then
  AC_MSG_RESULT(yes)
ifval([$2], [  $2
])dnl
else
  AC_MSG_RESULT(no)
ifval([$3], [  $3
])dnl
fi
AC_VAR_POPDEF([ac_var])])


# AC_CHECK_FILES(FILE..., [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# -----------------------------------------------------------------
AC_DEFUN(AC_CHECK_FILES,
[AC_FOREACH([AC_FILE_NAME], [$1],
  [AC_SPECIALIZE([AC_CHECK_FILE], AC_FILE_NAME,
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_[]AC_FILE_NAME))
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
[AC_TRY_COMPILE(AC_INCLUDES_DEFAULT([$4]),
[#ifndef $1
  char *p = (char *) $1;
#endif
],
AC_VAR_SET(ac_Symbol, yes), AC_VAR_SET(ac_Symbol, no))])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_Symbol) = yes],
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_Symbol])dnl
])dnl AC_CHECK_DECL


# AC_CHECK_DECLS(SYMBOL,
#                [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#                [INCLUDES])
# --------------------------------------------------------
AC_DEFUN([AC_CHECK_DECLS],
[m4_foreach([AC_Symbol], [$1],
  [AC_SPECIALIZE([AC_CHECK_DECL], AC_Symbol,
                 [$2],
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP([NEED_]AC_Symbol[_DECL]))
$3],
                 [$4])])
])dnl AC_CHECK_DECLS


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
]ifelse(AC_LANG, CPLUSPLUS, [#ifdef __cplusplus
extern "C"
#endif
])dnl
[/* We use char because int might match the return type of a gcc2
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
])dnl AC_CHECK_FUNC


# AC_CHECK_FUNCS(FUNCTION..., [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# ---------------------------------------------------------------------
# FIXME: Should we die if there are not enough arguments, or just
# ignore?
AC_DEFUN(AC_CHECK_FUNCS,
[for ac_func in $1
do
AC_CHECK_FUNC($ac_func,
              [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_$ac_func)) $2],
              [$3])dnl
done
])


# AC_REPLACE_FUNCS(FUNCTION...)
# -----------------------------
AC_DEFUN(AC_REPLACE_FUNCS,
[AC_CHECK_FUNCS([$1], , [LIBOBJS="$LIBOBJS ${ac_func}.${ac_objext}"])
AC_SUBST(LIBOBJS)dnl
])


## ----------------------------------- ##
## Checking compiler characteristics.  ##
## ----------------------------------- ##


# AC_CHECK_SIZEOF(TYPE, [CROSS-SIZE], [INCLUDES])
# -----------------------------------------------
# This macro will probably be obsoleted by the macros of Kaveh.  In
# addition `CHECK' is not a proper name (is not boolean). And finally:
# shouldn't we use the default INCLUDES?
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
AC_DEFINE_UNQUOTED(AC_TR_CPP(sizeof_$1), AC_VAR_GET(ac_Sizeof))
AC_VAR_POPDEF([ac_Sizeof])dnl
])


## -------------------- ##
## Checking for types.  ##
## -------------------- ##


# AC_CHECK_TYPE_INTERNAL(TYPE,
#			 [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#			 [INCLUDES])
# ----------------------------------------------------------------
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
#
# FIXME: This is *the* macro which ought to be named AC_CHECK_TYPE.
AC_DEFUN(AC_CHECK_TYPE_INTERNAL,
[AC_REQUIRE([AC_HEADER_STDC])dnl
AC_VAR_PUSHDEF([ac_Type], [ac_cv_type_$1])dnl
AC_CACHE_CHECK([for $1], ac_Type,
[AC_TRY_COMPILE(AC_INCLUDES_DEFAULT([$4]),
[if (($1 *) 0)
  return 0;
if (sizeof ($1))
  return 0;],
                AC_VAR_SET(ac_Type, yes),
                AC_VAR_SET(ac_Type, no))])
AC_SHELL_IFELSE([test AC_VAR_GET(ac_Type) = yes],
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_Type])dnl
])dnl AC_CHECK_TYPE_INTERNAL


# AC_CHECK_TYPES((TYPE, ...),
#                [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#                [INCLUDES])
# --------------------------------------------------------
# TYPEs is an m4 list.
AC_DEFUN(AC_CHECK_TYPES,
[m4_foreach([AC_Type], [$1],
  [AC_SPECIALIZE([AC_CHECK_TYPE_INTERNAL], AC_Type,
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_[]AC_Type))
$2],
                 [$3],
                 [$4])])])


# AC_CHECK_TYPE(TYPE, DEFAULT, [INCLUDES])
# ----------------------------------------
# FIXME: This is an extremely badly chosen name, since this
# macro actually performs an AC_REPLACE_TYPE.  Some day we
# have to clean this up.  The macro AC_TYPE_PTRDIFF_T shows the
# need for a checking only macro.
AC_DEFUN(AC_CHECK_TYPE,
[AC_CHECK_TYPE_INTERNAL([$1],,
                        [AC_DEFINE_UNQUOTED($1, $2)],
                        [$3])dnl
])dnl AC_CHECK_TYPE




## ----------------------- ##
## Creating output files.  ##
## ----------------------- ##


# AC_CONFIG_IF_MEMBER(DEST[:SOURCE], LIST, ACTION-IF-TRUE, ACTION-IF-FALSE)
# -------------------------------------------------------------------------
# If DEST is member of LIST, expand to ACTION-IF-TRUE, else ACTION-IF-FALSE.
#
# LIST is an AC_CONFIG list, i.e., a list of DEST[:SOURCE], separated
# with spaces.
#
# FIXME: This macro is badly designed, but I'm not guilty: m4 is.  There
# is just no way to simply compare two strings in m4, but to use pattern
# matching.  The big problem is then that the active characters should
# be quoted.  So an additional macro should be used here.  Nevertheless,
# in the case of file names, there is not much to worry.
define(AC_CONFIG_IF_MEMBER,
[pushdef([AC_Dest], patsubst([$1], [:.*]))dnl
ifelse(regexp($2, [\(^\| \)]AC_Dest[\(:\| \|$\)]), -1, [$4], [$3])dnl
popdef([AC_Dest])dnl
])


# AC_CONFIG_UNIQUE(DEST[:SOURCE]...)
# ----------------------------------
# Verify that there is no double definition of an output file
# (precisely, guarantees there is no common elements between
# CONFIG_HEADERS, CONFIG_FILES, CONFIG_LINKS, and CONFIG_SUBDIRS).
# This macro should output nothing, so we divert to /dev/null.
define(AC_CONFIG_UNIQUE,
[AC_DIVERT_PUSH(AC_DIVERSION_KILL)
AC_FOREACH([AC_File], [$1],
 [AC_CONFIG_IF_MEMBER(AC_File, [AC_LIST_HEADERS],
     [AC_FATAL(`AC_File' [is already registered with AC_CONFIG_HEADER or AC_CONFIG_HEADERS.])])
  AC_CONFIG_IF_MEMBER(AC_File, [AC_LIST_LINKS],
     [AC_FATAL(`AC_File' [is already registered with AC_CONFIG_LINKS.])])
  AC_CONFIG_IF_MEMBER(AC_File, [AC_LIST_SUBDIRS],
     [AC_FATAL(`AC_File' [is already registered with AC_CONFIG_SUBDIRS.])])
  AC_CONFIG_IF_MEMBER(AC_File, [AC_LIST_COMMANDS],
     [AC_FATAL(`AC_File' [is already registered with AC_CONFIG_COMMANDS.])])
  AC_CONFIG_IF_MEMBER(AC_File, [AC_LIST_FILES],
     [AC_FATAL(`AC_File' [is already registered with AC_CONFIG_FILES or AC_OUTPUT.])])])
AC_DIVERT_POP()dnl
])


# AC_CONFIG_HEADERS(HEADERS..., [COMMANDS])
# -----------------------------------------
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
[AC_CONFIG_UNIQUE([$1])dnl
m4_append([AC_LIST_HEADERS], [$1])dnl
dnl Register the commands
ifelse([$2],,, [AC_FOREACH([AC_File], [$1],
[m4_append([AC_LIST_HEADERS_COMMANDS],
[    ]patsubst(AC_File, [:.*])[ ) $2 ;;
])])])dnl
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


# AC_CONFIG_LINKS(DEST:SOURCE..., [COMMANDS])
# -------------------------------------------
# Specify that config.status should establish a (symbolic if possible)
# link from TOP_SRCDIR/SOURCE to TOP_SRCDIR/DEST.
# Reject DEST=., because it is makes it hard for ./config.status
# to guess the links to establish (`./config.status .').
# This macro may be called multiple times.
#
# The commands are stored in a growing string AC_LIST_LINKS_COMMANDS
# which should be used like this:
#
#      case $ac_file in
#        AC_LIST_LINKS_COMMANDS
#      esac
AC_DEFUN(AC_CONFIG_LINKS,
[AC_CONFIG_UNIQUE([$1])dnl
ifelse(regexp([$1], [^\.:\| \.:]), -1,,
       [AC_FATAL([$0: invalid destination: `.'])])dnl
m4_append([AC_LIST_LINKS], [$1])dnl
dnl Register the commands
ifelse([$2],,, [AC_FOREACH([AC_File], [$1],
[m4_append([AC_LIST_LINKS_COMMANDS],
[    ]patsubst(AC_File, [:.*])[ ) $2 ;;
])])])dnl
])dnl

# Initialize the list.
define([AC_LIST_LINKS])
define([AC_LIST_LINKS_COMMANDS])


# AC_LINK_FILES(SOURCE..., DEST...)
# ---------------------------------
# Link each of the existing files SOURCE... to the corresponding
# link name in DEST...
AC_DEFUN(AC_LINK_FILES,
[AC_OBSOLETE([$0], [; instead use AC_CONFIG_LINKS(DEST:SOURCE...)])dnl
ifelse($#, 2, ,
  [AC_FATAL([$0: incorrect number of arguments])])dnl
dnl
pushdef([AC_Sources], m4_split(m4_strip(m4_join([$1]))))dnl
pushdef([AC_Dests], m4_split(m4_strip(m4_join([$2]))))dnl
dnl
m4_foreach([AC_Dummy], (AC_Sources),
[AC_CONFIG_LINKS(m4_car(AC_Dests):m4_car(AC_Sources))
define([AC_Sources], m4_quote(m4_shift(AC_Sources)))
define([AC_Dests], m4_quote(m4_shift(AC_Dests)))])dnl
dnl
popdef([AC_Sources])dnl
popdef([AC_Dests])dnl
])dnl AC_LINK_FILES


# AC_CONFIG_FILES(FILE...[, COMMANDS])
# ------------------------------------
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
[AC_CONFIG_UNIQUE([$1])dnl
m4_append([AC_LIST_FILES], [ $1])dnl
dnl Register the commands.
ifelse([$2],,, [AC_FOREACH([AC_File], [$1],
[m4_append([AC_LIST_FILES_COMMANDS],
[    ]patsubst(AC_File, [:.*])[ ) $2 ;;
])])])dnl
])dnl

# Initialize the lists.
define([AC_LIST_FILES])
define([AC_LIST_FILES_COMMANDS])

# AC_CONFIG_COMMANDS(NAME..., COMMANDS)
# -------------------------------------
# Specify additional commands to be run by config.status.  This
# commands must be associated with a NAME, which should be thought
# as the name of a file the COMMANDS create.
#
# This name must be a unique config key.
#
# The commands are stored in a growing string AC_LIST_COMMANDS_COMMANDS
# which should be used like this:
#
#      case $ac_file in
#        AC_LIST_COMMANDS_COMMANDS
#      esac
AC_DEFUN([AC_CONFIG_COMMANDS],
[AC_CONFIG_UNIQUE([$1])dnl
m4_append([AC_LIST_COMMANDS], [ $1])dnl
dnl
ifelse([$2],,, [AC_FOREACH([AC_Name], [$1],
[m4_append([AC_LIST_COMMANDS_COMMANDS],
[    ]patsubst(AC_Name, [:.*])[ ) $2 ;;
])])])dnl
])dnl

# Initialize the lists.
define([AC_LIST_COMMANDS])
define([AC_LIST_COMMANDS_COMMANDS])


# AC_OUTPUT_COMMANDS(EXTRA-CMDS, INIT-CMDS)
# -----------------------------------------
# Add additional commands for AC_OUTPUT to put into config.status.
# Use diversions instead of macros so we can be robust in the
# presence of commas in $1 and/or $2.
# FIXME: Obsolete it?
AC_DEFUN(AC_OUTPUT_COMMANDS,
[AC_DIVERT_PUSH(AC_DIVERSION_CMDS)dnl
[$1]
AC_DIVERT_POP()dnl
AC_DIVERT_PUSH(AC_DIVERSION_ICMDS)dnl
[$2]
AC_DIVERT_POP()])


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


# AC_CONFIG_SUBDIRS(DIR ...)
# --------------------------
# FIXME: `subdirs=' should not be here.
AC_DEFUN(AC_CONFIG_SUBDIRS,
[AC_CONFIG_UNIQUE([$1])dnl
AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
m4_append([AC_LIST_SUBDIRS], [$1])dnl
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
AC_CONFIG_FILES([$1])dnl
AC_OUTPUT_COMMANDS([$2], [$3])dnl
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
changequote(, )dnl
  ac_vpsub='/^[ 	]*VPATH[ 	]*=[^:]*$/d'
changequote([, ])dnl
fi

ifset([AC_LIST_HEADERS], [DEFS=-DHAVE_CONFIG_H], [AC_OUTPUT_MAKE_DEFS()])

dnl Commands to run before creating config.status.
AC_OUTPUT_COMMANDS_PRE()dnl

: ${CONFIG_STATUS=./config.status}
trap 'rm -f $CONFIG_STATUS conftest*; exit 1' 1 2 15
AC_OUTPUT_CONFIG_STATUS()dnl
rm -fr confdefs* $ac_clean_files
trap 'exit 1' 1 2 15

dnl Commands to run after config.status was created
AC_OUTPUT_COMMANDS_POST()dnl

test "$no_create" = yes || $SHELL $CONFIG_STATUS || exit 1
dnl config.status should not do recursion.
ifset([AC_LIST_SUBDIRS], [AC_OUTPUT_SUBDIRS(AC_LIST_SUBDIRS)])dnl
])dnl AC_OUTPUT


# AC_OUTPUT_CONFIG_STATUS
# -----------------------
# Produce config.status.  Called by AC_OUTPUT.
# Pay special attention not to have too long here docs: some old
# shells die.  Unfortunately the limit is not known precisely...
define(AC_OUTPUT_CONFIG_STATUS,
[echo creating $CONFIG_STATUS
cat >$CONFIG_STATUS <<EOF
#! /bin/sh
# Generated automatically by configure.
# Run this file to recreate the current configuration.
# This directory was configured as follows,
dnl hostname on some systems (SVR3.2, Linux) returns a bogus exit status,
dnl so uname gets run too.
# on host `(hostname || uname -n) 2>/dev/null | sed 1q`:
#
@PND@ [$]0 [$]ac_configure_args
#
# Compiler output produced by configure, useful for debugging
# configure, is in ./config.log if it exists.

# Files that config.status was made for.
ifset([AC_LIST_FILES], [config_files="\\
m4_wrap(AC_LIST_FILES, [  ])"
])dnl
ifset([AC_LIST_HEADERS], [config_headers="\\
m4_wrap(AC_LIST_HEADERS, [  ])"
])dnl
ifset([AC_LIST_LINKS], [config_links="\\
m4_wrap(AC_LIST_LINKS, [  ])"
])dnl
ifset([AC_LIST_COMMANDS], [config_commands="\\
m4_wrap(AC_LIST_COMMANDS, [  ])"
])dnl

ac_cs_usage="\\
\\\`$CONFIG_STATUS' instantiates files from templates according to the
current configuration.

Usage: $CONFIG_STATUS @BKL@OPTIONS@BKR@ FILE...

  --recheck    Update $CONFIG_STATUS by reconfiguring in the same conditions
  --version    Print the version of Autoconf and exit
  --help       Display this help and exit
ifset([AC_LIST_FILES],
[  --file=FILE@BKL@:TEMPLATE@BKR@
               Instantiate the configuration file FILE
])dnl
ifset([AC_LIST_HEADERS],
[  --header=FILE@BKL@:TEMPLATE@BKR@
               Instantiate the configuration header FILE
])dnl

ifset([AC_LIST_FILES],
[Configuration files:
\$config_files

])dnl
ifset([AC_LIST_HEADERS],
[Configuration headers:
\$config_headers

])dnl
ifset([AC_LIST_LINKS],
[Links to install:
\$config_links

])dnl
ifset([AC_LIST_COMMANDS],
[Individual commands to run:
\$config_commands

])dnl
Report bugs to <bug-autoconf@gnu.org>."

ac_cs_version="\\
$CONFIG_STATUS generated by autoconf version AC_ACVERSION.
Configured on host `(hostname || uname -n) 2>/dev/null | sed 1q` by running
  [$]0 [$]ac_configure_args"

dnl We use a different name than CONFTEST just to help the maintainers
dnl to make the difference between `conftest' which is the root of the
dnl files used by configure, and `ac_cs_root' which is the root of the
dnl files of config.status.
# Root of the tmp file names.  Use pid to allow concurrent executions.
ac_cs_root=cs\$\$
ac_given_srcdir=$srcdir
ifdef([AC_PROVIDE_AC_PROG_INSTALL], [ac_given_INSTALL="$INSTALL"
])dnl

# If no file are specified by the user, then we need to provide default
# value.  By we need to know if files were specified by the user.
ac_need_defaults=:
while test [\$]@PND@ != 0
do
  case "[\$]1" in
  --*=*)
    ac_option=\`echo "[\$]1" | sed -e 's/=.*//'\`
    ac_optarg=\`echo "[\$]1" | sed -e 's/@BKL@^=@BKR@*=//'\`
    shift
    set dummy "[\$]ac_option" "[\$]ac_optarg" [\$]{1+"[\$]@"}
    shift
    ;;
  -*);;
  *) # This is not an option, so the user has probably given explicit
     # arguments.
     ac_need_defaults=false;;
  esac

  case "[\$]1" in

  # Handling of the options.
  -recheck | --recheck | --rechec | --reche | --rech | --rec | --re | --r)
dnl FIXME: This line is suspicious, it contains "" inside a "`...`".
    echo "running [\$]{CONFIG_SHELL-/bin/sh} [$]0 `echo "[$]ac_configure_args" | sed 's/[[\\"\`\$]]/\\\\&/g'` --no-create --no-recursion"
    exec [\$]{CONFIG_SHELL-/bin/sh} [$]0 [$]ac_configure_args --no-create --no-recursion ;;
  -version | --version | --versio | --versi | --vers | --ver | --ve | --v)
    echo "[\$]ac_cs_version"; exit 0 ;;
  --he | --h)
    # Conflict between --help and --header
    echo "$CONFIG_STATUS: ambiguous option: [\$]ac_option"; exit 1 ;;
  -help | --help | --hel )
    echo "[\$]ac_cs_usage"; exit 0 ;;
  --file | --fil | --fi | --f )
    shift
    CONFIG_FILES="[\$]CONFIG_FILES [\$]1"
    ac_need_defaults=false;;
  --header | --heade | --head | --hea )
    shift
    CONFIG_HEADERS="[\$]CONFIG_FILES [\$]1"
    ac_need_defaults=false;;

  # Handling of arguments.
AC_FOREACH([AC_File], AC_LIST_FILES,
[  'patsubst(AC_File, [:.*])' )dnl
 CONFIG_FILES="[\$]CONFIG_FILES AC_File" ;;
])dnl
AC_FOREACH([AC_File], AC_LIST_LINKS,
[  'patsubst(AC_File, [:.*])' )dnl
 CONFIG_LINKS="[\$]CONFIG_LINKS AC_File" ;;
])dnl
AC_FOREACH([AC_File], AC_LIST_COMMANDS,
[  'patsubst(AC_File, [:.*])' )dnl
 CONFIG_COMMANDS="[\$]CONFIG_COMMANDS AC_File" ;;
])dnl
AC_FOREACH([AC_File], AC_LIST_HEADERS,
[  'patsubst(AC_File, [:.*])' )dnl
 CONFIG_HEADERS="[\$]CONFIG_HEADERS AC_File" ;;
])dnl

  # This is an error.
  -*) echo "$CONFIG_STATUS: invalid option: [\$]1"; exit 1 ;;
  *) echo "$CONFIG_STATUS: invalid argument: [\$]1"; exit 1 ;;
  esac
  shift
done

EOF

dnl Issue this section only if there were actually config files.
dnl This checks if one of AC_LIST_HEADERS, AC_LIST_FILES, AC_LIST_COMMANDS,
dnl or AC_LIST_LINKS is set.
ifval(AC_LIST_HEADERS()AC_LIST_LINKS()AC_LIST_FILES()AC_LIST_COMMANDS(),
[cat >>$CONFIG_STATUS <<EOF
# If the user did not use the arguments to specify the items to instantiate,
# then the envvar interface is used.  Set only those that are not.
if [\$]ac_need_defaults; then
ifset([AC_LIST_FILES], [  : \${CONFIG_FILES="\$config_files"}
])dnl
ifset([AC_LIST_HEADERS], [  : \${CONFIG_HEADERS="\$config_headers"}
])dnl
ifset([AC_LIST_LINKS], [  : \${CONFIG_LINKS="\$config_links"}
])dnl
ifset([AC_LIST_COMMANDS], [  : \${CONFIG_COMMANDS="\$config_commands"}
])dnl
fi

# Remove all the CONFIG_FILES, and trap to remove the temp files.
dnl There is no need to trap for the config files since they are built
dnl from `mv tmp-file config-file', hence their update is atomic.
rm -fr \`echo "\$CONFIG_FILES" | sed "s/:@BKL@^ @BKR@*//g"\`
trap 'rm -fr \$ac_cs_root*; exit 1' 1 2 15

EOF
])[]dnl ifval

dnl The following three sections are in charge of their own here
dnl documenting into $CONFIG_STATUS.

dnl Because AC_OUTPUT_FILES is in charge of undiverting the AC_SUBST
dnl section, it is better to divert it to void and *call it*, rather
dnl than not calling it at all
ifset([AC_LIST_FILES],
      [AC_OUTPUT_FILES()],
      [AC_DIVERT_PUSH(AC_DIVERSION_KILL)dnl
       AC_OUTPUT_FILES()dnl
       AC_DIVERT_POP()])dnl
ifset([AC_LIST_HEADERS],
      [AC_OUTPUT_HEADERS()])dnl
ifset([AC_LIST_LINKS],
      [AC_OUTPUT_LINKS()])dnl
ifset([AC_LIST_COMMANDS],
      [AC_OUTPUT_COMMANDS_COMMANDS()])dnl

cat >>$CONFIG_STATUS <<EOF

#
# CONFIG_COMMANDS section.
#

undivert(AC_DIVERSION_ICMDS)dnl
EOF
cat >>$CONFIG_STATUS <<\EOF
undivert(AC_DIVERSION_CMDS)dnl
exit 0
EOF
chmod +x $CONFIG_STATUS
])dnl AC_OUTPUT_CONFIG_STATUS


# AC_OUTPUT_MAKE_DEFS
# -------------------
# Set the DEFS variable to the -D options determined earlier.
# This is a subroutine of AC_OUTPUT.
# It is called inside configure, outside of config.status.
# FIXME: This has to be fixed the same way as in AC_OUTPUT_HEADERS.
define(AC_OUTPUT_MAKE_DEFS,
[# Transform confdefs.h into DEFS.
dnl Using a here document instead of a string reduces the quoting nightmare.
# Protect against shell expansion while executing Makefile rules.
# Protect against Makefile macro expansion.
#
# If the first sed substitution is executed (which looks for macros that
# take arguments), then we branch to the cleanup section.  Otherwise,
# look for a macro that doesn't take arguments.
cat >$ac_cs_root.defs <<\EOF
changequote(<<, >>)dnl
s%^[ 	]*<<#>>[ 	]*define[ 	][ 	]*\([^ 	(][^ 	(]*([^)]*)\)[ 	]*\(.*\)%-D\1=\2%g
t cleanup
s%^[ 	]*<<#>>[ 	]*define[ 	][ 	]*\([^ 	][^ 	]*\)[ 	]*\(.*\)%-D\1=\2%g
: cleanup
s%[ 	`~<<#>>$^&*(){}\\|;'"<>?]%\\&%g
s%\[%\\&%g
s%\]%\\&%g
s%\$%$$%g
changequote([, ])dnl
EOF
# We use echo to avoid assuming a particular line-breaking character.
# The extra dot is to prevent the shell from consuming trailing
# line-breaks from the sub-command output.  A line-break within
# single-quotes doesn't work because, if this script is created in a
# platform that uses two characters for line-breaks (e.g., DOS), tr
# would break.
ac_LF_and_DOT=`echo; echo .`
DEFS=`sed -f $ac_cs_root.defs confdefs.h | tr "$ac_LF_and_DOT" ' .'`
rm -f $ac_cs_root.defs
])


# AC_OUTPUT_FILES
# ---------------
# Do the variable substitutions to create the Makefiles or whatever.
# This is a subroutine of AC_OUTPUT.
#
# It has to send itself into $CONFIG_STATUS (eg, via here documents).
# Upon exit, no here document shall be opened.
define(AC_OUTPUT_FILES,
[cat >>$CONFIG_STATUS <<EOF

#
# CONFIG_FILES section.
#

# Protect against being on the right side of a sed subst in config.status.
dnl Please, pay attention that this sed code depends a lot on the shape
dnl of the sed commands issued by AC_SUBST.  So if you change one, change
dnl the other too.
changequote(, )dnl
sed 's/%@/@@/; s/@%/@@/; s/%;t t\$/@;t t/; /@;t t\$/s/[\\\\&%]/\\\\&/g;
 s/@@/%@/; s/@@/@%/; s/@;t t\$/%;t t/' >\$ac_cs_root.subs <<\\CEOF
changequote([, ])dnl
dnl These here document variables are unquoted when configure runs
dnl but quoted when config.status runs, so variables are expanded once.
dnl Insert the sed substitutions of variables.
undivert(AC_DIVERSION_SED)dnl
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
ac_sed_cmds=""
while $ac_more_lines; do
  if test $ac_beg -gt 1; then
    sed "1,${ac_beg}d; ${ac_end}q" $ac_cs_root.subs >$ac_cs_root.sfrag
  else
    sed "${ac_end}q" $ac_cs_root.subs >$ac_cs_root.sfrag
  fi
  if test ! -s $ac_cs_root.sfrag; then
    ac_more_lines=false
    rm -f $ac_cs_root.sfrag
  else
    # The purpose of the label and of the branching condition is to
    # speed up the sed processing (if there are no `@' at all, there
    # is no need to browse any of the substitutions).
    # These are the two extra sed commands mentioned above.
    (echo ':t
/@@BKL@a-zA-Z_@BKR@@BKL@a-zA-Z_0-9@BKR@*@/!b' && cat $ac_cs_root.sfrag) >$ac_cs_root.s$ac_sed_frag
    if test -z "$ac_sed_cmds"; then
      ac_sed_cmds="sed -f $ac_cs_root.s$ac_sed_frag"
    else
      ac_sed_cmds="$ac_sed_cmds | sed -f $ac_cs_root.s$ac_sed_frag"
    fi
    ac_sed_frag=`expr $ac_sed_frag + 1`
    ac_beg=$ac_end
    ac_end=`expr $ac_end + $ac_max_sed_lines`
  fi
done
if test -z "$ac_sed_cmds"; then
  ac_sed_cmds=cat
fi

EOF

cat >>$CONFIG_STATUS <<\EOF
for ac_file in .. $CONFIG_FILES; do if test "x$ac_file" != x..; then
changequote(, )dnl
  # Support "outfile[:infile[:infile...]]", defaulting infile="outfile.in".
  case "$ac_file" in
  *:*) ac_file_in=`echo "$ac_file"|sed 's%[^:]*:%%'`
       ac_file=`echo "$ac_file"|sed 's%:.*%%'` ;;
  *) ac_file_in="${ac_file}.in" ;;
  esac

  # Adjust a relative srcdir, top_srcdir, and INSTALL for subdirectories.

  # Remove last slash and all that follows it.  Not all systems have dirname.
  ac_dir=`echo $ac_file|sed 's%/[^/][^/]*$%%'`
changequote([, ])dnl
  if test "$ac_dir" != "$ac_file" && test "$ac_dir" != .; then
    # The file is in a subdirectory.
dnl FIXME: should actually be mkinstalldirs (parents may have
dnl to be created too.
    test ! -d "$ac_dir" && mkdir "$ac_dir"
    ac_dir_suffix="/`echo $ac_dir|sed 's%^\./%%'`"
    # A "../" for each directory in $ac_dir_suffix.
changequote(, )dnl
    ac_dots=`echo $ac_dir_suffix|sed 's%/[^/]*%../%g'`
changequote([, ])dnl
  else
    ac_dir_suffix= ac_dots=
  fi

  case "$ac_given_srcdir" in
  .)  srcdir=.
      if test -z "$ac_dots"; then top_srcdir=.
      else top_srcdir=`echo $ac_dots|sed 's%/$%%'`; fi ;;
  /*) srcdir="$ac_given_srcdir$ac_dir_suffix"; top_srcdir="$ac_given_srcdir" ;;
  *) # Relative path.
    srcdir="$ac_dots$ac_given_srcdir$ac_dir_suffix"
    top_srcdir="$ac_dots$ac_given_srcdir" ;;
  esac

ifdef([AC_PROVIDE_AC_PROG_INSTALL],
[  case "$ac_given_INSTALL" in
changequote(, )dnl
  [/$]*) INSTALL="$ac_given_INSTALL" ;;
changequote([, ])dnl
  *) INSTALL="$ac_dots$ac_given_INSTALL" ;;
  esac
])dnl

  echo creating "$ac_file"
  rm -f "$ac_file"
  configure_input="Generated automatically from `echo $ac_file_in|sed 's%.*/%%'` by configure."
  case "$ac_file" in
changequote(, )dnl
  *[Mm]akefile*) ac_comsub="1i\\
changequote([, ])dnl
# $configure_input" ;;
  *) ac_comsub= ;;
  esac

# Don't redirect the output to AC_FILE directly: use `mv' so that updating
# is atomic, and doesn't need trapping.
  ac_file_inputs=`echo $ac_file_in | sed -e "s%^%$ac_given_srcdir/%" -e "s%:% $ac_given_srcdir/%g"`
  for ac_file_input in $ac_file_inputs;
  do
    test -f "$ac_file_input" ||
        AC_MSG_ERROR(cannot find input file `$ac_file_input')
  done
EOF
cat >>$CONFIG_STATUS <<EOF
  sed -e "$ac_comsub
dnl Neutralize VPATH when `$srcdir' = `.'.
$ac_vpsub
dnl Shell code in configure.in might set extrasub.
dnl FIXME: do we really want to maintain this feature?
$extrasub
EOF
cat >>$CONFIG_STATUS <<\EOF
:t
/@@BKL@a-zA-Z_@BKR@@BKL@a-zA-Z_0-9@BKR@*@/!b
s%@configure_input@%$configure_input%;t t
s%@srcdir@%$srcdir%;t t
s%@top_srcdir@%$top_srcdir%;t t
ifdef([AC_PROVIDE_AC_PROG_INSTALL], [s%@INSTALL@%$INSTALL%;t t
])dnl
dnl The parens around the eval prevent an "illegal io" in Ultrix sh.
" $ac_file_inputs | (eval "$ac_sed_cmds") >$ac_cs_root.out
dnl This would break Makefile dependencies.
dnl  if cmp -s $ac_file $ac_cs_root.out 2>/dev/null; then
dnl    echo "$ac_file is unchanged"
dnl    rm -f $ac_cs_root.out
dnl   else
dnl     rm -f $ac_file
dnl    mv $ac_cs_root.out $ac_file
dnl  fi
  mv $ac_cs_root.out $ac_file

ifset([AC_LIST_FILES_COMMANDS],
[  # Run the commands associated with the file.
  case "$ac_file" in
AC_LIST_FILES_COMMANDS()dnl
  esac
])dnl
fi; done
rm -f $ac_cs_root.s*
EOF
])dnl AC_OUTPUT_FILES


# AC_OUTPUT_HEADERS
# -----------------
# Create the config.h files from the config.h.in files.
# This is a subroutine of AC_OUTPUT.
#
# It has to send itself into $CONFIG_STATUS (eg, via here documents).
# Upon exit, no here document shall be opened.
define(AC_OUTPUT_HEADERS,
[cat >>$CONFIG_STATUS <<\EOF
changequote(<<, >>)dnl

#
# CONFIG_HEADER section.
#

# These sed commands are passed to sed as "A NAME B NAME C VALUE D", where
# NAME is the cpp macro being defined and VALUE is the value it is being given.
#
# ac_d sets the value in "#define NAME VALUE" lines.
ac_dA='s%^\([ 	]*\)#\([ 	]*define[ 	][ 	]*\)'
ac_dB='\([ 	][ 	]*\)[^ 	]*%\1#\2'
ac_dC='\3'
ac_dD='%;t t'
# ac_u turns "#undef NAME" without trailing blanks into "#define NAME VALUE".
ac_uA='s%^\([ 	]*\)#\([ 	]*\)undef\([ 	][ 	]*\)'
ac_uB='<<$>>%\1#\2define\3'
ac_uC=' '
ac_uD='%;t t'
changequote([, ])dnl

for ac_file in .. $CONFIG_HEADERS; do if test "x$ac_file" != x..; then
changequote(, )dnl
  # Support "outfile[:infile[:infile...]]", defaulting infile="outfile.in".
  case "$ac_file" in
  *:*) ac_file_in=`echo "$ac_file"|sed 's%[^:]*:%%'`
       ac_file=`echo "$ac_file"|sed 's%:.*%%'` ;;
  *) ac_file_in="${ac_file}.in" ;;
  esac
changequote([, ])dnl

  echo creating $ac_file

  rm -f $ac_cs_root.frag $ac_cs_root.in $ac_cs_root.out
  ac_file_inputs=`echo $ac_file_in|sed -e "s%^%$ac_given_srcdir/%" -e "s%:% $ac_given_srcdir/%g"`
    for ac_file_input in $ac_file_inputs;
  do
    test -f "$ac_file_input" ||
        AC_MSG_ERROR(cannot find input file `$ac_file_input')
  done
  # Remove the trailing spaces.
  sed -e 's/@BKL@ 	@BKR@*$//' $ac_file_inputs >$ac_cs_root.in

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
cat >$ac_cs_root.hdr <<\EOF
changequote(<<, >>)dnl
s/[\\&%]/\\&/g
s%[\\$`]%\\&%g
t clear
: clear
s%^[ 	]*<<#>>[ 	]*define[ 	][ 	]*\(\([^ 	(][^ 	(]*\)([^)]*)\)[ 	]*\(.*\)$%${ac_dA}\2${ac_dB}\1${ac_dC}\3${ac_dD}%gp
t cleanup
s%^[ 	]*<<#>>[ 	]*define[ 	][ 	]*\([^ 	][^ 	]*\)[ 	]*\(.*\)$%${ac_dA}\1${ac_dB}\1${ac_dC}\2${ac_dD}%gp
: cleanup
changequote([, ])dnl
EOF
# If some macros were called several times there might be several times
# the same #defines, which is useless.  Nevertheless, we may not want to
# sort them, since we want the *last* AC_DEFINE to be honored.
uniq confdefs.h | sed -n -f $ac_cs_root.hdr >conftest.defines
sed -e 's/ac_d/ac_u/g' conftest.defines >conftest.undefs
rm -f $ac_cs_root.hdr

# This sed command replaces #undef with comments.  This is necessary, for
# example, in the case of _POSIX_SOURCE, which is predefined and required
# on some systems where configure will not decide to define it.
cat >>conftest.undefs <<\EOF
changequote(, )dnl
s%^[ 	]*#[ 	]*undef[ 	][ 	]*[a-zA-Z_][a-zA-Z_0-9]*%/* & */%
changequote([, ])dnl
EOF

# Break up conftest.defines because some shells have a limit on the size
# of here documents, and old seds have small limits too (100 cmds).
echo '  # Handle all the #define templates only if necessary.' >>$CONFIG_STATUS
echo '  if egrep "^@BKL@ 	@BKR@*#@BKL@ 	@BKR@*define" $ac_cs_root.in >/dev/null; then' >>$CONFIG_STATUS
echo '  # If there are no defines, we may have an empty if/fi' >>$CONFIG_STATUS
echo '  :' >>$CONFIG_STATUS
rm -f conftest.tail
while :
do
  ac_lines=`grep -c . conftest.defines`
  # grep -c gives empty output for an empty file on some AIX systems.
  if test -z "$ac_lines" || test "$ac_lines" -eq 0; then break; fi
  # Write a limited-size here document to $ac_cs_root.frag.
  echo '  cat >$ac_cs_root.frag <<CEOF' >>$CONFIG_STATUS
dnl Speed up: don't consider the non `#define' lines.
  echo ': t' >>$CONFIG_STATUS
  echo '/^@BKL@ 	@BKR@*#@BKL@ 	@BKR@*define/!b' >>$CONFIG_STATUS
  sed ${ac_max_here_lines}q conftest.defines >>$CONFIG_STATUS
  echo 'CEOF
  sed -f $ac_cs_root.frag $ac_cs_root.in >$ac_cs_root.out
  rm -f $ac_cs_root.in
  mv $ac_cs_root.out $ac_cs_root.in
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
while :
do
  ac_lines=`grep -c . conftest.undefs`
  # grep -c gives empty output for an empty file on some AIX systems.
  if test -z "$ac_lines" || test "$ac_lines" -eq 0; then break; fi
  # Write a limited-size here document to $ac_cs_root.frag.
  echo '  cat >$ac_cs_root.frag <<CEOF' >>$CONFIG_STATUS
dnl Speed up: don't consider the non `#undef'
  echo ': t' >>$CONFIG_STATUS
  echo '/^@BKL@ 	@BKR@*#@BKL@ 	@BKR@*undef/!b' >>$CONFIG_STATUS
  sed ${ac_max_here_lines}q conftest.undefs >>$CONFIG_STATUS
  echo 'CEOF
  sed -f $ac_cs_root.frag $ac_cs_root.in >$ac_cs_root.out
  rm -f $ac_cs_root.in
  mv $ac_cs_root.out $ac_cs_root.in
' >>$CONFIG_STATUS
  sed 1,${ac_max_here_lines}d conftest.undefs >conftest.tail
  rm -f conftest.undefs
  mv conftest.tail conftest.undefs
done
rm -f conftest.undefs

dnl Now back to your regularly scheduled config.status.
cat >>$CONFIG_STATUS <<\EOF
  rm -f $ac_cs_root.frag $ac_cs_root.h
  echo "/* $ac_file.  Generated automatically by configure.  */" >$ac_cs_root.h
  cat $ac_cs_root.in >>$ac_cs_root.h
  rm -f $ac_cs_root.in
  if cmp -s $ac_file $ac_cs_root.h 2>/dev/null; then
    echo "$ac_file is unchanged"
    rm -f $ac_cs_root.h
  else
    # Remove last slash and all that follows it.  Not all systems have dirname.
  changequote(, )dnl
    ac_dir=`echo $ac_file|sed 's%/[^/][^/]*$%%'`
  changequote([, ])dnl
    if test "$ac_dir" != "$ac_file" && test "$ac_dir" != .; then
      # The file is in a subdirectory.
dnl FIXME: should actually be mkinstalldirs (parents may have
dnl to be created too.
      test ! -d "$ac_dir" && mkdir "$ac_dir"
    fi
    rm -f $ac_file
    mv $ac_cs_root.h $ac_file
  fi
ifset([AC_LIST_HEADERS_COMMANDS],
[  # Run the commands associated with the file.
  case "$ac_file" in
AC_LIST_HEADERS_COMMANDS()dnl
  esac
])dnl
fi; done
EOF
])dnl AC_OUTPUT_HEADERS


# AC_OUTPUT_LINKS
# ---------------
# This is a subroutine of AC_OUTPUT.
#
# It has to send itself into $CONFIG_STATUS (eg, via here documents).
# Upon exit, no here document shall be opened.
define(AC_OUTPUT_LINKS,
[cat >>$CONFIG_STATUS <<\EOF

#
# CONFIG_LINKS section.
#
srcdir=$ac_given_srcdir

dnl Here we use : instead of .. because if AC_LINK_FILES was used
dnl with empty parameters (as in gettext.m4), then we obtain here
dnl `:', which we want to skip.  So let's keep a single exception: `:'.
for ac_file in : $CONFIG_LINKS; do if test "x$ac_file" != x:; then
  ac_dest=`echo "$ac_file"|sed 's%:.*%%'`
  ac_source=`echo "$ac_file"|sed 's%@BKL@^:@BKR@*:%%'`

  echo "linking $srcdir/$ac_source to $ac_dest"

  if test ! -r $srcdir/$ac_source; then
    AC_MSG_ERROR($srcdir/$ac_source: File not found)
  fi
  rm -f $ac_dest

  # Make relative symlinks.
  # Remove last slash and all that follows it.  Not all systems have dirname.
changequote(, )dnl
  ac_dest_dir=`echo $ac_dest|sed 's%/[^/][^/]*$%%'`
changequote([, ])dnl
  if test "$ac_dest_dir" != "$ac_dest" && test "$ac_dest_dir" != .; then
    # The dest file is in a subdirectory.
dnl FIXME: should actually be mkinstalldirs (parents may have
dnl to be created too.
    test ! -d "$ac_dest_dir" && mkdir "$ac_dest_dir"
    ac_dest_dir_suffix="/`echo $ac_dest_dir|sed 's%^\./%%'`"
    # A "../" for each directory in $ac_dest_dir_suffix.
changequote(, )dnl
    ac_dots=`echo $ac_dest_dir_suffix|sed 's%/[^/]*%../%g'`
changequote([, ])dnl
  else
    ac_dest_dir_suffix= ac_dots=
  fi

  case "$srcdir" in
changequote(, )dnl
  [/$]*) ac_rel_source="$srcdir/$ac_source" ;;
changequote([, ])dnl
      *) ac_rel_source="$ac_dots$srcdir/$ac_source" ;;
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
fi; done
EOF
])dnl AC_OUTPUT_LINKS


# AC_OUTPUT_COMMANDS_COMMANDS
# ---------------------------
# This is a subroutine of AC_OUTPUT, in charge of issuing the code
# related to AC_CONFIG_COMMANDS.  The weird name is due to the fact
# that AC_OUTPUT_COMMANDS is already used.  This should be fixed.
#
# It has to send itself into $CONFIG_STATUS (eg, via here documents).
# Upon exit, no here document shall be opened.
define(AC_OUTPUT_COMMANDS_COMMANDS,
[cat >>$CONFIG_STATUS <<\EOF

#
# CONFIG_COMMANDS section.
#
for ac_file in .. $CONFIG_COMMANDS; do if test "x$ac_file" != x..; then
  ac_dest=`echo "$ac_file"|sed 's%:.*%%'`
  ac_source=`echo "$ac_file"|sed 's%@BKL@^:@BKR@*:%%'`

  echo "executing commands of $ac_dest"
  case "$ac_dest" in
AC_LIST_COMMANDS_COMMANDS()dnl
  esac
fi;done
EOF
])dnl AC_OUTPUT_COMMANDS_COMMANDS


# AC_OUTPUT_SUBDIRS(DIRECTORY...)
# -------------------------------
# This is a subroutine of AC_OUTPUT, but it does not go into
# config.status, rather, it is called after running config.status.
define(AC_OUTPUT_SUBDIRS,
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
    | --cache-f=* | --cache-=* | --cache=* | --cach=* | --cac=* | --ca=* | --c=*)
      ;;
    -srcdir | --srcdir | --srcdi | --srcd | --src | --sr)
      ac_prev=srcdir ;;
    -srcdir=* | --srcdir=* | --srcdi=* | --srcd=* | --src=* | --sr=*)
      ;;
    *) ac_sub_configure_args="$ac_sub_configure_args $ac_arg" ;;
    esac
  done

ifdef([AC_PROVIDE_AC_PROG_INSTALL],[  ac_given_INSTALL="$INSTALL"
])dnl

  for ac_config_dir in $1; do

    # Do not complain, so a configure script can configure whichever
    # parts of a large source tree are present.
    if test ! -d $srcdir/$ac_config_dir; then
      continue
    fi

    echo configuring in $ac_config_dir

    case "$srcdir" in
    .) ;;
    *)
dnl FIXME: should actually be mkinstalldirs (parents may have
dnl to be created too.
      if test -d ./$ac_config_dir || mkdir ./$ac_config_dir; then :;
      else
        AC_MSG_ERROR(cannot create `pwd`/$ac_config_dir)
      fi
      ;;
    esac

    ac_popdir=`pwd`
    cd $ac_config_dir

changequote(, )dnl
      # A "../" for each directory in /$ac_config_dir.
      ac_dots=`echo $ac_config_dir|sed -e 's%^\./%%' -e 's%[^/]$%&/%' -e 's%[^/]*/%../%g'`
changequote([, ])dnl

    case "$srcdir" in
    .) # No --srcdir option.  We are building in place.
      ac_sub_srcdir=$srcdir ;;
    /*) # Absolute path.
      ac_sub_srcdir=$srcdir/$ac_config_dir ;;
    *) # Relative path.
      ac_sub_srcdir=$ac_dots$srcdir/$ac_config_dir ;;
    esac

    # Check for guested configure; otherwise get Cygnus style configure.
    if test -f $ac_sub_srcdir/configure; then
      ac_sub_configure="$SHELL $ac_sub_srcdir/configure"
    elif test -f $ac_sub_srcdir/configure.in; then
      ac_sub_configure=$ac_configure
    else
      AC_MSG_WARN(no configuration information is in $ac_config_dir)
      ac_sub_configure=
    fi

    # The recursion is here.
    if test -n "$ac_sub_configure"; then

      # Make the cache file name correct relative to the subdirectory.
      case "$cache_file" in
      /*) ac_sub_cache_file=$cache_file ;;
      *) # Relative path.
        ac_sub_cache_file="$ac_dots$cache_file" ;;
      esac
ifdef([AC_PROVIDE_AC_PROG_INSTALL],
      [  case "$ac_given_INSTALL" in
changequote(, )dnl
        [/$]*) INSTALL="$ac_given_INSTALL" ;;
changequote([, ])dnl
        *) INSTALL="$ac_dots$ac_given_INSTALL" ;;
        esac
])dnl

      echo "[running $ac_sub_configure $ac_sub_configure_args --cache-file=$ac_sub_cache_file] --srcdir=$ac_sub_srcdir"
      # The eval makes quoting arguments work.
      if eval $ac_sub_configure $ac_sub_configure_args --cache-file=$ac_sub_cache_file --srcdir=$ac_sub_srcdir
      then :
      else
        AC_MSG_ERROR($ac_sub_configure failed for $ac_config_dir)
      fi
    fi

    cd $ac_popdir
  done
fi
])dnl AC_OUTPUT_SUBDIRS


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
              [CPLUSPLUS], [test x"$GXX" = xyes && using_gnu_compiler=yes],
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

  AC_SHELL_IFELSE([test x"ac_$exists" = xtrue], [$3], [$4])
])
