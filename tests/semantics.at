#							-*- autoconf -*-

cat <<EOF

Semantics.

EOF


# AC_TRY_LINK_FUNC
# ----------------
AT_CHECK_MACRO(AC_TRY_LINK_FUNC,
[AC_TRY_LINK_FUNC(exit,, exit 1)
AC_TRY_LINK_FUNC(Be_doomed_if_your_libc_has_a_function_named_like_this,
                 exit 1)])



## -------------------------------- ##
## Members of the AC_CHECK family.  ##
## -------------------------------- ##


# AC_CHECK_LIB
# ------------
# Well, I can't imagine a system where `cos' is neither in libc, nor
# in libm.  Nor can I imagine a lib more likely to exists than libm.
# But there are systems without libm, on which we don't want to have
# this test fail, so exit successfully if `cos' is in libc.
AT_CHECK_MACRO(AC_CHECK_LIB,
[AC_TRY_LINK_FUNC(cos, exit 0)
AC_CHECK_LIB(m, cos,, exit 1)])


# AC_CHECK_DECLS
# --------------
# Check that it performs the correct actions:
# Must define NEED_NO_DECL, but not NEED_YES_DECL.
AT_CHECK_MACRO(AC_CHECK_DECLS,
[[AC_CHECK_DECLS([yes, no],,,
                 [int yes = 1;])]],
[AT_CHECK_DEFINES(
[#define HAVE_DECL_NO 0
#define HAVE_DECL_YES 1
])])


# AC_CHECK_FUNCS
# --------------
# Check that it performs the correct actions:
# Must define HAVE_EXIT, but not HAVE_AUTOCONF_TIXE
AT_CHECK_MACRO(AC_CHECK_FUNCS,
[AC_CHECK_FUNCS(exit autoconf_tixe)],
[AT_CHECK_DEFINES(
[/* #undef HAVE_AUTOCONF_TIXE */
#define HAVE_EXIT 1
])])



# AC_CHECK_HEADERS
# ----------------
# Check that it performs the correct actions:
# Must define HAVE_STDIO_H, but not HAVE_AUTOCONF_IO_H.
AT_CHECK_MACRO(AC_CHECK_HEADERS,
[AC_CHECK_HEADERS(stdio.h autoconf_io.h)],
[AT_CHECK_DEFINES(
[/* #undef HAVE_AUTOCONF_IO_H */
#define HAVE_STDIO_H 1
])])



# AC_CHECK_MEMBERS
# ----------------
# Check that it performs the correct actions.
# Must define HAVE_STRUCT_YES_S_YES, but not HAVE_STRUCT_YES_S_NO.
AT_CHECK_MACRO(AC_CHECK_MEMBERS,
[[AC_CHECK_MEMBERS([struct yes_s.yes, struct yes_s.no],,,
                   [struct yes_s { int yes ;} ;])]],
[AT_CHECK_DEFINES(
[/* #undef HAVE_STRUCT_YES_S_NO */
#define HAVE_STRUCT_YES_S_YES 1
])])


# AC_CHECK_SIZEOF
# ---------------
AT_CHECK_MACRO(AC_CHECK_SIZEOF,
[AC_CHECK_SIZEOF(char)
AC_CHECK_SIZEOF(charchar,,
[#include <stdio.h>
typedef struct
{
  char a;
  char b;
} charchar;])
AC_CHECK_SIZEOF(charcharchar)

# Exercize the code used when cross-compiling
cross_compiling=yes
AC_CHECK_SIZEOF(unsigned char)
AC_CHECK_SIZEOF(ucharchar,,
[#include <stdio.h>
typedef struct
{
  unsigned char a;
  unsigned char b;
} ucharchar;])
AC_CHECK_SIZEOF(ucharcharchar)],
[AT_CHECK_DEFINES(
[#define SIZEOF_CHAR 1
#define SIZEOF_CHARCHAR 2
#define SIZEOF_CHARCHARCHAR 0
#define SIZEOF_UCHARCHAR 2
#define SIZEOF_UCHARCHARCHAR 0
#define SIZEOF_UNSIGNED_CHAR 1
])])


# AC_CHECK_TYPES
# --------------
# Check that it performs the correct actions.
# Must define HAVE_STRUCT_YES_S, HAVE_INT, but not HAVE_STRUCT_NO_S.
# `int' and `struct yes_s' are both checked to test both the compiler
# builtin types, and defined types.
AT_CHECK_MACRO(AC_CHECK_TYPES,
[[AC_CHECK_TYPES([int, struct yes_s, struct no_s],,,
                 [struct yes_s { int yes ;} ;])]],
[AT_CHECK_DEFINES(
[#define HAVE_INT 1
/* #undef HAVE_STRUCT_NO_S */
#define HAVE_STRUCT_YES_S 1
])])



# AC_CHECK_TYPES
# --------------
# Check that we properly dispatch properly to the old implementation
# or to the new one.
AT_SETUP([AC_CHECK_TYPES])

AT_DATA(configure.in,
[[AC_INIT
define([_AC_CHECK_TYPE_NEW], [NEW])
define([_AC_CHECK_TYPE_OLD], [OLD])
#(cut-from-here
AC_CHECK_TYPE(ptrdiff_t)
AC_CHECK_TYPE(ptrdiff_t, int)
AC_CHECK_TYPE(quad, long long)
AC_CHECK_TYPE(table_42, [int[42]])
# Nice machine!
AC_CHECK_TYPE(uint8_t, uint65536_t)
AC_CHECK_TYPE(a,b,c,d)
#to-here)
AC_OUTPUT
]])

AT_CHECK([../autoconf --autoconf-dir .. -l $at_srcdir], 0,,
[configure.in:10: warning: AC_CHECK_TYPE: assuming `uint65536_t' is not a type
])
AT_CHECK([[sed -e '/^#(cut-from-here/,/^#to-here)/!d' -e '/^#/d' configure]],
         0,
         [NEW
OLD
OLD
OLD
NEW
NEW
])

AT_CLEANUP(autoconf.err)



# AC_CHECK_FILES
# --------------
# FIXME: To really test HAVE_AC_EXISTS2 and HAVE_AC_MISSING2 we need to
# open AH_TEMPLATE to `configure.in', which is not yet the case.
AT_CHECK_MACRO(AC_CHECK_FILES,
[touch ac-exists1 ac-exists2
ac_exists2=ac-exists2
ac_missing2=ac-missing2
AC_CHECK_FILES(ac-exists1 ac-missing1 $ac_exists2 $ac_missing2)
rm ac-exists1 ac-exists2],
[AT_CHECK_DEFINES(
[#define HAVE_AC_EXISTS1 1
/* #undef HAVE_AC_MISSING1 */
])])



## ------------------------------ ##
## AC_CHECK_PROG & AC_PATH_PROG.  ##
## ------------------------------ ##

AT_SETUP(AC_CHECK_PROG & AC_PATH_PROG)

# Create a sub directory `path' with 6 subdirs which all 7 contain
# an executable `tool'. `6' contains a `better' tool.

mkdir path

cat >path/tool <<\EOF
#! /bin/sh
exit 0
EOF
chmod +x path/tool

for i in 1 2 3 4 5 6
do
  mkdir path/$i
  cp path/tool path/$i
done
cp path/tool path/6/better


# -------------------------------- #
# AC_CHECK_PROG & AC_CHECK_PROGS.  #
# -------------------------------- #

AT_DATA(configure.in,
[[AC_INIT
pwd=`pwd`
path=`echo "1:2:3:4:5:6" | sed -e 's,\([[0-9]]\),'"$pwd"'/path/\1,g'`
fail=0

AC_CHECK_PROG(TOOL1, tool, found, not-found, $path)
test "$TOOL1" = found || fail=1

# Yes, the semantics of this macro is weird.
AC_CHECK_PROG(TOOL2, tool,, not-found, $path)
test "$TOOL2" = not-found || fail=1

AC_CHECK_PROG(TOOL3, tool, tool, not-found, $path, $pwd/path/1/tool)
test "$TOOL3" = $pwd/path/2/tool || fail=1

AC_CHECK_PROG(TOOL4, better, better, not-found, $path, $pwd/path/1/tool)
test "$TOOL4" = better || fail=1

# When a tool is not found, and no value is given for not-found,
# the variable is left empty.
AC_CHECK_PROGS(TOOL5, missing,, $path)
test -z "$TOOL5" || fail=1

AC_CHECK_PROGS(TOOL6, missing tool better,, $path)
test "$TOOL6" = tool || fail=1

# no AC_OUTPUT, we don't need config.status.
exit $fail
]])

AT_CHECK([../autoconf --autoconf-dir .. -l $at_srcdir], 0, [], [])
AT_CHECK([./configure], 0, ignore)


# ------------------------------ #
# AC_PATH_PROG & AC_PATH_PROGS.  #
# ------------------------------ #

AT_DATA(configure.in,
[[AC_INIT
pwd=`pwd`
path=`echo "1:2:3:4:5:6" | sed -e 's,\([[0-9]]\),'"$pwd"'/path/\1,g'`
fail=0

AC_PATH_PROG(TOOL1, tool, not-found, $path)
test "$TOOL1" = $pwd/path/1/tool || fail=1

AC_PATH_PROG(TOOL2, better, not-found, $path)
test "$TOOL2" = $pwd/path/6/better || fail=1

# When a tool is not found, and no value is given for not-found,
# the variable is left empty.
AC_PATH_PROGS(TOOL3, missing,, $path)
test -z "$TOOL3" || fail=1

AC_PATH_PROGS(TOOL4, missing tool better,, $path)
test "$TOOL4" = $pwd/path/1/tool || fail=1

# no AC_OUTPUT, we don't need config.status.
exit $fail
]])

AT_CHECK([../autoconf --autoconf-dir .. -l $at_srcdir], 0, [], [])
AT_CHECK([./configure], 0, ignore)

AT_CLEANUP(path config.log config.cache configure)




## ----------------- ##
## Specific macros.  ##
## ----------------- ##


# C compiler
# ----------
# GCC supports `const', `volatile', and `inline'.
AT_CHECK_MACRO(C keywords,
[[AC_PROG_CC
AC_C_CONST
AC_C_INLINE
AC_C_VOLATILE
case "$GCC,$ac_cv_c_const,$ac_cv_c_inline,$ac_cv_c_volatile" in
 yes,*no*) exit 1;;
esac]])


## ------------- ##
## AC_PROG_CPP.  ##
## ------------- ##


# It's Ok for strict preprocessors to produce warnings.

AT_SETUP([AC_PROG_CPP with warnings])

AT_DATA([mycpp],
[[#! /bin/sh
echo noise >&2
exec ${1+"$@"}
]])

chmod +x mycpp

_AT_CHECK_AC_MACRO(
[AC_PROG_CPP
# If the preprocessor is not strict, just ignore
test "x$ac_c_preproc_warn_flag" = xyes && exit 77
CPP="./mycpp $CPP"
AC_CHECK_HEADERS(stdio.h autoconf_io.h)])

AT_CHECK_DEFINES(
[/* #undef HAVE_AUTOCONF_IO_H */
#define HAVE_STDIO_H 1
])

AT_CLEANUP(configure config.status config.log config.cache config.hin config.h env-after)dnl


# Non-strict preprocessors work if they produce no warnings.

AT_SETUP([AC_PROG_CPP without warnings])

AT_DATA([mycpp],
[[#! /bin/sh
/lib/cpp ${1+"$@"}
exit 0
]])

chmod +x mycpp

_AT_CHECK_AC_MACRO(
[# Ignore if /lib/cpp doesn't work
/lib/cpp </dev/null >/dev/null 2>&1 || exit 77
CPP=./mycpp
AC_PROG_CPP
test "x$ac_c_preproc_warn_flag" != xyes && exit 1
AC_CHECK_HEADERS(stdio.h autoconf_io.h)])

AT_CHECK_DEFINES(
[/* #undef HAVE_AUTOCONF_IO_H */
#define HAVE_STDIO_H 1
])

AT_CLEANUP(configure config.status config.log config.cache config.hin config.h env-after)dnl





## ------------- ##
## Base macros.  ##
## ------------- ##


AT_SETUP([AC_CONFIG_FILES, HEADERS, LINKS and COMMANDS])

AT_DATA(configure.in,
[[AC_INIT
rm -rf header file link command
touch header.in file.in link.in command.in
case $what_to_test in
 header)   AC_CONFIG_HEADERS(header:header.in);;
 file)     AC_CONFIG_FILES(file:file.in);;
 command)  AC_CONFIG_COMMANDS(command:command.in, [cp command.in command]);;
 link)     AC_CONFIG_LINKS(link:link.in);;
esac
AC_OUTPUT
]])

AT_CHECK([../autoconf --autoconf-dir .. -l $at_srcdir], 0, [], [])

# Create a header
AT_CHECK([./configure what_to_test=header], 0, ignore)
AT_CHECK([ls header file command link 2>/dev/null], [], [header
])

# Create a file
AT_CHECK([./configure what_to_test=file], 0, ignore)
AT_CHECK([ls header file command link 2>/dev/null], [], [file
])

# Execute a command
AT_CHECK([./configure what_to_test=command], 0, ignore)
AT_CHECK([ls header file command link 2>/dev/null], [], [command
])

# Create a link
AT_CHECK([./configure what_to_test=link], 0, ignore)
AT_CHECK([ls header file command link 2>/dev/null], [], [link
])

AT_CLEANUP(header file link command header.in file.in link.in command.in configure config.status)



## ------------------------------------------------------ ##
## Check that config.status detects missing input files.  ##
## ------------------------------------------------------ ##

AT_SETUP(missing templates)

AT_DATA(configure.in,
[[AC_INIT
AC_CONFIG_FILES([nonexistent])
AC_OUTPUT
]])

AT_CHECK([../autoconf --autoconf-dir .. -l $at_srcdir], 0, [], [])
AT_CHECK([./configure], 1, ignore,
[[configure: error: cannot find input file `nonexistent.in'
]])
# Make sure that the output file doesn't exist
AT_CHECK([test -f nonexistent], 1)

AT_CLEANUP(configure config.status config.log config.cache config.h defs)
