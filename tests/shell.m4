#							-*- Autoconf -*-

cat <<EOF

Autoshell.

EOF


## ------------ ##
## AS_MKDIR_P.  ##
## ------------ ##

# Build nested dirs.

AT_SETUP(AC_SHELL_MKDIR_P)

AT_DATA(configure.in,
[[AC_PLAIN_SCRIPT
pwd=`pwd`
set -e
# Absolute
AS_MKDIR_P($pwd/1/2/3/4/5/6)
test -d $pwd/1/2/3/4/5/6 || exit 1
# Relative
AS_MKDIR_P(a/b/c/d/e/f)
test -d a/b/c/d/e/f || exit 1
exit 0
]])

AT_CHECK([../autoconf --autoconf-dir .. -l $at_srcdir], 0, [], [])
AT_CHECK([./configure], 0)

AT_CLEANUP(configure 1 a)



## ----------------------------- ##
## AS_DIRNAME & AS_DIRNAME_SED.  ##
## ----------------------------- ##

# Build nested dirs.

AT_SETUP(AS_DIRNAME & AS_DIRNAME_SED)

AT_DATA(configure.in,
[[

define([AS_DIRNAME_TEST],
[dir=`AS_DIRNAME([$1])`
test "$dir" = "$2" ||
  echo "dirname($1) = $dir instead of $2" >&2])
define([AS_DIRNAME_SED_TEST],
[dir=`AS_DIRNAME_SED([$1])`
test "$dir" = "$2" ||
  echo "dirname_sed($1) = $dir instead of $2" >&2])

AC_PLAIN_SCRIPT
AS_DIRNAME_TEST([//1],		[//])
AS_DIRNAME_TEST([/1],		[/])
AS_DIRNAME_TEST([./1],		[.])
AS_DIRNAME_TEST([../../2],	[../..])
AS_DIRNAME_TEST([//1/],		[//])
AS_DIRNAME_TEST([/1/],		[/])
AS_DIRNAME_TEST([./1/],		[.])
AS_DIRNAME_TEST([../../2],	[../..])
AS_DIRNAME_TEST([//1/3],	[//1])
AS_DIRNAME_TEST([/1/3],		[/1])
AS_DIRNAME_TEST([./1/3],	[./1])
AS_DIRNAME_TEST([../../2/3],	[../../2])
AS_DIRNAME_TEST([//1/3///],	[//1])
AS_DIRNAME_TEST([/1/3///],	[/1])
AS_DIRNAME_TEST([./1/3///],	[./1])
AS_DIRNAME_TEST([../../2/3///],	[../../2])
AS_DIRNAME_TEST([//1//3/],	[//1])
AS_DIRNAME_TEST([/1//3/],	[/1])
AS_DIRNAME_TEST([./1//3/],	[./1])
AS_DIRNAME_TEST([../../2//3/],	[../../2])

AS_DIRNAME_SED_TEST([//1],		[//])
AS_DIRNAME_SED_TEST([/1],		[/])
AS_DIRNAME_SED_TEST([./1],		[.])
AS_DIRNAME_SED_TEST([../../2],		[../..])
AS_DIRNAME_SED_TEST([//1/],		[//])
AS_DIRNAME_SED_TEST([/1/],		[/])
AS_DIRNAME_SED_TEST([./1/],		[.])
AS_DIRNAME_SED_TEST([../../2],		[../..])
AS_DIRNAME_SED_TEST([//1/3],		[//1])
AS_DIRNAME_SED_TEST([/1/3],		[/1])
AS_DIRNAME_SED_TEST([./1/3],		[./1])
AS_DIRNAME_SED_TEST([../../2/3],	[../../2])
AS_DIRNAME_SED_TEST([//1/3///],		[//1])
AS_DIRNAME_SED_TEST([/1/3///],		[/1])
AS_DIRNAME_SED_TEST([./1/3///],		[./1])
AS_DIRNAME_SED_TEST([../../2/3///],	[../../2])
AS_DIRNAME_SED_TEST([//1//3/],		[//1])
AS_DIRNAME_SED_TEST([/1//3/],		[/1])
AS_DIRNAME_SED_TEST([./1//3/],		[./1])
AS_DIRNAME_SED_TEST([../../2//3/],	[../../2])
exit 0
]])

AT_CHECK([../autoconf --autoconf-dir .. -l $at_srcdir], 0, [], [])
AT_CHECK([./configure], 0)

AT_CLEANUP(configure)
