dnl This file is part of Autoconf.                       -*- Autoconf -*-
dnl Parameterized macros.
dnl Requires GNU m4.
dnl Copyright (C) 1992, 93, 94, 95, 96, 98, 1999 Free Software Foundation, Inc.
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2, or (at your option)
dnl any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software
dnl Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
dnl 02111-1307, USA.
dnl
dnl As a special exception, the Free Software Foundation gives unlimited
dnl permission to copy, distribute and modify the configure scripts that
dnl are the output of Autoconf.  You need not follow the terms of the GNU
dnl General Public License when using or distributing such scripts, even
dnl though portions of the text of Autoconf appear in them.  The GNU
dnl General Public License (GPL) does govern all other use of the material
dnl that constitutes the Autoconf program.
dnl
dnl Certain portions of the Autoconf source text are designed to be copied
dnl (in certain cases, depending on the input) into the output of
dnl Autoconf.  We call these the "data" portions.  The rest of the Autoconf
dnl source text consists of comments plus executable code that decides which
dnl of the data portions to output in any given case.  We call these
dnl comments and executable code the "non-data" portions.  Autoconf never
dnl copies any of the non-data portions into its output.
dnl
dnl This special exception to the GPL applies to versions of Autoconf
dnl released by the Free Software Foundation.  When you make and
dnl distribute a modified version of Autoconf, you may extend this special
dnl exception to the GPL to apply to your modified version as well, *unless*
dnl your modified version has the potential to copy into its output some
dnl of the text that was the non-data portion of the version that you started
dnl with.  (In other words, unless your change moves or copies text from
dnl the non-data portions to the data portions.)  If your modification has
dnl such potential, you must delete any notice of this special exception
dnl to the GPL from your modified version.
dnl
dnl Written by David MacKenzie, with help from
dnl Franc,ois Pinard, Karl Berry, Richard Pixley, Ian Lance Taylor,
dnl Roland McGrath, Noah Friedman, david d zuhn, and many others.
dnl
divert(-1)dnl Throw away output until AC_INIT is called.
changequote([, ])

include(acversion.m4)

dnl Some old m4's don't support m4exit.  But they provide
dnl equivalent functionality by core dumping because of the
dnl long macros we define.
ifdef([__gnu__], , [errprint(Autoconf requires GNU m4.
Install it before installing Autoconf or set the
M4 environment variable to its path name.
)m4exit(2)])


dnl m4_errprint(MSG)
dnl ----------------
dnl Same as `errprint', but reports the file and line.
define(m4_errprint, [errprint(__file__:__line__: [$1
])])


dnl m4_warn(MSG)
dnl ------------
dnl Warn the user.
define(m4_warn, [m4_errprint([warning: $1])])


dnl m4_fatal(MSG, [EXIT-STATUS])
dnl ----------------------------
dnl Fatal the user.                                                      :)
define(m4_fatal,
[m4_errprint([error: $1])dnl
m4exit(ifelse([$2],, 1, [$2]))])


dnl Some m4 internals have names colliding with tokens we might use.
dnl Rename them a` la `m4 --prefix-builtins'.
define([m4_prefix],
[define([m4_$1], defn([$1]))
undefine([$1])])

m4_prefix([eval])
m4_prefix([shift])
m4_prefix([format])


dnl We also want to neutralize include (and sinclude for symmetry),
dnl but we want to extend them slightly: warn when a file is included
dnl several times.  This is in general a dangerous operation because
dnl quite nobody quotes the first argument of define.
dnl
dnl For instance in the following case:
dnl   define(foo, [bar])
dnl then a second reading will turn into
dnl   define(bar, [bar])
dnl which is certainly not what was meant.


dnl m4_include_unique(FILE)
dnl -----------------------
dnl Declare that the FILE was loading; and warn if it has already
dnl been included.
define(m4_include_unique,
[ifdef([m4_include($1)],
       [m4_warn([file `$1' included several times])])dnl
define([m4_include($1)])])


dnl m4_include(FILE)
dnl ----------------
dnl As the builtin include, but warns against multiple inclusions.
define(m4_include,
[m4_include_unique([$1])dnl
builtin([include], [$1])])


dnl m4_sinclude(FILE)
dnl -----------------
dnl As the builtin sinclude, but warns against multiple inclusions.
define(m4_sinclude,
[m4_include_unique([$1])dnl
builtin([sinclude], [$1])])

dnl Neutralize include and sinclude.
undefine([include])
undefine([sinclude])

dnl ------------------------------------------------------------
dnl Text processing in m4.
dnl ------------------------------------------------------------

dnl m4_quote(STRING)
dnl ----------------
dnl Return STRING quoted.
dnl
dnl It is important to realize the difference between `quote(exp)' and
dnl `[exp]': in the first case you obtain the quoted *result* of the
dnl expansion of EXP, while in the latter you just obtain the string
dnl `exp'.
define([m4_quote], [[$@]])


dnl m4_split(STRING, [REGEXP])
dnl --------------------------
dnl Split STRING into an m4 list of quoted elements.  The elements are
dnl quoted with [ and ].  Beginning spaces and end spaces *are kept*.
dnl Use m4_strip to remove them.
dnl
dnl REGEXP specifies where to split.  Default is [\t ]+.
dnl
dnl Pay attention to the changequotes.  Inner changequotes exist for
dnl obvious reasons (we want to insert square brackets).  Outer
dnl changequotes are needed because otherwise the m4 parser, when it
dnl sees the closing bracket we add to the result, believes it is the
dnl end of the body of the macro we define.
dnl
dnl Also, notice that $1 is quoted twice, since we want the result to be
dnl quoted.  Then you should understand that the argument of patsubst is
dnl ``STRING'' (i.e., with additional `` and '').
dnl
dnl This macro is safe on active symbols, i.e.:
dnl   define(active, ACTIVE)
dnl   m4_split([active active ])end
dnl   => [active], [active], []end
changequote(<<, >>)
define(<<m4_split>>,
<<changequote(``, '')dnl
[dnl Can't use m4_default here instead of ifelse, because m4_default uses
dnl [ and ] as quotes.
patsubst(````$1'''',
         ifelse(``$2'',, ``[ 	]+'', ``$2''),
         ``], ['')]dnl
changequote([, ])>>)
changequote([, ])


dnl m4_join(STRING)
dnl ---------------
dnl If STRING contains end of lines, replace them with spaces.  If there
dnl are backslashed end of lines, remove them.  This macro is safe with
dnl active symbols.
dnl    define(active, ACTIVE)
dnl    m4_join([active
dnl    act\
dnl    ive])end
dnl    => active activeend
define([m4_join],
[translit(patsubst([[[$1]]], [\\
]), [
], [ ])])


dnl m4_strip(STRING)
dnl ----------------
dnl Expands into STRING with tabs and spaces singled out into a single
dnl space, and removing leading and trailing spaces.
dnl
dnl This macro is robust to active symbols.
dnl    define(active, ACTIVE)
dnl    m4_strip([  active  		active ])end
dnl    => active activeend
dnl
dnl This macro is fun!  Because we want to preserve active symbols, STRING
dnl must be quoted for each evaluation, which explains there are 4 levels
dnl of brackets around $1 (don't forget that the result must be quoted
dnl too, hence one more quoting than applications).
dnl
dnl Then notice the patsubst of the middle: it is in charge of removing
dnl the leading space.  Why not just `patsubst(..., [^ ])'?  Because this
dnl macro will receive the output of the preceding patsubst, i.e. more or
dnl less [[STRING]].  So if there is a leading space in STRING, then it is
dnl the *third* character, since there are two leading `['; Equally for
dnl the outer patsubst.
define([m4_strip],
[patsubst(patsubst(patsubst([[[[$1]]]],
                            [[ 	]+], [ ]),
                   [^\(..\) ], [\1]),
          [ \(.\)$], [\1])])



dnl m4_append(MACRO-NAME, STRING)
dnl -----------------------------
dnl Redefine MACRO-NAME to hold its former content plus STRING at the
dnl end.  It is valid to use this macro with MACRO-NAME undefined.
dnl
dnl This macro is robust to active symbols.  It can be used to grow
dnl strings.
dnl
dnl    | define(active, ACTIVE)
dnl    | m4_append([sentence], [This is an])
dnl    | m4_append([sentence], [ active ])
dnl    | m4_append([sentence], [symbol.])
dnl    | sentence
dnl    | undefine([active])dnl
dnl    | sentence
dnl    => This is an ACTIVE symbol.
dnl    => This is an active symbol.
dnl
dnl It can be used to define hooks.
dnl
dnl    | define(active, ACTIVE)
dnl    | m4_append([hooks], [define([act1], [act2])])
dnl    | m4_append([hooks], [define([act2], [active])])
dnl    | undefine([active])
dnl    | act1
dnl    | hooks
dnl    | act1
dnl    => act1
dnl    =>
dnl    => active
define(m4_append,
[define([$1],
ifdef([$1], [defn([$1])])[$2])])


dnl m4_list_append(MACRO-NAME, STRING)
dnl ----------------------------------
dnl Same as `m4_append', but each element is separated by `, '.
define(m4_list_append,
[define([$1],
ifdef([$1], [defn([$1]), ])[$2])])


dnl ------------------------------------------------------------
dnl Some additional m4 structural control.
dnl ------------------------------------------------------------

dnl Both `ifval' and `ifset' tests against the empty string.  The
dnl difference is that `ifset' is specialized on macros.
dnl
dnl In case of arguments of macros, eg $[1], it makes little difference.
dnl In the case of a macro `FOO', you don't want to check `ifval(FOO,
dnl TRUE)', because if `FOO' expands with commas, there is a shifting of
dnl the arguments.  So you want to run `ifval([FOO])', but then you just
dnl compare the *string* `FOO' against `', which, of course fails.
dnl
dnl So you want a variation of `ifset' that expects a macro name as $[1].
dnl If this macro is both defined and defined to a non empty value, then
dnl it runs TRUE etc.


dnl ifval(COND, IF-TRUE[, IF-FALSE])
dnl --------------------------------
dnl If COND is not the empty string, expand IF-TRUE, otherwise IF-FALSE.
dnl Comparable to ifdef.
define([ifval], [ifelse([$1],[],[$3],[$2])])


dnl ifset(MACRO, IF-TRUE[, IF-FALSE])
dnl --------------------------------
dnl If MACRO has no definition, or of its definition is the empty string,
dnl expand IF-FALSE, otherwise IF-TRUE.
define([ifset],
[ifdef([$1],
       [ifelse(defn([$1]), [], [$3], [$2])],
       [$3])])


dnl m4_default(EXP1, EXP2)
dnl ----------------------
dnl Returns EXP1 if non empty, otherwise EXP2.
define([m4_default], [ifval([$1], [$1], [$2])])



dnl ### Implementing m4 loops

dnl Implementing loops (`foreach' loops) in m4 is much more tricky than it
dnl may seem.  Actually, the example of a `foreach' loop in the m4
dnl documentation is wrong: it does not quote the arguments properly,
dnl which leads to undesired expansions.
dnl
dnl The example in the documentation is:
dnl
dnl | # foreach(x, (item_1, item_2, ..., item_n), stmt)
dnl | define(`foreach',
dnl |        `pushdef(`$1', `')_foreach(`$1', `$2', `$3')popdef(`$1')')
dnl | define(`_arg1', `$1')
dnl | define(`_foreach',
dnl | 	  `ifelse(`$2', `()', ,
dnl | 		  `define(`$1', _arg1$2)$3`'_foreach(`$1', (shift$2), `$3')')')
dnl
dnl But then if you run
dnl
dnl | define(a, 1)
dnl | define(b, 2)
dnl | define(c, 3)
dnl | foreach(`f', `(`a', `(b', `c)')', `echo f
dnl | ')
dnl
dnl it gives
dnl
dnl  => echo 1
dnl  => echo (2,3)
dnl
dnl which is not what is expected.
dnl
dnl Once you understood this, you turn yourself into a quoting wizard,
dnl and come up with the following solution:
dnl
dnl | # foreach(x, (item_1, item_2, ..., item_n), stmt)
dnl | define(`foreach', `pushdef(`$1', `')_foreach($@)popdef(`$1')')
dnl | define(`_arg1', ``$1'')
dnl | define(`_foreach',
dnl |  `ifelse($2, `()', ,
dnl | 	       `define(`$1', `_arg1$2')$3`'_foreach(`$1', `(shift$2)', `$3')')')
dnl
dnl which this time answers
dnl
dnl  => echo a
dnl  => echo (b
dnl  => echo c)
dnl
dnl Bingo!


dnl M4_FOREACH(VARIABLE, LIST, EXPRESSION)
dnl --------------------------------------
dnl Expand EXPRESSION assigning to VARIABLE each value of the LIST
dnl (LIST should have the form `[(item_1, item_2, ..., item_n)]'),
dnl i.e. the whole list should be *quoted*.  Quote members too if
dnl you don't want them to be expanded.
dnl
dnl This macro is robust to active symbols:
dnl    define(active, ACTIVE)
dnl    m4_foreach([Var], [([active], [b], [active])], [-Var-])end
dnl    => -active--b--active-end
define(m4_foreach,
[pushdef([$1], [])_m4_foreach($@)popdef([$1])])

dnl Low level macros used to define m4_foreach
define(m4_car, [[$1]])
define(_m4_foreach,
[ifelse($2, [()], ,
        [define([$1], [m4_car$2])$3[]_m4_foreach([$1],
                                                 [(m4_shift$2)],
                                                 [$3])])])




dnl ### Defining macros


dnl m4 output diversions.  We let m4 output them all in order at the end,
dnl except that we explicitly undivert AC_DIVERSION_SED, AC_DIVERSION_CMDS,
dnl and AC_DIVERSION_ICMDS.

define(AC_DIVERSION_KILL, -1)dnl       	suppress output
define(AC_DIVERSION_BINSH, 0)dnl       	AC_REQUIRE'd #! /bin/sh line
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

dnl Change the diversion stream to STREAM, while stacking old values.
dnl AC_DIVERT_PUSH(STREAM)
define(AC_DIVERT_PUSH,
[pushdef([AC_DIVERSION_CURRENT], $1)dnl
divert(AC_DIVERSION_CURRENT)dnl
])

dnl Change the diversion stream to its previous value, unstacking it.
dnl AC_DIVERT_POP()
define(AC_DIVERT_POP,
[popdef([AC_DIVERSION_CURRENT])dnl
divert(AC_DIVERSION_CURRENT)dnl
])

dnl Initialize the diversion setup.
define([AC_DIVERSION_CURRENT], AC_DIVERSION_NORMAL)
dnl Throw away output until AC_INIT is called.
pushdef([AC_DIVERSION_CURRENT], AC_DIVERSION_KILL)

dnl The prologue for Autoconf macros.
dnl AC_PRO(MACRO-NAME)
define(AC_PRO,
[define([AC_PROVIDE_$1], )dnl
ifelse(AC_DIVERSION_CURRENT, AC_DIVERSION_NORMAL,
[AC_DIVERT_PUSH(m4_eval(AC_DIVERSION_CURRENT - 1))],
[pushdef([AC_DIVERSION_CURRENT], AC_DIVERSION_CURRENT)])dnl
])

dnl The Epilogue for Autoconf macros.
dnl AC_EPI()
define(AC_EPI,
[AC_DIVERT_POP()dnl
ifelse(AC_DIVERSION_CURRENT, AC_DIVERSION_NORMAL,
[undivert(AC_DIVERSION_NORMAL_4)dnl
undivert(AC_DIVERSION_NORMAL_3)dnl
undivert(AC_DIVERSION_NORMAL_2)dnl
undivert(AC_DIVERSION_NORMAL_1)dnl
])dnl
])


dnl AC_DEFUN(NAME, [REPLACED-FUNCTION, ARGUMENT, ]EXPANSION)
dnl --------------------------------------------------------
dnl Define a macro which automatically provides itself.  Add machinery
dnl so the macro automatically switches expansion to the diversion
dnl stack if it is not already using it.  In this case, once finished,
dnl it will bring back all the code accumulated in the diversion stack.
dnl This, combined with AC_REQUIRE, achieves the topological ordering of
dnl macros.  We don't use this macro to define some frequently called
dnl macros that are not involved in ordering constraints, to save m4
dnl processing.
dnl
dnl If the REPLACED-FUNCTION and ARGUMENT are defined, then declare that
dnl NAME is a specialized version of REPLACED-FUNCTION when its first
dnl argument is ARGUMENT.  For instance AC_TYPE_SIZE_T is a specialization
dnl of AC_CHECK_TYPE applied to `size_t'.
define([AC_DEFUN],
[ifelse([$3],,
[define([$1], [AC_PRO([$1])$2[]AC_EPI()])],
[define([$2-$3], [$1])
define([$1], [AC_PRO([$1])$4[]AC_EPI()])])])



dnl ### Some /bin/sh idioms

dnl AC_SHELL_IFELSE(TEST[, IF-TRUE[, IF-FALSE]])
dnl -------------------------------------------
dnl Expand into
dnl | if TEST; then
dnl | 	IF-TRUE;
dnl | else
dnl | 	IF-FALSE
dnl | fi
dnl with simplifications is IF-TRUE and/or IF-FALSE is empty.
define([AC_SHELL_IFELSE],
[ifval([$2$3],
[if [$1]; then
  ifval([$2], [$2], :)
ifval([$3],
[else
  $3
])dnl
fi
])])



dnl ### Common m4/sh handling of variables (indirections)


dnl The purpose of this section is to provide a uniform API for
dnl reading/setting sh variables with or without indirection.
dnl Typically, one can write
dnl   AC_VAR_SET(var, val)
dnl or
dnl   AC_VAR_SET(ac_$var, val)
dnl and expect the right thing to happen.

dnl AC_VAR_IF_INDIR(EXPRESSION, IF-INDIR, IF-NOT-INDIR)
dnl ---------------------------------------------------
dnl If EXPRESSION has shell indirections ($var or `expr`), expand
dnl IF-INDIR, else IF-NOT-INDIR.
define(AC_VAR_IF_INDIR,
[ifelse(regexp([$1], [[`$]]),
        -1, [$3],
        [$2])])

dnl AC_VAR_SET(VARIABLE, VALUE)
dnl ---------------------------
dnl Set the VALUE of the shell VARIABLE.
dnl If the variable contains indirections (e.g. `ac_cv_func_$ac_func')
dnl perform whenever possible at m4 level, otherwise sh level.
define(AC_VAR_SET,
[AC_VAR_IF_INDIR([$1],
                 [eval "$1=$2"],
                 [$1=$2])])


dnl AC_VAR_GET(VARIABLE)
dnl --------------------
dnl Get the value of the shell VARIABLE.
dnl Evaluates to $VARIABLE if there are no indirection in VARIABLE,
dnl else into the appropriate `eval' sequence.
define(AC_VAR_GET,
[AC_VAR_IF_INDIR([$1],
                 [`eval echo '${'patsubst($1, [[\\`]], [\\\&])'}'`],
                 [$[]$1])])


dnl AC_VAR_TEST_SET(VARIABLE)
dnl -------------------------
dnl Expands into the `test' expression which is true if VARIABLE
dnl is set.  Polymorphic.  Should be dnl'ed.
define(AC_VAR_TEST_SET,
[AC_VAR_IF_INDIR([$1],
           [eval "test \"\${$1+set}\" = set"],
           [test "${$1+set}" = set])])



dnl AC_VAR_IF_SET(VARIABLE, IF-TRUE, IF-FALSE)
dnl ------------------------------------------
dnl Implement a shell `if-then-else' depending whether VARIABLE is set
dnl or not.  Polymorphic.
define(AC_VAR_IF_SET,
[AC_SHELL_IFELSE(AC_VAR_TEST_SET([$1]), [$2], [$3])])


dnl AC_VAR_PUSHDEF and AC_VAR_POPDEF
dnl --------------------------------
dnl

dnl The idea behind these macros is that we may sometimes have to handle
dnl manifest values (e.g. `stdlib.h'), while at other moments, the same
dnl code may have to get the value from a variable (e.g., `ac_header').
dnl To have a uniform handling of both case, when a new value is about to
dnl be processed, declare a local variable, e.g.:
dnl
dnl   AC_VAR_PUSHDEF([header], [ac_cv_header_$1])
dnl
dnl and then in the body of the macro, use `header' as is.  It is of first
dnl importance to use `AC_VAR_*' to access this variable.  Don't quote its
dnl name: it must be used right away by m4.
dnl
dnl If the value `$1' was manifest (e.g. `stdlib.h'), then `header' is in
dnl fact the value `ac_cv_header_stdlib_h'.  If `$1' was indirect, then
dnl `header's value in m4 is in fact `$ac_header', the shell variable that
dnl holds all of the magic to get the expansion right.
dnl
dnl At the end of the block, free the variable with
dnl
dnl   AC_VAR_POPDEF([header])

dnl AC_VAR_PUSHDEF(VARNAME, VALUE)
dnl ------------------------------
dnl Define the m4 macro VARNAME to an accessor to the shell variable
dnl named VALUE.  VALUE does not need to be a valid shell variable name:
dnl the transliteration is handled here.  To be dnl'ed.
define(AC_VAR_PUSHDEF,
[AC_VAR_IF_INDIR([$2],
[ac_$1=AC_TR_SH($2)
pushdef([$1], [$ac_[$1]])],
[pushdef([$1], [AC_TR_SH($2)])])])

dnl AC_VAR_POPDEF(VARNAME)
dnl ----------------------
dnl Free the shell variable accessor VARNAME.  To be dnl'ed.
define(AC_VAR_POPDEF,
[popdef([$1])])


dnl ### Common m4/sh character translation

dnl The point of this section is to provide high level functions
dnl comparable to m4's `translit' primitive, but m4:sh polymorphic.
dnl Transliteration of manifest strings should be handled by m4, while
dnl shell variables' content will be translated at runtime (tr or sed).

dnl AC_TR_CPP(EXPRESSION)
dnl ---------------------
dnl Map EXPRESSION to an upper case string which is valid as rhs for a
dnl `#define'.  sh/m4 polymorphic.  Make sure to update the definition
dnl of `$ac_tr_cpp' if you change this.
define(AC_TR_CPP,
[AC_VAR_IF_INDIR([$1],
  [`echo "$1" | $ac_tr_cpp`],
  [patsubst(translit([[$1]],
                     [*abcdefghijklmnopqrstuvwxyz],
                     [PABCDEFGHIJKLMNOPQRSTUVWXYZ]),
            [[^A-Z0-9_]], [_])])])


dnl AC_TR_SH(EXPRESSION)
dnl --------------------
dnl Transform EXPRESSION into a valid shell variable name.
dnl sh/m4 polymorphic.
dnl Make sure to update the definition of `$ac_tr_sh' if you change this.
define(AC_TR_SH,
[AC_VAR_IF_INDIR([$1],
  [`echo "$1" | $ac_tr_sh`],
  [patsubst(translit([[$1]], [*+], [pp]),
            [[^a-zA-Z0-9_]], [_])])])



dnl ### Implementing Autoconf loops

dnl AC_FOREACH(VARIABLE, LIST, EXPRESSION)
dnl --------------------------------------
dnl
dnl Compute EXPRESSION assigning to VARIABLE each value of the LIST.
dnl LIST is a /bin/sh list, i.e., it has the form ` item_1 item_2
dnl ... item_n ': white spaces are separators, and leading and trailing
dnl spaces are meaningless.
dnl
dnl This macro is robust to active symbols:
dnl    AC_FOREACH([Var], [ active
dnl    b	act\
dnl    ive  ], [-Var-])end
dnl    => -active--b--active-end
define([AC_FOREACH],
[m4_foreach([$1], (m4_split(m4_strip(m4_join([$2])))), [$3])])


dnl AC_SPECIALIZE(MACRO, ARG1 [, ARGS...])
dnl --------------------------------------
dnl
dnl Basically calls the macro MACRO with arguments ARG1, ARGS... But if
dnl there exist a specialized version of MACRO for ARG1, use this macro
dnl instead with arguments ARGS (i.e., ARG1 is *not* given).  See the
dnl definition of `AC_DEFUN'.
AC_DEFUN(AC_SPECIALIZE,
[ifdef([$1-$2],
       [indir([$1-$2], m4_shift(m4_shift($@)))],
       [indir([$1], m4_shift($@))])])


dnl ## --------------------------------- ##
dnl ## Helping macros to display strings ##
dnl ## --------------------------------- ##


dnl AC_WRAP(STRING [, PREFIX[, FIRST-PREFIX[, WIDTH]]]]))
dnl -----------------------------------------------------
dnl Expands into STRING wrapped to hold in WIDTH columns (default = 79).
dnl If prefix is set, each line is prefixed with it.  If FIRST-PREFIX is
dnl specified, then the first line is prefixed with it.  As a special
dnl case, if the length of the first prefix is greater than that of
dnl PREFIX, then FIRST-PREFIX will be left alone on the first line.
dnl
dnl Typical outputs are:
dnl
dnl AC_WRAP([Short string */], [   ], [/* ], 20)
dnl  => /* Short string */
dnl
dnl AC_WRAP([Much longer string */], [   ], [/* ], 20)
dnl  => /* Much longer
dnl  =>    string */
dnl
dnl AC_WRAP([Short doc.], [          ], [  --short ], 30)
dnl  =>   --short Short doc.
dnl
dnl AC_WRAP([Short doc.], [          ], [  --too-wide ], 30)
dnl  =>   --too-wide
dnl  =>           Short doc.
dnl
dnl AC_WRAP([Super long documentation.], [          ], [  --too-wide ], 30)
dnl  =>   --too-wide
dnl  => 	  Super long
dnl  => 	  documentation.
dnl
dnl FIXME: there is no checking of a longer PREFIX than WIDTH, but do
dnl we really want to bother with people trying each single corner
dnl of a software?
dnl
dnl This macro does not leave a trailing space behind the last word,
dnl what complicates it a bit.  The algorithm is stupid simple: all the
dnl words are preceded by AC_Separator which is defined to empty for the
dnl first word, and then ` ' (single space) for all the others.
define([AC_WRAP],
[pushdef([AC_Prefix], m4_default([$2], []))dnl
pushdef([AC_Prefix1], m4_default([$3], [AC_Prefix]))dnl
pushdef([AC_Width], m4_default([$4], 79))dnl
pushdef([AC_Cursor], len(AC_Prefix1))dnl
pushdef([AC_Separator], [])dnl
AC_Prefix1[]dnl
ifelse(m4_eval(AC_Cursor > len(AC_Prefix)),
       1, [define([AC_Cursor], len(AC_Prefix))
AC_Prefix])[]dnl
AC_FOREACH([AC_Word], [$1],
[define([AC_Cursor], m4_eval(AC_Cursor + len(AC_Word) + 1))dnl
dnl New line if too long, else insert a space unless it is the first
dnl of the words.
ifelse(m4_eval(AC_Cursor > AC_Width),
       1, [define([AC_Cursor], m4_eval(len(AC_Prefix) + len(AC_Word) + 1))]
AC_Prefix,
       [AC_Separator])[]dnl
AC_Word[]dnl
define([AC_Separator], [ ])])dnl
popdef([AC_Separator])dnl
popdef([AC_Cursor])dnl
popdef([AC_Width])dnl
popdef([AC_Prefix1])dnl
popdef([AC_Prefix])dnl
])


dnl AC_HELP_STRING(LHS, RHS[, COLUMN])
dnl ----------------------------------
dnl
dnl Format an Autoconf macro's help string so that it looks pretty when
dnl the user executes "configure --help".  This macro takes three
dnl arguments, a "left hand side" (LHS), a "right hand side" (RHS), and
dnl the COLUMN which is a string of white spaces which leads to the
dnl the RHS column (default: 26 white spaces).
dnl
dnl The resulting string is suitable for use in other macros that require
dnl a help string (e.g. AC_ARG_WITH).
dnl
dnl Here is the sample string from the Autoconf manual (Node: External
dnl Software) which shows the proper spacing for help strings.
dnl
dnl    --with-readline         support fancy command line editing
dnl  ^ ^                       ^
dnl  | |                       |
dnl  | column 2                column 26
dnl  |
dnl  column 0
dnl
dnl A help string is made up of a "left hand side" (LHS) and a "right
dnl hand side" (RHS).  In the example above, the LHS is
dnl "--with-readline", while the RHS is "support fancy command line
dnl editing".
dnl
dnl If the LHS extends past column 24, then the LHS is terminated with a
dnl newline so that the RHS is on a line of its own beginning in column
dnl 26.
dnl
dnl Therefore, if the LHS were instead "--with-readline-blah-blah-blah",
dnl then the AC_HELP_STRING macro would expand into:
dnl
dnl
dnl    --with-readline-blah-blah-blah
dnl  ^ ^                       support fancy command line editing
dnl  | |                       ^
dnl  | column 2                |
dnl  column 0                  column 26
dnl
define([AC_HELP_STRING],
[pushdef([AC_Prefix], m4_default([$3], [                          ]))dnl
pushdef([AC_Prefix_Format], [  %-]m4_eval(len(AC_Prefix) - 3)[s ])dnl [  %-23s ]
AC_WRAP([$2], AC_Prefix, m4_format(AC_Prefix_Format, [$1]))dnl
popdef([AC_Prefix_Format])dnl
popdef([AC_Prefix])dnl
])

dnl ### Initialization


dnl AC_INIT_NOTICE
dnl --------------
AC_DEFUN(AC_INIT_NOTICE,
[# Guess values for system-dependent variables and create Makefiles.
# Generated automatically using Autoconf version] AC_ACVERSION [
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


dnl AC_PREFIX_DEFAULT(PREFIX)
dnl -------------------------
AC_DEFUN(AC_PREFIX_DEFAULT,
[AC_DIVERT_PUSH(AC_DIVERSION_NOTICE)dnl
ac_default_prefix=$1
AC_DIVERT_POP()])


dnl AC_INIT_PARSE_ARGS
dnl ------------------
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


dnl AC_INIT_BINSH
dnl -------------
dnl Try to have only one #! line, so the script doesn't look funny
dnl for users of AC_REVISION.
AC_DEFUN(AC_INIT_BINSH,
[AC_DIVERT_PUSH(AC_DIVERSION_BINSH)dnl
#! /bin/sh
AC_DIVERT_POP()dnl to KILL
])


dnl AC_INCLUDE(FILE)
dnl ----------------
dnl Wrapper around m4_include.
define(AC_INCLUDE,
[m4_include([$1])])

dnl AC_INCLUDES((FILE, ...))
dnl ------------------------
define(AC_INCLUDES,
[m4_foreach([File], [$1], [AC_INCLUDE(File)])])


dnl AC_INIT(UNIQUE-FILE-IN-SOURCE-DIR)
dnl ----------------------------------
dnl Output the preamble of the `configure' script.
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



dnl AC_INIT_PREPARE(UNIQUE-FILE-IN-SOURCE-DIR)
dnl ------------------------------------------
dnl Called by AC_INIT to build the preamble of the `configure' scripts.
dnl 1. Trap and clean up various tmp files.
dnl 2. Set up the fd and output files
dnl 3. Remember the options given to `configure' for `config.status --recheck'.
dnl 4. Ensure a correct environment
dnl 5. Find `$srcdir', and check its validity by verifying the presence of
dnl    UNIQUE-FILE-IN-SOURCE-DIR.
dnl 6. Required macros (cache, default AC_SUBST etc.)
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


dnl AC_ARG_ENABLE(FEATURE, HELP-STRING, ACTION-IF-TRUE [, ACTION-IF-FALSE])
dnl -----------------------------------------------------------------------
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


dnl ### Working with optional software


dnl AC_ARG_WITH(PACKAGE, HELP-STRING, ACTION-IF-TRUE [, ACTION-IF-FALSE])
dnl ---------------------------------------------------------------------
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



dnl ### Remembering env vars for reconfiguring


dnl AC_ARG_VAR(VARNAME, DOCUMENTATION)
dnl ----------------------------------
dnl Register VARNAME as a variable configure should remember, and
dnl document it in --help.
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



dnl ### Transforming program names.


dnl AC_ARG_PROGRAM()
dnl ----------------
dnl FIXME: Must be run only once.  Introduce AC_DEFUN_ONCE?
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


dnl ### Version numbers


dnl AC_REVISION(REVISION-INFO)
AC_DEFUN(AC_REVISION,
[AC_REQUIRE([AC_INIT_BINSH])dnl
AC_DIVERT_PUSH(AC_DIVERSION_BINSH)dnl
[# From configure.in] translit([$1], $")
AC_DIVERT_POP()dnl to KILL
])

dnl Subroutines of AC_PREREQ.

dnl m4_compare(VERSION-1, VERSION-2)
dnl --------------------------------
dnl Compare the two version numbers and expand into
dnl  -1 if VERSION-1 < VERSION-2
dnl   0 if           =
dnl   1 if           >
dnl The handling of the special values [[]] is a pain, but seems necessary.
dnl This macro is a excellent tutorial on the order of evaluation of ifelse.
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


dnl AC_UNGNITS(VERSION)
dnl -------------------
dnl Replace .a, .b etc. by .0.1, .0.2 in VERSION.  For instance, version
dnl 2.14a is understood as 2.14.0.1 for version comparison.
dnl This macro is absolutely not robust to active macro, it expects
dnl reasonable version numbers.
dnl Warning: Valid up to `z', no double letters.
define(AC_UNGNITS,
[translit(patsubst(patsubst(patsubst([$1],
                                     [\([abcdefghi]\)], [.0.\1]),
                            [\([jklmnopqrs]\)], [.0.1\1]),
          [\([tuvwxyz]\)], [.0.2\1]),
          abcdefghijklmnopqrstuvwxyz,
          12345678901234567890123456)])


dnl AC_PREREQ(VERSION)
dnl ------------------
dnl Complain and exit if the Autoconf version is less than VERSION.
define(AC_PREREQ,
[ifelse(m4_compare(m4_split(AC_UNGNITS([$1]),         [\.]),
                   m4_split(AC_UNGNITS(AC_ACVERSION), [\.])), -1,
       [AC_FATAL(Autoconf version $1 or higher is required for this script)])])




dnl ### Getting the canonical system type


dnl AC_CONFIG_AUX_DIR(DIR)
dnl ----------------------
dnl Find install-sh, config.sub, config.guess, and Cygnus configure
dnl in directory DIR.  These are auxiliary files used in configuration.
dnl DIR can be either absolute or relative to $srcdir.
AC_DEFUN(AC_CONFIG_AUX_DIR,
[AC_CONFIG_AUX_DIRS($1 $srcdir/$1)])

dnl The default is `$srcdir' or `$srcdir/..' or `$srcdir/../..'.
dnl There's no need to call this macro explicitly; just AC_REQUIRE it.
AC_DEFUN(AC_CONFIG_AUX_DIR_DEFAULT,
[AC_CONFIG_AUX_DIRS($srcdir $srcdir/.. $srcdir/../..)])

dnl AC_CONFIG_AUX_DIRS(DIR ...)
dnl ---------------------------
dnl Internal subroutine.
dnl Search for the configuration auxiliary files in directory list $1.
dnl We look only for install-sh, so users of AC_PROG_INSTALL
dnl do not automatically need to distribute the other auxiliary files.
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


dnl Canonicalize the host, target, and build system types.
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

dnl Subroutines of AC_CANONICAL_SYSTEM.

dnl Worker routine for AC_CANONICAL_{HOST TARGET BUILD}.  THING is one of
dnl `host', `target', or `build'.  Canonicalize the appropriate thing,
dnl generating the variables THING, THING_{alias cpu vendor os}, and the
dnl associated cache entries.  We also redo the cache entries if the user
dnl specifies something different from ac_cv_$THING_alias on the command line.

dnl AC_CANONICAL_THING(THING)
dnl -------------------------
AC_DEFUN(AC_CANONICAL_THING,
[AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl

ifelse($1, [host], ,AC_REQUIRE([AC_CANONICAL_HOST]))dnl
AC_MSG_CHECKING([$1 system type])
if test "x$ac_cv_$1" = "x" || (test "x$$1" != "xNONE" && test "x$$1" != "x$ac_cv_$1_alias"); then

# Make sure we can run config.sub.
  if $ac_config_sub sun4 >/dev/null 2>&1; then :
    else AC_MSG_ERROR(cannot run $ac_config_sub)
  fi

dnl Set $1_alias.
  ac_cv_$1_alias=$$1
  case "$ac_cv_$1_alias" in
  NONE)
    case $nonopt in
    NONE)
ifelse($1, [host],[dnl
      if ac_cv_$1_alias=`$ac_config_guess`; then :
      else AC_MSG_ERROR(cannot guess $1 type; you must specify one)
      fi ;;],[dnl
      ac_cv_$1_alias=$host_alias ;;
])
    *) ac_cv_$1_alias=$nonopt ;;
    esac ;;
  esac

dnl Set the other $[1] vars.
  ac_cv_$1=`$ac_config_sub $ac_cv_$1_alias`
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

AC_PROVIDE([$0])
])dnl AC_CANONICAL_THING

AC_DEFUN(AC_CANONICAL_HOST, [AC_CANONICAL_THING([host])])

dnl Internal use only.
AC_DEFUN(AC_CANONICAL_TARGET, [AC_CANONICAL_THING([target])])
AC_DEFUN(AC_CANONICAL_BUILD, [AC_CANONICAL_THING([build])])


dnl AC_VALIDATE_CACHED_SYSTEM_TUPLE([CMD])
dnl --------------------------------------
dnl If the cache file is inconsistent with the current host,
dnl target and build system types, execute CMD or print a default
dnl error message.
AC_DEFUN(AC_VALIDATE_CACHED_SYSTEM_TUPLE,
[
  AC_REQUIRE([AC_CANONICAL_SYSTEM])dnl
  AC_MSG_CHECKING([cached system tuple])
  if { test x"${ac_cv_host_system_type+set}" = x"set" &&
       test x"$ac_cv_host_system_type" != x"$host"; } ||
     { test x"${ac_cv_build_system_type+set}" = x"set" &&
       test x"$ac_cv_build_system_type" != x"$build"; } ||
     { test x"${ac_cv_target_system_type+set}" = x"set" &&
       test x"$ac_cv_target_system_type" != x"$target"; }; then
      AC_MSG_RESULT([different])
      ifelse($#, 1, [$1],
        [AC_MSG_ERROR([remove config.cache and re-run configure])])
  else
    AC_MSG_RESULT(ok)
  fi
  ac_cv_host_system_type="$host"
  ac_cv_build_system_type="$build"
  ac_cv_target_system_type="$target"
])


dnl ### Caching test results


dnl AC_SITE_LOAD
dnl ------------
dnl Look for site or system specific initialization scripts.
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


dnl AC_CACHE_LOAD
dnl -------------
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


dnl AC_CACHE_SAVE()
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
if cmp -s $cache_file confcache; then
  :
else
  if test -w $cache_file; then
    echo "updating cache $cache_file"
    cat confcache >$cache_file
  else
    echo "not updating unwritable cache $cache_file"
  fi
fi
rm -f confcache
])

dnl AC_CACHE_VAL(CACHE-ID, COMMANDS-TO-SET-IT)
dnl ------------------------------------------
dnl
dnl The name of shell var CACHE-ID must contain `_cv_' in order to get saved.
dnl Should be dnl'ed.
define(AC_CACHE_VAL,
[dnl We used to use the below line, but it fails if the 1st arg is a
dnl shell variable, so we need the eval.
dnl if test "${$1+set}" = set; then
AC_VAR_IF_SET([$1],
              [echo $ac_n "(cached) $ac_c" 1>&AC_FD_MSG],
              [$2])])


dnl AC_CACHE_CHECK(MESSAGE, CACHE-ID, COMMANDS)
dnl -------------------------------------------
dnl Do not call this macro with a dnl right behind.
define(AC_CACHE_CHECK,
[AC_MSG_CHECKING([$1])
AC_CACHE_VAL([$2], [$3])dnl
AC_MSG_RESULT_UNQUOTED(AC_VAR_GET([$2]))])


dnl ### Defining symbols


dnl AC_DEFINE(VARIABLE, [VALUE], [DESCRIPTION])
dnl -------------------------------------------
dnl Set VARIABLE to VALUE, verbatim, or 1.  Remember the value
dnl and if VARIABLE is affected the same VALUE, do nothing, else
dnl die.  The third argument is used by autoheader.
define(AC_DEFINE,
[cat >>confdefs.h <<\EOF
[#define] $1 ifelse($#, 2, [$2], $#, 3, [$2], 1)
EOF
])



dnl AC_DEFINE_UNQUOTED(VARIABLE, [VALUE], [DESCRIPTION])
dnl ----------------------------------------------------
dnl Similar, but perform shell substitutions $ ` \ once on VALUE.
define(AC_DEFINE_UNQUOTED,
[cat >>confdefs.h <<EOF
[#define] $1 ifelse($#, 2, [$2], $#, 3, [$2], 1)
EOF
])



dnl ### Setting output variables


dnl AC_SUBST(VARIABLE)
dnl ------------------
dnl This macro protects VARIABLE from being diverted twice
dnl if this macro is called twice for it.
dnl Beware that if you change this macro, you also have to change the
dnl sed script at the top of AC_OUTPUT_FILES.
define(AC_SUBST,
[ifdef([AC_SUBST_$1], ,
[define([AC_SUBST_$1], )dnl
AC_DIVERT_PUSH(AC_DIVERSION_SED)dnl
s%@$1@%[$]$1%;t t
AC_DIVERT_POP()dnl
])])

dnl AC_SUBST_FILE(VARIABLE)
dnl -----------------------
dnl Read the comments of the preceding macro.
define(AC_SUBST_FILE,
[ifdef([AC_SUBST_$1], ,
[define([AC_SUBST_$1], )dnl
AC_DIVERT_PUSH(AC_DIVERSION_SED)dnl
/@$1@/r [$]$1
s%@$1@%%;t t
AC_DIVERT_POP()dnl
])])



dnl ### Printing messages at autoconf runtime

dnl AC_WARNING(MESSAGE)
define(AC_WARNING, [m4_warn([$1])])

dnl AC_FATAL(MESSAGE, [EXIT-STATUS])
define(AC_FATAL, [m4_fatal([$1], [$2])])


dnl ### Printing messages at configure runtime

dnl _AC_SH_QUOTE(STRING)
dnl --------------------
dnl If there are quoted (via backslash) backquotes do nothing, else
dnl backslash all the quotes.  This macro is robust to active symbols.
dnl Both cases (with or without back quotes) *must* evaluate STRING the
dnl same number of times.
dnl
dnl   | define(active, ACTIVE)
dnl   | _AC_SH_QUOTE([`active'])
dnl   | => \`active'
dnl   | _AC_SH_QUOTE([\`active'])
dnl   | => \`active'
dnl   | error-->c.in:8: warning: backquotes should not be backslashed\
dnl   ...                        in: \`active'
dnl
define(_AC_SH_QUOTE,
[ifelse(regexp([[$1]], [\\`]),
        -1, [patsubst([[$1]], [`], [\\`])],
        [AC_WARNING([backquotes should not be backslashed in: $1])dnl
[$1]])])

dnl _AC_ECHO_UNQUOTED(STRING [ , FD ])
dnl Expands into a sh call to echo onto FD (default is AC_FD_MSG).
dnl The shell performs its expansions on STRING.
define([_AC_ECHO_UNQUOTED],
[echo "[$1]" 1>&ifelse($2,, AC_FD_MSG, $2)])

dnl _AC_ECHO(STRING [ , FD ])
dnl Expands into a sh call to echo onto FD (default is AC_FD_MSG),
dnl protecting STRING from backquote expansion.
define([_AC_ECHO],
[_AC_ECHO_UNQUOTED(_AC_SH_QUOTE([$1]), $2)])

dnl _AC_ECHO_N(STRING [ , FD ])
dnl Same as _AC_ECHO, but echo doesn't return to a new line.
define(_AC_ECHO_N,
[echo $ac_n "_AC_SH_QUOTE($1)$ac_c" 1>&ifelse($2,,AC_FD_MSG,$2)])

dnl AC_MSG_CHECKING(FEATURE-DESCRIPTION)
define(AC_MSG_CHECKING,
[_AC_ECHO_N([checking $1... ])
_AC_ECHO([configure:__oline__: checking $1], AC_FD_CC)])

dnl AC_CHECKING(FEATURE-DESCRIPTION)
define(AC_CHECKING,
[_AC_ECHO([checking $1])
_AC_ECHO([configure:__oline__: checking $1], AC_FD_CC)])

dnl AC_MSG_RESULT(RESULT-DESCRIPTION)
define(AC_MSG_RESULT,
[_AC_ECHO([$ac_t""$1])])

dnl AC_MSG_RESULT_UNQUOTED(RESULT-DESCRIPTION)
dnl Likewise, but perform $ ` \ shell substitutions.
define(AC_MSG_RESULT_UNQUOTED,
[_AC_ECHO_UNQUOTED([$ac_t""$1])])

dnl AC_VERBOSE(RESULT-DESCRIPTION)
define(AC_VERBOSE,
[AC_OBSOLETE([$0], [; instead use AC_MSG_RESULT])dnl
_AC_ECHO([	$1])])

dnl AC_MSG_WARN(PROBLEM-DESCRIPTION)
define(AC_MSG_WARN,
[_AC_ECHO([configure: warning: $1], 2)])

dnl AC_MSG_ERROR(ERROR-DESCRIPTION)
define(AC_MSG_ERROR,
[{ _AC_ECHO([configure: error: $1], 2); exit 1; }])

dnl AC_MSG_ERROR_UNQUOTED(ERROR-DESCRIPTION)
define(AC_MSG_ERROR_UNQUOTED,
[{ _AC_ECHO_UNQUOTED([configure: error: $1], 2); exit 1; }])


dnl ### Selecting which language to use for testing


dnl AC_LANG_C
dnl ---------
AC_DEFUN(AC_LANG_C,
[define([AC_LANG], [C])dnl
ac_ext=c
# CFLAGS is not in ac_cpp because -g, -O, etc. are not valid cpp options.
ac_cpp='$CPP $CPPFLAGS'
ac_compile='${CC-cc} -c $CFLAGS $CPPFLAGS conftest.$ac_ext 1>&AC_FD_CC'
ac_link='${CC-cc} -o conftest${ac_exeext} $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS 1>&AC_FD_CC'
cross_compiling=$ac_cv_prog_cc_cross
])

dnl AC_LANG_CPLUSPLUS
dnl -----------------
AC_DEFUN(AC_LANG_CPLUSPLUS,
[define([AC_LANG], [CPLUSPLUS])dnl
ac_ext=C
# CXXFLAGS is not in ac_cpp because -g, -O, etc. are not valid cpp options.
ac_cpp='$CXXCPP $CPPFLAGS'
ac_compile='${CXX-g++} -c $CXXFLAGS $CPPFLAGS conftest.$ac_ext 1>&AC_FD_CC'
ac_link='${CXX-g++} -o conftest${ac_exeext} $CXXFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS 1>&AC_FD_CC'
cross_compiling=$ac_cv_prog_cxx_cross
])

dnl AC_LANG_FORTRAN77
dnl -----------------
AC_DEFUN(AC_LANG_FORTRAN77,
[define([AC_LANG], [FORTRAN77])dnl
ac_ext=f
ac_compile='${F77-f77} -c $FFLAGS conftest.$ac_ext 1>&AC_FD_CC'
ac_link='${F77-f77} -o conftest${ac_exeext} $FFLAGS $LDFLAGS conftest.$ac_ext $LIBS 1>&AC_FD_CC'
cross_compiling=$ac_cv_prog_f77_cross
])

dnl AC_LANG_SAVE
dnl ------------
dnl Push the current language on a stack.
define(AC_LANG_SAVE,
[pushdef([AC_LANG_STACK], AC_LANG)])

dnl AC_LANG_RESTORE
dnl ---------------
dnl Restore the current language from the stack.
pushdef([AC_LANG_RESTORE],
[ifelse(AC_LANG_STACK, [C], [AC_LANG_C],dnl
AC_LANG_STACK, [CPLUSPLUS], [AC_LANG_CPLUSPLUS],dnl
AC_LANG_STACK, [FORTRAN77], [AC_LANG_FORTRAN77])[]popdef([AC_LANG_STACK])])


dnl ### Compiler-running mechanics


dnl AC_TRY_EVAL(VARIABLE)
dnl ---------------------
dnl The purpose of this macro is to "configure:123: command line"
dnl written into config.log for every test run.
AC_DEFUN(AC_TRY_EVAL,
[{ (eval echo configure:__oline__: \"[$]$1\") 1>&AC_FD_CC; dnl
(eval [$]$1) 2>&AC_FD_CC; }])

dnl AC_TRY_COMMAND(COMMAND)
dnl -----------------------
AC_DEFUN(AC_TRY_COMMAND,
[{ ac_try='$1'; AC_TRY_EVAL(ac_try); }])


dnl ### Dependencies between macros


dnl AC_BEFORE(THIS-MACRO-NAME, CALLED-MACRO-NAME)
dnl ---------------------------------------------
define(AC_BEFORE,
[ifdef([AC_PROVIDE_$2], [AC_WARNING([$2 was called before $1])])])

dnl AC_REQUIRE(MACRO-NAME)
dnl ----------------------
define(AC_REQUIRE,
[ifdef([AC_PROVIDE_$1], ,
[AC_DIVERT_PUSH(m4_eval(AC_DIVERSION_CURRENT - 1))dnl
indir([$1])
AC_DIVERT_POP()dnl
])])

dnl AC_PROVIDE(MACRO-NAME)
dnl ----------------------
define(AC_PROVIDE,
[define([AC_PROVIDE_$1], )])

dnl AC_OBSOLETE(THIS-MACRO-NAME [, SUGGESTION])
dnl -------------------------------------------
define(AC_OBSOLETE,
[AC_WARNING([$1] is obsolete[$2])])

dnl AC_HASBEEN(THIS-MACRO-NAME [, SUGGESTION])
dnl ------------------------------------------
define(AC_HASBEEN,
[AC_FATAL([$1] is obsolete[$2])])



dnl ### Generic structure checks

dnl AC_CHECK_MEMBER(AGGREGATE.MEMBER,
dnl                 [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
dnl                 [INCLUDES])
dnl ---------------------------------------------------------
dnl AGGREGATE.MEMBER is for instance `struct passwd.pw_gecos', shell
dnl variables are not a valid argument.
AC_DEFUN(AC_CHECK_MEMBER,
[AC_REQUIRE([AC_HEADER_STDC])dnl
AC_VAR_PUSHDEF([ac_Member], [ac_cv_member_$1])dnl
dnl Extract the aggregate name, and the member name
AC_VAR_IF_INDIR([$1],
[AC_FATAL([$0: requires manifest arguments])],
[ifelse(regexp([$1], [\.]), -1,
        [AC_FATAL([$0: Did not see any dot in `$1'])])dnl
pushdef(AC_Member_Aggregate, [patsubst([$1], [\.[^.]*])])dnl
pushdef(AC_Member_Member,     [patsubst([$1], [.*\.])])])dnl
AC_CACHE_CHECK([for $1], ac_Member,
[AC_TRY_COMPILE(AC_INCLUDES_DEFAULT([$4]),
ac_Member_Aggregate foo;
foo.ac_Member_Member;,
                AC_VAR_SET(ac_Member, yes),
                AC_VAR_SET(ac_Member, no))])
AC_SHELL_IFELSE(test AC_VAR_GET(ac_Member) = yes,
                [$2], [$3])dnl
popdef([AC_Member_Member])dnl
popdef([AC_Member_Aggregate])dnl
AC_VAR_POPDEF([ac_Member])dnl
])dnl AC_CHECK_MEMBER


dnl AC_CHECK_MEMBER((AGGREGATE.MEMBER, ...),
dnl                 [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND]
dnl                 [INCLUDES])
dnl --------------------------------------------------------
dnl The first argument is an m4 list.  First because we want to
dnl promote m4 lists, and second because anyway there can be spaces
dnl in some types (struct etc.).
AC_DEFUN(AC_CHECK_MEMBERS,
[m4_foreach([AC_Member], [$1],
  [AC_SPECIALIZE([AC_CHECK_MEMBER], AC_Member,
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_[]AC_Member))
$2],
                 [$3],
                 [$4])])])



dnl ### Default headers.

dnl Always use the same set of default headers for all the generic macros.
dnl It is easier to document, to extend, and to understand than having
dnl specific defaults for each macro.

dnl AC_INCLUDES_DEFAULT([INCLUDES])
dnl -------------------------------
dnl If INCLUDES is empty, expand in default includes, otherwise in
dnl INCLUDES.
define(AC_INCLUDES_DEFAULT,
[m4_default([$1],
[#include <stdio.h>
#ifdef HAVE_STRING_H
# if !STDC_HEADERS && HAVE_MEMORY_H
#  include <memory.h>
# endif
# include <string.h>
#else
# ifdef HAVE_STRINGS_H
#  include <strings.h>
# endif
#endif
#if STDC_HEADERS
# include <stdlib.h>
# include <stddef.h>
#else
# ifdef HAVE_STDLIB_H
#  include <stdlib.h>
# endif
#endif
#ifdef HAVE_UNISTD_H
# include <unistd.h>
#endif
])])


dnl ### Checking for programs


dnl AC_CHECK_PROG(VARIABLE, PROG-TO-CHECK-FOR,
dnl               [VALUE-IF-FOUND], [VALUE-IF-NOT-FOUND],
dnl               [PATH], [REJECT])
dnl -----------------------------------------------------
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


dnl AC_CHECK_PROGS(VARIABLE, PROGS-TO-CHECK-FOR [, VALUE-IF-NOT-FOUND
dnl                [, PATH]])
dnl -----------------------------------------------------------------
AC_DEFUN(AC_CHECK_PROGS,
[for ac_prog in $2
do
AC_CHECK_PROG($1, [$]ac_prog, [$]ac_prog, , $4)
test -n "[$]$1" && break
done
ifelse([$3], , , [test -n "[$]$1" || $1="$3"
])])


dnl AC_PATH_PROG(VARIABLE, PROG-TO-CHECK-FOR [, VALUE-IF-NOT-FOUND [, PATH]])
dnl -------------------------------------------------------------------------
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


dnl AC_PATH_PROGS(VARIABLE, PROGS-TO-CHECK-FOR [, VALUE-IF-NOT-FOUND
dnl               [, PATH]])
dnl ----------------------------------------------------------------
AC_DEFUN(AC_PATH_PROGS,
[for ac_prog in $2
do
AC_PATH_PROG($1, [$]ac_prog, , $4)
test -n "[$]$1" && break
done
ifelse([$3], , , [test -n "[$]$1" || $1="$3"
])])




dnl ### Checking for tools

dnl Internal subroutine.
AC_DEFUN(AC_CHECK_TOOL_PREFIX,
[AC_REQUIRE([AC_CANONICAL_HOST])AC_REQUIRE([AC_CANONICAL_BUILD])dnl
if test $host != $build; then
  ac_tool_prefix=${host_alias}-
else
  ac_tool_prefix=
fi
])

dnl AC_PATH_TOOL(VARIABLE, PROG-TO-CHECK-FOR[, VALUE-IF-NOT-FOUND [, PATH]])
dnl ------------------------------------------------------------------------
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

dnl AC_CHECK_TOOL(VARIABLE, PROG-TO-CHECK-FOR[, VALUE-IF-NOT-FOUND [, PATH]])
dnl -------------------------------------------------------------------------
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


dnl AC_PREFIX_PROGRAM(PROGRAM)
dnl --------------------------
dnl Guess the value for the `prefix' variable by looking for
dnl the argument program along PATH and taking its parent.
dnl Example: if the argument is `gcc' and we find /usr/local/gnu/bin/gcc,
dnl set `prefix' to /usr/local/gnu.
dnl This comes too late to find a site file based on the prefix,
dnl and it might use a cached value for the path.
dnl No big loss, I think, since most configures don't use this macro anyway.
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


dnl AC_TRY_COMPILER(TEST-PROGRAM, WORKING-VAR, CROSS-VAR)
dnl -----------------------------------------------------
dnl Try to compile, link and execute TEST-PROGRAM.  Set WORKING-VAR to
dnl `yes' if the current compiler works, otherwise set it ti `no'.  Set
dnl CROSS-VAR to `yes' if the compiler and linker produce non-native
dnl executables, otherwise set it to `no'.  Before calling
dnl `AC_TRY_COMPILER()', call `AC_LANG_*' to set-up for the right
dnl language.
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


dnl ### Checking for libraries


dnl AC_TRY_LINK_FUNC(func, action-if-found, action-if-not-found)
dnl ------------------------------------------------------------
dnl Try to link a program that calls FUNC, handling GCC builtins.  If
dnl the link succeeds, execute ACTION-IF-FOUND; otherwise, execute
dnl ACTION-IF-NOT-FOUND.

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


dnl AC_SEARCH_LIBS(FUNCTION, SEARCH-LIBS
dnl                [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND
dnl                [, OTHER-LIBRARIES]]])
dnl --------------------------------------------------------
dnl Search for a library defining FUNC, if it's not already available.

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



dnl AC_CHECK_LIB(LIBRARY, FUNCTION [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND
dnl              [, OTHER-LIBRARIES]]])
dnl ------------------------------------------------------------------------
dnl Use a cache variable name containing both the library and function name,
dnl because the test really is for library $1 defining function $2, not
dnl just for library $1.  Separate tests with the same $1 and different $2s
dnl may have different results.
dnl
dnl FIXME: This macro is extremely suspicious.  It DEFINEs unconditionnally,
dnl whatever the FUNCTION, in addition to not being a *S macro.  Note
dnl that the cache does depend upon the function with look for.
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
AC_SHELL_IFELSE(test AC_VAR_GET(ac_Lib) = yes,
                m4_default([$3],
                           [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_LIB$1))
  LIBS="-l$1 $LIBS"
]),
                [$4])dnl
AC_VAR_POPDEF([ac_Lib])dnl
])dnl AC_CHECK_LIB



dnl AC_HAVE_LIBRARY
dnl ---------------
AC_DEFUN(AC_HAVE_LIBRARY,
[AC_HASBEEN([$0], [; instead use AC_CHECK_LIB])])


dnl ### Examining declarations


dnl AC_TRY_CPP(INCLUDES, [ACTION-IF-TRUE [, ACTION-IF-FALSE]])
dnl ----------------------------------------------------------
dnl INCLUDES are not defaulted.
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

dnl AC_EGREP_HEADER(PATTERN, HEADER-FILE, ACTION-IF-FOUND [,
dnl                 ACTION-IF-NOT-FOUND])
dnl --------------------------------------------------------
AC_DEFUN(AC_EGREP_HEADER,
[AC_EGREP_CPP([$1], [#include <$2>], [$3], [$4])])

dnl Because this macro is used by AC_PROG_GCC_TRADITIONAL, which must
dnl come early, it is not included in AC_BEFORE checks.
dnl AC_EGREP_CPP(PATTERN, PROGRAM, [ACTION-IF-FOUND [,
dnl              ACTION-IF-NOT-FOUND]])
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


dnl ### Examining syntax


dnl AC_TRY_COMPILE(INCLUDES, FUNCTION-BODY,
dnl                [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl --------------------------------------------------------
dnl Should INCLUDES be defaulted here?
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


dnl ### Examining libraries


dnl AC_COMPILE_CHECK(ECHO-TEXT, INCLUDES, FUNCTION-BODY,
dnl                  ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
dnl ---------------------------------------------------------
AC_DEFUN(AC_COMPILE_CHECK,
[AC_OBSOLETE([$0], [; instead use AC_TRY_COMPILE or AC_TRY_LINK, and AC_MSG_CHECKING and AC_MSG_RESULT])dnl
ifelse([$1], , , [AC_CHECKING([for $1])
])dnl
AC_TRY_LINK([$2], [$3], [$4], [$5])
])

dnl AC_TRY_LINK(INCLUDES, FUNCTION-BODY,
dnl             [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl -----------------------------------------------------
dnl Should the INCLUDES be defaulted here?
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


dnl ### Checking for run-time features


dnl AC_TRY_RUN(PROGRAM, [ACTION-IF-TRUE], [ACTION-IF-FALSE],
dnl            [ACTION-IF-CROSS-COMPILING])
dnl --------------------------------------------------------
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


dnl AC_TRY_RUN_NATIVE(PROGRAM, [ACTION-IF-TRUE], [ACTION-IF-FALSE])
dnl ---------------------------------------------------------------
dnl Like AC_TRY_RUN but assumes a native-environment (non-cross) compiler.
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


dnl ### Checking for header files


dnl AC_CHECK_HEADER(HEADER-FILE, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
dnl -----------------------------------------------------------------------
AC_DEFUN(AC_CHECK_HEADER,
[AC_VAR_PUSHDEF([ac_Header], [ac_cv_header_$1])dnl
AC_CACHE_CHECK([for $1], ac_Header,
[AC_TRY_CPP([#include <$1>],
AC_VAR_SET(ac_Header, yes), AC_VAR_SET(ac_Header, no))])
AC_SHELL_IFELSE(test AC_VAR_GET(ac_Header) = yes,
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_Header])dnl
])dnl AC_CHECK_HEADER


dnl AC_CHECK_HEADERS(HEADER-FILE...
dnl                  [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
dnl -------------------------------------------------------------
AC_DEFUN(AC_CHECK_HEADERS,
[for ac_header in $1
do
AC_CHECK_HEADER($ac_header,
                [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_$ac_header)) $2],
                [$3])dnl
done
])


dnl ### Checking for the existence of files

dnl AC_CHECK_FILE(FILE, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
dnl --------------------------------------------------------------
dnl
dnl Check for the existence of FILE.
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

dnl AC_CHECK_FILES(FILE... [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
AC_DEFUN(AC_CHECK_FILES,
[AC_FOREACH([AC_FILE_NAME], [$1],
  [AC_SPECIALIZE([AC_CHECK_FILE], AC_FILE_NAME,
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_[]AC_FILE_NAME))
$2],
                 [$3])])])


dnl ### Checking for declared symbols


dnl AC_CHECK_DECL(SYMBOL,
dnl               [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
dnl               [INCLUDES])
dnl -------------------------------------------------------
dnl Check if SYMBOL (a variable or a function) is declared.
AC_DEFUN([AC_CHECK_DECL],
[AC_VAR_PUSHDEF([ac_Symbol], [ac_cv_have_decl_$1])dnl
AC_CACHE_CHECK([whether $1 is declared], ac_Symbol,
[AC_TRY_COMPILE(AC_INCLUDES_DEFAULT([$4]),
[#ifndef $1
  char *p = (char *) $1;
#endif
],
AC_VAR_SET(ac_Symbol, yes), AC_VAR_SET(ac_Symbol, no))])
AC_SHELL_IFELSE(test AC_VAR_GET(ac_Symbol) = yes,
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_Symbol])dnl
])dnl AC_CHECK_DECL


dnl AC_CHECK_DECLS(SYMBOL,
dnl                [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
dnl                [INCLUDES])
dnl --------------------------------------------------------
AC_DEFUN([AC_CHECK_DECLS],
[AC_FOREACH([AC_Symbol], [$1],
  [AC_SPECIALIZE([AC_CHECK_DECL], AC_Symbol,
                 [$2],
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP([NEED_]AC_Symbol[_DECL]))
$3],
                 [$4])])
])dnl AC_CHECK_DECLS


dnl ### Checking for library functions


dnl AC_CHECK_FUNC(FUNCTION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
dnl ------------------------------------------------------------------
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
AC_SHELL_IFELSE(test AC_VAR_GET(ac_var) = yes,
               [$2], [$3])dnl
AC_VAR_POPDEF([ac_var])dnl
])dnl AC_CHECK_FUNC

dnl AC_CHECK_FUNCS(FUNCTION... [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
AC_DEFUN(AC_CHECK_FUNCS,
[for ac_func in $1
do
AC_CHECK_FUNC($ac_func,
              [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_$ac_func)) $2],
              [$3])dnl
done
])


dnl AC_REPLACE_FUNCS(FUNCTION...)
AC_DEFUN(AC_REPLACE_FUNCS,
[AC_CHECK_FUNCS([$1], , [LIBOBJS="$LIBOBJS ${ac_func}.${ac_objext}"])
AC_SUBST(LIBOBJS)dnl
])


dnl ### Checking compiler characteristics


dnl AC_CHECK_SIZEOF(TYPE [, CROSS-SIZE, [INCLUDES]])
dnl ------------------------------------------------
dnl This macro will probably be obsoleted by the macros of Kaveh.  In
dnl addition `CHECK' is not a proper name (is not boolean). And finally:
dnl shouldn't we use the default INCLUDES?
AC_DEFUN(AC_CHECK_SIZEOF,
[AC_VAR_PUSHDEF([ac_Sizeof], [ac_cv_sizeof_$1])dnl
AC_CACHE_CHECK([size of $1], ac_Sizeof,
[AC_TRY_RUN([#include <stdio.h>
[$3]
int
main ()
{
  FILE *f=fopen("conftestval", "w");
  if (!f) exit(1);
  fprintf(f, "%d\n", sizeof([$1]));
  exit(0);
}],
  AC_VAR_SET(ac_Sizeof, `cat conftestval`),
  AC_VAR_SET(ac_Sizeof, 0),
  ifval([$2], AC_VAR_SET(ac_Sizeof, $2)))])
AC_DEFINE_UNQUOTED(AC_TR_CPP(sizeof_$1), AC_VAR_GET(ac_Sizeof))
AC_VAR_POPDEF([ac_Sizeof])dnl
])


dnl ### Checking for typedefs


dnl AC_CHECK_TYPE_INTERNAL(TYPE,
dnl                        [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
dnl                        [INCLUDES])
dnl ----------------------------------------------------------------
dnl Check whether the type TYPE is supported by the system, maybe via the
dnl the provided includes.  This macro implements the former task of
dnl AC_CHECK_TYPE, with one big difference though: AC_CHECK_TYPE was
dnl grepping in the headers, what led to many problems, BTW, until
dnl the egrep expression was correct and did not given false positives.
dnl Now, we try to compile a variable declaration.  It is probably slower,
dnl but it is *much* safer, and in addition, allows to check for types
dnl defined by the compiler (e.g., unsigned long long), not only for
dnl typedefs.
dnl FIXME: This is *the* macro which ought to be named AC_CHECK_TYPE.
AC_DEFUN(AC_CHECK_TYPE_INTERNAL,
[AC_REQUIRE([AC_HEADER_STDC])dnl
AC_VAR_PUSHDEF([ac_Type], [ac_cv_type_$1])dnl
AC_CACHE_CHECK([for $1], ac_Type,
[AC_TRY_COMPILE(AC_INCLUDES_DEFAULT([$4]),
               [$1 foo;],
               AC_VAR_SET(ac_Type, yes),
               AC_VAR_SET(ac_Type, no))])
AC_SHELL_IFELSE(test AC_VAR_GET(ac_Type) = yes,
                [$2], [$3])dnl
AC_VAR_POPDEF([ac_Type])dnl
])dnl AC_CHECK_TYPE_INTERNAL


dnl AC_CHECK_TYPES((TYPE, ...),
dnl                [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
dnl                [INCLUDES])
dnl --------------------------------------------------------
dnl TYPEs is an m4 list.
AC_DEFUN(AC_CHECK_TYPES,
[m4_foreach([AC_Type], [$1],
  [AC_SPECIALIZE([AC_CHECK_TYPE_INTERNAL], AC_Type,
                 [AC_DEFINE_UNQUOTED(AC_TR_CPP(HAVE_[]AC_Type))
$2]
                 [$3],
                 [$4])])])


dnl AC_CHECK_TYPE(TYPE, DEFAULT, [INCLUDES])
dnl ----------------------------------------
dnl FIXME: This is an extremely badly chosen name, since this
dnl macro actually performs an AC_REPLACE_TYPE.  Some day we
dnl have to clean this up.  The macro AC_TYPE_PTRDIFF_T shows the
dnl need for a checking only macro.
AC_DEFUN(AC_CHECK_TYPE,
[AC_CHECK_TYPE_INTERNAL([$1],,
                        [AC_DEFINE_UNQUOTED($1, $2)],
                        [$3])dnl
])dnl AC_CHECK_TYPE


dnl ### Creating output files

dnl AC_CONFIG_IF_MEMBER(DEST[:SOURCE], LIST, ACTION-IF-TRUE, ACTION-IF-FALSE)
dnl -------------------------------------------------------------------------
dnl If DEST is member of LIST, expand to ACTION-IF-TRUE, else ACTION-IF-FALSE.
dnl
dnl LIST is an AC_CONFIG list, i.e., a list of DEST[:SOURCE], separated
dnl with spaces.
dnl
dnl FIXME: This macro is badly designed, but I'm not guilty: m4 is.  There
dnl is just no way to simply compare two strings in m4, but to use pattern
dnl matching.  The big problem is then that the active characters should
dnl be quoted.  So an additional macro should be used here.  Nevertheless,
dnl in the case of file names, there is not much to worry.
define(AC_CONFIG_IF_MEMBER,
[pushdef([AC_Dest], patsubst([$1], [:.*]))dnl
ifelse(regexp($2, [\(^\| \)]AC_Dest[\(:\| \|$\)]), -1, [$4], [$3])dnl
popdef([AC_Dest])dnl
])


dnl AC_CONFIG_UNIQUE(DEST[:SOURCE]...)
dnl ----------------------------------
dnl Verify that there is no double definition of an output file
dnl (precisely, guarantees there is no common elements between
dnl CONFIG_HEADERS, CONFIG_FILES, CONFIG_LINKS, and CONFIG_SUBDIRS).
dnl This macro should output nothing, so we divert to /dev/null.
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


dnl AC_CONFIG_HEADERS(HEADERS..., [COMMANDS])
dnl -----------------------------------------
dnl Specify that the HEADERS are to be created by instantiation of the
dnl AC_DEFINEs.  Associate the COMMANDS to the HEADERS.  This macro
dnl accumulates if called several times.
dnl
dnl The commands are stored in a growing string AC_LIST_HEADERS_COMMANDS
dnl which should be used like this:
dnl
dnl      case $ac_file in
dnl        AC_LIST_HEADERS_COMMANDS
dnl      esac
AC_DEFUN([AC_CONFIG_HEADERS],
[AC_CONFIG_UNIQUE([$1])dnl
m4_append([AC_LIST_HEADERS], [$1])dnl
dnl Register the commands
ifelse([$2],,, [AC_FOREACH([AC_File], [$1],
[m4_append([AC_LIST_HEADERS_COMMANDS],
[    ]patsubst(AC_File, [:.*])[ ) $2 ;;
])])])dnl
])dnl

dnl Initialize to empty.  It is much easier and uniform to have a config
dnl list expand to empty when undefined, instead of special casing when
dnl not defined (since in this case, AC_CONFIG_FOO expands to AC_CONFIG_FOO).
define([AC_LIST_HEADERS])
define([AC_LIST_HEADERS_COMMANDS])


dnl AC_CONFIG_HEADER(HEADER-TO-CREATE ...)
dnl --------------------------------------
dnl FIXME: Make it obsolete?
AC_DEFUN(AC_CONFIG_HEADER,
[AC_CONFIG_HEADERS([$1])])


dnl AC_CONFIG_LINKS(DEST:SOURCE..., [COMMANDS])
dnl -------------------------------------------
dnl Specify that config.status should establish a (symbolic if possible)
dnl link from TOP_SRCDIR/SOURCE to TOP_SRCDIR/DEST.
dnl Reject DEST=., because it is makes it hard for ./config.status
dnl to guess the links to establish (`./config.status .').
dnl This macro may be called multiple times.
dnl
dnl The commands are stored in a growing string AC_LIST_LINKS_COMMANDS
dnl which should be used like this:
dnl
dnl      case $ac_file in
dnl        AC_LIST_LINKS_COMMANDS
dnl      esac
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

dnl Initialize the list.
define([AC_LIST_LINKS])
define([AC_LIST_LINKS_COMMANDS])


dnl AC_LINK_FILES(SOURCE..., DEST...)
dnl ---------------------------------
dnl Link each of the existing files SOURCE... to the corresponding
dnl link name in DEST...
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


dnl AC_CONFIG_FILES(FILE...[, COMMANDS])
dnl ------------------------------------
dnl Specify output files, as with AC_OUTPUT, i.e., files that are
dnl configured with AC_SUBST.  Associate the COMMANDS to each FILE,
dnl i.e., when config.status creates FILE, run COMMANDS afterwards.
dnl
dnl The commands are stored in a growing string AC_LIST_FILES_COMMANDS
dnl which should be used like this:
dnl
dnl      case $ac_file in
dnl        AC_LIST_FILES_COMMANDS
dnl      esac
AC_DEFUN([AC_CONFIG_FILES],
[AC_CONFIG_UNIQUE([$1])dnl
m4_append([AC_LIST_FILES], [ $1])dnl
dnl Register the commands.
ifelse([$2],,, [AC_FOREACH([AC_File], [$1],
[m4_append([AC_LIST_FILES_COMMANDS],
[    ]patsubst(AC_File, [:.*])[ ) $2 ;;
])])])dnl
])dnl

dnl Initialize the lists.
define([AC_LIST_FILES])
define([AC_LIST_FILES_COMMANDS])

dnl AC_CONFIG_COMMANDS(NAME..., COMMANDS)
dnl -------------------------------------
dnl Specify additional commands to be run by config.status.  This
dnl commands must be associated with a NAME, which should be thought
dnl as the name of a file the COMMANDS create.
dnl
dnl This name must be a unique config key.
dnl
dnl The commands are stored in a growing string AC_LIST_COMMANDS_COMMANDS
dnl which should be used like this:
dnl
dnl      case $ac_file in
dnl        AC_LIST_COMMANDS_COMMANDS
dnl      esac
AC_DEFUN([AC_CONFIG_COMMANDS],
[AC_CONFIG_UNIQUE([$1])dnl
m4_append([AC_LIST_COMMANDS], [ $1])dnl
dnl
ifelse([$2],,, [AC_FOREACH([AC_Name], [$1],
[m4_append([AC_LIST_COMMANDS_COMMANDS],
[    ]patsubst(AC_Name, [:.*])[ ) $2 ;;
])])])dnl
])dnl

dnl Initialize the lists.
define([AC_LIST_COMMANDS])
define([AC_LIST_COMMANDS_COMMANDS])


dnl AC_OUTPUT_COMMANDS(EXTRA-CMDS, INIT-CMDS)
dnl -----------------------------------------
dnl Add additional commands for AC_OUTPUT to put into config.status.
dnl Use diversions instead of macros so we can be robust in the
dnl presence of commas in $1 and/or $2.
dnl FIXME: Obsolete it?
AC_DEFUN(AC_OUTPUT_COMMANDS,
[AC_DIVERT_PUSH(AC_DIVERSION_CMDS)dnl
[$1]
AC_DIVERT_POP()dnl
AC_DIVERT_PUSH(AC_DIVERSION_ICMDS)dnl
[$2]
AC_DIVERT_POP()])


dnl AC_CONFIG_PRE_COMMANDS(CMDS)
dnl ----------------------------
dnl Commands to run right before config.status is created. Accumulates.
AC_DEFUN([AC_CONFIG_PRE_COMMANDS],
[m4_append([AC_OUTPUT_PRE_COMMANDS], [$1
])])

dnl Initialize.
define([AC_OUTPUT_PRE_COMMANDS])


dnl AC_CONFIG_POST_COMMANDS(CMDS)
dnl -----------------------------
dnl Commands to run after config.status was created.  Accumulates.
AC_DEFUN([AC_CONFIG_POST_COMMANDS],
[m4_append([AC_OUTPUT_POST_COMMANDS], [$1
])])

dnl Initialize.
define([AC_OUTPUT_POST_COMMANDS])


dnl AC_CONFIG_SUBDIRS(DIR ...)
dnl --------------------------
dnl FIXME: `subdirs=' should not be here.
AC_DEFUN(AC_CONFIG_SUBDIRS,
[AC_CONFIG_UNIQUE([$1])dnl
AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
m4_append([AC_LIST_SUBDIRS], [$1])dnl
subdirs="AC_LIST_SUBDIRS"
AC_SUBST(subdirs)dnl
])

dnl Initialize the list.
define([AC_LIST_SUBDIRS])


dnl AC_OUTPUT([CONFIG_FILES...] [, EXTRA-CMDS] [, INIT-CMDS])
dnl ---------------------------------------------------------
dnl The big finish.
dnl Produce config.status, config.h, and links; and configure subdirs.
dnl The CONFIG_HEADERS are defined in the m4 variable AC_LIST_HEADERS.
dnl Pay special attention not to have too long here docs: some old
dnl shells die.  Unfortunately the limit is not known precisely...
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

trap 'rm -f $CONFIG_STATUS conftest*; exit 1' 1 2 15

ifset([AC_LIST_HEADERS], [DEFS=-DHAVE_CONFIG_H], [AC_OUTPUT_MAKE_DEFS()])

dnl Commands to run before creating config.status.
AC_OUTPUT_PRE_COMMANDS()dnl

# Without the "./", some shells look in PATH for config.status.
: ${CONFIG_STATUS=./config.status}
AC_OUTPUT_CONFIG_STATUS()dnl
rm -fr confdefs* $ac_clean_files
trap 'exit 1' 1 2 15

dnl Commands to run after config.status was created
AC_OUTPUT_POST_COMMANDS()dnl

test "$no_create" = yes || $SHELL $CONFIG_STATUS || exit 1
dnl config.status should not do recursion.
ifset([AC_LIST_SUBDIRS], [AC_OUTPUT_SUBDIRS(AC_LIST_SUBDIRS)])dnl
])dnl AC_OUTPUT


dnl AC_OUTPUT_CONFIG_STATUS
dnl -----------------------
dnl Produce config.status.  Called by AC_OUTPUT.
dnl Pay special attention not to have too long here docs: some old
dnl shells die.  Unfortunately the limit is not known precisely...
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
AC_WRAP(AC_LIST_FILES, [  ])"
])dnl
ifset([AC_LIST_HEADERS], [config_headers="\\
AC_WRAP(AC_LIST_HEADERS, [  ])"
])dnl
ifset([AC_LIST_LINKS], [config_links="\\
AC_WRAP(AC_LIST_LINKS, [  ])"
])dnl
ifset([AC_LIST_COMMANDS], [config_commands="\\
AC_WRAP(AC_LIST_COMMANDS, [  ])"
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
# AC_OUTPUT_COMMANDS section.
#

undivert(AC_DIVERSION_ICMDS)dnl
EOF
cat >>$CONFIG_STATUS <<\EOF
undivert(AC_DIVERSION_CMDS)dnl
exit 0
EOF
chmod +x $CONFIG_STATUS
])dnl AC_OUTPUT_CONFIG_STATUS


dnl AC_OUTPUT_MAKE_DEFS
dnl -------------------
dnl Set the DEFS variable to the -D options determined earlier.
dnl This is a subroutine of AC_OUTPUT.
dnl It is called inside configure, outside of config.status.
dnl FIXME: This has to be fixed the same way as in AC_OUTPUT_HEADERS.
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


dnl AC_OUTPUT_FILES
dnl ---------------
dnl Do the variable substitutions to create the Makefiles or whatever.
dnl This is a subroutine of AC_OUTPUT.
dnl
dnl It has to send itself into $CONFIG_STATUS (eg, via here documents).
dnl Upon exit, no here document shall be opened.
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


dnl AC_OUTPUT_HEADERS
dnl -----------------
dnl Create the config.h files from the config.h.in files.
dnl This is a subroutine of AC_OUTPUT.
dnl
dnl It has to send itself into $CONFIG_STATUS (eg, via here documents).
dnl Upon exit, no here document shall be opened.
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


dnl AC_OUTPUT_LINKS
dnl ---------------
dnl This is a subroutine of AC_OUTPUT.
dnl
dnl It has to send itself into $CONFIG_STATUS (eg, via here documents).
dnl Upon exit, no here document shall be opened.
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


dnl AC_OUTPUT_COMMANDS_COMMANDS
dnl ---------------------------
dnl This is a subroutine of AC_OUTPUT, in charge of issuing the code
dnl related to AC_CONFIG_COMMANDS.  The weird name is due to the fact
dnl that AC_OUTPUT_COMMANDS is already used.  This should be fixed.
dnl
dnl It has to send itself into $CONFIG_STATUS (eg, via here documents).
dnl Upon exit, no here document shall be opened.
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


dnl AC_OUTPUT_SUBDIRS(DIRECTORY...)
dnl -------------------------------
dnl This is a subroutine of AC_OUTPUT, but it does not go into
dnl config.status, rather, it is called after running config.status.
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


dnl AC_LINKER_OPTION
dnl ----------------
dnl
dnl usage: AC_LINKER_OPTION(LINKER-OPTIONS, SHELL-VARIABLE)
dnl
dnl Specifying options to the compiler (whether it be the C, C++ or
dnl Fortran 77 compiler) that are meant for the linker is compiler
dnl dependent.  This macro lets you give options to the compiler that
dnl are meant for the linker in a portable, compiler-independent way.
dnl
dnl This macro take two arguments, a list of linker options that the
dnl compiler should pass to the linker (LINKER-OPTIONS) and the name of
dnl a shell variable (SHELL-VARIABLE).  The list of linker options are
dnl appended to the shell variable in a compiler-dependent way.
dnl
dnl For example, if the selected language is C, then this:
dnl
dnl   AC_LINKER_OPTION([-R /usr/local/lib/foo], foo_LDFLAGS)
dnl
dnl will expand into this if the selected C compiler is gcc:
dnl
dnl   foo_LDFLAGS="-Xlinker -R -Xlinker /usr/local/lib/foo"
dnl
dnl otherwise, it will expand into this:
dnl
dnl   foo_LDFLAGS"-R /usr/local/lib/foo"
dnl
dnl You are encouraged to add support for compilers that this macro
dnl doesn't currently support.
dnl
dnl pushdef([AC_LINKER_OPTION],
AC_DEFUN(AC_LINKER_OPTION,
[
  using_gnu_compiler=

  ifelse(AC_LANG, [C],         test x"$GCC" = xyes && using_gnu_compiler=yes,
 [ifelse(AC_LANG, [CPLUSPLUS], test x"$GXX" = xyes && using_gnu_compiler=yes,
 [ifelse(AC_LANG, [FORTRAN77], test x"$G77" = xyes && using_gnu_compiler=yes)])])

  for i in $1; do
    if test x"$using_gnu_compiler" = xyes; then
      $2="[$]$2 -Xlinker $i"
    else
      $2="[$]$2 $i"
    fi
  done
])


dnl AC_LIST_MEMBER_OF
dnl -----------------
dnl
dnl usage: AC_LIST_MEMBER_OF(ELEMENT, LIST, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl Processing the elements of a list is tedious in shell programming,
dnl as lists tend to be implemented as space delimited strings.
dnl
dnl This macro searches LIST for ELEMENT, and executes ACTION-IF-FOUND
dnl if ELEMENT is a member of LIST, otherwise it executes
dnl ACTION-IF-NOT-FOUND.
dnl
dnl pushdef([AC_LIST_MEMBER_OF],
AC_DEFUN(AC_LIST_MEMBER_OF,
[
  dnl Do some sanity checking of the arguments.
  ifelse($1, , [AC_MSG_ERROR([$0]: 1st arg must be defined)])
  ifelse($2, , [AC_MSG_ERROR([$0]: 2nd arg must be defined)])

  exists=false
  for i in $2; do
      if test x"$1" = x"$i"; then
          exists=true
          break
      fi
  done

  if test x"$exists" = xtrue; then
      ifelse($3, , :, $3)
  else
      ifelse($4, , :, $4)
  fi
])
