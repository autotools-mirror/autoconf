# actest.m4                                              -*- autoconf -*-
# Additional Autoconf macros to ease testing.

# AC_STATE_SAVE(FILE)
# ------------------
# Save the environment, but the variables we are allowed to touch.
# This is to check no test touches the user name space.
# FIXME: There are surely better ways.  Explore for instance if
# we can ask help from AC_SUBST.  We have the right to touch what
# is AC_SUBST.
# - ^ac_
#   Autoconf's shell name space.
# - ALLOCA|NEED_SETGID|KMEM_GROUP
#   AC_FUNCs from acspecific.
# - AWK|LEX|LEXLIB|LEX_OUTPUT_ROOT|LN_S|M4|RANLIB|SET_MAKE|YACC
#   AC_PROGs from acspecific
# - _|@|.[*#?].|LINENO|OLDPWD|PIPESTATUS|RANDOM|SECONDS
#   Some variables some shells use and change.
#   `.[*#?].' catches `$#' etc. which are displayed like this:
#      | '!'=18186
#      | '#'=0
#      | '$'=6908
# - POW_LIB
#   From acfunctions.m4.
#
# Some `egrep' choke on such a big regex (e.g., SunOS 4.1.3).  In this
# case just don't pay attention to the env.  It would be great
# to keep the error message but we can't: that would break AT_CHECK.
m4_defun([AC_STATE_SAVE],
[(set) 2>&1 |
  egrep -v -e 'm4_join([|],
      [^ac_],
      [^(CC|CFLAGS|CPP|GCC|CXX|CXXFLAGS|CXXCPP|GXX|F77|FFLAGS|FLIBS|G77)=],
      [^(LIBS|LIBOBJS|LDFLAGS)=],
      [^INSTALL(_(DATA|PROGRAM|SCRIPT))?=],
      [^(CYGWIN|ISC|MINGW32|MINIX|EMXOS2|XENIX|EXEEXT|OBJEXT)=],
      [^(X_(CFLAGS|(EXTRA_|PRE_)?LIBS)|x_(includes|libraries)|(have|no)_x)=],
      [^(host|build|target)(_(alias|cpu|vendor|os))?=],
      [^(cross_compiling)=],
      [^(interpval)=],
      [^(f77_(case|underscore))=],
      [^(ALLOCA|GETLOADAVG_LIBS|KMEM_GROUP|NEED_SETGID|POW_LIB)=],
      [^(AWK|LEX|LEXLIB|LEX_OUTPUT_ROOT|LN_S|M4|RANLIB|SET_MAKE|YACC)=],
      [^(_|@|.[*#?].|LINENO|OLDPWD|PIPESTATUS|RANDOM|SECONDS)=])' 2>/dev/null |
  # There maybe variables spread on several lines, eg IFS, remove the dead
  # lines.
  fgrep = >state-env.$1
test $? = 0 || rm -f state-env.$1

ls -1 | grep -v '^state' | sort >state-ls.$1
])# AC_STATE_SAVE



# AC_DEFUBST(NAME)
# ----------------
# Related VALUE to NAME both with AC_SUBST and AC_DEFINE.  This is
# used in the torture tests.
m4_defun([AC_DEFUBST],
[AC_DUMMY_VAR($1)="AC_DEFUBST_VALUE"
AC_DEFINE_UNQUOTED(AC_DUMMY_VAR($1),
                   "$AC_DUMMY_VAR($1)",
                   [Define to a long string if your `Autoconf' works
                    properly.])
AC_SUBST(AC_DUMMY_VAR($1))])
