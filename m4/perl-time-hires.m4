# perl-time-hires.m4 serial 1

# Copyright (C) 2022-2023 Free Software Foundation, Inc.

# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without warranty of any kind.

# AClocal_PATH_PROG_GLOBS_FEATURE_CHECK
# ---------------------------------
# Like AC_PATH_PROGS_FEATURE_CHECK, but each of 'progs-to-check-for' may
# be a shell glob, which is expanded once for each path entry.
# That is, AClocal_PATH_PROG_GLOBS_FEATURE_CHECK([PERL], [perl-*]) will
# test each program named something like 'perl-*' found anywhere on the
# path.  Due to the syntax conflict with Autoconf string quoting,
# character sets (e.g. perl-[56]*) are not supported.
m4_define([AClocal_PATH_PROG_GLOBS_FEATURE_CHECK],
[if test -z "$$1"; then
  ac_path_$1_found=false
  # Loop through the user's path and test for each of PROGNAME-LIST
  dnl AS_ESCAPE has been excessively optimized and does not work for anything
  dnl other than constructing strings.  I have not been able to figure out how
  dnl to get [ and ] through this process without mangling them, so
  dnl character sets are not supported for now.
  _AS_PATH_WALK([$5],
  [for ac_prog in m4_bpatsubst([$2], [[!?*]], [\\\&])
   do
    for ac_exec_ext in '' $ac_executable_extensions; do
      ac_pathglob_$1="$as_dir$ac_prog$ac_exec_ext"
      for ac_path_$1 in $ac_pathglob_$1; do
        AS_EXECUTABLE_P(["$ac_path_$1"]) || continue
$3
        $ac_path_$1_found && break 4
      done
    done
  done])dnl
  if test -z "$ac_cv_path_$1"; then
    m4_default([$4],
      [AC_MSG_ERROR([no acceptable m4_bpatsubst([$2], [ .*]) could be dnl
found in m4_default([$5], [\$PATH])])])
  fi
else
  ac_cv_path_$1=$$1
fi
])

# AC_PATH_PERL_WITH_TIME_HIRES_STAT
# ---------------------------------
# Check for a version of perl that supports Time::HiRes::stat.
# This was added to perl core in 5.10 and it's convenient to
# have a consistent 'use 5.0xx' baseline for all the perl scripts,
# so that is the version we require, even though technically we
# could be getting away with 5.8 or even 5.6 in many of the scripts.
# (Note: Files shared with Automake do not necessarily use our baseline.)
AC_DEFUN([AC_PATH_PERL_WITH_TIME_HIRES_STAT],
  [AC_ARG_VAR([PERL], [Location of Perl 5.10 or later.  Defaults to
    the first program named 'perl', 'perl5*', or 'perl-5.*' on the PATH
    that meets Autoconf's needs.])
  AC_CACHE_CHECK([for Perl >=5.10.0 with Time::HiRes::stat],
                 [ac_cv_path_PERL],
    [AClocal_PATH_PROG_GLOBS_FEATURE_CHECK(
        [PERL], [perl perl5* perl-5.*],
        [AS_ECHO("$as_me:${as_lineno-$LINENO}: trying $ac_path_PERL") \
             >&AS_MESSAGE_LOG_FD
         $ac_path_PERL >&AS_MESSAGE_LOG_FD 2>&AS_MESSAGE_LOG_FD -e '
  use 5.010;
  use Time::HiRes qw(stat);
  1;' \
         && ac_cv_path_PERL=$ac_path_PERL ac_path_PERL_found=:],
    [AC_MSG_ERROR([no acceptable perl could be found in \$PATH.
Perl 5.10.0 or later is required, with Time::HiRes::stat.])])])
  PERL=$ac_cv_path_PERL
])
