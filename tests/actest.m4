dnl actest.m4                                              -*- autoconf -*-
dnl Additional Autoconf macros to ease testing.


# AC_ENV_SAVE(FILE)
# ------------------
# Save the environment, but the variables we are allowed to touch.
# This is to check no test touches the user name space.
# FIXME: There are surely better ways.  Explore for instance if
# we can ask help from AC_SUBST.  We have the right to touch what
# is AC_SUBST.
AC_DEFUN(AC_ENV_SAVE,
[(set) 2>&1 |
  grep -v '^ac_' |
  # Some variables we are allowed to touch
  egrep -v '^(CC|CFLAGS|CPP|GCC|CXX|CXXFLAGS|CXXCPP|GXX|LIBS|LIBOBJS|LDFLAGS)=' |
  egrep -v '^(AWK|LEX|LEXLIB|LEX_OUTPUT_ROOT|LN_S|M4|RANLIB|SET_MAKE|YACC)=' |
  egrep -v '^INSTALL(_(DATA|PROGRAM|SCRIPT))?=' |
  egrep -v '^(CYGWIN|ISC|MINGW32|MINIX|EMXOS2|EXEEXT|OBJEXT)=' |
  egrep -v '^(NEED_SETGID)=' |
  egrep -v '^(X_(CFLAGS|LIBS|PRE_LIBS)|x_(includes|libraries)|have_x)=' |
  egrep -v '^(host|build|target)(_(alias|cpu|vendor|os))?=' |
  egrep -v '^(cross_compiling)=' |
  egrep -v '^(interpval)=' |
  # Some variables some shells use and change
  egrep -v '^(_|PIPESTATUS|OLDPWD)=' |
  # There maybe variables spread on several lines, eg IFS, remove the dead
  # lines
  fgrep = >$1
])
