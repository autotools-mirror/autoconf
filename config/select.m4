# AC_FUNC_SELECT_ARGTYPES
# -----------------------
# Determine the correct type to be passed to each of the `select'
# function's arguments, and define those types in `SELECT_TYPE_ARG1',
# `SELECT_TYPE_ARG234', and `SELECT_TYPE_ARG5'.
AC_DEFUN([AC_FUNC_SELECT_ARGTYPES],
[# Common prologue for testing `select ()'.
AC_CHECK_HEADERS(unistd.h sys/time.h sys/select.h sys/socket.h)
ac_func_select_argtypes_includes="\
#include <sys/types.h>
#if HAVE_SYS_TIME_H
# include <sys/time.h>
#endif
#ifdef HAVE_UNISTD_H
# include <unistd.h>
#endif
#if HAVE_SYS_SELECT_H
# include <sys/select.h>
#endif
#if HAVE_SYS_SOCKET_H
# include <sys/socket.h>
#endif"

# 1. Looking for the types of the arguments.
AC_CACHE_CHECK([types of arguments for select],
[ac_cv_func_select_args],
[for ac_arg234 in 'fd_set *' 'int *' 'void *'; do
 for ac_arg1 in 'int' 'size_t' 'unsigned long' 'unsigned'; do
  for ac_arg5 in 'struct timeval *' 'const struct timeval *'; do
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM(
[$ac_func_select_argtypes_includes
#ifdef __STDC__
extern int select ($ac_arg1,
                   $ac_arg234,  $ac_arg234, $ac_arg234,
                   $ac_arg5);
#else
extern int select ();
  $ac_arg1 s;
  $ac_arg234 p;
  $ac_arg5 t;
#endif
])],
              [ac_cv_func_select_args="$ac_arg1,$ac_arg234,$ac_arg5"; break 3])
  done
 done
done
# Provide a safe default value.
: ${ac_cv_func_select_args='int,int *,struct timeval *'}
])
ac_save_IFS=$IFS; IFS=','
set dummy `echo "$ac_cv_func_select_args" | sed 's/\*/\*/g'`
IFS=$ac_save_IFS
shift
AC_DEFINE_UNQUOTED(SELECT_TYPE_ARG1, $[1],
                   [Define to the type of arg 1 for `select'.])
AC_DEFINE_UNQUOTED(SELECT_TYPE_ARG234, ($[2]),
                   [Define to the type of args 2, 3 and 4 for `select'.])
AC_DEFINE_UNQUOTED(SELECT_TYPE_ARG5, ($[3]),
                   [Define to the type of arg 5 for `select'.])

# 2. Is `fd_set' defined?
ac_cast=
if test "$[2]" != fd_set; then
  # Arguments 2-4 are not fd_set.  Some weirdo systems use fd_set type
  # for FD_SET macros, but insist that you cast the argument to
  # select.  I don't understand why that might be, but it means we
  # cannot define fd_set.
  AC_CHECK_TYPE([fd_set],
                [AC_DEFINE_UNQUOTED(fd_set, $[2],
                                    [Define if the type of arguments 2, 3 and 4
                                     to `select' is `fd_set' and `fd_set' is
                                     not defined.])
ac_cast="($[2] *)"],
                [],
                [$ac_func_select_argtypes_includes])
fi

# 3. Define the cast.
AC_DEFINE_UNQUOTED(SELECT_FD_SET_CAST, $ac_cast,
                   [Define if the type in arguments 2, 3 and 4 to `select' is
                    `fd_set'.])

])# AC_FUNC_SELECT_ARGTYPES
