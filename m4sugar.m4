divert(-1)#                                                  -*- Autoconf -*-
# This file is part of Autoconf.
# Base m4 layer.
# Requires GNU m4.
# Copyright 1999, 2000 Free Software Foundation, Inc.
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
# Written by Akim Demaille.
#

# Set the quotes, whatever the current quoting system.
changequote()
changequote([, ])

# Some old m4's don't support m4exit.  But they provide
# equivalent functionality by core dumping because of the
# long macros we define.
ifdef([__gnu__], ,
[errprint(Autoconf requires GNU m4. Install it before installing Autoconf or
set the M4 environment variable to its path name.)
m4exit(2)])


## ------------------------------- ##
## 1. Simulate --prefix-builtins.  ##
## ------------------------------- ##

# m4_define
# m4_defn
# m4_undefine
define([m4_define],   defn([define]))
define([m4_defn],     defn([defn]))
define([m4_undefine], defn([undefine]))

m4_undefine([define])
m4_undefine([defn])
m4_undefine([undefine])


# m4_copy(SRC, DST)
# -----------------
# Define DST as the definition of SRC.
m4_define([m4_copy],
[m4_define([$2], m4_defn([$1]))])


# m4_rename(SRC, DST)
# -------------------
# Rename the macro SRC as DST.
m4_define([m4_rename],
[m4_copy([$1], [$2])m4_undefine([$1])])


# m4_rename_m4(MACRO-NAME)
# ------------------------
# Rename MACRO-NAME as m4_MACRO-NAME.
m4_define([m4_rename_m4],
[m4_rename([$1], [m4_$1])])


# m4_copy_unm4(m4_MACRO-NAME)
# ---------------------------
# Copy m4_MACRO-NAME as MACRO-NAME.
m4_define([m4_copy_unm4],
[m4_copy([$1], m4_patsubst([[$1]], [[m4_]]))])


# Some m4 internals have names colliding with tokens we might use.
# Rename them a` la `m4 --prefix-builtins'.
m4_rename_m4([builtin])
m4_rename_m4([changecom])
m4_rename_m4([changequote])
m4_rename_m4([debugfile])
m4_rename_m4([debugmode])
m4_rename_m4([decr])
m4_rename_m4([dumpdef])
m4_rename_m4([eval])
m4_rename_m4([format])
m4_rename_m4([incr])
m4_rename_m4([index])
m4_rename_m4([indir])
m4_rename_m4([len])
m4_rename([m4exit], [m4_exit])
m4_rename([m4wrap], [m4_wrap])
m4_rename_m4([maketemp])
m4_rename_m4([patsubst])
m4_rename_m4([popdef])
m4_rename_m4([pushdef])
m4_rename_m4([regexp])
m4_rename_m4([shift])
m4_rename_m4([substr])
m4_rename_m4([symbols])
m4_rename_m4([syscmd])
m4_rename_m4([sysval])
m4_rename_m4([traceoff])
m4_rename_m4([traceon])
m4_rename_m4([translit])


## ------------------- ##
## 2. Error messages.  ##
## ------------------- ##


# m4_location
# -----------
m4_define([m4_location], [__file__:__line__])


# m4_errprint(MSG)
# ----------------
# Same as `errprint', but with the missing end of line.
m4_define([m4_errprint], [errprint([$1
])])


# m4_warning(MSG)
# ---------------
# Warn the user.
m4_define([m4_warning],
[m4_errprint(m4_location[: warning: $1])])


# m4_fatal(MSG, [EXIT-STATUS])
# ----------------------------
# Fatal the user.                                                      :)
m4_define([m4_fatal],
[m4_errprint(m4_location[: error: $1])dnl
m4_expansion_stack_dump()dnl
m4_exit(ifelse([$2],, 1, [$2]))])


# m4_assert( EXPRESSION [, EXIT-STATUS = 1 ])
# -------------------------------------------
# This macro ensures that EXPRESSION evaluates to true, and exits if
# EXPRESSION evaluates to false.
m4_define([m4_assert],
[ifelse(m4_eval([$1]), 0,
        [m4_fatal([assert failed: $1], [$2])],
        [])])


## ------------- ##
## 3. Warnings.  ##
## ------------- ##


# m4_warning_ifelse(CATEGORY, IF-TRUE, IF-FALSE)
# ----------------------------------------------
# If the CATEGORY of warnings is enabled, expand IF_TRUE otherwise
# IF-FALSE.
#
# The variable `m4_warnings' contains a comma separated list of
# warnings which order is the converse from the one specified by
# the user, i.e., if she specified `-W error,none,obsolete',
# `m4_warnings' is `obsolete,none,error'.  We read it from left to
# right, and:
# - if none or noCATEGORY is met, run IF-FALSE
# - if all or CATEGORY is met, run IF-TRUE
# - if there is nothing left, run IF-FALSE.
m4_define([m4_warning_ifelse],
[_m4_warning_ifelse([$1], [$2], [$3], m4_warnings)])


# _m4_warning_ifelse(CATEGORY, IF-TRUE, IF-FALSE, WARNING1, ...)
# --------------------------------------------------------------
# Implementation of the loop described above.
m4_define([_m4_warning_ifelse],
[ifelse([$4],  [$1],    [$2],
        [$4],  [all],   [$2],
        [$4],  [],      [$3],
        [$4],  [none],  [$3],
        [$4],  [no-$1], [$3],
        [$0([$1], [$2], [$3], m4_shiftn(4, $@))])])


# _m4_warning_error_ifelse(IF-TRUE, IF-FALSE)
# -------------------------------------------
# The same as m4_warning_ifelse, but scan for `error' only.
m4_define([_m4_warning_error_ifelse],
[__m4_warning_error_ifelse([$1], [$2], m4_warnings)])


# __m4_warning_error_ifelse(IF-TRUE, IF-FALSE)
# --------------------------------------------
# The same as _m4_warning_ifelse, but scan for `error' only.
m4_define([__m4_warning_error_ifelse],
[ifelse([$3],  [error],    [$1],
        [$3],  [],         [$2],
        [$3],  [no-error], [$2],
        [$0([$1], [$2], m4_shiftn(3, $@))])])



# _m4_warn(MESSAGE)
# -----------------
# Report MESSAGE as a warning, unless the user requested -W error,
# in which case report a fatal error.
m4_define([_m4_warn],
[_m4_warning_error_ifelse([m4_fatal([$1])],
                          [m4_warning([$1])])])


# m4_warn(CATEGORY, MESSAGE)
# --------------------------
# Report a MESSAGE to the autoconf user if the CATEGORY of warnings
# is requested (in fact, not disabled).
m4_define([m4_warn],
[m4_warning_ifelse([$1], [_m4_warn([$2])])])



## ------------------- ##
## 4. File inclusion.  ##
## ------------------- ##


# We also want to neutralize include (and sinclude for symmetry),
# but we want to extend them slightly: warn when a file is included
# several times.  This is in general a dangerous operation because
# quite nobody quotes the first argument of m4_define.
#
# For instance in the following case:
#   m4_define(foo, [bar])
# then a second reading will turn into
#   m4_define(bar, [bar])
# which is certainly not what was meant.

# m4_include_unique(FILE)
# -----------------------
# Declare that the FILE was loading; and warn if it has already
# been included.
m4_define([m4_include_unique],
[ifdef([m4_include($1)],
       [m4_warn([syntax],
                [file `$1' included several times])])dnl
m4_define([m4_include($1)])])


# m4_include(FILE)
# ----------------
# As the builtin include, but warns against multiple inclusions.
m4_define([m4_include],
[m4_include_unique([$1])dnl
m4_builtin([include], [$1])])


# m4_sinclude(FILE)
# -----------------
# As the builtin sinclude, but warns against multiple inclusions.
m4_define([m4_sinclude],
[m4_include_unique([$1])dnl
m4_builtin([sinclude], [$1])])

# Neutralize include and sinclude.
m4_undefine([include])
m4_undefine([sinclude])



## ------------------------------------ ##
## 5. Additional branching constructs.  ##
## ------------------------------------ ##

# Both `ifval' and `ifset' tests against the empty string.  The
# difference is that `ifset' is specialized on macros.
#
# In case of arguments of macros, eg $[1], it makes little difference.
# In the case of a macro `FOO', you don't want to check `ifval(FOO,
# TRUE)', because if `FOO' expands with commas, there is a shifting of
# the arguments.  So you want to run `ifval([FOO])', but then you just
# compare the *string* `FOO' against `', which, of course fails.
#
# So you want a variation of `ifset' that expects a macro name as $[1].
# If this macro is both defined and defined to a non empty value, then
# it runs TRUE etc.


# ifval(COND, [IF-TRUE], [IF-FALSE])
# ----------------------------------
# If COND is not the empty string, expand IF-TRUE, otherwise IF-FALSE.
# Comparable to ifdef.
m4_define([ifval], [ifelse([$1], [], [$3], [$2])])


# m4_ifvanl(COND, [IF-TRUE], [IF-FALSE])
# --------------------------------------
# Same as `ifval', but add an extra newline to IF-TRUE or IF-FALSE
# unless that argument is empty.
m4_define([m4_ifvanl], [ifelse([$1], [],
[ifelse([$3], [], [], [$3
])],
[ifelse([$2], [], [], [$2
])])])


# ifset(MACRO, [IF-TRUE], [IF-FALSE])
# -----------------------------------
# If MACRO has no definition, or of its definition is the empty string,
# expand IF-FALSE, otherwise IF-TRUE.
m4_define([ifset],
[ifdef([$1],
       [ifelse(m4_defn([$1]), [], [$3], [$2])],
       [$3])])


# ifndef(NAME, [IF-NOT-DEFINED], [IF-DEFINED])
# --------------------------------------------
m4_define([ifndef],
[ifdef([$1], [$3], [$2])])


# m4_case(SWITCH, VAL1, IF-VAL1, VAL2, IF-VAL2, ..., DEFAULT)
# -----------------------------------------------------------
# m4 equivalent of
# switch (SWITCH)
# {
#   case VAL1:
#     IF-VAL1;
#     break;
#   case VAL2:
#     IF-VAL2;
#     break;
#   ...
#   default:
#     DEFAULT;
#     break;
# }.
# All the values are optional, and the macro is robust to active
# symbols properly quoted.
m4_define([m4_case],
[ifelse([$#], 0, [],
	[$#], 1, [],
	[$#], 2, [$2],
        [$1], [$2], [$3],
        [m4_case([$1], m4_shiftn(3, $@))])])


# m4_match(SWITCH, RE1, VAL1, RE2, VAL2, ..., DEFAULT)
# ----------------------------------------------------
# m4 equivalent of
#
# if (SWITCH =~ RE1)
#   VAL1;
# elif (SWITCH =~ RE2)
#   VAL2;
# elif ...
#   ...
# else
#   DEFAULT
#
# All the values are optional, and the macro is robust to active symbols
# properly quoted.
m4_define([m4_match],
[ifelse([$#], 0, [],
	[$#], 1, [],
	[$#], 2, [$2],
        m4_regexp([$1], [$2]), -1, [m4_match([$1], m4_shiftn(3, $@))],
        [$3])])



## ---------------------------------------- ##
## 6. Enhanced version of some primitives.  ##
## ---------------------------------------- ##

# m4_do(STRING, ...)
# ------------------
# This macro invokes all its arguments (in sequence, of course).  It is
# useful for making your macros more structured and readable by dropping
# unecessary dnl's and have the macros indented properly.
m4_define([m4_do],
  [ifelse($#, 0, [],
          $#, 1, [$1],
          [$1[]m4_do(m4_shift($@))])])


# m4_default(EXP1, EXP2)
# ----------------------
# Returns EXP1 if non empty, otherwise EXP2.
m4_define([m4_default], [ifval([$1], [$1], [$2])])


# m4_shiftn(N, ...)
# -----------------
# Returns ... shifted N times.  Useful for recursive "varargs" constructs.
m4_define([m4_shiftn],
[m4_assert(($1 >= 0) && ($# > $1))dnl
_m4_shiftn($@)])

m4_define([_m4_shiftn],
[ifelse([$1], 0,
        [m4_shift($@)],
        [_m4_shiftn(m4_eval([$1]-1), m4_shift(m4_shift($@)))])])




# _m4_dumpdefs_up(NAME)
# ---------------------
m4_define([_m4_dumpdefs_up],
[ifdef([$1],
       [m4_pushdef([_m4_dumpdefs], m4_defn([$1]))dnl
m4_dumpdef([$1])dnl
m4_popdef([$1])dnl
_m4_dumpdefs_up([$1])])])


# _m4_dumpdefs_down(NAME)
# -----------------------
m4_define([_m4_dumpdefs_down],
[ifdef([_m4_dumpdefs],
       [m4_pushdef([$1], m4_defn([_m4_dumpdefs]))dnl
m4_popdef([_m4_dumpdefs])dnl
_m4_dumpdefs_down([$1])])])


# m4_dumpdefs(NAME)
# -----------------
# Similar to `m4_dumpdef(NAME)', but if NAME was m4_pushdef'ed, display its
# value stack (most recent displayed first).
m4_define([m4_dumpdefs],
[_m4_dumpdefs_up([$1])dnl
_m4_dumpdefs_down([$1])])


# m4_quote(STRING)
# ----------------
# Return STRING quoted.
#
# It is important to realize the difference between `m4_quote(exp)' and
# `[exp]': in the first case you obtain the quoted *result* of the
# expansion of EXP, while in the latter you just obtain the string
# `exp'.
m4_define([m4_quote], [[$*]])


# m4_noquote(STRING)
# ------------------
# Return the result of ignoring all quotes in STRING and invoking the
# macros it contains.  Amongst other things useful for enabling macro
# invocations inside strings with [] blocks (for instance regexps and
# help-strings).
m4_define([m4_noquote],
[m4_changequote(-=<{,}>=-)$1-=<{}>=-m4_changequote([,])])


## -------------------------- ##
## 7. Implementing m4 loops.  ##
## -------------------------- ##


# m4_for(VARIABLE, FIRST, LAST, [STEP = +/-1], EXPRESSION)
# --------------------------------------------------------
# Expand EXPRESSION defining VARIABLE to FROM, FROM + 1, ..., TO.
# Both limits are included.

m4_define([m4_for],
[m4_case(m4_sign(m4_eval($3 - $2)),
         1, [m4_assert(m4_sign(m4_default($4, 1)) == 1)],
        -1, [m4_assert(m4_sign(m4_default($4, -1)) == -1)])dnl
m4_pushdef([$1], [$2])dnl
ifelse(m4_eval([$3 > $2]), 1,
       [_m4_for([$1], [$3], m4_default([$4], 1), [$5])],
       [_m4_for([$1], [$3], m4_default([$4], -1), [$5])])dnl
m4_popdef([$1])])

m4_define([_m4_for],
[$4[]dnl
ifelse($1, [$2], [],
       [m4_define([$1], m4_eval($1+[$3]))_m4_for([$1], [$2], [$3], [$4])])])


# Implementing `foreach' loops in m4 is much more tricky than it may
# seem.  Actually, the example of a `foreach' loop in the m4
# documentation is wrong: it does not quote the arguments properly,
# which leads to undesired expansions.
#
# The example in the documentation is:
#
# | # foreach(VAR, (LIST), STMT)
# | m4_define([foreach],
# |        [m4_pushdef([$1])_foreach([$1], [$2], [$3])m4_popdef([$1])])
# | m4_define([_arg1], [$1])
# | m4_define([_foreach],
# | 	      [ifelse([$2], [()], ,
# | 		      [m4_define([$1], _arg1$2)$3[]_foreach([$1],
# |                                                         (shift$2),
# |                                                         [$3])])])
#
# But then if you run
#
# | m4_define(a, 1)
# | m4_define(b, 2)
# | m4_define(c, 3)
# | foreach([f], [([a], [(b], [c)])], [echo f
# | ])
#
# it gives
#
#  => echo 1
#  => echo (2,3)
#
# which is not what is expected.
#
# Of course the problem is that many quotes are missing.  So you add
# plenty of quotes at random places, until you reach the expected
# result.  Alternatively, if you are a quoting wizard, you directly
# reach the following implementation (but if you really did, then
# apply to the maintenance of m4sugar!).
#
# | # foreach(VAR, (LIST), STMT)
# | m4_define([foreach], [m4_pushdef([$1])_foreach($@)m4_popdef([$1])])
# | m4_define([_arg1], [[$1]])
# | m4_define([_foreach],
# |  [ifelse($2, [()], ,
# | 	     [m4_define([$1], [_arg1$2])$3[]_foreach([$1],
# |                                                  [(shift$2)],
# |                                                  [$3])])])
#
# which this time answers
#
#  => echo a
#  => echo (b
#  => echo c)
#
# Bingo!
#
# Well, not quite.
#
# With a better look, you realize that the parens are more a pain than
# a help: since anyway you need to quote properly the list, you end up
# with always using an outermost pair of parens and an outermost pair
# of quotes.  Rejecting the parens both eases the implementation, and
# simplifies the use:
#
# | # foreach(VAR, (LIST), STMT)
# | m4_define([foreach], [m4_pushdef([$1])_foreach($@)m4_popdef([$1])])
# | m4_define([_arg1], [$1])
# | m4_define([_foreach],
# |  [ifelse($2, [], ,
# | 	     [m4_define([$1], [_arg1($2)])$3[]_foreach([$1],
# |                                                    [shift($2)],
# |                                                    [$3])])])
#
#
# Now, just replace the `$2' with `m4_quote($2)' in the outer `ifelse'
# to improve robustness, and you come up with a quite satisfactory
# implementation.


# m4_foreach(VARIABLE, LIST, EXPRESSION)
# --------------------------------------
#
# Expand EXPRESSION assigning each value of the LIST to VARIABLE.
# LIST should have the form `item_1, item_2, ..., item_n', i.e. the
# whole list must *quoted*.  Quote members too if you don't want them
# to be expanded.
#
# This macro is robust to active symbols:
#      | m4_define(active, [ACT, IVE])
#      | m4_foreach(Var, [active, active], [-Var-])
#     => -ACT--IVE--ACT--IVE-
#
#      | m4_foreach(Var, [[active], [active]], [-Var-])
#     => -ACT, IVE--ACT, IVE-
#
#      | m4_foreach(Var, [[[active]], [[active]]], [-Var-])
#     => -active--active-
m4_define([m4_foreach],
[m4_pushdef([$1])_m4_foreach($@)m4_popdef([$1])])

# Low level macros used to define m4_foreach.
m4_define([m4_car], [$1])
m4_define([_m4_foreach],
[ifelse(m4_quote($2), [], [],
        [m4_define([$1], [m4_car($2)])$3[]_m4_foreach([$1],
                                                      [m4_shift($2)],
                                                      [$3])])])



## --------------------------- ##
## 8. More diversion support.  ##
## --------------------------- ##


# _m4_divert(DIBERSION-NAME or NUMBER)
# ------------------------------------
# If DIVERSION-NAME is the name of a diversion, return its number, otherwise
# return makeNUMBER.
m4_define([_m4_divert],
[ifdef([_m4_divert($1)],
       [m4_indir([_m4_divert($1)])],
       [$1])])


# m4_divert_push(DIVERSION-NAME)
# ------------------------------
# Change the diversion stream to DIVERSION-NAME, while stacking old values.
m4_define([m4_divert_push],
[m4_pushdef([_m4_divert_diversion], _m4_divert([$1]))dnl
divert(_m4_divert_diversion)dnl
])


# m4_divert_pop
# -------------
# Change the diversion stream to its previous value, unstacking it.
m4_define([m4_divert_pop],
[m4_popdef([_m4_divert_diversion])dnl
ifndef([_m4_divert_diversion],
       [m4_fatal([too many m4_divert_pop])])dnl
divert(_m4_divert_diversion)dnl
])


# m4_divert(DIVERSION-NAME, CONTENT)
# ----------------------------------
# Output CONTENT into DIVERSION-NAME (which may be a number actually).
# An end of line is appended for free to CONTENT.
m4_define([m4_divert],
[m4_divert_push([$1])dnl
$2
m4_divert_pop()dnl
])


## -------------------------------------------- ##
## 8. Defining macros with bells and whistles.  ##
## -------------------------------------------- ##

# `m4_defun' is basically `m4_define' but it equips the macro with the
# needed machinery for `m4_require'.  A macro must be m4_defun'd if
# either it is m4_require'd, or it m4_require's.
#
# Two things deserve attention and are detailed below:
#  1. Implementation of m4_require
#  2. Keeping track of the expansion stack
#
# 1. Implementation of m4_require
# ===============================
#
# Of course m4_defun AC_PROVIDE's the macro, so that a macro which has
# been expanded is not expanded again when m4_require'd, but the
# difficult part is the proper expansion of macros when they are
# m4_require'd.
#
# The implementation is based on two ideas, (i) using diversions to
# prepare the expansion of the macro and its dependencies (by François
# Pinard), and (ii) expand the most recently m4_require'd macros _after_
# the previous macros (by Axel Thimm).
#
#
# The first idea: why using diversions?
# -------------------------------------
#
# When a macro requires another, the other macro is expanded in new
# diversion, GROW.  When the outer macro is fully expanded, we first
# undivert the most nested diversions (GROW - 1...), and finally
# undivert GROW.  To understand why we need several diversions,
# consider the following example:
#
# | m4_defun([TEST1], [Test...REQUIRE([TEST2])1])
# | m4_defun([TEST2], [Test...REQUIRE([TEST3])2])
# | m4_defun([TEST3], [Test...3])
#
# Because m4_require is not required to be first in the outer macros, we
# must keep the expansions of the various level of m4_require separated.
# Right before executing the epilogue of TEST1, we have:
#
# 	   GROW - 2: Test...3
# 	   GROW - 1: Test...2
# 	   GROW:     Test...1
# 	   BODY:
#
# Finally the epilogue of TEST1 undiverts GROW - 2, GROW - 1, and
# GROW into the regular flow, BODY.
#
# 	   GROW - 2:
# 	   GROW - 1:
# 	   GROW:
# 	   BODY:        Test...3; Test...2; Test...1
#
# (The semicolons are here for clarification, but of course are not
# emitted.)  This is what Autoconf 2.0 (I think) to 2.13 (I'm sure)
# implement.
#
#
# The second idea: first required first out
# -----------------------------------------
#
# The natural implementation of the idea above is buggy and produces
# very surprising results in some situations.  Let's consider the
# following example to explain the bug:
#
# | m4_defun([TEST1],  [REQUIRE([TEST2a])REQUIRE([TEST2b])])
# | m4_defun([TEST2a], [])
# | m4_defun([TEST2b], [REQUIRE([TEST3])])
# | m4_defun([TEST3],  [REQUIRE([TEST2a])])
# |
# | AC_INIT
# | TEST1
#
# The dependencies between the macros are:
#
# 		 3 --- 2b
# 		/        \              is m4_require'd by
# 	       /          \       left -------------------- right
# 	    2a ------------ 1
#
# If you strictly apply the rules given in the previous section you get:
#
# 	   GROW - 2: TEST3
# 	   GROW - 1: TEST2a; TEST2b
# 	   GROW:     TEST1
# 	   BODY:
#
# (TEST2a, although required by TEST3 is not expanded in GROW - 3
# because is has already been expanded before in GROW - 1, so it has
# been AC_PROVIDE'd, so it is not expanded again) so when you undivert
# the stack of diversions, you get:
#
# 	   GROW - 2:
# 	   GROW - 1:
# 	   GROW:
# 	   BODY:        TEST3; TEST2a; TEST2b; TEST1
#
# i.e., TEST2a is expanded after TEST3 although the latter required the
# former.
#
# Starting from 2.50, uses an implementation provided by Axel Thimm.
# The idea is simple: the order in which macros are emitted must be the
# same as the one in which macro are expanded.  (The bug above can
# indeed be described as: a macro has been AC_PROVIDE'd, but it is
# emitted after: the lack of correlation between emission and expansion
# order is guilty).
#
# How to do that?  You keeping the stack of diversions to elaborate the
# macros, but each time a macro is fully expanded, emit it immediately.
#
# In the example above, when TEST2a is expanded, but it's epilogue is
# not run yet, you have:
#
# 	   GROW - 2:
# 	   GROW - 1: TEST2a
# 	   GROW:     Elaboration of TEST1
# 	   BODY:
#
# The epilogue of TEST2a emits it immediately:
#
# 	   GROW - 2:
# 	   GROW - 1:
# 	   GROW:     Elaboration of TEST1
# 	   BODY:     TEST2a
#
# TEST2b then requires TEST3, so right before the epilogue of TEST3, you
# have:
#
# 	   GROW - 2: TEST3
# 	   GROW - 1: Elaboration of TEST2b
# 	   GROW:     Elaboration of TEST1
# 	   BODY:      TEST2a
#
# The epilogue of TEST3 emits it:
#
# 	   GROW - 2:
# 	   GROW - 1: Elaboration of TEST2b
# 	   GROW:     Elaboration of TEST1
# 	   BODY:     TEST2a; TEST3
#
# TEST2b is now completely expanded, and emitted:
#
# 	   GROW - 2:
# 	   GROW - 1:
# 	   GROW:     Elaboration of TEST1
# 	   BODY:     TEST2a; TEST3; TEST2b
#
# and finally, TEST1 is finished and emitted:
#
# 	   GROW - 2:
# 	   GROW - 1:
# 	   GROW:
# 	   BODY:     TEST2a; TEST3; TEST2b: TEST1
#
# The idea, is simple, but the implementation is a bit evolved.  If you
# are like me, you will want to see the actual functioning of this
# implementation to be convinced.  The next section gives the full
# details.
#
#
# The Axel Thimm implementation at work
# -------------------------------------
#
# We consider the macros above, and this configure.in:
#
# 	    AC_INIT
# 	    TEST1
#
# You should keep the definitions of _m4_defun_pro, _m4_defun_epi, and
# m4_require at hand to follow the steps.
#
# This implements tries not to assume that of the current diversion is
# BODY, so as soon as a macro (m4_defun'd) is expanded, we first
# record the current diversion under the name _m4_divert_dump (denoted
# DUMP below for short).  This introduces an important difference with
# the previous versions of Autoconf: you cannot use m4_require if you
# were not inside an m4_defun'd macro, and especially, you cannot
# m4_require directly from the top level.
#
# We have not tried to simulate the old behavior (better yet, we
# diagnose it), because it is too dangerous: a macro m4_require'd from
# the top level is expanded before the body of `configure', i.e., before
# any other test was run.  I let you imagine the result of requiring
# AC_STDC_HEADERS for instance, before AC_PROG_CC was actually run....
#
# After AC_INIT was run, the current diversion is BODY.
# * AC_INIT was run
#   DUMP:                undefined
#   diversion stack:     BODY |-
#
# * TEST1 is expanded
# The prologue of TEST1 sets AC_DIVERSION_DUMP, which is the diversion
# where the current elaboration will be dumped, to the current
# diversion.  It also m4_divert_push to GROW, where the full
# expansion of TEST1 and its dependencies will be elaborated.
#   DUMP:       BODY
#   BODY:       empty
#   diversions: GROW, BODY |-
#
# * TEST1 requires TEST2a: prologue
# m4_require m4_divert_pushes another temporary diversion GROW - 1 (in
# fact, the diversion whose number is one less than the current
# diversion), and expands TEST2a in there.
#   DUMP:       BODY
#   BODY:       empty
#   diversions: GROW-1, GROW, BODY |-
#
# * TEST2a is expanded.
# Its prologue pushes the current diversion again.
#   DUMP:       BODY
#   BODY:       empty
#   diversions: GROW - 1, GROW - 1, GROW, BODY |-
# It is expanded in GROW - 1, and GROW - 1 is popped by the epilogue
# of TEST2a.
#   DUMP:        BODY
#   BODY:        nothing
#   GROW - 1:    TEST2a
#   diversions:  GROW - 1, GROW, BODY |-
#
# * TEST1 requires TEST2a: epilogue
# The content of the current diversion is appended to DUMP (and removed
# from the current diversion).  A diversion is popped.
#   DUMP:       BODY
#   BODY:       TEST2a
#   diversions: GROW, BODY |-
#
# * TEST1 requires TEST2b: prologue
# m4_require pushes GROW - 1 and expands TEST2b.
#   DUMP:       BODY
#   BODY:       TEST2a
#   diversions: GROW - 1, GROW, BODY |-
#
# * TEST2b is expanded.
# Its prologue pushes the current diversion again.
#   DUMP:       BODY
#   BODY:       TEST2a
#   diversions: GROW - 1, GROW - 1, GROW, BODY |-
# The body is expanded here.
#
# * TEST2b requires TEST3: prologue
# m4_require pushes GROW - 2 and expands TEST3.
#   DUMP:       BODY
#   BODY:       TEST2a
#   diversions: GROW - 2, GROW - 1, GROW - 1, GROW, BODY |-
#
# * TEST3 is expanded.
# Its prologue pushes the current diversion again.
#   DUMP:       BODY
#   BODY:       TEST2a
#   diversions: GROW-2, GROW-2, GROW-1, GROW-1, GROW, BODY |-
# TEST3 requires TEST2a, but TEST2a has already been AC_PROVIDE'd, so
# nothing happens.  It's body is expanded here, and its epilogue pops a
# diversion.
#   DUMP:       BODY
#   BODY:       TEST2a
#   GROW - 2:   TEST3
#   diversions: GROW - 2, GROW - 1, GROW - 1, GROW, BODY |-
#
# * TEST2b requires TEST3: epilogue
# The current diversion is appended to DUMP, and a diversion is popped.
#   DUMP:       BODY
#   BODY:       TEST2a; TEST3
#   diversions: GROW - 1, GROW - 1, GROW, BODY |-
# The content of TEST2b is expanded here.
#   DUMP:       BODY
#   BODY:       TEST2a; TEST3
#   GROW - 1:   TEST2b,
#   diversions: GROW - 1, GROW - 1, GROW, BODY |-
# The epilogue of TEST2b pops a diversion.
#   DUMP:       BODY
#   BODY:       TEST2a; TEST3
#   GROW - 1:   TEST2b,
#   diversions: GROW - 1, GROW, BODY |-
#
# * TEST1 requires TEST2b: epilogue
# The current diversion is appended to DUMP, and a diversion is popped.
#   DUMP:       BODY
#   BODY:       TEST2a; TEST3; TEST2b
#   diversions: GROW, BODY |-
#
# * TEST1 is expanded: epilogue
# TEST1's own content is in GROW, and it's epilogue pops a diversion.
#   DUMP:       BODY
#   BODY:       TEST2a; TEST3; TEST2b
#   GROW:       TEST1
#   diversions: BODY |-
# Here, the epilogue of TEST1 notices the elaboration is done because
# DUMP and the current diversion are the same, it then undiverts
# GROW by hand, and undefines DUMP.
#   DUMP:       undefined
#   BODY:       TEST2a; TEST3; TEST2b; TEST1
#   diversions: BODY |-
#
#
# 2. Keeping track of the expansion stack
# =======================================
#
# When M4 expansion goes wrong it is often extremely hard to find the
# path amongst macros that drove to the failure.  What is needed is
# the stack of macro `calls'. One could imagine that GNU M4 would
# maintain a stack of macro expansions, unfortunately it doesn't, so
# we do it by hand.  This is of course extremely costly, but the help
# this stack provides is worth it.  Nevertheless to limit the
# performance penalty this is implemented only for m4_defun'd macros,
# not for define'd macros.
#
# The scheme is simplistic: each time we enter an m4_defun'd macros,
# we m4_pushdef its name in _m4_expansion_stack, and when we exit the
# macro, we m4_popdef _m4_expansion_stack.
#
# In addition, we want to use the expansion stack to detect circular
# m4_require dependencies.  This means we need to browse the stack to
# check whether a macro being expanded is m4_require'd.  For ease of
# implementation, and certainly for the benefit of performances, we
# don't browse the _m4_expansion_stack, rather each time we expand a
# macro FOO we define _AC_EXPANDING(FOO).  Then m4_require(BAR) simply
# needs to check whether _AC_EXPANDING(BAR) is defined to diagnose a
# circular dependency.
#
# To improve the diagnostic, in addition to keeping track of the stack
# of macro calls, _m4_expansion_stack also records the m4_require
# stack.  Note that therefore an m4_defun'd macro being required will
# appear twice in the stack: the first time because it is required,
# the second because it is expanded.  We can avoid this, but it has
# two small drawbacks: (i) the implementation is slightly more
# complex, and (ii) it hides the difference between define'd macros
# (which don't appear in _m4_expansion_stack) and m4_defun'd macros
# (which do).  The more debugging information, the better.

# _m4_divert(GROW)
# ----------------
# This diversion is used by the m4_defun/m4_require machinery.  It is
# important to keep room before GROW because for each nested
# AC_REQUIRE we use an additional diversion (i.e., two m4_require's
# will use GROW - 2.  More than 3 levels has never seemed to be
# needed.)
#
# ...
# - GROW - 2
#   m4_require'd code, 2 level deep
# - GROW - 1
#   m4_require'd code, 1 level deep
# - GROW
#   m4_defun'd macros are elaborated here.

m4_define([_m4_divert(GROW)],       10000)

# _m4_expansion_stack_DUMP
# ------------------------
# Dump the expansion stack.
m4_define([_m4_expansion_stack_dump],
[ifdef([_m4_expansion_stack],
       [m4_errprint(m4_defn([_m4_expansion_stack]))dnl
m4_popdef([_m4_expansion_stack])dnl
_m4_expansion_stack_dump()],
       [m4_errprint(m4_defn([m4_location])[: the top level])])])


# _m4_defun_pro(MACRO-NAME)
# -------------------------
# The prologue for Autoconf macros.
m4_define([_m4_defun_pro],
[m4_pushdef([_m4_expansion_stack],
            m4_defn([m4_location($1)])[: $1 is expanded from...])dnl
m4_pushdef([_m4_expanding($1)])dnl
ifdef([_m4_divert_dump],
      [m4_divert_push(m4_defn([_m4_divert_diversion]))],
      [m4_copy([_m4_divert_diversion], [_m4_divert_dump])dnl
m4_divert_push([GROW])])dnl
])


# _m4_defun_epi(MACRO-NAME)
# -------------------------
# The Epilogue for Autoconf macros.  MACRO-NAME only helps tracing
# the PRO/EPI pairs.
m4_define([_m4_defun_epi],
[m4_divert_pop()dnl
ifelse(_m4_divert_dump, _m4_divert_diversion,
       [undivert(_m4_divert([GROW]))dnl
m4_undefine([_m4_divert_dump])])dnl
m4_popdef([_m4_expansion_stack])dnl
m4_popdef([_m4_expanding($1)])dnl
m4_provide([$1])dnl
])


# m4_defun(NAME, EXPANSION)
# -------------------------
# Define a macro which automatically provides itself.  Add machinery
# so the macro automatically switches expansion to the diversion
# stack if it is not already using it.  In this case, once finished,
# it will bring back all the code accumulated in the diversion stack.
# This, combined with m4_require, achieves the topological ordering of
# macros.  We don't use this macro to define some frequently called
# macros that are not involved in ordering constraints, to save m4
# processing.
m4_define([m4_defun],
[m4_define([m4_location($1)], m4_defn([m4_location]))dnl
m4_define([$1],
          [_m4_defun_pro([$1])$2[]_m4_defun_epi([$1])])])


# m4_defun_once(NAME, EXPANSION)
# ------------------------------
# As m4_defun, but issues the EXPANSION only once, and warns if used
# several times.
m4_define([m4_defun_once],
[m4_define([m4_location($1)], m4_defn([m4_location]))dnl
m4_define([$1],
          [m4_provide_ifelse([$1],
                             [m4_warn([syntax], [$1 invoked multiple times])],
                             [_m4_defun_pro([$1])$2[]_m4_defun_epi([$1])])])])


## ----------------------------- ##
## Dependencies between macros.  ##
## ----------------------------- ##


# m4_before(THIS-MACRO-NAME, CALLED-MACRO-NAME)
# ---------------------------------------------
m4_define([m4_before],
[m4_provide_ifelse([$2],
                   [m4_warn([syntax], [$2 was called before $1])])])


# _m4_require(NAME-TO-CHECK, BODY-TO-EXPAND)
# ------------------------------------------
# If NAME-TO-CHECK has never been expanded (actually, if it is not
# m4_provide'd), expand BODY-TO-EXPAND *before* the current macro
# expansion.  Once expanded, emit it in _m4_divert_dump.  Keep track
# of the m4_require chain in _m4_expansion_stack.
#
# The normal cases are:
#
# - NAME-TO-CHECK == BODY-TO-EXPAND
#   Which you can use for regular macros with or without arguments, e.g.,
#     _m4_require([AC_PROG_CC], [AC_PROG_CC])
#     _m4_require([AC_CHECK_HEADERS(limits.h)], [AC_CHECK_HEADERS(limits.h)])
#
# - BODY-TO-EXPAND == m4_indir([NAME-TO-CHECK])
#   In the case of macros with irregular names.  For instance:
#     _m4_require([AC_LANG_COMPILER(C)], [indir([AC_LANG_COMPILER(C)])])
#   which means `if the macro named `AC_LANG_COMPILER(C)' (the parens are
#   part of the name, it is not an argument) has not been run, then
#   call it.'
#   Had you used
#     _m4_require([AC_LANG_COMPILER(C)], [AC_LANG_COMPILER(C)])
#   then _m4_require would have tried to expand `AC_LANG_COMPILER(C)', i.e.,
#   call the macro `AC_LANG_COMPILER' with `C' as argument.
#
#   You could argue that `AC_LANG_COMPILER', when it receives an argument
#   such as `C' should dispatch the call to `AC_LANG_COMPILER(C)'.  But this
#   `extension' prevents `AC_LANG_COMPILER' from having actual arguments that
#   it passes to `AC_LANG_COMPILER(C)'.
m4_define([_m4_require],
[m4_pushdef([_m4_expansion_stack],
            m4_defn([m4_location])[: $1 is required by...])dnl
ifdef([_m4_expanding($1)],
      [m4_fatal([m4_require: circular dependency of $1])])dnl
ifndef([_m4_divert_dump],
    [m4_fatal([m4_require: cannot be used outside of an m4_defun'd macro])])dnl
m4_provide_ifelse([$1],
                  [],
                  [m4_divert_push(m4_eval(_m4_divert_diversion - 1))dnl
$2
divert(_m4_divert_dump)undivert(_m4_divert_diversion)dnl
m4_divert_pop()])dnl
m4_provide_ifelse([$1],
                  [],
                  [m4_warn([syntax],
                           [$1 is m4_require'd but is not m4_defun'd])])dnl
m4_popdef([_m4_expansion_stack])dnl
])


# m4_require(STRING)
# ------------------
# If STRING has never been m4_provide'd, then expand it.
m4_define([m4_require],
[_m4_require([$1], [$1])])


# m4_expand_once(TEXT)
# --------------------
# If TEXT has never been expanded, expand it *here*.
m4_define([m4_expand_once],
[m4_provide_ifelse([$1],
                   [],
                   [m4_provide([$1])[]$1])])


# m4_provide(MACRO-NAME)
# ----------------------
m4_define([m4_provide],
[m4_define([m4_provide($1)])])


# m4_provide_ifelse(MACRO-NAME, IF-PROVIDED, IF-NOT-PROVIDED)
# -----------------------------------------------------------
# If MACRO-NAME is provided do IF-PROVIDED, else IF-NOT-PROVIDED.
# The purpose of this macro is to provide the user with a means to
# check macros which are provided without letting her know how the
# information is coded.
m4_define([m4_provide_ifelse],
[ifdef([m4_provide($1)],
       [$2], [$3])])


## -------------------- ##
## 9. Text processing.  ##
## -------------------- ##

# m4_tolower(STRING)
# m4_toupper(STRING)
# ------------------
# These macros lowercase and uppercase strings.
m4_define([m4_tolower],
[m4_translit([$1],
             [ABCDEFGHIJKLMNOPQRSTUVWXYZ],
             [abcdefghijklmnopqrstuvwxyz])])

m4_define([m4_toupper],
[m4_translit([$1],
             [abcdefghijklmnopqrstuvwxyz],
             [ABCDEFGHIJKLMNOPQRSTUVWXYZ])])


# m4_split(STRING, [REGEXP])
# --------------------------
#
# Split STRING into an m4 list of quoted elements.  The elements are
# quoted with [ and ].  Beginning spaces and end spaces *are kept*.
# Use m4_strip to remove them.
#
# REGEXP specifies where to split.  Default is [\t ]+.
#
# Pay attention to the m4_changequotes.  Inner m4_changequotes exist for
# obvious reasons (we want to insert square brackets).  Outer
# m4_changequotes are needed because otherwise the m4 parser, when it
# sees the closing bracket we add to the result, believes it is the
# end of the body of the macro we define.
#
# Also, notice that $1 is quoted twice, since we want the result to
# be quoted.  Then you should understand that the argument of
# patsubst is ``STRING'' (i.e., with additional `` and '').
#
# This macro is safe on active symbols, i.e.:
#   m4_define(active, ACTIVE)
#   m4_split([active active ])end
#   => [active], [active], []end

m4_changequote(<<, >>)
m4_define(<<m4_split>>,
<<m4_changequote(``, '')dnl
[dnl Can't use m4_default here instead of ifelse, because m4_default uses
dnl [ and ] as quotes.
m4_patsubst(````$1'''',
	    ifelse(``$2'',, ``[ 	]+'', ``$2''),
	    ``], ['')]dnl
m4_changequote([, ])>>)
m4_changequote([, ])



# m4_join(STRING)
# ---------------
# If STRING contains end of lines, replace them with spaces.  If there
# are backslashed end of lines, remove them.  This macro is safe with
# active symbols.
#    m4_define(active, ACTIVE)
#    m4_join([active
#    act\
#    ive])end
#    => active activeend
m4_define([m4_join],
[m4_translit(m4_patsubst([[[$1]]], [\\
]), [
], [ ])])


# m4_strip(STRING)
# ----------------
# Expands into STRING with tabs and spaces singled out into a single
# space, and removing leading and trailing spaces.
#
# This macro is robust to active symbols.
#    m4_define(active, ACTIVE)
#    m4_strip([  active  		active ])end
#    => active activeend
#
# This macro is fun!  Because we want to preserve active symbols, STRING
# must be quoted for each evaluation, which explains there are 4 levels
# of brackets around $1 (don't forget that the result must be quoted
# too, hence one more quoting than applications).
#
# Then notice the patsubst of the middle: it is in charge of removing
# the leading space.  Why not just `patsubst(..., [^ ])'?  Because this
# macro will receive the output of the preceding patsubst, i.e. more or
# less [[STRING]].  So if there is a leading space in STRING, then it is
# the *third* character, since there are two leading `['; Equally for
# the outer patsubst.
m4_define([m4_strip],
[m4_patsubst(m4_patsubst(m4_patsubst([[[[$1]]]],
                            [[ 	]+], [ ]),
                   [^\(..\) ], [\1]),
          [ \(.\)$], [\1])])



# m4_append(MACRO-NAME, STRING)
# -----------------------------
# Redefine MACRO-NAME to hold its former content plus STRING at the
# end.  It is valid to use this macro with MACRO-NAME undefined.
#
# This macro is robust to active symbols.  It can be used to grow
# strings.
#
#    | m4_define(active, ACTIVE)
#    | m4_append([sentence], [This is an])
#    | m4_append([sentence], [ active ])
#    | m4_append([sentence], [symbol.])
#    | sentence
#    | m4_undefine([active])dnl
#    | sentence
#    => This is an ACTIVE symbol.
#    => This is an active symbol.
#
# It can be used to define hooks.
#
#    | m4_define(active, ACTIVE)
#    | m4_append([hooks], [m4_define([act1], [act2])])
#    | m4_append([hooks], [m4_define([act2], [active])])
#    | m4_undefine([active])
#    | act1
#    | hooks
#    | act1
#    => act1
#    =>
#    => active
m4_define([m4_append],
[m4_define([$1],
ifdef([$1], [m4_defn([$1])])[$2])])


# m4_list_append(MACRO-NAME, STRING)
# ----------------------------------
# Same as `m4_append', but each element is separated by `, '.
m4_define([m4_list_append],
[m4_define([$1],
ifdef([$1], [m4_defn([$1]), ])[$2])])


# m4_foreach_quoted(VARIABLE, LIST, EXPRESSION)
# ---------------------------------------------
# FIXME: This macro should not exists.  Currently it's used only in
# m4_wrap, which needs to be rewritten.  But it's godam hard.
m4_define([m4_foreach_quoted],
[m4_pushdef([$1], [])_m4_foreach_quoted($@)m4_popdef([$1])])

# Low level macros used to define m4_foreach.
m4_define([m4_car_quoted], [[$1]])
m4_define([_m4_foreach_quoted],
[ifelse($2, [()], ,
        [m4_define([$1], [m4_car_quoted$2])$3[]_m4_foreach_quoted([$1],
                                                               [(m4_shift$2)],
                                                               [$3])])])


# m4_text_wrap(STRING, [PREFIX], [FIRST-PREFIX], [WIDTH])
# -------------------------------------------------------
# Expands into STRING wrapped to hold in WIDTH columns (default = 79).
# If prefix is set, each line is prefixed with it.  If FIRST-PREFIX is
# specified, then the first line is prefixed with it.  As a special
# case, if the length of the first prefix is greater than that of
# PREFIX, then FIRST-PREFIX will be left alone on the first line.
#
# Typical outputs are:
#
# m4_text_wrap([Short string */], [   ], [/* ], 20)
#  => /* Short string */
#
# m4_text_wrap([Much longer string */], [   ], [/* ], 20)
#  => /* Much longer
#  =>    string */
#
# m4_text_wrap([Short doc.], [          ], [  --short ], 30)
#  =>   --short Short doc.
#
# m4_text_wrap([Short doc.], [          ], [  --too-wide ], 30)
#  =>   --too-wide
#  =>           Short doc.
#
# m4_text_wrap([Super long documentation.], [          ], [  --too-wide ], 30)
#  =>   --too-wide
#  => 	  Super long
#  => 	  documentation.
#
# FIXME: there is no checking of a longer PREFIX than WIDTH, but do
# we really want to bother with people trying each single corner
# of a software?
#
# This macro does not leave a trailing space behind the last word,
# what complicates it a bit.  The algorithm is stupid simple: all the
# words are preceded by m4_Separator which is defined to empty for the
# first word, and then ` ' (single space) for all the others.
m4_define([m4_text_wrap],
[m4_pushdef([m4_Prefix], m4_default([$2], []))dnl
m4_pushdef([m4_Prefix1], m4_default([$3], [m4_Prefix]))dnl
m4_pushdef([m4_Width], m4_default([$4], 79))dnl
m4_pushdef([m4_Cursor], m4_len(m4_Prefix1))dnl
m4_pushdef([m4_Separator], [])dnl
m4_Prefix1[]dnl
ifelse(m4_eval(m4_Cursor > m4_len(m4_Prefix)),
       1, [m4_define([m4_Cursor], m4_len(m4_Prefix))
m4_Prefix])[]dnl
m4_foreach_quoted([m4_Word], (m4_split(m4_strip(m4_join([$1])))),
[m4_define([m4_Cursor], m4_eval(m4_Cursor + len(m4_Word) + 1))dnl
dnl New line if too long, else insert a space unless it is the first
dnl of the words.
ifelse(m4_eval(m4_Cursor > m4_Width),
       1, [m4_define([m4_Cursor],
                     m4_eval(m4_len(m4_Prefix) + m4_len(m4_Word) + 1))]
m4_Prefix,
       [m4_Separator])[]dnl
m4_Word[]dnl
m4_define([m4_Separator], [ ])])dnl
m4_popdef([m4_Separator])dnl
m4_popdef([m4_Cursor])dnl
m4_popdef([m4_Width])dnl
m4_popdef([m4_Prefix1])dnl
m4_popdef([m4_Prefix])dnl
])



## ----------------------- ##
## 10. Number processing.  ##
## ----------------------- ##

# m4_sign(A)
# ----------
#
# The sign of the integer A.
m4_define([m4_sign],
[m4_match([$1],
          [^-], -1,
          [^0+], 0,
                 1)])

# m4_cmp(A, B)
# ------------
#
# Compare two integers.
# A < B -> -1
# A = B ->  0
# A > B ->  1
m4_define([m4_cmp],
[m4_sign(m4_eval([$1 - $2]))])


# m4_list_cmp(A, B)
# -----------------
#
# Compare the two lists of integers A and B.  For instance:
#   m4_list_cmp((1, 0),     (1))    ->  0
#   m4_list_cmp((1, 0),     (1, 0)) ->  0
#   m4_list_cmp((1, 2),     (1, 0)) ->  1
#   m4_list_cmp((1, 2, 3),  (1, 2)) ->  1
#   m4_list_cmp((1, 2, -3), (1, 2)) -> -1
#   m4_list_cmp((1, 0),     (1, 2)) -> -1
#   m4_list_cmp((1),        (1, 2)) -> -1
m4_define([m4_list_cmp],
[ifelse([$1$2], [()()], 0,
        [$1], [()], [m4_list_cmp((0), [$2])],
        [$2], [()], [m4_list_cmp([$1], (0))],
        [m4_case(m4_cmp(m4_car$1, m4_car$2),
                 -1, -1,
                  1, 1,
                  0, [m4_list_cmp((m4_shift$1), (m4_shift$2))])])])



## ------------------------ ##
## 11. Version processing.  ##
## ------------------------ ##


# m4_version_unletter(VERSION)
# ----------------------------
# Normalize beta version numbers with letters to numbers only for comparison.
#
#   Nl -> (N+1).-1.(l#)
#
#i.e., 2.14a -> 2.15.-1.1, 2.14b -> 2.15.-1.2, etc.
# This macro is absolutely not robust to active macro, it expects
# reasonable version numbers and is valid up to `z', no double letters.
m4_define([m4_version_unletter],
[m4_translit(m4_patsubst(m4_patsubst(m4_patsubst([$1],
                                                 [\([0-9]+\)\([abcdefghi]\)],
                                                 [m4_eval(\1 + 1).-1.\2]),
                                     [\([0-9]+\)\([jklmnopqrs]\)],
                                     [m4_eval(\1 + 1).-1.1\2]),
                         [\([0-9]+\)\([tuvwxyz]\)],
                         [m4_eval(\1 + 1).-1.2\2]),
             [abcdefghijklmnopqrstuvwxyz],
             [12345678901234567890123456])])


# m4_version_compare(VERSION-1, VERSION-2)
# ----------------------------------------
# Compare the two version numbers and expand into
#  -1 if VERSION-1 < VERSION-2
#   0 if           =
#   1 if           >
m4_define([m4_version_compare],
[m4_list_cmp((m4_split(m4_version_unletter([$1]), [\.])),
             (m4_split(m4_version_unletter([$2]), [\.])))])
