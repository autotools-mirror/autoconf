dnl Parameterized macros that do not check for something specific.
dnl This file is part of Autoconf.
dnl Copyright (C) 1992, 1993, 1994 Free Software Foundation, Inc.
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
dnl Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
dnl
dnl Written by David MacKenzie, with help from
dnl Franc,ois Pinard, Karl Berry, Richard Pixley, Ian Lance Taylor,
dnl Roland McGrath, Noah Friedman, and david d zuhn.
dnl
changequote([,])dnl
undefine([eval])dnl
undefine([include])dnl
undefine([shift])dnl
undefine([format])dnl
dnl
ifdef([__gnu__], , [errprint(Autoconf requires GNU m4
)m4exit(2)])dnl
dnl
define(AC_ACVERSION, 1.93)dnl
dnl This is defined by the --version option of the autoconf script.
ifdef([AC_PRINT_VERSION], [errprint(Autoconf version AC_ACVERSION
)m4exit(0)])dnl
dnl
dnl
dnl ### Controlling Autoconf operation
dnl
dnl
dnl m4 diversions:
define(AC_DIVERSION_NORMAL, 0)dnl	normal output
define(AC_DIVERSION_SED, 1)dnl		sed substitutions for config.status
define(AC_DIVERSION_VAR, 2)dnl		variable assignments for config.status
define(AC_DIVERSION_HELP_ENABLE, 3)dnl	--enable/--disable help strings
define(AC_DIVERSION_ARG_ENABLE, 4)dnl	--enable/--disable actions
define(AC_DIVERSION_HELP_WITH, 5)dnl	--with/--without help strings
define(AC_DIVERSION_ARG_WITH, 6)dnl	--with/--without actions
dnl
define(AC_NOTICE,
[# Guess values for system-dependent variables and create Makefiles.
# Generated automatically using autoconf version] AC_ACVERSION [
# Copyright (C) 1991, 1992, 1993, 1994 Free Software Foundation, Inc.
#
# This configure script is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This script is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
])dnl
dnl
define(AC_PARSEARGS,
[AC_BEFORE([$0], [AC_ARG_ENABLE])dnl
AC_BEFORE([$0], [AC_ARG_WITH])dnl
# Save the original args to write them into config.status later.
configure_args="[$]*"

# Omit some internal, obsolete, or unimplemented options to make the
# list less imposing.
changequote(,)dnl
ac_usage="Usage: configure [options] [host]
Options: [defaults in brackets after descriptions]
--build=BUILD		configure for building on BUILD [BUILD=HOST]
--cache-file=FILE	cache test results in FILE
--disable-FEATURE	do not include FEATURE (same as --enable-FEATURE=no)
--enable-FEATURE[=ARG]	include FEATURE [ARG=yes]
--exec-prefix=PREFIX	install host dependent files in PREFIX [/usr/local]
--help			print this message
--host=HOST		configure for HOST [guessed]
--no-create		do not create output files
--prefix=PREFIX		install host independent files in PREFIX [/usr/local]
--quiet, --silent	do not print \`checking for...' messages
--srcdir=DIR		find the sources in DIR [configure dir or ..]
--target=TARGET		configure for TARGET [TARGET=HOST]
--verbose		print results of checks
--version		print the version of autoconf that created configure
--with-PACKAGE[=ARG]	use PACKAGE [ARG=yes]
--without-PACKAGE	do not use PACKAGE (same as --with-PACKAGE=no)
--x-includes=DIR	X include files are in DIR
--x-libraries=DIR	X library files are in DIR

--enable/--disable options recognized:
undivert(AC_DIVERSION_HELP_ENABLE)dnl
--with/--without options recognized:
undivert(AC_DIVERSION_HELP_WITH)"dnl
changequote([,])dnl

# Initialize some variables set by options.
# The variables have the same names as the options, with
# dashes changed to underlines.
build=NONE
cache_file=./config.cache
exec_prefix=NONE
host=NONE
no_create=
nonopt=NONE
norecursion=
prefix=NONE
program_prefix=
program_suffix=
program_transform_name=
silent=
srcdir=
target=NONE
verbose=
x_includes=
x_libraries=

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
changequote(,)dnl
  -*=*) ac_optarg=`echo "$ac_option" | sed 's/[-_a-zA-Z0-9]*=//'` ;;
changequote([,])dnl
  *) ac_optarg= ;;
  esac

  # Accept (but ignore some of) the important Cygnus configure
  # options, so we can diagnose typos.

  case "$ac_option" in

  -build | --build | --buil | --bui | --bu | --b)
    ac_prev=build ;;
  -build=* | --build=* | --buil=* | --bui=* | --bu=* | --b=*)
    build="$ac_optarg" ;;

  -cache-file | --cache-file | --cache-fil | --cache-fi \
  | --cache-f | --cache- | --cache | --cach | --cac | --ca | --c)
    ac_prev=cache_file ;;
  -cache-file=* | --cache-file=* | --cache-fil=* | --cache-fi=* \
  | --cache-f=* | --cache-=* | --cache=* | --cach=* | --cac=* | --ca=* | --c=*)
    cache_file="$ac_optarg" ;;

  -disable-* | --disable-*)
    ac_feature=`echo $ac_option|sed -e 's/-*disable-//'`
    # Reject names that are not valid shell variable names.
changequote(,)dnl
    if test -n "`echo $ac_feature| sed 's/[-a-zA-Z0-9_]//g'`"; then
changequote([,])dnl
      AC_ERROR($ac_feature: invalid feature name)
    fi
    ac_feature=`echo $ac_feature| sed 's/-/_/g'`
    eval "enable_${ac_feature}=no" ;;

  -enable-* | --enable-*)
    ac_feature=`echo $ac_option|sed -e 's/-*enable-//' -e 's/=.*//'`
    # Reject names that are not valid shell variable names.
changequote(,)dnl
    if test -n "`echo $ac_feature| sed 's/[-_a-zA-Z0-9]//g'`"; then
changequote([,])dnl
      AC_ERROR($ac_feature: invalid feature name)
    fi
    ac_feature=`echo $ac_feature| sed 's/-/_/g'`
    case "$ac_option" in
      *=*) ;;
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
    cat << EOF
$ac_usage
EOF
    exit 0 ;;

  -host | --host | --hos | --ho)
    ac_prev=host ;;
  -host=* | --host=* | --hos=* | --ho=*)
    host="$ac_optarg" ;;

  -nfp | --nfp | --nf)
    # Obsolete; use --without-fp.
    with_fp=no ;;

  -no-create | --no-create | --no-creat | --no-crea | --no-cre \
  | --no-cr | --no-c)
    no_create=yes ;;

  -norecursion | --norecursion | --norecursio | --norecursi \
  | --norecurs | --norecur | --norecu | --norec | --nore | --nor)
    norecursion=yes ;;

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

  -srcdir | --srcdir | --srcdi | --srcd | --src | --sr)
    ac_prev=srcdir ;;
  -srcdir=* | --srcdir=* | --srcdi=* | --srcd=* | --src=* | --sr=*)
    srcdir="$ac_optarg" ;;

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
    ac_package=`echo $ac_option|sed -e 's/-*with-//' -e 's/=.*//'`
    # Reject names that are not valid shell variable names.
changequote(,)dnl
    if test -n "`echo $ac_package| sed 's/[-_a-zA-Z0-9]//g'`"; then
changequote([,])dnl
      AC_ERROR($ac_package: invalid package name)
    fi
    ac_package=`echo $ac_package| sed 's/-/_/g'`
    case "$ac_option" in
      *=*) ;;
      *) ac_optarg=yes ;;
    esac
    eval "with_${ac_package}='$ac_optarg'" ;;

  -without-* | --without-*)
    ac_package=`echo $ac_option|sed -e 's/-*without-//'`
    # Reject names that are not valid shell variable names.
changequote(,)dnl
    if test -n "`echo $ac_package| sed 's/[-a-zA-Z0-9_]//g'`"; then
changequote([,])dnl
      AC_ERROR($ac_package: invalid package name)
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

  -*) AC_ERROR([$ac_option: invalid option; use --help to show usage])
    ;;

  *) 
changequote(,)dnl
    if test -n "`echo $ac_option| sed 's/[-a-z0-9.]//g'`"; then
changequote([,])dnl
      AC_WARN($ac_option: invalid host type)
    fi
    if test "x$nonopt" != xNONE; then
      AC_ERROR(can only configure for one host and one target at a time)
    fi
    nonopt="$ac_option"
    ;;

  esac
done

if test -n "$ac_prev"; then
  AC_ERROR(missing argument to --`echo $ac_prev | sed 's/_/-/g'`)
fi
])dnl
dnl
dnl Try to have only one #! line, just so it doesn't look funny.
dnl
define(AC_BINSH,
[AC_PROVIDE([AC_BINSH])dnl
dnl AC_REQUIRE inserts a newline after this.
#!/bin/sh])dnl
dnl
define(AC_INIT,
[AC_REQUIRE([AC_BINSH])dnl
AC_NOTICE
AC_PARSEARGS
AC_PREPARE($1)])dnl
dnl
dnl AC_PREPARE(UNIQUE-FILE-IN-SOURCE-DIR)
define(AC_PREPARE,
[AC_BEFORE([$0], [AC_ARG_ENABLE])dnl
AC_BEFORE([$0], [AC_ARG_WITH])dnl
AC_BEFORE([$0], [AC_CONFIG_HEADER])dnl
AC_BEFORE([$0], [AC_REVISION])dnl
AC_BEFORE([$0], [AC_PREREQ])dnl
AC_BEFORE([$0], [AC_CONFIG_SUBDIRS])dnl
trap 'rm -fr conftest* confdefs* core $ac_clean_files; exit 1' 1 2 15
trap 'rm -fr confdefs* $ac_clean_files' 0

# File descriptor usage:
# 0 unused; standard input
# 1 file creation
# 2 errors and warnings
# 3 unused; some systems may open it to /dev/tty
# 4 checking for... messages
# 5 test results
# 6 compiler messages
if test "$silent" = yes; then
  exec 4>/dev/null
else
  exec 4>&1
fi
if test "$verbose" = yes; then
  exec 5>&1
else
  exec 5>/dev/null
fi
exec 6>./config.log

echo "\
This file contains any messages produced by compilers while
running configure, to aid debugging if configure makes a mistake.
" 1>&6

# Save the original args if we used an alternate arg parser.
ac_configure_temp="${configure_args-[$]*}"
# Strip out --no-create and --norecursion so they do not pile up.
configure_args=
for ac_arg in $ac_configure_temp; do
  case "$ac_arg" in
  -no-create | --no-create | --no-creat | --no-crea | --no-cre \
  | --no-cr | --no-c) ;;
  -norecursion | --norecursion | --norecursio | --norecursi \
  | --norecurs | --norecur | --norecu | --norec | --nore | --nor) ;;
  *) configure_args="$configure_args $ac_arg" ;;
  esac
done

# NLS nuisances.
# Only set LANG and LC_ALL to C if already set.
# These must not be set unconditionally because not all systems understand
# e.g. LANG=C (notably SCO).
if test "${LC_ALL+set}" = set; then LC_ALL=C; export LC_ALL; fi
if test "${LANG+set}"   = set; then LANG=C;   export LANG;   fi

# confdefs.h avoids OS command line length limits that DEFS can exceed.
rm -rf conftest* confdefs.h
# AIX cpp loses on an empty file, so make sure it contains at least a newline.
echo > confdefs.h

# A filename unique to this package, relative to the directory that
# configure is in, which we can look for to find out if srcdir is correct.
ac_unique_file=$1

# Find the source files, if location was not specified.
if test -z "$srcdir"; then
  ac_srcdir_defaulted=yes
  # Try the directory containing this script, then its parent.
  ac_prog=[$]0
changequote(,)dnl
  ac_confdir=`echo $ac_prog|sed 's%/[^/][^/]*$%%'`
changequote([,])dnl
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
    AC_ERROR(can not find sources in ${ac_confdir} or ..)
  else
    AC_ERROR(can not find sources in ${srcdir})
  fi
fi

ifdef([AC_LIST_PREFIX_PROGRAM], [AC_PREFIX(AC_LIST_PREFIX_PROGRAM)])dnl
dnl Let the site file select an alternate cache file if it wants to.
AC_SITE_LOAD
AC_CACHE_LOAD

AC_LANG_C
undivert(AC_DIVERSION_ARG_ENABLE)dnl
undivert(AC_DIVERSION_ARG_WITH)dnl
])dnl
dnl
dnl AC_ARG_ENABLE(FEATURE, HELP-STRING, ACTION-IF-TRUE [, ACTION-IF-FALSE])
define(AC_ARG_ENABLE,
[AC_PROVIDE([$0])dnl
divert(AC_DIVERSION_HELP_ENABLE)dnl
$2
divert(AC_DIVERSION_ARG_ENABLE)dnl
AC_ENABLE_INTERNAL([$1], [$3], [$4])dnl
divert(AC_DIVERSION_NORMAL)dnl
])dnl
dnl
define(AC_ENABLE,
[AC_OBSOLETE([$0], [; instead use AC_ARG_ENABLE before AC_INIT])dnl
AC_ENABLE_INTERNAL([$1], [$2], [$3])dnl
])dnl
dnl
dnl AC_ENABLE_INTERNAL(FEATURE, ACTION-IF-TRUE [, ACTION-IF-FALSE])
define(AC_ENABLE_INTERNAL,
[[#] Check whether --enable-$1 or --disable-$1 was given.
enableval="[$enable_]patsubst($1,-,_)"
if test -n "$enableval"; then
  ifelse([$2], , :, [$2])
ifelse([$3], , , [else
  $3
])dnl
fi
])dnl
dnl
dnl AC_ARG_WITH(PACKAGE, HELP-STRING, ACTION-IF-TRUE [, ACTION-IF-FALSE])
define(AC_ARG_WITH,
[AC_PROVIDE([$0])dnl
divert(AC_DIVERSION_HELP_WITH)dnl
$2
divert(AC_DIVERSION_ARG_WITH)dnl
AC_WITH_INTERNAL([$1], [$3], [$4])dnl
divert(AC_DIVERSION_NORMAL)dnl
])dnl
dnl
define(AC_WITH,
[AC_OBSOLETE([$0], [; instead use AC_ARG_WITH before AC_INIT])dnl
AC_WITH_INTERNAL([$1], [$2], [$3])dnl
])dnl
dnl
dnl AC_WITH_INTERNAL(PACKAGE, ACTION-IF-TRUE [, ACTION-IF-FALSE])
define(AC_WITH_INTERNAL,
[[#] Check whether --with-$1 or --without-$1 was given.
withval="[$with_]patsubst($1,-,_)"
if test -n "$withval"; then
  ifelse([$2], , :, [$2])
ifelse([$3], , , [else
  $3
])dnl
fi
])dnl
dnl
dnl AC_CONFIG_HEADER(HEADER-TO-CREATE ...)
define(AC_CONFIG_HEADER, [AC_PROVIDE([$0])define(AC_LIST_HEADERS, $1)])dnl
dnl
dnl AC_REVISION(REVISION-INFO)
define(AC_REVISION, [AC_PROVIDE([$0])AC_REQUIRE([AC_BINSH])dnl
[# From configure.in] translit([$1],$")])dnl
dnl
dnl Subroutines of AC_PREREQ.
dnl
dnl Change the dots in version number $1 into commas.
define(AC_PREREQ_SPLIT, [translit($1,.,[,])])dnl
dnl
dnl Default the ternary version number to 0 (e.g., 1,7 -> 1,7,0).
define(AC_PREREQ_CANON, [$1,$2,ifelse([$3],,0,[$3])])dnl
dnl
dnl Complain and exit if the version number in $1 through $3 is less than
dnl the version number in $4 through $6.
dnl $7 is the printable version of the second version number.
define(AC_PREREQ_COMPARE,
[ifelse(builtin([eval],
[$3 + $2 * 100 + $1 * 10000 < $6 + $5 * 100 + $4 * 10000]),1,
[errprint(Autoconf version $7 or higher is required
)m4exit(3)])])dnl
dnl
dnl Complain and exit if the Autoconf version is less than $1.
dnl AC_PREREQ(VERSION)
define(AC_PREREQ,
[AC_PROVIDE([$0])dnl
AC_PREREQ_COMPARE(AC_PREREQ_CANON(AC_PREREQ_SPLIT(AC_ACVERSION)),
AC_PREREQ_CANON(AC_PREREQ_SPLIT([$1])),[$1])])dnl
dnl
dnl Run configure in subdirectories $1.
dnl Not actually done until AC_OUTPUT_SUBDIRS.
dnl AC_CONFIG_SUBDIRS(DIR ...)
define(AC_CONFIG_SUBDIRS,
[AC_PROVIDE([$0])dnl
AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
define([AC_LIST_SUBDIRS],[$1])])dnl
dnl
dnl Guess the value for the `prefix' variable by looking for
dnl the argument program along PATH and taking its parent.
dnl Example: if the argument is `gcc' and we find /usr/local/gnu/bin/gcc,
dnl set `prefix' to /usr/local/gnu.
dnl AC_PREFIX_PROGRAM(PROGRAM)
define(AC_PREFIX_PROGRAM, [define([AC_LIST_PREFIX_PROGRAM],[$1])])dnl
define(AC_PREFIX_INTERNAL,
[if test "x$prefix" = xNONE; then
changequote(<<,>>)dnl
define(<<AC_VAR_NAME>>, translit($1, [a-z], [A-Z]))dnl
changequote([,])dnl
AC_PROGRAM_PATH(AC_VAR_NAME, $1)
changequote(<<,>>)dnl
  if test -n "$ac_cv_path_<<>>AC_VAR_NAME"; then
    prefix=`echo $ac_cv_path_<<>>AC_VAR_NAME|sed 's%/[^/][^/]*/[^/][^/]*$%%'`
changequote([,])dnl
dnl    test -z "$prefix" && prefix=/
    AC_VERBOSE(setting installation directory prefix to ${prefix})
  fi
fi
undefine(AC_VAR_NAME)dnl
])dnl
define(AC_PREFIX,
[AC_OBSOLETE([$0], [; instead use AC_PREFIX_PROGRAM before AC_INIT])dnl
AC_PREFIX_INTERNAL([$1])])dnl
dnl
dnl
dnl ### Canonicalizing the system type
dnl
dnl
dnl Find install.sh, config.sub, config.guess, and Cygnus configure
dnl in directory $1.  These are auxiliary files used in configuration.
dnl $1 can be either absolute or relative to ${srcdir}.
dnl AC_CONFIG_AUX_DIR(DIR)
define(AC_CONFIG_AUX_DIR,
[AC_CONFIG_AUX_DIRS($1 ${srcdir}/$1)])dnl
dnl
dnl The default is `${srcdir}' or `${srcdir}/..' or `${srcdir}/../..'.
dnl There's no need to call this macro explicitly; just AC_REQUIRE it.
define(AC_CONFIG_AUX_DIR_DEFAULT,
[AC_CONFIG_AUX_DIRS(${srcdir} ${srcdir}/.. ${srcdir}/../..)])dnl
dnl
dnl Internal subroutine.
dnl Search for the configuration auxiliary files in directory list $1.
dnl We look only for install.sh, so users of AC_PROG_INSTALL
dnl do not automatically need to distribute the other auxiliary files.
dnl AC_CONFIG_AUX_DIRS(DIR ...)
define(AC_CONFIG_AUX_DIRS,
[ac_aux_dir=
for ac_dir in $1; do
  if test -f $ac_dir/install.sh; then
    ac_aux_dir=$ac_dir; break
  fi
done
if test -z "$ac_aux_dir"; then
  AC_ERROR([can not find install.sh in $1])
fi
ac_config_guess=${ac_aux_dir}/config.guess
ac_config_sub=${ac_aux_dir}/config.sub
ac_configure=${ac_aux_dir}/configure # This should be Cygnus configure.
ac_install_sh="${ac_aux_dir}/install.sh -c"
AC_PROVIDE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
])dnl
dnl
dnl Canonicalize the host, target, and build system types.
define(AC_CANONICAL_SYSTEM,
[AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
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
# 4. Target defaults to nonopt.
# 5. If nonopt is not specified, then target defaults to host.
# 6. build defaults to empty.

# The aliases save the names the user supplied, while $host etc.
# will get canonicalized.
build_alias=$build
host_alias=$host
target_alias=$target
case $host_alias---$target_alias---$nonopt in
NONE---*---* | *---NONE---* | *---*---NONE) ;;
*) AC_ERROR(can only configure for one host and one target at a time) ;;
esac

# Make sure we can run config.sub.
if ${ac_config_sub} sun4 >/dev/null 2>&1; then :
else AC_ERROR(can not run ${ac_config_sub})
fi

AC_CANONICAL_HOST
AC_CANONICAL_TARGET
AC_CANONICAL_BUILD
])dnl
dnl
dnl Subroutines of AC_CANONICAL_SYSTEM.
dnl
define(AC_CANONICAL_HOST,
[AC_CHECKING(host type)

case "${host_alias}" in
NONE)
  case $nonopt in
  NONE)
    if host_alias=`${ac_config_guess}`; then :
    else AC_ERROR(can not guess host type; you must specify one)
    fi ;;
  *) host_alias=$nonopt ;;
  esac ;;
esac

host=`${ac_config_sub} ${host_alias}`
host_cpu=`echo $host | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\1/'`
host_vendor=`echo $host | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\2/'`
host_os=`echo $host | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\3/'`
test -n "$host" && AC_VERBOSE(setting host to $host)
AC_SUBST(host)dnl
AC_SUBST(host_alias)dnl
])dnl
dnl
define(AC_CANONICAL_TARGET,
[AC_CHECKING(target type)

case "${target_alias}" in
NONE)
  case $nonopt in
  NONE) target_alias=$host_alias ;;
  *) target_alias=$nonopt ;;
  esac ;;
esac

target=`${ac_config_sub} ${target_alias}`
target_cpu=`echo $target | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\1/'`
target_vendor=`echo $target | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\2/'`
target_os=`echo $target | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\3/'`
test -n "$target" && AC_VERBOSE(setting target to $target)
AC_SUBST(target)dnl
AC_SUBST(target_alias)dnl
])dnl
dnl
define(AC_CANONICAL_BUILD,
[AC_CHECKING(build type)

case "${build_alias}" in
NONE) build= build_alias= ;;
*)
build=`${ac_config_sub} ${build_alias}`
build_cpu=`echo $build | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\1/'`
build_vendor=`echo $build | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\2/'`
build_os=`echo $build | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\3/'`
;;
esac
test -n "$build" && AC_VERBOSE(setting build to $build)
AC_SUBST(build)dnl
AC_SUBST(build_alias)dnl
])dnl
dnl
dnl Link each of the existing files in $2 to the corresponding
dnl link name in $1.
dnl Not actually done until AC_OUTPUT_LINKS.
dnl AC_LINK_FILES(LINK ..., FILE ...)
define(AC_LINK_FILES,
[define([AC_LIST_LINKS],[$1])define([AC_LIST_FILES],[$2])])dnl
dnl
dnl
dnl ### Caching test results
dnl
dnl
dnl Look for site or system specific initialization scripts.
define(AC_SITE_LOAD,
[ac_site_dirs=/usr/local
if test "x$prefix" != xNONE; then
  ac_site_dirs=$prefix
fi
# System dependent files override system independent ones in case of conflict.
if test "x$exec_prefix" != xNONE && test "x$exec_prefix" != "x$prefix"; then
  ac_site_dirs="$ac_site_dirs $exec_prefix"
fi
for ac_site_dir in $ac_site_dirs; do
  ac_site_file=$ac_site_dir/lib/config.site
  if test -r "$ac_site_file"; then
    AC_VERBOSE(loading site initialization script $ac_site_file)
    . $ac_site_file
  fi
done
])dnl
dnl
define(AC_CACHE_LOAD,
[if test -r "$cache_file"; then
  AC_VERBOSE(loading test results from cache file $cache_file)
  . $cache_file
else
  AC_VERBOSE(creating new cache file $cache_file)
  > $cache_file
fi])dnl
dnl
define(AC_CACHE_SAVE,
[if test -w $cache_file; then
AC_VERBOSE(saving test results in cache file $cache_file)
cat > $cache_file <<\CEOF
# This file is a shell script that caches the results of configure
# tests run on this system so they can be shared between configure
# scripts and configure runs.  It is not useful on other systems.
# If its contents are invalid for some reason, you may delete or edit it.
#
# By default, configure uses ./config.cache as the cache file,
# creating it if it does not exist already.  You can give configure
# the --cache-file=FILE option to use a different cache file; that is
# what configure does when it calls configure scripts in
# subdirectories, so they share the cache.
# config.status only pays attention to the cache file if you give it the
# --recheck option to rerun configure.
CEOF
changequote(,)dnl
dnl Allow a site initialization script to override cache values.
set | sed -n "s/^\([a-zA-Z0-9_]*_cv_[a-zA-Z0-9_]*\)=\(.*\)/\1=\${\1-'\2'}/p" >> $cache_file
changequote([,])dnl
fi])dnl
dnl
dnl AC_CACHE_VAL(CACHE-ID, COMMANDS-TO-SET-IT)
dnl The name of shell var CACHE-ID must contain `_cv_' in order to get saved.
define(AC_CACHE_VAL,
[dnl We used to use the below line, but it fails if the 1st arg is a
dnl shell variable, so we need the eval.
dnl if test "${$1+set}" = set; then 
if eval "test \"`echo '${'$1'+set}'`\" = set"; then
dnl This verbose message is just for testing the caching code.
  AC_VERBOSE(using cached value for $1)
else
  $2
fi
])dnl
dnl
dnl
dnl ### Setting variables
dnl
dnl
dnl Several simple subroutines to do various flavors of quoting.
dnl
dnl Quote $1 against shell "s.
define(AC_QUOTE_DQUOTE, [dnl We use \1 instead of \& to avoid an m4 1.0.3 bug.
patsubst($1, changequote(,)\([$"`\\]\)changequote([,]), \\\1)])dnl
dnl
dnl Quote $1 against shell 's.
define(AC_QUOTE_SQUOTE, [patsubst($1, ', '\\'')])dnl
dnl
dnl Quote $1 against shell here documents (<<EOF).
define(AC_QUOTE_HERE, [changequote({,})dnl
dnl We use \1 instead of \& to avoid an m4 1.0.3 bug.
patsubst(patsubst($1, \(\\[$`\\]\), \\\1), \([$`]\), \\\1){}dnl
changequote([,])])dnl
dnl
dnl Quote $1 against the right hand side of a sed substitution.
define(AC_QUOTE_SED, [changequote({,})dnl
dnl We use \1 instead of \& to avoid an m4 1.0.3 bug.
dnl % and @ and ! are commonly used as the sed s separator character.
patsubst($1, \([&\\%@!]\), \\\1){}dnl
changequote([,])])dnl
dnl
dnl Quote $1 against tokenization.
define(AC_QUOTE_TOKEN, [changequote({,})dnl
patsubst($1, \([	 ]\), \\\1){}dnl
changequote([,])])dnl
dnl
dnl Subroutines of AC_DEFINE.  Does more quoting magic than any sane person
dnl should be able to understand.  The point of it all is that what goes into
dnl Makefile et al should be verbatim what was written in configure.in.
define(AC_DEFINE_QUOTE, [dnl
AC_QUOTE_TOKEN(AC_QUOTE_SQUOTE(AC_QUOTE_DQUOTE($1)))])dnl
dnl
define(AC_DEFINE_SEDQUOTE, [dnl
AC_QUOTE_DQUOTE(AC_QUOTE_HERE(AC_QUOTE_HERE(AC_QUOTE_SED($1))))])dnl
dnl
dnl Don't compare $2 to a blank, so we can support "-Dfoo=".
dnl If creating a configuration header file, we add
dnl commands to ac_sed_defs to define the variable.  ac_[due][ABCD]
dnl get defined in config.status.  Here we just insert the
dnl variable parts of the string: the variable name to define
dnl and the value to give it.
dnl The newlines around the curly braces prevent sh syntax errors.
dnl AC_DEFINE(VARIABLE [, VALUE])
define(AC_DEFINE,[
{
dnl Uniformly use AC_DEFINE_[SED]QUOTE, so callers of AC_DEFINE_UNQUOTED
dnl can use AC_QUOTE_* manually if they want to.
test "$verbose" = yes && \
ifelse($#, 2,
[define([AC_VAL], $2)dnl
echo "	defining" $1 to be ifelse(AC_VAL,, empty, "AC_QUOTE_SQUOTE(AC_VAL)")],
[define([AC_VAL], 1)dnl
echo "	defining $1"])
dnl
echo "[#][define]" $1 "AC_QUOTE_SQUOTE(AC_VAL)" >> confdefs.h
dnl Define DEFS even if AC_LIST_HEADERS for use in user case statements.
DEFS="$DEFS -D$1=AC_QUOTE_SQUOTE(AC_VAL)"
ifdef([AC_LIST_HEADERS],
ac_sed_defs="dnl
${ac_sed_defs}\${ac_dA}$1\${ac_dB}$1\${ac_dC}AC_DEFINE_SEDQUOTE(AC_VAL)\${ac_dD}
\${ac_uA}$1\${ac_uB}$1\${ac_uC}AC_DEFINE_SEDQUOTE(AC_VAL)\${ac_uD}
\${ac_eA}$1\${ac_eB}$1\${ac_eC}AC_DEFINE_SEDQUOTE(AC_VAL)\${ac_eD}
"
)dnl
}
])dnl
dnl
dnl Unsafe version of AC_DEFINE.
dnl Users are responsible for the quoting nightmare.
dnl Well, not all of it.  We need to pull the identity function out to
dnl the top level, because m4 doesn't really support nested functions;
dnl it doesn't distinguish between the arguments to the outer
dnl function, which should be expanded, and the arguments to the inner
dnl function, which shouldn't yet.
define(AC_QUOTE_IDENTITY,$1)dnl
define(AC_DEFINE_UNQUOTED,[dnl
pushdef([AC_QUOTE_SQUOTE],defn([AC_QUOTE_IDENTITY]))dnl
pushdef([AC_DEFINE_SEDQUOTE],defn([AC_QUOTE_IDENTITY]))dnl
AC_DEFINE($1,$2)dnl
popdef([AC_DEFINE_SEDQUOTE])dnl
popdef([AC_QUOTE_SQUOTE])dnl
])dnl
dnl
dnl This macro protects the argument from being diverted twice
dnl if this macro is called twice for it.
dnl AC_SUBST(VARIABLE)
define(AC_SUBST,
[ifdef([AC_SUBST_$1], ,
[define([AC_SUBST_$1], )dnl
divert(AC_DIVERSION_SED)dnl
s%@$1@%[$]$1%g
divert(AC_DIVERSION_VAR)dnl
$1='[$]$1'
divert(AC_DIVERSION_NORMAL)dnl
])])dnl
dnl
dnl
dnl ### Printing messages
dnl
dnl
dnl AC_CHECKING(FEATURE-DESCRIPTION)
define(AC_CHECKING,
[echo "checking $1" 1>&4])dnl
dnl
dnl AC_VERBOSE(RESULT-DESCRIPTION)
define(AC_VERBOSE,
[echo "	$1" 1>&5])dnl
dnl
dnl AC_WARN(PROBLEM-DESCRIPTION)
define(AC_WARN,
[echo "configure: warning: $1" 1>&2])dnl
dnl
dnl AC_ERROR(ERROR-DESCRIPTION)
define(AC_ERROR,
[echo "configure: $1" 1>&2; exit 1])dnl
dnl
dnl
dnl ### Selecting which language to use for testing
dnl
dnl
define(AC_LANG_C,
[define([AC_LANG],[C])dnl
AC_PROVIDE([$0])dnl
ac_ext=c
# CFLAGS is not in ac_cpp because -g, -O, etc. are not valid cpp options.
ac_cpp='${CPP}'
ac_compile='${CC-cc} $CFLAGS $LDFLAGS conftest.${ac_ext} -o conftest $LIBS 1>&6 2>&6'
])dnl
dnl
define(AC_LANG_CPLUSPLUS,
[define([AC_LANG],[CPLUSPLUS])dnl
AC_PROVIDE([$0])dnl
ac_ext=C
# CXXFLAGS is not in ac_cpp because -g, -O, etc. are not valid cpp options.
ac_cpp='${CXXCPP}'
ac_compile='${CXX-gcc} $CXXFLAGS $LDFLAGS conftest.${ac_ext} -o conftest $LIBS 1>&6 2>&6'
])dnl
dnl
dnl Push the current language on a stack.
define(AC_LANG_SAVE, [pushdef([AC_LANG_STACK], AC_LANG)])dnl
dnl
dnl Restore the current language from the stack.
define(AC_LANG_RESTORE,
[ifelse(AC_LANG_STACK,C,[ifelse(AC_LANG,C,,[AC_LANG_C])],[ifelse(AC_LANG,CPLUSPLUS,,[AC_LANG_CPLUSPLUS])])[]popdef([AC_LANG_STACK])])dnl
dnl
dnl
dnl ### Enforcing ordering constraints
dnl
dnl
dnl AC_BEFORE(THIS-MACRO-NAME, CALLED-MACRO-NAME)
define(AC_BEFORE,
[ifdef([AC_PROVIDE_$2], [errprint(__file__:__line__: [$2 was called before $1
])])])dnl
dnl
dnl AC_REQUIRE(MACRO-NAME)
define(AC_REQUIRE,
[ifdef([AC_PROVIDE_$1],,[indir([$1])
])])dnl
dnl
dnl AC_PROVIDE(MACRO-NAME)
define(AC_PROVIDE,
[define([AC_PROVIDE_$1],)])dnl
dnl
dnl AC_OBSOLETE(THIS-MACRO-NAME [, SUGGESTION])
define(AC_OBSOLETE,
[errprint(__file__:__line__: warning: [$1] is obsolete[$2]
)])dnl
dnl
dnl
dnl ### Checking for files - fundamental (caching)
dnl
dnl
dnl AC_PROGRAM_CHECK(VARIABLE, PROG-TO-CHECK-FOR, VALUE-IF-FOUND
dnl                  [, VALUE-IF-NOT-FOUND])
define(AC_PROGRAM_CHECK,
[# Extract the first word of "$2", so it can be a program name with args.
set dummy $2; ac_word=[$]2
AC_CHECKING([for $ac_word])
AC_CACHE_VAL(ac_cv_prog_$1,
[if test -n "[$]$1"; then
  ac_cv_prog_$1="[$]$1" # Let the user override the test.
else
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:"
  for ac_dir in $PATH; do
    test -z "$ac_dir" && ac_dir=.
    if test -f $ac_dir/$ac_word; then
      ac_cv_prog_$1="$3"
      break
    fi
  done
  IFS="$ac_save_ifs"
dnl If no 4th arg is given, leave the cache variable unset,
dnl so AC_PROGRAMS_CHECK will keep looking.
ifelse([$4],,, [  test -z "[$]ac_cv_prog_$1" && ac_cv_prog_$1="$4"
])dnl
fi])dnl
$1="$ac_cv_prog_$1"
test -n "[$]$1" && AC_VERBOSE(setting $1 to [$]$1)
AC_SUBST($1)dnl
])dnl
dnl
dnl AC_PROGRAM_PATH(VARIABLE, PROG-TO-CHECK-FOR [, VALUE-IF-NOT-FOUND])
define(AC_PROGRAM_PATH,
[# Extract the first word of "$2", so it can be a program name with args.
set dummy $2; ac_word=[$]2
AC_CHECKING([for $ac_word])
AC_CACHE_VAL(ac_cv_path_$1,
[case "[$]$1" in
  /*)
  ac_cv_path_$1="[$]$1" # Let the user override the test with a path.
  ;;
  *)
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:"
  for ac_dir in $PATH; do
    test -z "$ac_dir" && ac_dir=.
    if test -f $ac_dir/$ac_word; then
      ac_cv_path_$1="$ac_dir/$ac_word"
      break
    fi
  done
  IFS="$ac_save_ifs"
dnl If no 3rd arg is given, leave the cache variable unset,
dnl so AC_PROGRAMS_PATH will keep looking.
ifelse([$3],,, [  test -z "[$]ac_cv_path_$1" && ac_cv_path_$1="$3"
])dnl
  ;;
esac])dnl
$1="$ac_cv_path_$1"
test -n "[$]$1" && AC_VERBOSE(setting $1 to [$]$1)
AC_SUBST($1)dnl
])dnl
dnl
dnl
dnl ### Checking for files - derived (caching)
dnl
dnl
dnl AC_PROGRAMS_CHECK(VARIABLE, PROGS-TO-CHECK-FOR [, VALUE-IF-NOT-FOUND])
define(AC_PROGRAMS_CHECK,
[for ac_prog in $2
do
AC_PROGRAM_CHECK($1, [$]ac_prog, [$]ac_prog, )
test -n "[$]$1" && break
done
ifelse([$3],,, [test -n "[$]$1" || $1="$3"
])])dnl
dnl
dnl AC_PROGRAMS_PATH(VARIABLE, PROGS-TO-CHECK-FOR [, VALUE-IF-NOT-FOUND])
define(AC_PROGRAMS_PATH,
[for ac_prog in $2
do
AC_PROGRAM_PATH($1, [$]ac_prog)
test -n "[$]$1" && break
done
ifelse([$3],,, [test -n "[$]$1" || $1="$3"
])])dnl
dnl
dnl AC_HAVE_LIBRARY(LIBRARY [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
define(AC_HAVE_LIBRARY, [dnl
changequote(/,/)dnl
define(/AC_LIB_NAME/, dnl
patsubst(patsubst($1, /lib\([^\.]*\)\.a/, /\1/), /-l/, //))dnl
define(/AC_CV_NAME/, ac_cv_lib_//AC_LIB_NAME)dnl
changequote([,])dnl
AC_CHECKING([for -l[]AC_LIB_NAME])
AC_CACHE_VAL(AC_CV_NAME,
[ac_save_LIBS="${LIBS}"
LIBS="${LIBS} -l[]AC_LIB_NAME[]"
AC_TEST_LINK( , [main();],
AC_CV_NAME=yes, AC_CV_NAME=no)dnl
LIBS="${ac_save_LIBS}"
])dnl
if test "${AC_CV_NAME}" = yes; then
ifelse($#, 1, [dnl
   AC_DEFINE([HAVE_LIB]translit(AC_LIB_NAME, [a-z], [A-Z]))
   LIBS="${LIBS} -l[]AC_LIB_NAME[]"
undefine(AC_LIB_NAME)dnl
undefine(AC_CV_NAME)dnl
], [dnl
   :; $2
else
   :; $3
])dnl
fi
])dnl
dnl
dnl
dnl ### Checking for C features - fundamental (no caching)
dnl
dnl
dnl AC_HEADER_EGREP(PATTERN, HEADER-FILE, ACTION-IF-FOUND [,
dnl                 ACTION-IF-NOT-FOUND])
define(AC_HEADER_EGREP,
[AC_PROVIDE([$0])dnl
AC_PROGRAM_EGREP([$1], [#include <$2>], [$3], [$4])])dnl
dnl
dnl Because this macro is used by AC_GCC_TRADITIONAL, which must come early,
dnl it is not included in AC_BEFORE checks.
dnl AC_PROGRAM_EGREP(PATTERN, PROGRAM, ACTION-IF-FOUND [,
dnl                  ACTION-IF-NOT-FOUND])
define(AC_PROGRAM_EGREP,
[AC_REQUIRE_CPP()dnl
AC_PROVIDE([$0])dnl
cat > conftest.${ac_ext} <<EOF
#include "confdefs.h"
[$2]
EOF
eval "$ac_cpp conftest.${ac_ext} > conftest.out 2>&1"
if egrep "$1" conftest.out >/dev/null 2>&1; then
  ifelse([$3], , :, [rm -rf conftest*
  $3])
ifelse([$4], , , [else
  rm -rf conftest*
  $4
])dnl
fi
rm -f conftest*
])dnl
dnl
dnl AC_COMPILE_CHECK(ECHO-TEXT, INCLUDES, FUNCTION-BODY,
dnl                  ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
define(AC_COMPILE_CHECK,
[AC_PROVIDE([$0])dnl
dnl It's actually ok to use this, if you don't care about caching.
dnl AC_OBSOLETE([$0], [; instead use AC_TEST_LINK])dnl
ifelse([$1], , , [AC_CHECKING([for $1])
])dnl
AC_TEST_LINK([$2], [$3], [$4], [$5])dnl
])dnl
dnl
dnl AC_TEST_LINK(INCLUDES, FUNCTION-BODY,
dnl              ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
define(AC_TEST_LINK,
[AC_PROVIDE([$0])dnl
dnl We use return because because C++ requires a prototype for exit.
cat > conftest.${ac_ext} <<EOF
#include "confdefs.h"
[$1]
int main() { return 0; }
int t() { [$2]; return 0; }
EOF
if eval $ac_compile; then
  ifelse([$3], , :, [rm -rf conftest*
  $3])
ifelse([$4], , , [else
  rm -rf conftest*
  $4
])dnl
fi
rm -f conftest*]
)dnl
dnl
dnl AC_TEST_RUN(PROGRAM, ACTION-IF-TRUE [, ACTION-IF-FALSE
dnl             [, ACTION-IF-CROSS-COMPILING]])
define(AC_TEST_RUN,
[AC_PROVIDE([$0])dnl
AC_REQUIRE([AC_CROSS_CHECK])dnl
if test -n "$cross_compiling"; then
  ifelse([$4], , AC_ERROR(can not run test program while cross compiling),
  [AC_VERBOSE(using default for cross-compiling)
$4
])
else
cat > conftest.${ac_ext} <<EOF
#include "confdefs.h"
[$1]
EOF
eval $ac_compile
if test -s conftest && (./conftest; exit) 2>/dev/null; then
  ifelse([$2], , :, [$2])
ifelse([$3], , , [else
  $3
])dnl
fi
fi
rm -fr conftest*])dnl
dnl Obsolete name, which is less clear about what the macro does,
dnl but is otherwise ok to use.
define(AC_TEST_PROGRAM, [AC_TEST_RUN([$1], [$2], [$3], [$4])])dnl
dnl
dnl AC_TEST_CPP(INCLUDES, ACTION-IF-TRUE [, ACTION-IF-FALSE])
define(AC_TEST_CPP,
[AC_REQUIRE_CPP()dnl
cat > conftest.${ac_ext} <<EOF
#include "confdefs.h"
[$1]
EOF
# Some shells (Coherent) do redirections in the wrong order, so need
# the parens.
ac_err=`eval "($ac_cpp conftest.${ac_ext} >/dev/null) 2>&1"`
if test -z "$ac_err"; then
  ifelse([$2], , :, [rm -rf conftest*
  $2])
ifelse([$3], , , [else
  rm -rf conftest*
  $3
])dnl
fi
rm -f conftest*])dnl
dnl
dnl
dnl ### Checking for C features - derived (caching)
dnl
dnl
dnl AC_HEADER_CHECK(HEADER-FILE, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
define(AC_HEADER_CHECK,
[dnl Do the transliteration at runtime so arg 1 can be a shell variable.
ac_var=`echo "$1" | tr './' '__'`
AC_CHECKING([for $1])
AC_CACHE_VAL(ac_cv_header_$ac_var,
[AC_TEST_CPP([#include <$1>], eval "ac_cv_header_$ac_var=yes",
  eval "ac_cv_header_$ac_var=no")])dnl
if eval "test \"`echo '$ac_cv_header_'$ac_var`\" = yes"; then
  ifelse([$2], , :, [$2])
ifelse([$3], , , [else
  $3
])dnl
fi
])dnl
dnl
dnl AC_FUNC_CHECK(FUNCTION, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
define(AC_FUNC_CHECK,
[AC_CHECKING([for $1])
AC_CACHE_VAL(ac_cv_func_$1,
[AC_TEST_LINK(
[#include <ctype.h> /* Arbitrary system header to define __stub macros. */], [
/* The GNU C library defines this for functions which it implements
    to always fail with ENOSYS.  Some functions are actually named
    something starting with __ and the normal name is an alias.  */
#if defined (__stub_$1) || defined (__stub___$1)
choke me
#else
/* Override any gcc2 internal prototype to avoid an error.  */
extern char $1(); $1();
#endif
], eval "ac_cv_func_$1=yes", eval "ac_cv_func_$1=no")])dnl
if eval "test \"`echo '$ac_cv_func_'$1`\" = yes"; then
  ifelse([$2], , :, [$2])
ifelse([$3], , , [else
  $3
])dnl
fi
])dnl
dnl
dnl AC_HAVE_FUNCS(FUNCTION...)
define(AC_HAVE_FUNCS,
[for ac_func in $1
do
changequote(,)dnl
ac_tr_func=HAVE_`echo $ac_func | tr '[a-z]' '[A-Z]'`
changequote([,])dnl
AC_FUNC_CHECK(${ac_func}, AC_DEFINE(${ac_tr_func}))dnl
done
])dnl
dnl
dnl AC_HAVE_HEADERS(HEADER-FILE...)
define(AC_HAVE_HEADERS,
[AC_REQUIRE_CPP()dnl Make sure the cpp check happens outside the loop.
for ac_hdr in $1
do
changequote(,)dnl
ac_tr_hdr=HAVE_`echo $ac_hdr | tr '[a-z]./' '[A-Z]__'`
changequote([,])dnl
AC_HEADER_CHECK(${ac_hdr}, AC_DEFINE(${ac_tr_hdr}))dnl
done
])dnl
dnl
dnl AC_REPLACE_FUNCS(FUNCTION-NAME...)
define(AC_REPLACE_FUNCS,
[for ac_func in $1
do
AC_FUNC_CHECK(${ac_func}, ,
[LIBOBJS="$LIBOBJS ${ac_func}.o"
AC_VERBOSE(using ${ac_func}.o instead)
])dnl
done
AC_SUBST(LIBOBJS)dnl
])dnl
dnl
dnl AC_SIZEOF_TYPE(TYPE)
define(AC_SIZEOF_TYPE, [dnl
changequote(<<,>>)dnl
dnl The name to #define.
define(<<AC_TYPE_NAME>>, translit(sizeof_$1, [a-z *], [A-Z_P]))dnl
dnl The cache variable name.
define(<<AC_CV_NAME>>, translit(ac_cv_sizeof_$1, [ *], [_p]))dnl
changequote([,])dnl
AC_CHECKING(size of $1)
AC_CACHE_VAL(AC_CV_NAME,
[AC_TEST_RUN([#include <stdio.h>
main()
{
  FILE *f=fopen("conftestval", "w");
  if (!f) exit(1);
  fprintf(f, "%d\n", sizeof($1));
  exit(0);
}], AC_CV_NAME=`cat conftestval`)])dnl
AC_DEFINE_UNQUOTED(AC_TYPE_NAME, $AC_CV_NAME)
undefine(AC_TYPE_NAME)dnl
undefine(AC_CV_NAME)dnl
])dnl
dnl
dnl
dnl ### The big finish
dnl
dnl
dnl AC_OUTPUT([FILE...] [,EXTRA-CMDS])
define(AC_OUTPUT,
[AC_CACHE_SAVE

test "x$prefix" = xNONE && prefix=/usr/local
# Let make expand exec_prefix.
test "x$exec_prefix" = xNONE && exec_prefix='${prefix}'

# Any assignment to VPATH causes Sun make to only execute
# the first set of double-colon rules, so remove it if not needed.
# If there is a colon in the path, we need to keep it.
changequote(,)dnl
if test "x$srcdir" = x.; then
  ac_vpsub='/^[ 	]*VPATH[ 	]*=[^:]*$/d'
fi

# Quote sed substitution magic chars in DEFS.
cat >conftest.def <<EOF
$DEFS
EOF
ac_escape_ampersand_and_backslash='s%[&\\]%\\&%g'
DEFS=`sed "$ac_escape_ampersand_and_backslash" <conftest.def`
rm -f conftest.def
# Substitute for predefined variables.
changequote([,])dnl
AC_SUBST(LIBS)dnl
AC_SUBST(srcdir)dnl
AC_SUBST(top_srcdir)dnl
AC_SUBST(prefix)dnl
AC_SUBST(exec_prefix)dnl
dnl Substituting for DEFS would confuse sed if it contains multiple lines.
ifdef([AC_LIST_HEADERS],
[divert(AC_DIVERSION_SED)dnl
s%@DEFS@%-DHAVE_CONFIG_H%],
[divert(AC_DIVERSION_SED)dnl
s%@DEFS@%$DEFS%]
[divert(AC_DIVERSION_VAR)dnl
DEFS='$DEFS'
])dnl
divert(AC_DIVERSION_VAR)dnl
ac_vpsub='$ac_vpsub'
extrasub='$extrasub'
divert(AC_DIVERSION_NORMAL)dnl

# Some shells look in PATH for config.status without the "./".
: ${CONFIG_STATUS=./config.status}

trap "rm -f ${CONFIG_STATUS}; exit 1" 1 2 15
echo creating ${CONFIG_STATUS}
rm -f ${CONFIG_STATUS}
cat > ${CONFIG_STATUS} <<EOF
#!/bin/sh
# Generated automatically by configure.
# Run this file to recreate the current configuration.
# This directory was configured as follows,
dnl hostname on some systems (SVR3.2, Linux) returns a bogus exit status,
dnl so uname gets run too.
# on host `(hostname || uname -n) 2>/dev/null | sed 1q`:
#
[#] [$]0 [$]configure_args

changequote(,)dnl
ac_cs_usage="Usage: ${CONFIG_STATUS} [--recheck] [--version] [--help]"
changequote([,])dnl
for ac_option
do
  case "[\$]ac_option" in
  -recheck | --recheck | --rechec | --reche | --rech | --rec | --re | --r)
    echo running [\$]{CONFIG_SHELL-/bin/sh} [$]0 [$]configure_args --no-create --norecursion
    exec [\$]{CONFIG_SHELL-/bin/sh} [$]0 [$]configure_args --no-create --norecursion ;;
  -version | --version | --versio | --versi | --vers | --ver | --ve | --v)
    echo "${CONFIG_STATUS} generated by autoconf version AC_ACVERSION"
    exit 0 ;;
  -help | --help | --hel | --he | --h)
    echo "[\$]ac_cs_usage"; exit 0 ;;
  *) echo "[\$]ac_cs_usage"; exit 1 ;;
  esac
done

ifdef([AC_LIST_HEADERS],
[trap 'rm -fr $1 AC_LIST_HEADERS conftest*; exit 1' 1 2 15],
[trap 'rm -f $1; exit 1' 1 2 15])
dnl Insert the variable assignments.
undivert(AC_DIVERSION_VAR)dnl
EOF
cat >> ${CONFIG_STATUS} <<\EOF

ac_given_srcdir=$srcdir

CONFIG_FILES=${CONFIG_FILES-"$1"}
for ac_file in .. ${CONFIG_FILES}; do if test "x$ac_file" != x..; then
  # Remove last slash and all that follows it.  Not all systems have dirname.
changequote(,)dnl
  ac_dir=`echo $ac_file|sed 's%/[^/][^/]*$%%'`
changequote([,])dnl
  if test "$ac_dir" != "$ac_file" && test "$ac_dir" != .; then
    # The file is in a subdirectory.
    test ! -d "$ac_dir" && mkdir "$ac_dir"
    ac_dir_suffix="/$ac_dir"
  else
    ac_dir_suffix=
  fi

changequote(,)dnl
  # A "../" for each directory in $ac_dir_suffix.
  ac_dots=`echo $ac_dir_suffix|sed 's%/[^/]*%../%g'`
changequote([,])dnl
  case "$ac_given_srcdir" in
  .)  srcdir=.
      if test -z "$ac_dir_suffix"; then top_srcdir=.
      else top_srcdir=`echo $ac_dots|sed 's%/$%%'`; fi ;;
  /*) srcdir="$ac_given_srcdir$ac_dir_suffix"; top_srcdir="$ac_given_srcdir" ;;
  *) # Relative path.
    srcdir="$ac_dots$ac_given_srcdir$ac_dir_suffix"
    top_srcdir="$ac_dots$ac_given_srcdir" ;;
  esac

  echo creating "$ac_file"
  rm -f "$ac_file"
  comment_str="Generated automatically from `echo $ac_file|sed 's|.*/||'`.in by configure."
  case "$ac_file" in
    *.c | *.h | *.C | *.cc | *.m )
    ac_comsub="1i\\
/* $comment_str */" ;;
    * ) # Add the comment on the second line of scripts, first line of others.
    ac_comsub="
1{
s/^#!/&/
t script
i\\
# $comment_str
b done
: script
a\\
# $comment_str
: done
}
" ;;
  esac
  sed -e "
$ac_comsub
$ac_vpsub
dnl Shell code in configure.in might set extrasub.
$extrasub
dnl Insert the sed substitutions.
undivert(AC_DIVERSION_SED)dnl
" $ac_given_srcdir/${ac_file}.in > $ac_file
fi; done
ifdef([AC_LIST_HEADERS],[AC_OUTPUT_HEADER(AC_LIST_HEADERS)])dnl
ifdef([AC_LIST_LINKS],[AC_OUTPUT_LINKS(AC_LIST_LINKS,AC_LIST_FILES)])dnl
$2
exit 0
EOF
chmod +x ${CONFIG_STATUS}
test "$no_create" = yes || ${CONFIG_SHELL-/bin/sh} ${CONFIG_STATUS}
dnl config.status should never do recursion.
ifdef([AC_LIST_SUBDIRS],[AC_OUTPUT_SUBDIRS(AC_LIST_SUBDIRS)])dnl
])dnl
dnl
dnl Create the header files listed in $1.
dnl This is a subroutine of AC_OUTPUT.  It is called inside a quoted
dnl here document whose contents are going into config.status.
define(AC_OUTPUT_HEADER,[dnl
changequote(<<,>>)dnl

# These sed commands are put into ac_sed_defs when defining a macro.
# They are broken into pieces to make the sed script easier to manage.
# They are passed to sed as "A NAME B NAME C VALUE D", where NAME
# is the cpp macro being defined and VALUE is the value it is being given.
# Each defining turns into a single global substitution command.
# Hopefully no one uses "!" as a variable value.
# Other candidates for the sed separators, like , and @, do get used.
#
# ac_d sets the value in "#define NAME VALUE" lines.
ac_dA='s!^\([ 	]*\)#\([ 	]*define[ 	][ 	]*\)'
ac_dB='\([ 	][ 	]*\)[^ 	]*!\1#\2'
ac_dC='\3'
ac_dD='!g'
# ac_u turns "#undef NAME" with trailing blanks into "#define NAME VALUE".
ac_uA='s!^\([ 	]*\)#\([ 	]*\)undef\([ 	][ 	]*\)'
ac_uB='\([ 	]\)!\1#\2define\3'
ac_uC=' '
ac_uD='\4!g'
# ac_e turns "#undef NAME" without trailing blanks into "#define NAME VALUE".
ac_eA='s!^\([ 	]*\)#\([ 	]*\)undef\([ 	][ 	]*\)'
ac_eB='<<$>>!\1#\2define\3'
ac_eC=' '
ac_eD='!g'
changequote([,])dnl
rm -f conftest.sed
EOF
# Turn off quoting long enough to insert the sed commands.
rm -f conftest.sh
cat > conftest.sh <<EOF
$ac_sed_defs
EOF

# Break up $ac_sed_defs (now in conftest.sh) because some shells have a limit
# on the size of here documents.

# Maximum number of lines to put in a single here document.
ac_max_sh_lines=9

while :
do
  # wc gives bogus results for an empty file on some AIX systems.
  ac_lines=`grep -c . conftest.sh`
  if test -z "$ac_lines" || test "$ac_lines" -eq 0; then break; fi
  rm -f conftest.s1 conftest.s2
  sed ${ac_max_sh_lines}q conftest.sh > conftest.s1 # Like head -9.
  sed 1,${ac_max_sh_lines}d conftest.sh > conftest.s2 # Like tail +10.
  # Write a limited-size here document to append to conftest.sed.
  echo 'cat >> conftest.sed <<CONFEOF' >> ${CONFIG_STATUS}
  cat conftest.s1 >> ${CONFIG_STATUS}
  echo 'CONFEOF' >> ${CONFIG_STATUS}
  rm -f conftest.s1 conftest.sh
  mv conftest.s2 conftest.sh
done
rm -f conftest.sh

# Now back to your regularly scheduled config.status.
cat >> ${CONFIG_STATUS} <<\EOF
# This sed command replaces #undef with comments.  This is necessary, for
# example, in the case of _POSIX_SOURCE, which is predefined and required
# on some systems where configure will not decide to define it in
[#] $1.
cat >> conftest.sed <<\CONFEOF
changequote(,)dnl
s,^[ 	]*#[ 	]*undef[ 	][ 	]*[a-zA-Z_][a-zA-Z_0-9]*,/* & */,
changequote([,])dnl
CONFEOF
rm -f conftest.h
# Break up the sed commands because old seds have small limits.
ac_max_sed_lines=20

CONFIG_HEADERS=${CONFIG_HEADERS-"$1"}
for ac_file in .. ${CONFIG_HEADERS}; do if test "x$ac_file" != x..; then
  echo creating $ac_file

  cp $ac_given_srcdir/$ac_file.in conftest.h1
  cp conftest.sed conftest.stm
  while :
  do
    ac_lines=`grep -c . conftest.stm`
    if test -z "$ac_lines" || test "$ac_lines" -eq 0; then break; fi
    rm -f conftest.s1 conftest.s2 conftest.h2
    sed ${ac_max_sed_lines}q conftest.stm > conftest.s1 # Like head -20.
    sed 1,${ac_max_sed_lines}d conftest.stm > conftest.s2 # Like tail +21.
    sed -f conftest.s1 < conftest.h1 > conftest.h2
    rm -f conftest.s1 conftest.h1 conftest.stm
    mv conftest.h2 conftest.h1
    mv conftest.s2 conftest.stm
  done
  rm -f conftest.stm conftest.h
  echo "/* $ac_file.  Generated automatically by configure.  */" > conftest.h
  cat conftest.h1 >> conftest.h
  rm -f conftest.h1
  if cmp -s $ac_file conftest.h 2>/dev/null; then
    # The file exists and we would not be changing it.
    echo "$ac_file is unchanged"
    rm -f conftest.h
  else
    rm -f $ac_file
    mv conftest.h $ac_file
  fi
fi; done
rm -f conftest.sed

])dnl
dnl
define(AC_OUTPUT_LINKS,
[ac_links="$1"
ac_files="$2"
while test -n "${ac_files}"; do
  set ${ac_links}; ac_link=[$]1; shift; ac_links=[$]*
  set ${ac_files}; ac_file=[$]1; shift; ac_files=[$]*

  echo "linking ${ac_link} to ${srcdir}/${ac_file}"

  if test ! -r ${srcdir}/${ac_file}; then
    AC_ERROR(${srcdir}/${ac_file}: File not found)
  fi
  rm -f ${ac_link}
  # Make a symlink if possible; otherwise try a hard link.
  if ln -s ${srcdir}/${ac_file} ${ac_link} 2>/dev/null ||
    ln ${srcdir}/${ac_file} ${ac_link}; then :
  else
    AC_ERROR(can not link ${ac_link} to ${srcdir}/${ac_file})
  fi
done
])dnl
dnl
define(AC_OUTPUT_SUBDIRS,
[if test -z "${norecursion}"; then

  # Remove --cache-file arguments so they do not pile up.
  ac_sub_configure_args=
  ac_prev=
  for ac_arg in $configure_args; do
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
    *) ac_sub_configure_args="$ac_sub_configure_args $ac_arg" ;;
    esac
  done

  for ac_config_dir in $1; do

    # Do not complain, so a configure script can configure whichever
    # parts of a large source tree are present.
    if test ! -d ${srcdir}/${ac_config_dir}; then
      continue
    fi

    echo configuring ${ac_config_dir}

    case "${srcdir}" in
    .) ;;
    *)
      if test -d ./${ac_config_dir} || mkdir ./${ac_config_dir}; then :;
      else
        AC_ERROR(can not create `pwd`/${ac_config_dir})
      fi
      ;;
    esac

    ac_popdir=`pwd`
    cd ${ac_config_dir}

    case "${srcdir}" in
    .) # No --srcdir option.  We are building in place.
      ac_sub_srcdir=${srcdir} ;;
    /*) # Absolute path.
      ac_sub_srcdir=${srcdir}/${ac_config_dir} ;;
    *) # Relative path.
      ac_sub_srcdir=../${srcdir}/${ac_config_dir} ;;
    esac

    # Check for guested configure; otherwise get Cygnus style configure.
    if test -f ${ac_sub_srcdir}/configure; then
      ac_sub_configure=${ac_sub_srcdir}/configure
    elif test -f ${ac_sub_srcdir}/configure.in; then
      ac_sub_configure=${ac_configure}
    else
      AC_WARN(no configuration information is in ${ac_config_dir})
      ac_sub_configure=
    fi

    # Make the cache file name correct relative to the subdirectory.
changequote(,)dnl
    # A "../" for each directory in /${ac_config_dir}.
    ac_dots=`echo /${ac_config_dir}|sed 's%/[^/]*%../%g'`
changequote([,])dnl
    case "$cache_file" in
    /*) ac_sub_cache_file=$cache_file ;;
    *) # Relative path.
      ac_sub_cache_file="$ac_dots$cache_file" ;;
    esac

    # The recursion is here.
    if test -n "${ac_sub_configure}"; then
      AC_VERBOSE([running ${CONFIG_SHELL-/bin/sh} ${ac_sub_configure} ${ac_sub_configure_args} --cache-file=$ac_sub_cache_file])
      if ${CONFIG_SHELL-/bin/sh} ${ac_sub_configure} ${ac_sub_configure_args} --cache-file=$ac_sub_cache_file
      then :
      else
        AC_ERROR(${ac_sub_configure} failed for ${ac_config_dir})
      fi
    fi

    cd ${ac_popdir}
  done
fi
])dnl
dnl
