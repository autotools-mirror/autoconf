dnl actest.m4                                              -*- autoconf -*-
dnl Additional Autoconf macros to ease testing.

# join(SEP, ARG1, ARG2...)
# ------------------------
# Produce ARG1SEPARG2...SEPARGn.
define(join,
[ifelse([$#], [1], [],
        [$#], [2], [[$2]],
        [[$2][$1]join([$1], m4_shift(m4_shift($@)))])])


# AC_ENV_SAVE(FILE)
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
# - _|LINENO|OLDPWD|PIPESTATUS|RANDOM|SECONDS
#   Some variables some shells use and change

AC_DEFUN(AC_ENV_SAVE,
[(set) 2>&1 |
  egrep -v -e \
'join([|],
      [^ac_],
      [^(CC|CFLAGS|CPP|GCC|CXX|CXXFLAGS|CXXCPP|GXX|F77|FFLAGS|FLIBS|G77)=],
      [^(LIBS|LIBOBJS|LDFLAGS)=],
      [^INSTALL(_(DATA|PROGRAM|SCRIPT))?=],
      [^(CYGWIN|ISC|MINGW32|MINIX|EMXOS2|EXEEXT|OBJEXT)=],
      [^(X_(CFLAGS|(EXTRA_|PRE_)?LIBS)|x_(includes|libraries)|have_x)=],
      [^(host|build|target)(_(alias|cpu|vendor|os))?=],
      [^(cross_compiling)=],
      [^(interpval)=],
      [^(f77_(case|underscore))=],
      [^(ALLOCA|NEED_SETGID|KMEM_GROUP)=],
      [^(AWK|LEX|LEXLIB|LEX_OUTPUT_ROOT|LN_S|M4|RANLIB|SET_MAKE|YACC)=],
      [^(_|LINENO|OLDPWD|PIPESTATUS|RANDOM|SECONDS)=])' |
  # There maybe variables spread on several lines, eg IFS, remove the dead
  # lines
  fgrep = >$1
])



# AC_DEFUBST(NAME)
# ----------------
# Related VALUE to NAME both with AC_SUBST and AC_DEFINE.  This is
# used in the torture tests.
AC_DEFUN(AC_DEFUBST,
[AC_DUMMY_VAR($1)="AC_DEFUBST_VALUE"
AC_DEFINE_UNQUOTED(AC_DUMMY_VAR($1),
                   "$AC_DUMMY_VAR($1)",
                   [Define to a long string if your `Autoconf' works
                    properly.])
AC_SUBST(AC_DUMMY_VAR($1))])
