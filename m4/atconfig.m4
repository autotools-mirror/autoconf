## ----------------------##                              -*- Autoconf -*-
## Prepare for testing.  ##
## ----------------------##

#serial 2

# Single argument says where are built sources to test, relative to the
# built test directory.  Maybe omitted if the same (flat distribution).

AC_DEFUN([AT_CONFIG],
[AUTOTEST_PATH=ifelse([$1], [], [.], [$1])
AC_SUBST(AUTOTEST_PATH)
])
