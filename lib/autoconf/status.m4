# This file is part of Autoconf.                       -*- Autoconf -*-
# Parameterizing and creating config.status.
# Copyright (C) 1992, 1993, 1994, 1995, 1996, 1998, 1999, 2000, 2001,
# 2002, 2003, 2004, 2005 Free Software Foundation, Inc.

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
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.

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


# This file handles about all the preparation aspects for
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
#	  case $ac_tag in
#	    AC_LIST_FOOS_COMMANDS
#	  esac
#
# Finally, the `INIT-CMDS' are dumped into a special diversion, via
# `_AC_CONFIG_COMMANDS_INIT'.  While `COMMANDS' are output once per TAG,
# `INIT-CMDS' are dumped only once per call to AC_CONFIG_FOOS.
#
# It also leave the TAG in the shell variable ac_config_foo which contains
# those which will actually be executed.  In other words:
#
#	if false; then
#	  AC_CONFIG_FOOS(bar, [touch bar])
#	fi
#
# will not create bar.
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


## ------------------ ##
## Auxiliary macros.  ##
## ------------------ ##

# _AC_SRCDIRS(BUILD-DIR-NAME)
# ---------------------------
# Inputs:
#   - BUILD-DIR-NAME is `top-build -> build' and `top-src -> src'
#   - `$srcdir' is `top-build -> top-src'
#
# Outputs:
# - `ac_builddir' is `.', for symmetry only.
# - `ac_top_builddir_sub' is `build -> top_build'.
#      This is used for @top_builddir@.
# - `ac_top_build_prefix' is `build -> top_build'.
#      If not empty, has a trailing slash.
# - `ac_srcdir' is `build -> src'.
# - `ac_top_srcdir' is `build -> top-src'.
# and `ac_abs_builddir' etc., the absolute directory names.
m4_define([_AC_SRCDIRS],
[ac_builddir=.

case $1 in
.) ac_dir_suffix= ac_top_builddir_sub=. ac_top_build_prefix= ;;
*)
  ac_dir_suffix=/`echo $1 | sed 's,^\.[[\\/]],,'`
  # A ".." for each directory in $ac_dir_suffix.
  ac_top_builddir_sub=`echo "$ac_dir_suffix" | sed 's,/[[^\\/]]*,/..,g;s,/,,'`
  case $ac_top_builddir_sub in
  "") ac_top_builddir_sub=. ac_top_build_prefix= ;;
  *)  ac_top_build_prefix=$ac_top_builddir_sub/ ;;
  esac ;;
esac
ac_abs_top_builddir=$ac_pwd
ac_abs_builddir=$ac_pwd$ac_dir_suffix
# for backward compatibility:
ac_top_builddir=$ac_top_build_prefix

case $srcdir in
  .)  # No --srcdir option.  We are building in place.
    ac_srcdir=.
    ac_top_srcdir=$ac_top_builddir_sub
    ac_abs_top_srcdir=$ac_pwd ;;
  [[\\/]]* | ?:[[\\/]]* )  # Absolute name.
    ac_srcdir=$srcdir$ac_dir_suffix;
    ac_top_srcdir=$srcdir
    ac_abs_top_srcdir=$srcdir ;;
  *) # Relative name.
    ac_srcdir=$ac_top_build_prefix$srcdir$ac_dir_suffix
    ac_top_srcdir=$ac_top_build_prefix$srcdir
    ac_abs_top_srcdir=$ac_pwd/$srcdir ;;
esac
ac_abs_srcdir=$ac_abs_top_srcdir$ac_dir_suffix
])# _AC_SRCDIRS



## ------------------------------------- ##
## Ensuring the uniqueness of the tags.  ##
## ------------------------------------- ##

# AC_CONFIG_IF_MEMBER(DEST, LIST-NAME, ACTION-IF-TRUE, ACTION-IF-FALSE)
# ----------------------------------------------------------------
# If DEST is member of LIST-NAME, expand to ACTION-IF-TRUE, else
# ACTION-IF-FALSE.
#
# LIST is an AC_CONFIG list, i.e., a list of DEST[:SOURCE], separated
# with spaces.
#
# FIXME: This macro is badly designed, but I'm not guilty: m4 is.  There
# is just no way to simply compare two strings in m4, but to use pattern
# matching.  The big problem is then that the active characters should
# be quoted.  Currently `+*.' are quoted.
m4_define([AC_CONFIG_IF_MEMBER],
[m4_bmatch(m4_defn([$2]), [\(^\| \)]m4_re_escape([$1])[\([: ]\|$\)],
	   [$3], [$4])])


# AC_FILE_DEPENDENCY_TRACE(DEST, SOURCE1, [SOURCE2...])
# -----------------------------------------------------
# This macro does nothing, it's a hook to be read with `autoconf --trace'.
# It announces DEST depends upon the SOURCE1 etc.
m4_define([AC_FILE_DEPENDENCY_TRACE], [])


# _AC_CONFIG_DEPENDENCY(DEST, [SOURCE1], [SOURCE2...])
# ----------------------------------------------------
# Be sure that a missing dependency is expressed as a dependency upon
# `DEST.in'.
m4_define([_AC_CONFIG_DEPENDENCY],
[m4_ifval([$2],
	  [AC_FILE_DEPENDENCY_TRACE($@)],
	  [AC_FILE_DEPENDENCY_TRACE([$1], [$1.in])])])


# _AC_CONFIG_DEPENDENCIES(DEST[:SOURCE1[:SOURCE2...]]...)
# -------------------------------------------------------
# Declare the DESTs depend upon their SOURCE1 etc.
m4_define([_AC_CONFIG_DEPENDENCIES],
[AC_FOREACH([AC_File], [$1],
  [_AC_CONFIG_DEPENDENCY(m4_bpatsubst(AC_File, [:], [,]))])dnl
])


# _AC_CONFIG_UNIQUE(DEST[:SOURCE]...)
# -----------------------------------
#
# Verify that there is no double definition of an output file
# (precisely, guarantees there is no common elements between
# CONFIG_HEADERS, CONFIG_FILES, CONFIG_LINKS, and CONFIG_SUBDIRS).
#
# Note that this macro does not check if the list $[1] itself
# contains doubles.
m4_define([_AC_CONFIG_UNIQUE],
[AC_FOREACH([AC_File], [$1],
[m4_pushdef([AC_Dest], m4_bpatsubst(AC_File, [:.*]))dnl
  AC_CONFIG_IF_MEMBER(AC_Dest, [AC_LIST_HEADERS],
     [AC_FATAL(`AC_Dest' [is already registered with AC_CONFIG_HEADERS.])])dnl
  AC_CONFIG_IF_MEMBER(AC_Dest, [AC_LIST_LINKS],
     [AC_FATAL(`AC_Dest' [is already registered with AC_CONFIG_LINKS.])])dnl
  AC_CONFIG_IF_MEMBER(AC_Dest, [_AC_LIST_SUBDIRS],
     [AC_FATAL(`AC_Dest' [is already registered with AC_CONFIG_SUBDIRS.])])dnl
  AC_CONFIG_IF_MEMBER(AC_Dest, [AC_LIST_COMMANDS],
     [AC_FATAL(`AC_Dest' [is already registered with AC_CONFIG_COMMANDS.])])dnl
  AC_CONFIG_IF_MEMBER(AC_Dest, [AC_LIST_FILES],
     [AC_FATAL(`AC_Dest' [is already registered with AC_CONFIG_FILES.])])dnl
m4_popdef([AC_Dest])])dnl
])


# _AC_CONFIG_SPLIT(LIST, DEST, SOURCE)
# ------------------------------------
#
# Shell variable LIST must contain at least two file names, separated by
# colon.  The first component goes to DEST, the rest to SOURCE.
# We compute SOURCE first, so LIST and DEST can be the same variable.
#
m4_define([_AC_CONFIG_SPLIT],
[	$3=`expr "X$$1" : ['X[^:]*:\(.*\)']`
	$2=`expr "X$$1" : ['X\([^:]*\)']`[]dnl
])

# _AC_CONFIG_SPLIT_SOURCE_DEST
# ----------------------------
#
# Used in CONFIG_COMMANDS and CONFIG_LINKS sections.
#
m4_define([_AC_CONFIG_SPLIT_SOURCE_DEST],
[case $ac_file in
  *:*)	_AC_CONFIG_SPLIT(ac_file, ac_dest, ac_source) ;;
  *)	ac_dest=$ac_file ac_source=$ac_file ;;
esac[]dnl
])

# _AC_CONFIG_SPLIT_FILE_IN
# ------------------------
#
# Used in CONFIG_HEADERS and CONFIG_FILES sections.
#
m4_define([_AC_CONFIG_SPLIT_FILE_IN],
[case $ac_file in
  *:*)	_AC_CONFIG_SPLIT(ac_file, ac_file, ac_file_in) ;;
  -)	ac_file_in=- ;;
  *)	ac_file_in=$ac_file.in ;;
esac[]dnl
])



## ------------------------ ##
## Configuration commands.  ##
## ------------------------ ##


# _AC_CONFIG_COMMANDS_INIT([INIT-COMMANDS])
# -----------------------------------------
#
# Register INIT-COMMANDS as command pasted *unquoted* in
# `config.status'.  This is typically used to pass variables from
# `configure' to `config.status'.  Note that $[1] is not over quoted as
# was the case in AC_OUTPUT_COMMANDS.
m4_define([_AC_CONFIG_COMMANDS_INIT],
[m4_ifval([$1],
	  [m4_append([_AC_OUTPUT_COMMANDS_INIT],
		     [$1
])])])

# Initialize.
m4_define([_AC_OUTPUT_COMMANDS_INIT])


# _AC_CONFIG_COMMAND(NAME, [COMMANDS])
# ------------------------------------
# See below.
m4_define([_AC_CONFIG_COMMAND],
[_AC_CONFIG_UNIQUE([$1])dnl
m4_append([AC_LIST_COMMANDS], [ $1])dnl
m4_ifval([$2],
[m4_append([AC_LIST_COMMANDS_COMMANDS],
[    ]m4_bpatsubst([$1], [:.*])[ ) $2 ;;
])])dnl
])

# AC_CONFIG_COMMANDS(NAME...,[COMMANDS], [INIT-CMDS])
# ---------------------------------------------------
#
# Specify additional commands to be run by config.status.  This
# commands must be associated with a NAME, which should be thought
# as the name of a file the COMMANDS create.
AC_DEFUN([AC_CONFIG_COMMANDS],
[AC_FOREACH([AC_Name], [$1], [_AC_CONFIG_COMMAND(m4_defn([AC_Name]), [$2])])dnl
_AC_CONFIG_COMMANDS_INIT([$3])dnl
ac_config_commands="$ac_config_commands $1"
])

# Initialize the lists.
m4_define([AC_LIST_COMMANDS])
m4_define([AC_LIST_COMMANDS_COMMANDS])


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
# if you update an included file and configure.ac: you might have
# clashes :(  On the other hand, I'd like to avoid weird keys (e.g.,
# depending upon __file__ or the pid).
AU_DEFUN([AC_OUTPUT_COMMANDS],
[m4_define([_AC_OUTPUT_COMMANDS_CNT], m4_incr(_AC_OUTPUT_COMMANDS_CNT))dnl
dnl Double quoted since that was the case in the original macro.
AC_CONFIG_COMMANDS([default-]_AC_OUTPUT_COMMANDS_CNT, [[$1]], [[$2]])dnl
])

# Initialize.
AU_DEFUN([_AC_OUTPUT_COMMANDS_CNT], 0)


# AC_CONFIG_COMMANDS_PRE(CMDS)
# ----------------------------
# Commands to run right before config.status is created. Accumulates.
AC_DEFUN([AC_CONFIG_COMMANDS_PRE],
[m4_append([AC_OUTPUT_COMMANDS_PRE], [$1
])])


# AC_OUTPUT_COMMANDS_PRE
# ----------------------
# A *variable* in which we append all the actions that must be
# performed before *creating* config.status.  For a start, clean
# up all the LIBOBJ mess.
m4_define([AC_OUTPUT_COMMANDS_PRE],
[_AC_LIBOBJS_NORMALIZE()
])


# AC_CONFIG_COMMANDS_POST(CMDS)
# -----------------------------
# Commands to run after config.status was created.  Accumulates.
AC_DEFUN([AC_CONFIG_COMMANDS_POST],
[m4_append([AC_OUTPUT_COMMANDS_POST], [$1
])])

# Initialize.
m4_define([AC_OUTPUT_COMMANDS_POST])



# _AC_OUTPUT_COMMANDS
# -------------------
# This is a subroutine of AC_OUTPUT, in charge of issuing the code
# related to AC_CONFIG_COMMANDS.
#
# It has to send itself into $CONFIG_STATUS (eg, via here documents).
# Upon exit, no here document shall be opened.
m4_define([_AC_OUTPUT_COMMANDS],
[cat >>$CONFIG_STATUS <<\_ACEOF

#
# CONFIG_COMMANDS section.
#
for ac_file in : $CONFIG_COMMANDS; do test "x$ac_file" = x: && continue
  _AC_CONFIG_SPLIT_SOURCE_DEST
  ac_dir=`AS_DIRNAME(["$ac_dest"])`
  AS_MKDIR_P(["$ac_dir"])
  _AC_SRCDIRS(["$ac_dir"])

  AC_MSG_NOTICE([executing $ac_dest commands])
dnl Some shells don't like empty case/esac
m4_ifset([AC_LIST_COMMANDS_COMMANDS],
[  case $ac_dest in
AC_LIST_COMMANDS_COMMANDS()dnl
  esac
])dnl
done
_ACEOF
])# _AC_OUTPUT_COMMANDS




## ----------------------- ##
## Configuration headers.  ##
## ----------------------- ##


# _AC_CONFIG_HEADER(HEADER, [COMMANDS])
# -------------------------------------
# See below.
m4_define([_AC_CONFIG_HEADER],
[_AC_CONFIG_UNIQUE([$1])dnl
m4_append([AC_LIST_HEADERS], [ $1])dnl
_AC_CONFIG_DEPENDENCIES([$1])dnl
dnl Register the commands
m4_ifval([$2],
[m4_append([AC_LIST_HEADERS_COMMANDS],
[    ]m4_bpatsubst([$1], [:.*])[ ) $2 ;;
])])dnl
])


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
[AC_FOREACH([AC_File], [$1], [_AC_CONFIG_HEADER(m4_defn([AC_File]), [$2])])dnl
_AC_CONFIG_COMMANDS_INIT([$3])dnl
ac_config_headers="$ac_config_headers m4_normalize([$1])"
])

# Initialize to empty.  It is much easier and uniform to have a config
# list expand to empty when undefined, instead of special casing when
# not defined (since in this case, AC_CONFIG_FOO expands to AC_CONFIG_FOO).
m4_define([AC_LIST_HEADERS])
m4_define([AC_LIST_HEADERS_COMMANDS])


# AC_CONFIG_HEADER(HEADER-TO-CREATE ...)
# --------------------------------------
# FIXME: Make it obsolete?
AC_DEFUN([AC_CONFIG_HEADER],
[AC_CONFIG_HEADERS([$1])])


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
m4_define([_AC_OUTPUT_HEADERS],
[cat >>$CONFIG_STATUS <<\_ACEOF

#
# CONFIG_HEADERS section.
#

# These sed commands are passed to sed as "A NAME B PARAMS C VALUE D", where
# NAME is the cpp macro being defined, VALUE is the value it is being given.
# PARAMS is the parameter list in the macro definition--in most cases, it's
# just an empty string.
#
dnl Quote, for the `[ ]' and `define'.
[ac_dA='s,^\([	 ]*#[	 ]*\)[^	 ]*\([	 ][	 ]*'
ac_dB='\)[ 	(].*$,\1define\2'
ac_dC=' '
ac_dD=' ,']
dnl ac_dD used to contain `;t' at the end, but that was both slow and incorrect.
dnl 1) Since the script must be broken into chunks containing 100 commands,
dnl the extra command meant extra calls to sed.
dnl 2) The code was incorrect: in the unusual case where a symbol has multiple
dnl different AC_DEFINEs, the last one should be honored.
dnl
dnl ac_dB works because every line has a space appended.  ac_dB reinserts
dnl the space, because some symbol may have been AC_DEFINEd several times.

[ac_word_regexp=[_$as_cr_Letters][_$as_cr_alnum]*]

for ac_file in : $CONFIG_HEADERS; do test "x$ac_file" = x: && continue
  # Support "outfile[:infile[:infile...]]", defaulting infile="outfile.in".
  case $ac_file in
  - | *:- | *:-:* ) # input from stdin
	cat >"$tmp/stdin" ;;
  esac
  _AC_CONFIG_SPLIT_FILE_IN

  test x"$ac_file" != x- && AC_MSG_NOTICE([creating $ac_file])

  # First look for the input files in the build tree, otherwise in the
  # src tree.
  ac_file_inputs=`IFS=:
    for f in $ac_file_in; do
      case $f in
      -) echo "$tmp/stdin" ;;
      [[\\/$]]*)
	 # Absolute (can't be DOS-style, as IFS=:)
	 test -f "$f" || AC_MSG_ERROR([cannot find input file: $f])
	 # Quote $f, to prevent DOS file names from being IFS'd.
	 echo "$f";;
      *) # Relative
	 if test -f "$f"; then
	   # Build tree
	   echo "$f"
	 elif test -f "$srcdir/$f"; then
	   # Source tree
	   echo "$srcdir/$f"
	 else
	   # /dev/null tree
	   AC_MSG_ERROR([cannot find input file: $f])
	 fi;;
      esac
    done` || AS_EXIT([1])

_ACEOF

# Transform confdefs.h into a sed script `conftest.defines', that
# substitutes the proper values into config.h.in to produce config.h.
rm -f conftest.defines conftest.tail
# First, append a space to every undef/define line, to ease matching.
echo 's/$/ /' >conftest.defines
# Then, protect against being on the right side of a sed subst, or in
# an unquoted here document, in config.status.  If some macros were
# called several times there might be several #defines for the same
# symbol, which is useless.  But do not sort them, since the last
# AC_DEFINE must be honored.
dnl
dnl Quote, for `[ ]' and `define'.
[ac_word_re=[_$as_cr_Letters][_$as_cr_alnum]*
uniq confdefs.h |
  sed -n '
	t rset
	:rset
	s/^[ 	]*#[ 	]*define[ 	][	 ]*//
	t ok
	d
	:ok
	s/[\\&,]/\\&/g
	s/[\\$`]/\\&/g
	s/^\('"$ac_word_re"'\)\(([^()]*)\)[ 	]*\(.*\)/${ac_dA}\1$ac_dB\2${ac_dC}\3$ac_dD/p
	s/^\('"$ac_word_re"'\)[ 	]*\(.*\)/${ac_dA}\1$ac_dB${ac_dC}\2$ac_dD/p
  ' >>conftest.defines
]
# Remove the space that was appended to ease matching.
# Then replace #undef with comments.  This is necessary, for
# example, in the case of _POSIX_SOURCE, which is predefined and required
# on some systems where configure will not decide to define it.
# (The regexp can be short, since the line contains either #define or #undef.)
echo 's/ $//
[s,^[	 #]*u.*,/* & */,]' >>conftest.defines

# Break up conftest.defines:
ac_max_sed_lines=m4_eval(_AC_SED_CMD_LIMIT - 3)

# First sed command is:	 sed -f defines.sed $ac_file_inputs >"$tmp/out1"
# Second one is:	 sed -f defines.sed "$tmp/out1" >"$tmp/out2"
# Third one will be:	 sed -f defines.sed "$tmp/out2" >"$tmp/out1"
# et cetera.
ac_in='$ac_file_inputs'
ac_out='"$tmp/out1"'
ac_nxt='"$tmp/out2"'

while :
do
  # Write a here document:
  dnl Quote, for the `[ ]' and `define'.
  echo ['    # First, check the format of the line:
    cat >"$tmp/defines.sed" <<CEOF
/^[	 ]*#[	 ]*undef[	 ][	 ]*$ac_word_regexp[ 	]*$/!{
/^[	 ]*#[	 ]*define[	 ][	 ]*$ac_word_regexp[( 	]/!b
}'] >>$CONFIG_STATUS
  sed ${ac_max_sed_lines}q conftest.defines >>$CONFIG_STATUS
  echo 'CEOF
    sed -f "$tmp/defines.sed"' "$ac_in >$ac_out" >>$CONFIG_STATUS
  ac_in=$ac_out ac_out=$ac_nxt ac_nxt=$ac_in
  sed 1,${ac_max_sed_lines}d conftest.defines >conftest.tail
  grep . conftest.tail >/dev/null || break
  rm -f conftest.defines
  mv conftest.tail conftest.defines
done
rm -f conftest.defines conftest.tail

dnl Now back to your regularly scheduled config.status.
echo "ac_result=$ac_in" >>$CONFIG_STATUS
cat >>$CONFIG_STATUS <<\_ACEOF
  # Let's still pretend it is `configure' which instantiates (i.e., don't
  # use $as_me), people would be surprised to read:
  #    /* config.h.  Generated by config.status.  */
  if test x"$ac_file" != x-; then
    echo "/* $ac_file.  Generated by configure.  */" >"$tmp/config.h"
    cat "$ac_result" >>"$tmp/config.h"
    if diff $ac_file "$tmp/config.h" >/dev/null 2>&1; then
      AC_MSG_NOTICE([$ac_file is unchanged])
    else
      ac_dir=`AS_DIRNAME(["$ac_file"])`
      AS_MKDIR_P(["$ac_dir"])
      rm -f $ac_file
      mv "$tmp/config.h" $ac_file
    fi
  else
    echo "/* Generated by configure.  */"
    cat "$ac_result"
  fi
  rm -f "$tmp/out[12]"
dnl If running for Automake, be ready to perform additional
dnl commands to set up the timestamp files.
m4_ifdef([_AC_AM_CONFIG_HEADER_HOOK],
	 [_AC_AM_CONFIG_HEADER_HOOK([$ac_file])
])dnl
m4_ifset([AC_LIST_HEADERS_COMMANDS],
[  # Run the commands associated with the file.
  case $ac_file in
AC_LIST_HEADERS_COMMANDS()dnl
  esac
])dnl
done
_ACEOF
])# _AC_OUTPUT_HEADERS



## --------------------- ##
## Configuration links.  ##
## --------------------- ##


# _AC_CONFIG_LINK(DEST:SOURCE, [COMMANDS])
# ----------------------------------------
# See below.
m4_define([_AC_CONFIG_LINK],
[_AC_CONFIG_UNIQUE([$1])dnl
m4_append([AC_LIST_LINKS], [ $1])dnl
_AC_CONFIG_DEPENDENCIES([$1])dnl
m4_bmatch([$1], [^\.:\| \.:], [m4_fatal([$0: invalid destination: `.'])])dnl
dnl Register the commands
m4_ifval([$2],
[m4_append([AC_LIST_LINKS_COMMANDS],
[    ]m4_bpatsubst([$1], [:.*])[ ) $2 ;;
])])dnl
])

# AC_CONFIG_LINKS(DEST:SOURCE..., [COMMANDS], [INIT-CMDS])
# --------------------------------------------------------
# Specify that config.status should establish a (symbolic if possible)
# link from TOP_SRCDIR/SOURCE to TOP_SRCDIR/DEST.
# Reject DEST=., because it is makes it hard for ./config.status
# to guess the links to establish (`./config.status .').
AC_DEFUN([AC_CONFIG_LINKS],
[AC_FOREACH([AC_File], [$1], [_AC_CONFIG_LINK(m4_defn([AC_File]), [$2])])dnl
_AC_CONFIG_COMMANDS_INIT([$3])dnl
ac_config_links="$ac_config_links m4_normalize([$1])"
])


# Initialize the list.
m4_define([AC_LIST_LINKS])
m4_define([AC_LIST_LINKS_COMMANDS])


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
# _AC_LINK_FILES_CNT is used to be robust to multiple calls.
AU_DEFUN([AC_LINK_FILES],
[m4_if($#, 2, ,
       [m4_fatal([$0: incorrect number of arguments])])dnl
m4_define([_AC_LINK_FILES_CNT], m4_incr(_AC_LINK_FILES_CNT))dnl
ac_sources="$1"
ac_dests="$2"
while test -n "$ac_sources"; do
  set $ac_dests; ac_dest=$[1]; shift; ac_dests=$[*]
  set $ac_sources; ac_source=$[1]; shift; ac_sources=$[*]
  [ac_config_links_]_AC_LINK_FILES_CNT="$[ac_config_links_]_AC_LINK_FILES_CNT $ac_dest:$ac_source"
done
AC_CONFIG_LINKS($[ac_config_links_]_AC_LINK_FILES_CNT)dnl
],
[It is technically impossible to `autoupdate' cleanly from AC_LINK_FILES
to AC_CONFIG_FILES.  `autoupdate' provides a functional but inelegant
update, you should probably tune the result yourself.])# AC_LINK_FILES


# Initialize.
AU_DEFUN([_AC_LINK_FILES_CNT], 0)

# _AC_OUTPUT_LINKS
# ----------------
# This is a subroutine of AC_OUTPUT.
#
# It has to send itself into $CONFIG_STATUS (eg, via here documents).
# Upon exit, no here document shall be opened.
m4_define([_AC_OUTPUT_LINKS],
[cat >>$CONFIG_STATUS <<\_ACEOF

#
# CONFIG_LINKS section.
#

dnl Here we use : instead of .. because if AC_LINK_FILES was used
dnl with empty parameters (as in gettext.m4), then we obtain here
dnl `:', which we want to skip.  So let's keep a single exception: `:'.
for ac_file in : $CONFIG_LINKS; do test "x$ac_file" = x: && continue
  _AC_CONFIG_SPLIT_SOURCE_DEST

  AC_MSG_NOTICE([linking $srcdir/$ac_source to $ac_dest])

  if test ! -r $srcdir/$ac_source; then
    AC_MSG_ERROR([$srcdir/$ac_source: file not found])
  fi
  rm -f $ac_dest

  # Make relative symlinks.
  ac_dest_dir=`AS_DIRNAME(["$ac_dest"])`
  AS_MKDIR_P(["$ac_dest_dir"])
  _AC_SRCDIRS(["$ac_dest_dir"])

  case $srcdir in
  [[\\/$]]* | ?:[[\\/]]* ) ac_rel_source=$srcdir/$ac_source ;;
      *) ac_rel_source=$ac_top_build_prefix$srcdir/$ac_source ;;
  esac

  # Try a symlink, then a hard link, then a copy.
  ln -s $ac_rel_source $ac_dest 2>/dev/null ||
    ln $srcdir/$ac_source $ac_dest 2>/dev/null ||
    cp -p $srcdir/$ac_source $ac_dest ||
    AC_MSG_ERROR([cannot link or copy $srcdir/$ac_source to $ac_dest])
m4_ifset([AC_LIST_LINKS_COMMANDS],
[  # Run the commands associated with the file.
  case $ac_file in
AC_LIST_LINKS_COMMANDS()dnl
  esac
])dnl
done
_ACEOF
])# _AC_OUTPUT_LINKS



## --------------------- ##
## Configuration files.  ##
## --------------------- ##


# _AC_CONFIG_FILE(FILE..., [COMMANDS])
# ------------------------------------
# See below.
m4_define([_AC_CONFIG_FILE],
[_AC_CONFIG_UNIQUE([$1])dnl
m4_append([AC_LIST_FILES], [ $1])dnl
_AC_CONFIG_DEPENDENCIES([$1])dnl
dnl Register the commands.
m4_ifval([$2],
[m4_append([AC_LIST_FILES_COMMANDS],
[    ]m4_bpatsubst([$1], [:.*])[ ) $2 ;;
])])dnl
])

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
[AC_FOREACH([AC_File], [$1], [_AC_CONFIG_FILE(m4_defn([AC_File]), [$2])])dnl
_AC_CONFIG_COMMANDS_INIT([$3])dnl
ac_config_files="$ac_config_files m4_normalize([$1])"
])

# Initialize the lists.
m4_define([AC_LIST_FILES])
m4_define([AC_LIST_FILES_COMMANDS])

# _AC_SED_CMD_LIMIT
# -----------------
# Evaluate to an m4 number equal to the maximum number of commands to put
# in any single sed program.
#
# Some seds have small command number limits, like on Digital OSF/1 and HP-UX.
m4_define([_AC_SED_CMD_LIMIT],
dnl One cannot portably go further than 100 commands because of HP-UX.
[100])

# _AC_OUTPUT_FILES
# ----------------
# Do the variable substitutions to create the Makefiles or whatever.
# This is a subroutine of AC_OUTPUT.
#
# It has to send itself into $CONFIG_STATUS (eg, via here documents).
# Upon exit, no here document shall be opened.
m4_define([_AC_OUTPUT_FILES],
[cat >>$CONFIG_STATUS <<\_ACEOF
#
# CONFIG_FILES section.
#

# No need to generate the scripts if there are no CONFIG_FILES.
# This happens for instance when ./config.status config.h
if test -n "$CONFIG_FILES"; then

_ACEOF

m4_pushdef([_AC_SED_CMDS], [])dnl Part of pipeline that does substitutions.
dnl
m4_pushdef([_AC_SED_FRAG_NUM], 0)dnl Fragment number.
m4_pushdef([_AC_SED_CMD_NUM], 2)dnl Num of commands in current frag so far.
m4_pushdef([_AC_SED_DELIM_NUM], 0)dnl Expected number of delimiters in file.
m4_pushdef([_AC_SED_FRAG], [])dnl The constant part of the current fragment.
dnl
m4_ifdef([_AC_SUBST_FILES],
[# Create sed commands to just substitute file output variables.

AC_FOREACH([_AC_Var], m4_defn([_AC_SUBST_FILES]),
[dnl End fragments at beginning of loop so that last fragment is not ended.
m4_if(1,m4_eval(_AC_SED_CMD_NUM+4>_AC_SED_CMD_LIMIT),
[dnl Fragment is full and not the last one, so no need for the final un-escape.
dnl Increment fragment number.
m4_define([_AC_SED_FRAG_NUM],m4_incr(_AC_SED_FRAG_NUM))dnl
dnl Record that this fragment will need to be used.
m4_define([_AC_SED_CMDS],
m4_defn([_AC_SED_CMDS])[| sed -f "$tmp/subs-]_AC_SED_FRAG_NUM[.sed" ])dnl
[cat >>$CONFIG_STATUS <<_ACEOF
cat >"$tmp/subs-]_AC_SED_FRAG_NUM[.sed" <\CEOF
/@[a-zA-Z_][a-zA-Z_0-9]*@/!b
]m4_defn(_AC_SED_FRAG)dnl
[CEOF

_ACEOF
]m4_define([_AC_SED_CMD_NUM], 2)m4_define([_AC_SED_FRAG])dnl
])dnl Last fragment ended.
m4_define([_AC_SED_CMD_NUM], m4_eval(_AC_SED_CMD_NUM+4))dnl
m4_define([_AC_SED_FRAG],
m4_defn([_AC_SED_FRAG])dnl
[/^[ 	]*@]_AC_Var[@[ 	]*$/{ r $]_AC_Var[
d; }
])dnl
])dnl
# Remaining file output variables are in a fragment that also has non-file
# output varibles.

])
dnl
m4_define([_AC_SED_FRAG],[
]m4_defn([_AC_SED_FRAG]))dnl
AC_FOREACH([_AC_Var],
m4_ifdef([_AC_SUBST_VARS],[m4_defn([_AC_SUBST_VARS]) ])[@END@],
[m4_if(_AC_SED_DELIM_NUM,0,
[m4_if(_AC_Var,[@END@],
[dnl The whole of the last fragment would be the final deletion of `|#_!!_#|'.
m4_define([_AC_SED_CMDS],m4_defn([_AC_SED_CMDS])[| sed 's/|#_!!_#|//g' ])],
[
ac_delim='%!_!# '
for ac_last_try in false false false false false :; do
  cat >conf$$subs.sed <<_ACEOF
])])dnl
m4_if(_AC_Var,[ac_delim],
[dnl Just to be on the safe side, claim that $ac_delim is the empty string.
m4_define([_AC_SED_FRAG],
m4_defn([_AC_SED_FRAG])dnl
[s,ac_delim,|#_!!_#|,g
])dnl
m4_define([_AC_SED_CMD_NUM], m4_incr(_AC_SED_CMD_NUM))],
      _AC_Var,[@END@],
      [m4_if(1,m4_eval(_AC_SED_CMD_NUM+2<=_AC_SED_CMD_LIMIT),
             [m4_define([_AC_SED_FRAG], [ end]m4_defn([_AC_SED_FRAG]))])],
[m4_define([_AC_SED_CMD_NUM], m4_incr(_AC_SED_CMD_NUM))dnl
m4_define([_AC_SED_DELIM_NUM], m4_incr(_AC_SED_DELIM_NUM))dnl
_AC_Var!$_AC_Var$ac_delim
])dnl
m4_if(_AC_SED_CMD_LIMIT,
      m4_if(_AC_Var,[@END@],_AC_SED_CMD_LIMIT,_AC_SED_CMD_NUM),
[_ACEOF

  if test `grep -c "$ac_delim\$" conf$$subs.sed` = _AC_SED_DELIM_NUM; then
    break
  elif $ac_last_try; then
    AC_MSG_ERROR([could not make $CONFIG_STATUS])
  else
    ac_delim="$ac_delim!$ac_delim _$ac_delim!! "
  fi
done

ac_eof=`sed -n '/^CEOF[0-9]*$/s/CEOF//p' conf$$subs.sed | sort -nru | sed 1q`
ac_eof=`expr 0$ac_eof + 1`

dnl Increment fragment number.
m4_define([_AC_SED_FRAG_NUM],m4_incr(_AC_SED_FRAG_NUM))dnl
dnl Record that this fragment will need to be used.
m4_define([_AC_SED_CMDS],
m4_defn([_AC_SED_CMDS])[| sed -f "$tmp/subs-]_AC_SED_FRAG_NUM[.sed" ])dnl
[cat >>$CONFIG_STATUS <<_ACEOF
cat >"\$tmp/subs-]_AC_SED_FRAG_NUM[.sed" <<\CEOF$ac_eof
/@[a-zA-Z_][a-zA-Z_0-9]*@/!b]m4_defn([_AC_SED_FRAG])dnl
[_ACEOF
sed '
s/[,\\&]/\\&/g; s/@/@|#_!!_#|/g
s/^/s,@/; s/!/@,|#_!!_#|/
:n
t n
s/'"$ac_delim"'$/,g/; t
s/$/\\/; p
N; s/^.*\n//; s/[,\\&]/\\&/g; s/@/@|#_!!_#|/g; b n
' >>$CONFIG_STATUS <conf$$subs.sed
rm -f conf$$subs.sed
cat >>$CONFIG_STATUS <<_ACEOF
]m4_if(_AC_Var,[@END@],
[m4_if(1,m4_eval(_AC_SED_CMD_NUM+2>_AC_SED_CMD_LIMIT),
[m4_define([_AC_SED_CMDS],m4_defn([_AC_SED_CMDS])[| sed 's/|#_!!_#|//g' ])],
[[:end
s/|#_!!_#|//g
]])])dnl
CEOF$ac_eof
_ACEOF
m4_define([_AC_SED_FRAG], [
])m4_define([_AC_SED_DELIM_NUM], 0)m4_define([_AC_SED_CMD_NUM], 2)dnl

])])dnl
dnl
m4_popdef([_AC_SED_FRAG_NUM])dnl
m4_popdef([_AC_SED_CMD_NUM])dnl
m4_popdef([_AC_SED_DELIM_NUM])dnl
m4_popdef([_AC_SED_FRAG])dnl
dnl
cat >>$CONFIG_STATUS <<\_ACEOF
fi # test -n "$CONFIG_FILES"

for ac_file in : $CONFIG_FILES; do test "x$ac_file" = x: && continue
  # Support "outfile[:infile[:infile...]]", defaulting infile="outfile.in".
  case $ac_file in
  - | *:- | *:-:* ) # input from stdin
	cat >"$tmp/stdin" ;;
  esac
  _AC_CONFIG_SPLIT_FILE_IN

  # Compute @srcdir@, @top_srcdir@, and @INSTALL@ for subdirectories.
  ac_dir=`AS_DIRNAME(["$ac_file"])`
  AS_MKDIR_P(["$ac_dir"])
  _AC_SRCDIRS(["$ac_dir"])

AC_PROVIDE_IFELSE([AC_PROG_INSTALL],
[  case $INSTALL in
  [[\\/$]]* | ?:[[\\/]]* ) ac_INSTALL=$INSTALL ;;
  *) ac_INSTALL=$ac_top_build_prefix$INSTALL ;;
  esac
])dnl

  if test x"$ac_file" != x-; then
    AC_MSG_NOTICE([creating $ac_file])
    rm -f "$ac_file"
  fi
  # Let's still pretend it is `configure' which instantiates (i.e., don't
  # use $as_me), people would be surprised to read:
  #    /* config.h.  Generated by config.status.  */
  if test x"$ac_file" = x-; then
    configure_input=
  else
    configure_input="$ac_file.  "
  fi
  configure_input=$configure_input"Generated from `echo $ac_file_in |
				     sed 's,.*/,,'` by configure."

  # First look for the input files in the build tree, otherwise in the
  # src tree.
  ac_file_inputs=`IFS=:
    for f in $ac_file_in; do
      case $f in
      -) echo "$tmp/stdin" ;;
      [[\\/$]]*)
	 # Absolute (can't be DOS-style, as IFS=:)
	 test -f "$f" || AC_MSG_ERROR([cannot find input file: $f])
	 echo "$f";;
      *) # Relative
	 if test -f "$f"; then
	   # Build tree
	   echo "$f"
	 elif test -f "$srcdir/$f"; then
	   # Source tree
	   echo "$srcdir/$f"
	 else
	   # /dev/null tree
	   AC_MSG_ERROR([cannot find input file: $f])
	 fi;;
      esac
    done` || AS_EXIT([1])
_ACEOF
cat >>$CONFIG_STATUS <<_ACEOF
dnl Neutralize VPATH when `$srcdir' = `.'.
  sed "$ac_vpsub
dnl Shell code in configure.ac might set extrasub.
dnl FIXME: do we really want to maintain this feature?
$extrasub
_ACEOF
cat >>$CONFIG_STATUS <<\_ACEOF
:t
[/@[a-zA-Z_][a-zA-Z_0-9]*@/!b]
s|@configure_input@|$configure_input|;t t
s|@srcdir@|$ac_srcdir|;t t
s|@abs_srcdir@|$ac_abs_srcdir|;t t
s|@top_srcdir@|$ac_top_srcdir|;t t
s|@abs_top_srcdir@|$ac_abs_top_srcdir|;t t
s|@builddir@|$ac_builddir|;t t
s|@abs_builddir@|$ac_abs_builddir|;t t
s|@top_builddir@|$ac_top_builddir_sub|;t t
s|@abs_top_builddir@|$ac_abs_top_builddir|;t t
AC_PROVIDE_IFELSE([AC_PROG_INSTALL], [s,@INSTALL@,$ac_INSTALL,;t t
])dnl
" $ac_file_inputs m4_defn([_AC_SED_CMDS])>$tmp/out
m4_popdef([_AC_SED_CMDS])dnl
  rm -f "$tmp/stdin"
dnl This would break Makefile dependencies.
dnl  if diff $ac_file "$tmp/out" >/dev/null 2>&1; then
dnl    echo "$ac_file is unchanged"
dnl   else
dnl     rm -f $ac_file
dnl    mv "$tmp/out" $ac_file
dnl  fi
  if test x"$ac_file" != x-; then
    mv "$tmp/out" $ac_file
  else
    cat "$tmp/out"
    rm -f "$tmp/out"
  fi

m4_ifset([AC_LIST_FILES_COMMANDS],
[  # Run the commands associated with the file.
  case $ac_file in
AC_LIST_FILES_COMMANDS()dnl
  esac
])dnl
done
_ACEOF
])# _AC_OUTPUT_FILES



## ----------------------- ##
## Configuration subdirs.  ##
## ----------------------- ##


# AC_CONFIG_SUBDIRS(DIR ...)
# --------------------------
# We define two variables:
# - ac_subdirs_all
#   is built in the `default' section, and should contain *all*
#   the arguments of AC_CONFIG_SUBDIRS.  It is used for --help=recursive.
#   It makes no sense for arguments which are sh variables.
# - subdirs
#   which is built at runtime, so some of these dirs might not be
#   included, if for instance the user refused a part of the tree.
#   This is used in _AC_OUTPUT_SUBDIRS.
# _AC_LIST_SUBDIRS is used only for _AC_CONFIG_UNIQUE.
AC_DEFUN([AC_CONFIG_SUBDIRS],
[_AC_CONFIG_UNIQUE([$1])dnl
AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
m4_append([_AC_LIST_SUBDIRS], [ $1])dnl
AS_LITERAL_IF([$1], [],
	      [AC_DIAGNOSE(syntax, [$0: you should use literals])])
m4_divert_text([DEFAULTS],
	       [ac_subdirs_all="$ac_subdirs_all m4_normalize([$1])"])
AC_SUBST(subdirs, "$subdirs $1")dnl
])

# Initialize the list.
m4_define([_AC_LIST_SUBDIRS])


# _AC_OUTPUT_SUBDIRS
# ------------------
# This is a subroutine of AC_OUTPUT, but it does not go into
# config.status, rather, it is called after running config.status.
m4_define([_AC_OUTPUT_SUBDIRS],
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
    case $ac_arg in
    -cache-file | --cache-file | --cache-fil | --cache-fi \
    | --cache-f | --cache- | --cache | --cach | --cac | --ca | --c)
      ac_prev=cache_file ;;
    -cache-file=* | --cache-file=* | --cache-fil=* | --cache-fi=* \
    | --cache-f=* | --cache-=* | --cache=* | --cach=* | --cac=* | --ca=* \
    | --c=*)
      ;;
    --config-cache | -C)
      ;;
    -srcdir | --srcdir | --srcdi | --srcd | --src | --sr)
      ac_prev=srcdir ;;
    -srcdir=* | --srcdir=* | --srcdi=* | --srcd=* | --src=* | --sr=*)
      ;;
    -prefix | --prefix | --prefi | --pref | --pre | --pr | --p)
      ac_prev=prefix ;;
    -prefix=* | --prefix=* | --prefi=* | --pref=* | --pre=* | --pr=* | --p=*)
      ;;
    *) ac_sub_configure_args="$ac_sub_configure_args $ac_arg" ;;
    esac
  done

  # Always prepend --prefix to ensure using the same prefix
  # in subdir configurations.
  ac_sub_configure_args="--prefix=$prefix $ac_sub_configure_args"

  ac_popdir=`pwd`
  for ac_dir in : $subdirs; do test "x$ac_dir" = x: && continue

    # Do not complain, so a configure script can configure whichever
    # parts of a large source tree are present.
    test -d $srcdir/$ac_dir || continue

    AC_MSG_NOTICE([configuring in $ac_dir])
    AS_MKDIR_P(["$ac_dir"])
    _AC_SRCDIRS(["$ac_dir"])

    cd $ac_dir

    # Check for guested configure; otherwise get Cygnus style configure.
    if test -f $ac_srcdir/configure.gnu; then
      ac_sub_configure="$SHELL '$ac_srcdir/configure.gnu'"
    elif test -f $ac_srcdir/configure; then
      ac_sub_configure="$SHELL '$ac_srcdir/configure'"
    elif test -f $ac_srcdir/configure.ac ||
	 test -f $ac_srcdir/configure.in; then
      ac_sub_configure=$ac_configure
    else
      AC_MSG_WARN([no configuration information is in $ac_dir])
      ac_sub_configure=
    fi

    # The recursion is here.
    if test -n "$ac_sub_configure"; then
      # Make the cache file name correct relative to the subdirectory.
      case $cache_file in
      [[\\/]]* | ?:[[\\/]]* ) ac_sub_cache_file=$cache_file ;;
      *) # Relative name.
	ac_sub_cache_file=$ac_top_build_prefix$cache_file ;;
      esac

      AC_MSG_NOTICE([running $ac_sub_configure $ac_sub_configure_args --cache-file=$ac_sub_cache_file --srcdir=$ac_srcdir])
      # The eval makes quoting arguments work.
      eval $ac_sub_configure $ac_sub_configure_args \
	   --cache-file=$ac_sub_cache_file --srcdir=$ac_srcdir ||
	AC_MSG_ERROR([$ac_sub_configure failed for $ac_dir])
    fi

    cd "$ac_popdir"
  done
fi
])# _AC_OUTPUT_SUBDIRS




## -------------------------- ##
## Outputting config.status.  ##
## -------------------------- ##


# autoupdate::AC_OUTPUT([CONFIG_FILES...], [EXTRA-CMDS], [INIT-CMDS])
# -------------------------------------------------------------------
#
# If there are arguments given to AC_OUTPUT, dispatch them to the
# proper modern macros.
AU_DEFUN([AC_OUTPUT],
[m4_ifvaln([$1],
	   [AC_CONFIG_FILES([$1])])dnl
m4_ifvaln([$2$3],
	  [AC_CONFIG_COMMANDS(default, [[$2]], [[$3]])])dnl
[AC_OUTPUT]])


# AC_OUTPUT([CONFIG_FILES...], [EXTRA-CMDS], [INIT-CMDS])
# -------------------------------------------------------
# The big finish.
# Produce config.status, config.h, and links; and configure subdirs.
# The CONFIG_HEADERS are defined in the m4 variable AC_LIST_HEADERS.
# Pay special attention not to have too long here docs: some old
# shells die.  Unfortunately the limit is not known precisely...
m4_define([AC_OUTPUT],
[dnl Dispatch the extra arguments to their native macros.
m4_ifval([$1],
	 [AC_CONFIG_FILES([$1])])dnl
m4_ifval([$2$3],
	 [AC_CONFIG_COMMANDS(default, [$2], [$3])])dnl
m4_ifval([$1$2$3],
	 [AC_DIAGNOSE([obsolete],
		      [$0 should be used without arguments.
You should run autoupdate.])])dnl
AC_CACHE_SAVE

test "x$prefix" = xNONE && prefix=$ac_default_prefix
# Let make expand exec_prefix.
test "x$exec_prefix" = xNONE && exec_prefix='${prefix}'

# VPATH may cause trouble with some makes, so we remove $(srcdir),
# ${srcdir} and @srcdir@ from VPATH if srcdir is ".", strip leading and
# trailing colons and then remove the whole line if VPATH becomes empty
# (actually we leave an empty line to preserve line numbers).
if test "x$srcdir" = x.; then
  ac_vpsub=['/^[	 ]*VPATH[	 ]*=/{
s/:*\$(srcdir):*/:/;
s/:*\${srcdir}:*/:/;
s/:*@srcdir@:*/:/;
s/^\([^=]*=[	 ]*\):*/\1/;
s/:*$//;
s/^[^=]*=[	 ]*$//;
}']
fi

m4_ifset([AC_LIST_HEADERS], [DEFS=-DHAVE_CONFIG_H], [AC_OUTPUT_MAKE_DEFS()])

dnl Commands to run before creating config.status.
AC_OUTPUT_COMMANDS_PRE()dnl

: ${CONFIG_STATUS=./config.status}
ac_clean_files_save=$ac_clean_files
ac_clean_files="$ac_clean_files $CONFIG_STATUS"
_AC_OUTPUT_CONFIG_STATUS()dnl
ac_clean_files=$ac_clean_files_save

dnl Commands to run after config.status was created
AC_OUTPUT_COMMANDS_POST()dnl

# configure is writing to config.log, and then calls config.status.
# config.status does its own redirection, appending to config.log.
# Unfortunately, on DOS this fails, as config.log is still kept open
# by configure, so config.status won't be able to write to it; its
# output is simply discarded.  So we exec the FD to /dev/null,
# effectively closing config.log, so it can be properly (re)opened and
# appended to by config.status.  When coming back to configure, we
# need to make the FD available again.
if test "$no_create" != yes; then
  ac_cs_success=:
  ac_config_status_args=
  test "$silent" = yes &&
    ac_config_status_args="$ac_config_status_args --quiet"
  exec AS_MESSAGE_LOG_FD>/dev/null
  $SHELL $CONFIG_STATUS $ac_config_status_args || ac_cs_success=false
  exec AS_MESSAGE_LOG_FD>>config.log
  # Use ||, not &&, to avoid exiting from the if with $? = 1, which
  # would make configure fail if this is the last instruction.
  $ac_cs_success || AS_EXIT([1])
fi
dnl config.status should not do recursion.
AC_PROVIDE_IFELSE([AC_CONFIG_SUBDIRS], [_AC_OUTPUT_SUBDIRS()])dnl
])# AC_OUTPUT


# _AC_OUTPUT_CONFIG_STATUS
# ------------------------
# Produce config.status.  Called by AC_OUTPUT.
# Pay special attention not to have too long here docs: some old
# shells die.  Unfortunately the limit is not known precisely...
m4_define([_AC_OUTPUT_CONFIG_STATUS],
[AC_MSG_NOTICE([creating $CONFIG_STATUS])
cat >$CONFIG_STATUS <<_ACEOF
#! $SHELL
# Generated by $as_me.
# Run this file to recreate the current configuration.
# Compiler output produced by configure, useful for debugging
# configure, is in config.log if it exists.

debug=false
ac_cs_recheck=false
ac_cs_silent=false
SHELL=\${CONFIG_SHELL-$SHELL}
_ACEOF

cat >>$CONFIG_STATUS <<\_ACEOF
AS_SHELL_SANITIZE
dnl Watch out, this is directly the initializations, do not use
dnl AS_PREPARE, otherwise you'd get it output in the initialization
dnl of configure, not config.status.
_AS_PREPARE
exec AS_MESSAGE_FD>&1

# Open the log real soon, to keep \$[0] and so on meaningful, and to
# report actual input values of CONFIG_FILES etc. instead of their
# values after options handling.  Logging --version etc. is OK.
exec AS_MESSAGE_LOG_FD>>config.log
{
  echo
  AS_BOX([Running $as_me.])
} >&AS_MESSAGE_LOG_FD
cat >&AS_MESSAGE_LOG_FD <<_CSEOF

This file was extended by m4_ifset([AC_PACKAGE_NAME], [AC_PACKAGE_NAME ])dnl
$as_me[]m4_ifset([AC_PACKAGE_VERSION], [ AC_PACKAGE_VERSION]), which was
generated by m4_PACKAGE_STRING.  Invocation command line was

  CONFIG_FILES    = $CONFIG_FILES
  CONFIG_HEADERS  = $CONFIG_HEADERS
  CONFIG_LINKS    = $CONFIG_LINKS
  CONFIG_COMMANDS = $CONFIG_COMMANDS
  $ $[0] $[@]

_CSEOF
echo "on `(hostname || uname -n) 2>/dev/null | sed 1q`" >&AS_MESSAGE_LOG_FD
echo >&AS_MESSAGE_LOG_FD
_ACEOF

# Files that config.status was made for.
if test -n "$ac_config_files"; then
  echo "config_files=\"$ac_config_files\"" >>$CONFIG_STATUS
fi

if test -n "$ac_config_headers"; then
  echo "config_headers=\"$ac_config_headers\"" >>$CONFIG_STATUS
fi

if test -n "$ac_config_links"; then
  echo "config_links=\"$ac_config_links\"" >>$CONFIG_STATUS
fi

if test -n "$ac_config_commands"; then
  echo "config_commands=\"$ac_config_commands\"" >>$CONFIG_STATUS
fi

cat >>$CONFIG_STATUS <<\_ACEOF

ac_cs_usage="\
\`$as_me' instantiates files from templates according to the
current configuration.

Usage: $[0] [[OPTIONS]] [[FILE]]...

  -h, --help       print this help, then exit
  -V, --version    print version number, then exit
  -q, --quiet      do not print progress messages
  -d, --debug      don't remove temporary files
      --recheck    update $as_me by reconfiguring in the same conditions
m4_ifset([AC_LIST_FILES],
[[  --file=FILE[:TEMPLATE]
		   instantiate the configuration file FILE
]])dnl
m4_ifset([AC_LIST_HEADERS],
[[  --header=FILE[:TEMPLATE]
		   instantiate the configuration header FILE
]])dnl

m4_ifset([AC_LIST_FILES],
[Configuration files:
$config_files

])dnl
m4_ifset([AC_LIST_HEADERS],
[Configuration headers:
$config_headers

])dnl
m4_ifset([AC_LIST_LINKS],
[Configuration links:
$config_links

])dnl
m4_ifset([AC_LIST_COMMANDS],
[Configuration commands:
$config_commands

])dnl
Report bugs to <bug-autoconf@gnu.org>."
_ACEOF

cat >>$CONFIG_STATUS <<_ACEOF
ac_cs_version="\\
m4_ifset([AC_PACKAGE_NAME], [AC_PACKAGE_NAME ])config.status[]dnl
m4_ifset([AC_PACKAGE_VERSION], [ AC_PACKAGE_VERSION])
configured by $[0], generated by m4_PACKAGE_STRING,
  with options \\"`echo "$ac_configure_args" | sed 's/[[\\""\`\$]]/\\\\&/g'`\\"

Copyright (C) 2005 Free Software Foundation, Inc.
This config.status script is free software; the Free Software Foundation
gives unlimited permission to copy, distribute and modify it."
ac_pwd='$ac_pwd'
srcdir='$srcdir'
AC_PROVIDE_IFELSE([AC_PROG_INSTALL],
[dnl Leave those double quotes here: this $INSTALL is evaluated in a
dnl here document, which might result in `INSTALL=/bin/install -c'.
INSTALL="$INSTALL"
])dnl
_ACEOF

cat >>$CONFIG_STATUS <<\_ACEOF
# If no file are specified by the user, then we need to provide default
# value.  By we need to know if files were specified by the user.
ac_need_defaults=:
while test $[#] != 0
do
  case $[1] in
  --*=*)
    ac_option=`expr "X$[1]" : 'X\([[^=]]*\)='`
    ac_optarg=`expr "X$[1]" : 'X[[^=]]*=\(.*\)'`
    ac_shift=:
    ;;
  -*)
    ac_option=$[1]
    ac_optarg=$[2]
    ac_shift=shift
    ;;
  *) # This is not an option, so the user has probably given explicit
     # arguments.
     ac_option=$[1]
     ac_need_defaults=false;;
  esac

  case $ac_option in
  # Handling of the options.
_ACEOF
cat >>$CONFIG_STATUS <<\_ACEOF
  -recheck | --recheck | --rechec | --reche | --rech | --rec | --re | --r)
    ac_cs_recheck=: ;;
  --version | --versio | --versi | --vers | --ver | --ve | --v | -V )
    echo "$ac_cs_version"; exit ;;
  --he | --h)
    # Conflict between --help and --header
    AC_MSG_ERROR([ambiguous option: $[1]
Try `$[0] --help' for more information.]);;
  --help | --hel | -h )
    echo "$ac_cs_usage"; exit ;;
  --debug | --debu | --deb | --de | --d | -d )
    debug=: ;;
  --file | --fil | --fi | --f )
    $ac_shift
    CONFIG_FILES="$CONFIG_FILES $ac_optarg"
    ac_need_defaults=false;;
  --header | --heade | --head | --hea )
    $ac_shift
    CONFIG_HEADERS="$CONFIG_HEADERS $ac_optarg"
    ac_need_defaults=false;;
  -q | -quiet | --quiet | --quie | --qui | --qu | --q \
  | -silent | --silent | --silen | --sile | --sil | --si | --s)
    ac_cs_silent=: ;;

  # This is an error.
  -*) AC_MSG_ERROR([unrecognized option: $[1]
Try `$[0] --help' for more information.]) ;;

  *) ac_config_targets="$ac_config_targets $[1]" ;;

  esac
  shift
done

ac_configure_extra_args=

if $ac_cs_silent; then
  exec AS_MESSAGE_FD>/dev/null
  ac_configure_extra_args="$ac_configure_extra_args --silent"
fi

_ACEOF
cat >>$CONFIG_STATUS <<_ACEOF
if \$ac_cs_recheck; then
  echo "running $SHELL $[0] " $ac_configure_args \$ac_configure_extra_args " --no-create --no-recursion" >&AS_MESSAGE_FD
  exec $SHELL $[0] $ac_configure_args \$ac_configure_extra_args --no-create --no-recursion
fi

_ACEOF

dnl We output the INIT-CMDS first for obvious reasons :)
m4_ifset([_AC_OUTPUT_COMMANDS_INIT],
[cat >>$CONFIG_STATUS <<_ACEOF
#
# INIT-COMMANDS section.
#

_AC_OUTPUT_COMMANDS_INIT()
_ACEOF])


dnl Issue this section only if there were actually config files.
dnl This checks if one of AC_LIST_HEADERS, AC_LIST_FILES, AC_LIST_COMMANDS,
dnl or AC_LIST_LINKS is set.
m4_ifval(AC_LIST_HEADERS()AC_LIST_LINKS()AC_LIST_FILES()AC_LIST_COMMANDS(),
[
cat >>$CONFIG_STATUS <<\_ACEOF
for ac_config_target in $ac_config_targets
do
  case "$ac_config_target" in
  # Handling of arguments.
AC_FOREACH([AC_File], AC_LIST_FILES,
[  "m4_bpatsubst(AC_File, [:.*])" )dnl
 CONFIG_FILES="$CONFIG_FILES AC_File" ;;
])dnl
AC_FOREACH([AC_File], AC_LIST_LINKS,
[  "m4_bpatsubst(AC_File, [:.*])" )dnl
 CONFIG_LINKS="$CONFIG_LINKS AC_File" ;;
])dnl
AC_FOREACH([AC_File], AC_LIST_COMMANDS,
[  "m4_bpatsubst(AC_File, [:.*])" )dnl
 CONFIG_COMMANDS="$CONFIG_COMMANDS AC_File" ;;
])dnl
AC_FOREACH([AC_File], AC_LIST_HEADERS,
[  "m4_bpatsubst(AC_File, [:.*])" )dnl
 CONFIG_HEADERS="$CONFIG_HEADERS AC_File" ;;
])dnl
  *) AC_MSG_ERROR([invalid argument: $ac_config_target]);;
  esac
done

# If the user did not use the arguments to specify the items to instantiate,
# then the envvar interface is used.  Set only those that are not.
# We use the long form for the default assignment because of an extremely
# bizarre bug on SunOS 4.1.3.
if $ac_need_defaults; then
m4_ifset([AC_LIST_FILES],
[  test "${CONFIG_FILES+set}" = set || CONFIG_FILES=$config_files
])dnl
m4_ifset([AC_LIST_HEADERS],
[  test "${CONFIG_HEADERS+set}" = set || CONFIG_HEADERS=$config_headers
])dnl
m4_ifset([AC_LIST_LINKS],
[  test "${CONFIG_LINKS+set}" = set || CONFIG_LINKS=$config_links
])dnl
m4_ifset([AC_LIST_COMMANDS],
[  test "${CONFIG_COMMANDS+set}" = set || CONFIG_COMMANDS=$config_commands
])dnl
fi

# Have a temporary directory for convenience.  Make it in the build tree
# simply because there is no reason against having it here, and in addition,
# creating and moving files from /tmp can sometimes cause problems.
# Hook for its removal unless debugging.
$debug ||
{
  trap 'exit_status=$?; rm -fr "$tmp" && exit $exit_status' 0
  trap 'AS_EXIT([1])' 1 2 13 15
}
dnl The comment above AS_TMPDIR says at most 4 chars are allowed.
AS_TMPDIR([conf], [.])

_ACEOF
])[]dnl m4_ifval

dnl The following four sections are in charge of their own here
dnl documenting into $CONFIG_STATUS.
m4_ifset([AC_LIST_FILES],    [_AC_OUTPUT_FILES()])dnl
m4_ifset([AC_LIST_HEADERS],  [_AC_OUTPUT_HEADERS()])dnl
m4_ifset([AC_LIST_LINKS],    [_AC_OUTPUT_LINKS()])dnl
m4_ifset([AC_LIST_COMMANDS], [_AC_OUTPUT_COMMANDS()])dnl

cat >>$CONFIG_STATUS <<\_ACEOF

AS_EXIT(0)
_ACEOF
chmod +x $CONFIG_STATUS
])# _AC_OUTPUT_CONFIG_STATUS


# AC_OUTPUT_MAKE_DEFS
# -------------------
# Set the DEFS variable to the -D options determined earlier.
# This is a subroutine of AC_OUTPUT.
# It is called inside configure, outside of config.status.
# Using a here document instead of a string reduces the quoting nightmare.
m4_define([AC_OUTPUT_MAKE_DEFS],
[[# Transform confdefs.h into DEFS.
# Protect against shell expansion while executing Makefile rules.
# Protect against Makefile macro expansion.
#
# If the first sed substitution is executed (which looks for macros that
# take arguments), then we branch to the quote section.  Otherwise,
# look for a macro that doesn't take arguments.
cat >confdef2opt.sed <<\_ACEOF
t clear
: clear
s,^[	 ]*#[	 ]*define[	 ][	 ]*\([^	 (][^	 (]*([^)]*)\)[	 ]*\(.*\),-D\1=\2,g
t quote
s,^[	 ]*#[	 ]*define[	 ][	 ]*\([^	 ][^	 ]*\)[	 ]*\(.*\),-D\1=\2,g
t quote
d
: quote
s,[	 `~#$^&*(){}\\|;'"<>?],\\&,g
s,\[,\\&,g
s,\],\\&,g
s,\$,$$,g
p
_ACEOF
# We use echo to avoid assuming a particular line-breaking character.
# The extra dot is to prevent the shell from consuming trailing
# line-breaks from the sub-command output.  A line-break within
# single-quotes doesn't work because, if this script is created in a
# platform that uses two characters for line-breaks (e.g., DOS), tr
# would break.
ac_LF_and_DOT=`echo; echo .`
DEFS=`sed -n -f confdef2opt.sed confdefs.h | tr "$ac_LF_and_DOT" ' .'`
rm -f confdef2opt.sed
]])# AC_OUTPUT_MAKE_DEFS
