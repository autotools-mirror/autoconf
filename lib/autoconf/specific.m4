dnl Macros that test for specific features.
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
dnl Roland McGrath, and Noah Friedman.
dnl
dnl
dnl ### Checks for programs
dnl
dnl
define(AC_PROG_CC,
[AC_BEFORE([$0], [AC_PROG_CPP])dnl
AC_PROVIDE([$0])dnl
AC_PROGRAM_CHECK(CC, gcc, gcc, cc)

# Find out if we are using GNU C, under whatever name.
AC_CACHE_VAL(ac_cv_prog_gcc,
[cat > conftest.c <<EOF
#ifdef __GNUC__
  yes
#endif
EOF
if ${CC-cc} -E conftest.c 2>&6 | egrep yes >/dev/null 2>&1; then
  ac_cv_prog_gcc=yes
else
  ac_cv_prog_gcc=no
fi])dnl
if test $ac_cv_prog_gcc = yes; then GCC=yes; else GCC= ; fi
])dnl
dnl
define(AC_PROG_CXX,
[AC_BEFORE([$0],[AC_PROG_CXXCPP])dnl
AC_PROVIDE([$0])dnl
AC_PROGRAMS_CHECK(CXX, $CCC c++ g++ gcc CC cxx, gcc)

# Find out if we are using GNU C++, under whatever name.
AC_CACHE_VAL(ac_cv_prog_gxx,
[cat > conftest.C <<EOF
#ifdef __GNUC__
  yes
#endif
EOF
if ${CXX-gcc} -E conftest.C 2>&6 | egrep yes >/dev/null 2>&1; then
  ac_cv_prog_gxx=yes
else
  ac_cv_prog_gxx=no
fi])dnl
if test $ac_cv_prog_gxx = yes; then GXX=yes; else GXX= ; fi
])dnl
dnl
define(AC_GCC_TRADITIONAL,
[AC_REQUIRE([AC_PROG_CC])dnl
AC_REQUIRE([AC_PROG_CPP])dnl
if test $ac_cv_prog_gcc = yes; then
  AC_CHECKING(whether -traditional is needed)
AC_CACHE_VAL(ac_cv_prog_gcc_traditional,
[  ac_pattern="Autoconf.*'x'"
  ac_prog='#include <sgtty.h>
Autoconf TIOCGETP'
  AC_PROGRAM_EGREP($ac_pattern, $ac_prog,
  ac_cv_prog_gcc_traditional=yes, ac_cv_prog_gcc_traditional=no)

  if test $ac_cv_prog_gcc_traditional = no; then
    ac_prog='#include <termio.h>
Autoconf TCGETA'
    AC_PROGRAM_EGREP($ac_pattern, $ac_prog, ac_cv_prog_gcc_traditional=yes)
  fi])dnl
  if test $ac_cv_prog_gcc_traditional = yes; then
    CC="$CC -traditional"
    AC_VERBOSE(setting CC to $CC)
  fi
fi
])dnl
dnl
define(AC_MINUS_C_MINUS_O,
[if test "x$CC" != xcc; then
  AC_CHECKING(whether $CC and cc understand -c and -o together)
else
  AC_CHECKING(whether cc understands -c and -o together)
fi
set dummy $CC; ac_cc=[$]2
AC_CACHE_VAL(ac_cv_prog_cc_${ac_cc}_c_o,
[ac_cv_prog_cc_${ac_cc}_c_o=no
echo 'foo(){}' > conftest.c
# Make sure it works both with $CC and with simple cc.
# We do the test twice because some compilers refuse to overwrite an
# existing .o file with -o, though they will create one.
if ${CC-cc} -c conftest.c -o conftest.o 1>&6 2>&6 &&
  test -f conftest.o && ${CC-cc} -c conftest.c -o conftest.o 1>&6 2>&6
then
  if test "x$CC" != xcc; then
    # Test first that cc exists at all.
    if cc -c conftest.c 1>&6 2>&6
    then
      if cc -c conftest.c -o conftest2.o 1>&6 2>&6 &&
        test -f conftest2.o && cc -c conftest.c -o conftest2.o 1>&6 2>&6
      then
        ac_cv_prog_cc_${ac_cc}_c_o=yes
      fi
    fi
  fi
fi
rm -f conftest*
])dnl
if test $ac_cv_prog_cc_${ac_cc}_c_o = no; then
  AC_DEFINE(NO_MINUS_C_MINUS_O)
fi
])dnl
dnl
dnl Define SET_MAKE to set ${MAKE} if make doesn't.
define(AC_SET_MAKE,
[AC_CHECKING(whether ${MAKE-make} sets \$MAKE)
set dummy ${MAKE-make}; ac_make=[$]2
AC_CACHE_VAL(ac_cv_prog_make_${ac_make}_set,
[cat > conftestmake <<'EOF'
all:
	@echo 'ac_maketemp="${MAKE}"'
EOF
changequote(,)dnl
# GNU make sometimes prints "make[1]: Entering...", which would confuse us.
eval `${MAKE-make} -f conftestmake 2>/dev/null | grep temp=`
changequote([,])dnl
if test -n "$ac_maketemp"; then
  ac_cv_prog_make_${ac_make}_set=yes
else
  ac_cv_prog_make_${ac_make}_set=no
fi
rm -f conftestmake])dnl
if test $ac_cv_prog_make_${ac_make}_set = yes; then
  SET_MAKE=
else
  SET_MAKE="MAKE=${MAKE-make}"
  AC_VERBOSE(setting MAKE to ${MAKE-make} in Makefiles)
fi
AC_SUBST([SET_MAKE])dnl
])dnl
dnl
define(AC_PROG_RANLIB, [AC_PROGRAM_CHECK(RANLIB, ranlib, ranlib, :)])dnl
dnl
define(AC_PROG_AWK, [AC_PROGRAMS_CHECK(AWK, mawk gawk nawk awk,)])dnl
dnl
define(AC_PROG_YACC,[AC_PROGRAMS_CHECK(YACC, 'bison -y' byacc, yacc)])dnl
dnl
define(AC_PROG_CPP,
[AC_PROVIDE([$0])dnl
AC_CHECKING(how to run the C preprocessor)
if test -z "$CPP"; then
AC_CACHE_VAL(ac_cv_prog_CPP,
[  # This must be in double quotes, not single quotes, because CPP may get
  # substituted into the Makefile and "${CC-cc}" will confuse make.
  CPP="${CC-cc} -E"
  # On the NeXT, cc -E runs the code through the compiler's parser,
  # not just through cpp.
  AC_TEST_CPP([#include <stdio.h>
Syntax Error], ,
  CPP="${CC-cc} -E -traditional-cpp"
  AC_TEST_CPP([#include <stdio.h>
Syntax Error], ,CPP=/lib/cpp))
  ac_cv_prog_CPP="$CPP"])dnl
fi
CPP="$ac_cv_prog_CPP"
AC_VERBOSE(setting CPP to $CPP)
AC_SUBST(CPP)dnl
])dnl
dnl
define(AC_PROG_CXXCPP,
[AC_PROVIDE([$0])dnl
AC_CHECKING(how to run the C++ preprocessor)
if test -z "$CXXCPP"; then
AC_CACHE_VAL(ac_cv_prog_CXXCPP,
[AC_LANG_SAVE[]dnl
AC_LANG_CPLUSPLUS[]dnl
  CXXCPP="${CXX-c++} -E"
  AC_TEST_CPP([#include <stdlib.h>], , CXXCPP=/lib/cpp)
  ac_cv_prog_CXXCPP="$CXXCPP"
AC_LANG_RESTORE[]dnl
fi])dnl
CXXCPP="$ac_cv_prog_CXXCPP"
AC_VERBOSE(setting CXXCPP to $CXXCPP)
AC_SUBST(CXXCPP)dnl
])dnl
dnl
dnl Require finding the C or C++ preprocessor, whichever is the
dnl current language.
define(AC_REQUIRE_CPP,
[ifelse(AC_LANG,C,[AC_REQUIRE([AC_PROG_CPP])],[AC_REQUIRE([AC_PROG_CXXCPP])])])dnl
dnl
define(AC_PROG_LEX,
[AC_PROVIDE([$0])dnl
AC_PROGRAM_CHECK(LEX, flex, flex, lex)
if test -z "$LEXLIB"
then
  case "$LEX" in
  flex*) AC_HAVE_LIBRARY(fl, LEXLIB="-lfl") ;;
  *) LEXLIB="-ll" ;;
  esac
fi
AC_VERBOSE(setting LEXLIB to $LEXLIB)
AC_SUBST(LEXLIB)])dnl
dnl
define(AC_YYTEXT_POINTER,
[AC_REQUIRE_CPP()dnl
AC_REQUIRE([AC_PROG_LEX])dnl
AC_CHECKING(for yytext declaration)
AC_CACHE_VALUE(ac_cv_prog_lex_yytext_pointer,
[# POSIX says lex can declare yytext either as a pointer or an array; the
# default is implementation-dependent. Figure out which it is, since
# not all implementations provide the %pointer and %array declarations.
#
# The minimal lex program is just a single line: %%.  But some broken lexes
# (Solaris, I think it was) want two %% lines, so accommodate them.
ac_cv_prog_lex_yytext_pointer=no
  echo '%%
%%' | ${LEX}
if test -f lex.yy.c; then
  LEX_OUTPUT_ROOT=lex.yy
elif test -f lexyy.c; then
  LEX_OUTPUT_ROOT=lexyy
else
  AC_ERROR(cannot find output from $LEX, giving up)
fi
echo 'extern char *yytext; main () { exit (0); }' >>$LEX_OUTPUT_ROOT.c
ac_save_LIBS="$LIBS"
LIBS="$LIBS $LEXLIB"
AC_TEST_LINK(`cat $LEX_OUTPUT_ROOT.c`, ac_cv_prog_lex_yytext_pointer=yes)
LIBS="$ac_save_LIBS"
rm -f "${LEX_OUTPUT_ROOT}.c"])dnl
if test $ac_cv_prog_lex_yytext_pointer = yes; then
  AC_DEFINE(YYTEXT_POINTER)
fi
AC_SUBST(LEX_OUTPUT_ROOT)dnl
])dnl
dnl
define(AC_PROG_INSTALL,
[AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT])dnl
# Make sure to not get the incompatible SysV /etc/install and
# /usr/sbin/install, which might be in PATH before a BSD-like install,
# or the SunOS /usr/etc/install directory, or the AIX /bin/install,
# or the AFS install, which mishandles nonexistent args, or
# /usr/ucb/install on SVR4, which tries to use the nonexistent group
# "staff", or /sbin/install on IRIX which has incompatible command-line
# syntax.  Sigh.
#
#     On most BSDish systems install is in /usr/bin, not /usr/ucb
#     anyway.
# This turns out not to be true, so the mere pathname is not an indication
# of whether the program works.  What we really need is a set of tests for
# the install program to see if it actually works in all the required ways.
#
# Avoid using ./install, which might have been erroneously created
# by make from ./install.sh.
AC_CHECKING(for a BSD compatible install)
if test -z "${INSTALL}"; then
AC_CACHE_VAL(ac_cv_path_install,
[  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:"
  for ac_dir in $PATH; do
    case "$ac_dir" in
    ''|.|/etc|/sbin|/usr/sbin|/usr/etc|/usr/afsws/bin|/usr/ucb) ;;
    *)
      # OSF1 and SCO ODT 3.0 have their own names for install.
      for ac_prog in ginstall installbsd scoinst install; do
        if test -f $ac_dir/$ac_prog; then
	  if test $ac_prog = install &&
            grep dspmsg $ac_dir/$ac_prog >/dev/null 2>&1; then
	    # AIX install.  It has an incompatible calling convention.
	    # OSF/1 installbsd also uses dspmsg, but is usable.
	    :
	  else
	    ac_cv_path_install="$ac_dir/$ac_prog -c"
	    break 2
	  fi
	fi
      done
      ;;
    esac
  done
  IFS="$ac_save_ifs"
  # As a last resort, use the slow shell script.
  test -z "$ac_cv_path_install" && ac_cv_path_install="$ac_install_sh"])dnl
  INSTALL="$ac_cv_path_install"
fi
AC_SUBST(INSTALL)dnl
AC_VERBOSE(setting INSTALL to $INSTALL)

# Use test -z because SunOS4 sh mishandles braces in ${var-val}.
# It thinks the first close brace ends the variable substitution.
test -z "$INSTALL_PROGRAM" && INSTALL_PROGRAM='${INSTALL}'
AC_SUBST(INSTALL_PROGRAM)dnl
AC_VERBOSE(setting INSTALL_PROGRAM to $INSTALL_PROGRAM)

test -z "$INSTALL_DATA" && INSTALL_DATA='${INSTALL} -m 644'
AC_SUBST(INSTALL_DATA)dnl
AC_VERBOSE(setting INSTALL_DATA to $INSTALL_DATA)
])dnl
dnl
define(AC_LN_S,
[AC_CHECKING(whether ln -s works)
AC_CACHE_VAL(ac_cv_prog_LN_S,
[rm -f conftestdata
if ln -s X conftestdata 2>/dev/null
then
  rm -f conftestdata
  ac_cv_prog_LN_S="ln -s"
else
  ac_cv_prog_LN_S=ln
fi])dnl
LN_S="$ac_cv_prog_LN_S"
if test "$ac_cv_prog_LN_S" = "ln -s"; then
  AC_VERBOSE(ln -s is supported)
else
  AC_VERBOSE(ln -s is not supported)
fi
AC_SUBST(LN_S)dnl
])dnl
dnl
define(AC_RSH,
[AC_CHECKING(for remote shell)
AC_CACHE_VAL(ac_cv_path_RSH,
[ac_cv_path_RSH=true
for ac_file in \
  /usr/ucb/rsh /usr/bin/remsh /usr/bin/rsh /usr/bsd/rsh /usr/bin/nsh
do
  if test -f $ac_file; then
    ac_cv_path_RSH=$ac_file
    break
  fi
done])dnl
RSH="$ac_cv_path_RSH"
if test $RSH != true; then
  AC_VERBOSE(found remote shell $RSH)
  RTAPELIB=rtapelib.o
else
  AC_VERBOSE(found no remote shell)
  AC_HEADER_CHECK(netdb.h, RTAPELIB=rtapelib.o AC_DEFINE(HAVE_NETDB_H),
    RTAPELIB= AC_DEFINE(NO_REMOTE))
fi
AC_SUBST(RSH)dnl
AC_SUBST(RTAPELIB)dnl
])dnl
dnl
dnl
dnl ### Checks for header files
dnl
dnl
define(AC_STDC_HEADERS,
[AC_REQUIRE_CPP()dnl
AC_CHECKING(for ANSI C header files)
AC_CACHE_VAL(ac_cv_header_stdc,
[AC_TEST_CPP([#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <float.h>], ac_cv_header_stdc=yes, ac_cv_header_stdc=no)

if test $ac_cv_header_stdc = yes; then
  # SunOS 4.x string.h does not declare mem*, contrary to ANSI.
AC_HEADER_EGREP(memchr, string.h, , ac_cv_header_stdc=no)
fi

if test $ac_cv_header_stdc = yes; then
  # ISC 2.0.2 stdlib.h does not declare free, contrary to ANSI.
AC_HEADER_EGREP(free, stdlib.h, , ac_cv_header_stdc=no)
fi

if test $ac_cv_header_stdc = yes; then
  # /bin/cc in Irix-4.0.5 gets non-ANSI ctype macros unless using -ansi.
AC_TEST_RUN([#include <ctype.h>
#define ISLOWER(c) ('a' <= (c) && (c) <= 'z')
#define TOUPPER(c) (ISLOWER(c) ? 'A' + ((c) - 'a') : (c))
#define XOR(e,f) (((e) && !(f)) || (!(e) && (f)))
int main () { int i; for (i = 0; i < 256; i++)
if (XOR (islower (i), ISLOWER (i)) || toupper (i) != TOUPPER (i)) exit(2);
exit (0); }
], , ac_stdc_headers=no)
fi])dnl
if test $ac_cv_header_stdc = yes; then
  AC_DEFINE(STDC_HEADERS)
fi])dnl
dnl
define(AC_UNISTD_H,
[AC_OBSOLETE([$0], [; instead use AC_HAVE_HEADERS(unistd.h)])dnl
AC_HEADER_CHECK(unistd.h, AC_DEFINE(HAVE_UNISTD_H))])dnl
dnl
define(AC_USG,
[AC_OBSOLETE([$0],
  [; instead use AC_HAVE_HEADERS(string.h) and HAVE_STRING_H])dnl
AC_CHECKING([for BSD string and memory functions])
AC_TEST_LINK([#include <strings.h>], [rindex(0, 0); bzero(0, 0);], ,
  AC_DEFINE(USG))])dnl
dnl
dnl
dnl If memchr and the like aren't declared in <string.h>, include <memory.h>.
dnl To avoid problems, don't check for gcc2 built-ins.
define(AC_MEMORY_H,
[AC_OBSOLETE([$0], [; instead use AC_HAVE_HEADERS(memory.h) and HAVE_MEMORY_H])AC_CHECKING(whether string.h declares mem functions)
AC_HEADER_EGREP(memchr, string.h, ,
  AC_HEADER_CHECK(memory.h, AC_DEFINE(NEED_MEMORY_H)))]
)dnl
dnl
define(AC_MAJOR_HEADER,
[AC_CHECKING([for major, minor and makedev header])
AC_CACHE_VAL(ac_cv_header_major,
[AC_TEST_LINK([#include <sys/types.h>],
[return makedev(0, 0);], ac_cv_header_major=sys/types.h, ac_cv_header_major=no)
if test $ac_cv_header_major = no; then
AC_HEADER_CHECK(sys/mkdev.h, ac_cv_header_major=sys/mkdev.h)
fi
if test $ac_cv_header_major = no; then
AC_HEADER_CHECK(sys/sysmacros.h, ac_cv_header_major=sys/sysmacros.h)
fi])dnl
case "$ac_cv_header_major" in
sys/mkdev.h) AC_DEFINE(MAJOR_IN_MKDEV) ;;
sys/sysmacros.h) AC_DEFINE(MAJOR_IN_SYSMACROS) ;;
esac
])dnl
dnl
define(AC_DIR_HEADER,
[AC_PROVIDE([$0])dnl
AC_CHECKING(for directory library header)
AC_CACHE_VAL(ac_cv_header_dir,
[ac_cv_header_dir=no
for ac_hdr in dirent.h sys/ndir.h sys/dir.h ndir.h; do
  AC_CHECKING([for $ac_hdr])
AC_TEST_LINK([#include <sys/types.h>
#include <$ac_hdr>], [DIR *dirp = 0;], ac_cv_header_dir=$ac_hdr; break)
done])dnl
case "$ac_cv_header_dir" in
dirent.h) AC_DEFINE(DIRENT) ;;
sys/ndir.h) AC_DEFINE(SYSNDIR) ;;
sys/dir.h) AC_DEFINE(SYSDIR) ;;
ndir.h) AC_DEFINE(NDIR) ;;
esac

AC_CHECKING(for closedir return value)
AC_CACHE_VAL(ac_cv_func_closedir_void,
[AC_TEST_RUN([#include <sys/types.h>
#include <$ac_cv_header_dir>
int closedir(); main() { exit(closedir(opendir(".")) != 0); }],
  ac_cv_func_closedir_void=no, ac_cv_func_closedir_void=yes)])dnl
if test $ac_cv_func_closedir_void = yes; then
  AC_DEFINE(VOID_CLOSEDIR)
fi
])dnl
dnl
define(AC_STAT_MACROS_BROKEN,
[AC_CHECKING(for broken stat file mode macros)
AC_CACHE_VAL(ac_cv_header_stat_broken,
[AC_PROGRAM_EGREP([You lose], [#include <sys/types.h>
#include <sys/stat.h>
#ifdef S_ISBLK
#if S_ISBLK (S_IFDIR)
You lose.
#endif
#ifdef S_IFCHR
#if S_ISBLK (S_IFCHR)
You lose.
#endif
#endif /* S_IFCHR */
#endif /* S_ISBLK */
#ifdef S_ISLNK
#if S_ISLNK (S_IFREG)
You lose.
#endif
#endif /* S_ISLNK */
#ifdef S_ISSOCK
#if S_ISSOCK (S_IFREG)
You lose.
#endif
#endif /* S_ISSOCK */
], ac_cv_header_stat_broken=yes, ac_cv_header_stat_broken=no)])dnl
if test $ac_cv_header_stat_broken = yes; then
  AC_DEFINE(STAT_MACROS_BROKEN)
fi
])dnl
dnl
define(AC_SYS_SIGLIST_DECLARED,
[AC_CHECKING([for sys_siglist declaration in signal.h or unistd.h])
AC_CACHE_VAL(ac_cv_decl_sys_siglist,
[AC_TEST_LINK([#include <sys/types.h>
#include <signal.h>
/* NetBSD declares sys_siglist in unistd.h.  */
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif], [char *msg = *(sys_siglist + 1);],
  ac_cv_decl_sys_siglist=yes, ac_cv_decl_sys_siglist=no)])dnl
if test $ac_cv_decl_sys_siglist = yes; then
  AC_DEFINE(SYS_SIGLIST_DECLARED)
fi
])dnl
dnl
dnl
dnl ### Checks for typedefs
dnl
dnl
define(AC_GETGROUPS_T,
[AC_REQUIRE([AC_UID_T])dnl
AC_CHECKING(for type of array argument to getgroups)
AC_CACHE_VAL(ac_cv_type_getgroups,
[changequote(,)dnl
dnl Do not put single quotes in the C program text!
ac_prog='/* Thanks to Mike Rendell for this test.  */
#include <sys/types.h>
#define NGID 256
#undef MAX
#define MAX(x,y) ((x) > (y) ? (x) : (y))
main()
{
  gid_t gidset[NGID];
  int i, n;
  union { gid_t gval; long lval; }  val;

  val.lval = -1;
  for (i = 0; i < NGID; i++)
    gidset[i] = val.gval;
  n = getgroups (sizeof (gidset) / MAX (sizeof (int), sizeof (gid_t)) - 1,
                 gidset);
  /* Exit non-zero if getgroups seems to require an array of ints.  This
     happens when gid_t is short but getgroups modifies an array of ints.  */
  exit ((n > 0 && gidset[n] != val.gval) ? 1 : 0);
}'
changequote([,])dnl
AC_TEST_RUN([$ac_prog],
  ac_cv_type_getgroups=gid_t, ac_cv_type_getgroups=int)])dnl
AC_DEFINE(GETGROUPS_T, $ac_cv_type_getgroups)
])dnl
dnl
define(AC_UID_T,
[AC_PROVIDE([$0])dnl
AC_CHECKING(for uid_t in sys/types.h)
AC_CACHE_VAL(ac_cv_type_uid_t,
[AC_HEADER_EGREP(uid_t, sys/types.h,
  ac_cv_type_uid_t=yes, ac_cv_type_uid_t=no)])dnl
if test $ac_cv_type_uid_t = no; then
  AC_DEFINE(uid_t, int)
  AC_DEFINE(gid_t, int)
fi
])dnl
dnl
define(AC_SIZE_T, [AC_CHECK_TYPE(size_t, unsigned)])dnl
dnl
define(AC_PID_T, [AC_CHECK_TYPE(pid_t, int)])dnl
dnl
define(AC_OFF_T,
[AC_PROVIDE([$0])dnl
AC_CHECK_TYPE(off_t, long)])dnl
dnl
define(AC_MODE_T, [AC_CHECK_TYPE(mode_t, int)])dnl
dnl
dnl Note that identifiers starting with SIG are reserved by ANSI C.
define(AC_RETSIGTYPE,
[AC_PROVIDE([$0])dnl
AC_CHECKING([return type of signal handlers])
AC_CACHE_VAL(ac_cv_type_signal,
[AC_TEST_LINK([#include <sys/types.h>
#include <signal.h>
#ifdef signal
#undef signal
#endif
extern void (*signal ()) ();],
[int i;], ac_cv_type_signal=void, ac_cv_type_signal=int)])dnl
AC_DEFINE(RETSIGTYPE, $ac_cv_type_signal)
])dnl
dnl
dnl
dnl ### Checks for functions
dnl
dnl
define(AC_MMAP,
[AC_CHECKING(for working mmap)
AC_CACHE_VAL(ac_cv_func_mmap,
[AC_TEST_RUN([/* Thanks to Mike Haertel and Jim Avera for this test. */
#include <sys/types.h>
#include <fcntl.h>
#include <sys/mman.h>

#ifdef BSD
#ifndef BSD4_1
#define HAVE_GETPAGESIZE
#endif
#endif
#ifndef HAVE_GETPAGESIZE
#include <sys/param.h>
#ifdef EXEC_PAGESIZE
#define getpagesize() EXEC_PAGESIZE
#else
#ifdef NBPG
#define getpagesize() NBPG * CLSIZE
#ifndef CLSIZE
#define CLSIZE 1
#endif /* no CLSIZE */
#else /* no NBPG */
#ifdef NBPC
#define getpagesize() NBPC
#else /* no NBPC */
#define getpagesize() PAGESIZE /* SVR4 */
#endif /* no NBPC */
#endif /* no NBPG */
#endif /* no EXEC_PAGESIZE */
#endif /* not HAVE_GETPAGESIZE */

#ifdef __osf__
#define valloc malloc
#endif

extern char *valloc();
extern char *malloc();

int
main()
{
  char *buf1, *buf2, *buf3;
  int i = getpagesize(), j;
  int i2 = getpagesize()*2;
  int fd;

  buf1 = valloc(i2);
  buf2 = valloc(i);
  buf3 = malloc(i2);
  for (j = 0; j < i2; ++j)
    *(buf1 + j) = rand();
  fd = open("conftestmmap", O_CREAT | O_RDWR, 0666);
  write(fd, buf1, i2);
  mmap(buf2, i, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE, fd, 0);
  for (j = 0; j < i; ++j)
    if (*(buf1 + j) != *(buf2 + j))
      exit(1);
  lseek(fd, (long)i, 0);
  read(fd, buf2, i); /* read into mapped memory -- file should not change */
  /* (it does in i386 SVR4.0 - Jim Avera) */
  lseek(fd, (long)0, 0);
  read(fd, buf3, i2);
  for (j = 0; j < i2; ++j)
    if (*(buf1 + j) != *(buf3 + j))
      exit(1);
  exit(0);
}
], ac_cv_func_mmap=yes, ac_cv_func_mmap=no)])dnl
if test $ac_cv_func_mmap = yes; then
  AC_DEFINE(HAVE_MMAP)
fi
])dnl
dnl
define(AC_VPRINTF,
[AC_FUNC_CHECK(vprintf, AC_DEFINE(HAVE_VPRINTF))
if test "$ac_cv_func_vprintf" != yes; then
AC_FUNC_CHECK(_doprnt, AC_DEFINE(HAVE_DOPRNT))
fi
])dnl
dnl
define(AC_VFORK,
[AC_REQUIRE([AC_PID_T])dnl
AC_HEADER_CHECK(vfork.h, AC_DEFINE(HAVE_VFORK_H))
AC_CHECKING(for working vfork)
AC_CACHE_VAL(ac_cv_func_vfork,
[AC_REQUIRE([AC_RETSIGTYPE])
AC_TEST_RUN([/* Thanks to Paul Eggert for this test.  */
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#ifdef HAVE_VFORK_H
#include <vfork.h>
#endif
/* On sparc systems, changes by the child to local and incoming
   argument registers are propagated back to the parent.
   The compiler is told about this with #include <vfork.h>,
   but some compilers (e.g. gcc -O) don't grok <vfork.h>.
   Test for this by using a static variable whose address
   is put into a register that is clobbered by the vfork.  */
static
sparc_address_test (arg) int arg; {
  static pid_t child;
  if (!child) {
    child = vfork ();
    if (child < 0)
      perror ("vfork");
    if (!child) {
      arg = getpid();
      write(-1, "", 0);
      _exit (arg);
    }
  }
}
static int signalled;
static RETSIGTYPE catch (s) int s; { signalled = 1; }
main() {
  pid_t parent = getpid ();
  pid_t child;

  sparc_address_test ();

  signal (SIGINT, catch);

  child = vfork ();

  if (child == 0) {
    /* Here is another test for sparc vfork register problems.
       This test uses lots of local variables, at least
       as many local variables as main has allocated so far
       including compiler temporaries.  4 locals are enough for
       gcc 1.40.3 on a sparc, but we use 8 to be safe.
       A buggy compiler should reuse the register of parent
       for one of the local variables, since it will think that
       parent can't possibly be used any more in this routine.
       Assigning to the local variable will thus munge parent
       in the parent process.  */
    pid_t
      p = getpid(), p1 = getpid(), p2 = getpid(), p3 = getpid(),
      p4 = getpid(), p5 = getpid(), p6 = getpid(), p7 = getpid();
    /* Convince the compiler that p..p7 are live; otherwise, it might
       use the same hardware register for all 8 local variables.  */
    if (p != p1 || p != p2 || p != p3 || p != p4
	|| p != p5 || p != p6 || p != p7)
      _exit(1);

    /* On some systems (e.g. SunOS 5.2), if the parent is catching
       a signal, the child ignores the signal before execing,
       and the parent later receives that signal, the parent dumps core.
       Test for this by ignoring SIGINT in the child.  */
    signal (SIGINT, SIG_IGN);

    /* On some systems (e.g. IRIX 3.3),
       vfork doesn't separate parent from child file descriptors.
       If the child closes a descriptor before it execs or exits,
       this munges the parent's descriptor as well.
       Test for this by closing stdout in the child.  */
    _exit(close(fileno(stdout)) != 0);
  } else {
    int status;
    struct stat st;

    while (wait(&status) != child)
      ;
    exit(
	 /* Was there some problem with vforking?  */
	 child < 0

	 /* Did the child fail?  (This shouldn't happen.)  */
	 || status

	 /* Did the vfork/compiler bug occur?  */
	 || parent != getpid()

	 /* Did the signal handling bug occur?  */
	 || kill(parent, SIGINT) != 0
	 || signalled != 1

	 /* Did the file descriptor bug occur?  */
	 || fstat(fileno(stdout), &st) != 0
	 );
  }
}], ac_cv_func_vfork=yes, ac_cv_func_vfork=no)])dnl
if test $ac_cv_func_vfork = no; then
  AC_DEFINE(vfork, fork)
fi
])dnl
dnl
define(AC_WAIT3,
[AC_CHECKING(for wait3 that fills in rusage)
AC_CACHE_VAL(ac_cv_func_wait3,
[AC_TEST_RUN([#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <stdio.h>
/* HP-UX has wait3 but does not fill in rusage at all.  */
main() {
  struct rusage r;
  int i;
  /* Use a field that we can force nonzero --
     voluntary context switches.
     For systems like NeXT and OSF/1 that don't set it,
     also use the system CPU time.  */
  r.ru_nvcsw = 0;
  r.ru_stime.tv_sec = 0;
  r.ru_stime.tv_usec = 0;
  switch (fork()) {
  case 0: /* Child.  */
    sleep(1); /* Give up the CPU.  */
    _exit(0);
  case -1: _exit(0); /* What can we do?  */
  default: /* Parent.  */
    wait3(&i, 0, &r);
    sleep(1); /* Avoid "text file busy" from rm on fast HP-UX machines.  */
    exit(r.ru_nvcsw == 0
	 && r.ru_stime.tv_sec == 0 && r.ru_stime.tv_usec == 0);
  }
}], ac_cv_func_wait3=yes, ac_cv_func_wait3=no)])dnl
if test $ac_cv_func_wait3 = yes; then
  AC_DEFINE(HAVE_WAIT3)
fi
])dnl
dnl
define(AC_ALLOCA,
[# The Ultrix 4.2 mips builtin alloca declared by alloca.h only works
# for constant arguments.  Useless!
AC_CHECKING([for working alloca.h])
AC_CACHE_VAL(ac_cv_header_alloca_h,
[AC_TEST_LINK([#include <alloca.h>], [char *p = alloca(2 * sizeof(int));],
  ac_cv_header_alloca_h=yes, ac_cv_header_alloca_h=no)])dnl
if test $ac_cv_header_alloca_h = yes; then
  AC_DEFINE(HAVE_ALLOCA_H)
fi

AC_CHECKING([for alloca])
AC_CACHE_VAL(ac_cv_func_alloca,
[AC_TEST_LINK([#ifdef __GNUC__
#define alloca __builtin_alloca
#else
#if HAVE_ALLOCA_H
#include <alloca.h>
#else
#ifdef _AIX
 #pragma alloca
#else
#ifndef alloca /* predefined by HP cc +Olibcalls */
char *alloca ();
#endif
#endif
#endif
#endif
], [char *p = (char *) alloca(1);],
  ac_cv_func_alloca=yes, ac_cv_func_alloca=no)])dnl
if test $ac_cv_func_alloca = yes; then
  AC_DEFINE(HAVE_ALLOCA)
fi

if test $ac_cv_func_alloca = no; then
  # The SVR3 libPW and SVR4 libucb both contain incompatible functions
  # that cause trouble.  Some versions do not even contain alloca or
  # contain a buggy version.  If you still want to use their alloca,
  # use ar to extract alloca.o from them instead of compiling alloca.c.
  ALLOCA=alloca.o
  AC_DEFINE(C_ALLOCA)

AC_CHECKING(whether Cray hooks are needed for C alloca)
AC_PROGRAM_EGREP(webecray,
[#if defined(CRAY) && ! defined(CRAY2)
webecray
#else
wenotbecray
#endif
],
AC_FUNC_CHECK([_getb67],AC_DEFINE(CRAY_STACKSEG_END, _getb67),
AC_FUNC_CHECK([GETB67],AC_DEFINE(CRAY_STACKSEG_END, GETB67),
AC_FUNC_CHECK([getb67],AC_DEFINE(CRAY_STACKSEG_END, getb67)))))

AC_CHECKING(stack direction for C alloca)
AC_CACHE_VAL(ac_cv_c_stack_direction,
[AC_TEST_RUN([find_stack_direction ()
{
  static char *addr = 0;
  auto char dummy;
  if (addr == 0)
    {
      addr = &dummy;
      return find_stack_direction ();
    }
  else
    return (&dummy > addr) ? 1 : -1;
}
main ()
{
  exit (find_stack_direction() < 0);
}], ac_cv_c_stack_direction=1, ac_cv_c_stack_direction=-1,
  ac_cv_c_stack_direction=0)])dnl
AC_DEFINE(STACK_DIRECTION, $ac_cv_c_stack_direction)
fi
AC_SUBST(ALLOCA)dnl
])dnl
dnl
define(AC_GETLOADAVG,
[# Some definitions of getloadavg require that the program be installed setgid.
NEED_SETGID=false
AC_SUBST(NEED_SETGID)dnl
ac_have_func=no

# Check for the 4.4BSD definition of getloadavg.
AC_HAVE_LIBRARY(util, [LIBS="$LIBS -lutil" ac_have_func=yes
# Some systems with -lutil have (and need) -lkvm as well, some do not.
AC_HAVE_LIBRARY(kvm, LIBS="$LIBS -lkvm")])

if test $ac_have_func = no; then
# There is a commonly available library for RS/6000 AIX.
# Since it is not a standard part of AIX, it might be installed locally.
ac_save_LIBS="$LIBS" LIBS="-L/usr/local/lib $LIBS"
AC_HAVE_LIBRARY(getloadavg, LIBS="$LIBS -lgetloadavg", LIBS="$ac_save_LIBS")
fi

# Make sure it is really in the library, if we think we found it.
AC_REPLACE_FUNCS(getloadavg)

if test $ac_cv_func_getloadavg = yes; then
  AC_DEFINE(HAVE_GETLOADAVG)
else
ac_have_func=no
AC_HEADER_CHECK(sys/dg_sys_info.h,
[ac_have_func=yes AC_DEFINE(DGUX)
# Some versions of DGUX need -ldgc for dg_sys_info.
AC_HAVE_LIBRARY(dgc)])
if test $ac_have_func = no; then
# We cannot check for <dwarf.h>, because Solaris 2 does not use dwarf (it
# uses stabs), but it is still SVR4.  We cannot check for <elf.h> because
# Irix 4.0.5F has the header but not the library.
AC_HAVE_LIBRARY(elf,
  [LIBS="$LIBS -lelf" ac_have_func=yes AC_DEFINE(SVR4)
  AC_HAVE_LIBRARY(kvm, LIBS="$LIBS -lkvm")])
fi
if test $ac_have_func = no; then
AC_HEADER_CHECK(inq_stats/cpustats.h,
  [ac_have_func=yes AC_DEFINE(UMAX4_3) AC_DEFINE(UMAX)])
fi
if test $ac_have_func = no; then
AC_HEADER_CHECK(sys/cpustats.h,
  [ac_have_func=yes AC_DEFINE(UMAX)])
fi
if test $ac_have_func = no; then
AC_HAVE_HEADERS(mach/mach.h)
fi

AC_HEADER_CHECK(nlist.h,
[AC_DEFINE(NLIST_STRUCT)
AC_CHECKING([for n_un in struct nlist])
AC_CACHE_VAL(ac_cv_struct_nlist_n_un,
[AC_TEST_LINK([#include <nlist.h>],
[struct nlist n; n.n_un.n_name = 0;],
ac_cv_struct_nlist_n_un=yes, ac_cv_struct_nlist_n_un=no)])dnl
if test $ac_cv_struct_nlist_n_un = yes; then
  AC_DEFINE(NLIST_NAME_UNION)
fi
])dnl

AC_CHECKING(whether getloadavg requires setgid)
AC_CACHE_VAL(ac_cv_func_getloadavg_setgid,
[AC_PROGRAM_EGREP([Yowza Am I SETGID yet],
[#include "${srcdir}/getloadavg.c"
#ifdef LDAV_PRIVILEGED
Yowza Am I SETGID yet
#endif],
  ac_cv_func_getloadavg_setgid=yes, ac_cv_func_getloadavg_setgid=no)])dnl
if test $ac_cv_func_getloadavg_setgid = yes; then
  NEED_SETGID=true AC_DEFINE(GETLOADAVG_PRIVILEGED)
fi

fi # Do not have getloadavg in system libraries.

if test "$NEED_SETGID" = true; then
  AC_CHECKING(group of /dev/kmem)
AC_CACHE_VAL(ac_cv_group_kmem,
[changequote(,)dnl
  # On Solaris, /dev/kmem is a symlink.  Get info on the real file.
  ac_ls_output=`ls -lgL /dev/kmem 2>/dev/null`
  # If we got an error (system does not support symlinks), try without -L.
  test -z "$ac_ls_output" && ac_ls_output=`ls -lg /dev/kmem`
  ac_cv_group_kmem=`echo $ac_ls_output \
    | sed -ne 's/[ 	][ 	]*/ /g;
	       s/^.[sSrwx-]* *[0-9]* *\([^0-9]*\)  *.*/\1/;
	       / /s/.* //;p;'`
changequote([,])dnl
])dnl
  KMEM_GROUP=$ac_cv_group_kmem
  AC_VERBOSE(/dev/kmem is owned by $KMEM_GROUP)
fi
AC_SUBST(KMEM_GROUP)dnl
])dnl
dnl
define(AC_UTIME_NULL,
[AC_CHECKING(utime with null argument)
AC_CACHE_VAL(ac_cv_func_utime_null,
[rm -f conftestdata; > conftestdata
# Sequent interprets utime(file, 0) to mean use start of epoch.  Wrong.
AC_TEST_RUN([#include <sys/types.h>
#include <sys/stat.h>
main() {
struct stat s, t;
exit(!(stat ("conftestdata", &s) == 0 && utime("conftestdata", (long *)0) == 0
&& stat("conftestdata", &t) == 0 && t.st_mtime >= s.st_mtime
&& t.st_mtime - s.st_mtime < 120));
}], ac_cv_func_utime_null=yes, ac_cv_func_utime_null=no)
rm -f core])dnl
if test $ac_cv_func_utime_null = yes; then
  AC_DEFINE(HAVE_UTIME_NULL)
fi
])dnl
dnl
define(AC_STRCOLL,
[AC_CHECKING(for strcoll)
AC_CACHE_VAL(ac_cv_func_strcoll,
[AC_TEST_RUN([#include <string.h>
main ()
{
  exit (strcoll ("abc", "def") >= 0 ||
	strcoll ("ABC", "DEF") >= 0 ||
	strcoll ("123", "456") >= 0);
}], ac_cv_func_strcoll=yes, ac_cv_func_strcoll=no)])dnl
if test $ac_cv_func_strcoll = yes; then
  AC_DEFINE(HAVE_STRCOLL)
fi
])dnl
dnl
define(AC_SETVBUF_REVERSED,
[AC_CHECKING(whether setvbuf arguments are reversed)
AC_CACHE_VAL(ac_cv_func_setvbuf_reversed,
[AC_TEST_RUN([#include <stdio.h>
/* If setvbuf has the reversed format, exit 0. */
main () {
  /* This call has the arguments reversed.
     A reversed system may check and see that the address of main
     is not _IOLBF, _IONBF, or _IOFBF, and return nonzero.  */
  if (setvbuf(stdout, _IOLBF, (char *) main, BUFSIZ) != 0)
    exit(1);
  putc('\r', stdout);
  exit(0);			/* Non-reversed systems segv here.  */
}], ac_cv_func_setvbuf_reversed=yes, ac_cv_func_setvbuf_reversed=no)
rm -f core])dnl
if test $ac_cv_func_setvbuf_reversed = yes; then
  AC_DEFINE(SETVBUF_REVERSED)
fi
])dnl
dnl
dnl
dnl ### Checks for structure members
dnl
dnl
define(AC_STRUCT_TM,
[AC_PROVIDE([$0])dnl
AC_CHECKING([for struct tm in sys/time.h instead of time.h])
AC_CACHE_VAL(ac_cv_struct_tm,
[AC_TEST_LINK([#include <sys/types.h>
#include <time.h>],
[struct tm *tp; tp->tm_sec;],
  ac_cv_struct_tm=time.h, ac_cv_struct_tm=sys/time.h)])dnl
if test $ac_cv_struct_tm = sys/time.h; then
  AC_DEFINE(TM_IN_SYS_TIME)
fi
])dnl
dnl
define(AC_TIME_WITH_SYS_TIME,
[AC_CHECKING([whether time.h and sys/time.h may both be included])
AC_CACHE_VAL(ac_cv_header_time,
[AC_TEST_LINK([#include <sys/types.h>
#include <sys/time.h>
#include <time.h>],
[struct tm *tp;], ac_cv_header_time=yes, ac_cv_header_time=no)])dnl
if test $ac_cv_header_time = yes; then
  AC_DEFINE(TIME_WITH_SYS_TIME)
fi
])dnl
dnl
define(AC_TIMEZONE,
[AC_REQUIRE([AC_STRUCT_TM])dnl
AC_CHECKING([for tm_zone in struct tm])
AC_CACHE_VAL(ac_cv_struct_tm_zone,
[AC_TEST_LINK([#include <sys/types.h>
#include <$ac_cv_struct_tm>], [struct tm tm; tm.tm_zone;],
  ac_cv_struct_tm_zone=yes, ac_cv_struct_tm_zone=no)])dnl
if test "$ac_cv_struct_tm_zone" = yes; then
  AC_DEFINE(HAVE_TM_ZONE)
else
  AC_CHECKING([for tzname])
AC_CACHE_VAL(ac_cv_var_tzname,
[AC_TEST_LINK(changequote(<<,>>)dnl
<<#include <time.h>
#ifndef tzname /* For SGI.  */
extern char *tzname[]; /* RS6000 and others reject char **tzname.  */
#endif>>, changequote([,])dnl
[atoi(*tzname);], ac_cv_var_tzname=yes, ac_cv_var_tzname=no)])dnl
  if test $ac_cv_var_tzname = yes; then
    AC_DEFINE(HAVE_TZNAME)
  fi
fi
])dnl
dnl
define(AC_ST_BLOCKS,
[AC_CHECKING([for st_blocks in struct stat])
AC_CACHE_VAL(ac_cv_struct_st_blocks,
[AC_TEST_LINK([#include <sys/types.h>
#include <sys/stat.h>], [struct stat s; s.st_blocks;],
ac_cv_struct_st_blocks=yes, ac_cv_struct_st_blocks=no)])dnl
if test $ac_cv_struct_st_blocks = yes; then
  AC_DEFINE(HAVE_ST_BLOCKS)
else
  LIBOBJS="$LIBOBJS fileblocks.o"
fi
AC_SUBST(LIBOBJS)dnl
])dnl
dnl
define(AC_ST_BLKSIZE,
[AC_CHECKING([for st_blksize in struct stat])
AC_CACHE_VAL(ac_cv_struct_st_blksize,
[AC_TEST_LINK([#include <sys/types.h>
#include <sys/stat.h>], [struct stat s; s.st_blksize;],
ac_cv_struct_st_blksize=yes, ac_cv_struct_st_blksize=no)])dnl
if test $ac_cv_struct_st_blksize = yes; then
  AC_DEFINE(HAVE_ST_BLKSIZE)
fi
])dnl
dnl
define(AC_ST_RDEV,
[AC_CHECKING([for st_rdev in struct stat])
AC_CACHE_VAL(ac_cv_struct_st_rdev,
[AC_TEST_LINK([#include <sys/types.h>
#include <sys/stat.h>], [struct stat s; s.st_rdev;],
ac_cv_struct_st_rdev=yes, ac_cv_struct_st_rdev=no)])dnl
if test $ac_cv_struct_st_rdev = yes; then
  AC_DEFINE(HAVE_ST_RDEV)
fi
])dnl
dnl
dnl
dnl ### Checks for compiler characteristics
dnl
dnl
define(AC_CROSS_CHECK,
[AC_PROVIDE([$0])dnl
# If we cannot run a trivial program, we must be cross compiling.
AC_CHECKING(whether cross-compiling)
AC_CACHE_VAL(ac_cv_c_cross,
[AC_TEST_RUN([main(){exit(0);}], ac_cv_c_cross=no, ac_cv_c_cross=yes)])dnl
cross_compiling=$ac_cv_c_cross
if test $ac_cv_c_cross = yes; then
  AC_VERBOSE(we are cross-compiling)
else
  AC_VERBOSE(we are not cross-compiling)
fi])dnl
dnl
define(AC_CHAR_UNSIGNED,
[AC_CHECKING(for unsigned characters)
AC_CACHE_VAL(ac_cv_c_char_unsigned,
[AC_TEST_RUN(
[/* volatile prevents gcc2 from optimizing the test away on sparcs.  */
#if !__STDC__
#define volatile
#endif
main() {
#ifdef __CHAR_UNSIGNED__
  exit(1); /* No need to redefine it.  */
#else
  volatile char c = 255; exit(c < 0);
#endif
}], ac_cv_c_char_unsigned=yes, ac_cv_c_char_unsigned=no)])dnl
if test $ac_cv_c_char_unsigned = yes; then
  AC_DEFINE(__CHAR_UNSIGNED__)
fi
])dnl
dnl
define(AC_LONG_DOUBLE,
[AC_REQUIRE([AC_PROG_CC])dnl
AC_CHECKING(for long double)
AC_CACHE_VAL(ac_cv_c_long_double,
[if test "$GCC" = yes; then
  ac_cv_c_long_double=yes
else
AC_TEST_RUN([int main() {
/* The Stardent Vistra knows sizeof(long double), but does not support it.  */
long double foo = 0.0;
/* On Ultrix 4.3 cc, long double is 4 and double is 8.  */
exit(sizeof(long double) < sizeof(double)); }],
ac_cv_c_long_double=yes, ac_cv_c_long_double=no)
fi])dnl
if test $ac_cv_c_long_double = yes; then
  AC_DEFINE(HAVE_LONG_DOUBLE)
fi
])dnl
dnl
define(AC_INT_16_BITS,
[AC_OBSOLETE([$0], [; instead use AC_SIZEOF_TYPE(int)])
AC_CHECKING(integer size)
AC_TEST_RUN([main() { exit(sizeof(int) != 2); }],
 AC_DEFINE(INT_16_BITS))
])dnl
dnl
define(AC_LONG_64_BITS,
[AC_OBSOLETE([$0], [; instead use AC_SIZEOF_TYPE(long)])
AC_CHECKING(for 64-bit long ints)
AC_TEST_RUN([main() { exit(sizeof(long int) != 8); }],
 AC_DEFINE(LONG_64_BITS))
])dnl
dnl
define(AC_WORDS_BIGENDIAN,
[AC_CHECKING(byte ordering)
AC_CACHE_VAL(ac_cv_c_bigendian,
[AC_TEST_RUN([main () {
  /* Are we little or big endian?  From Harbison&Steele.  */
  union
  {
    long l;
    char c[sizeof (long)];
  } u;
  u.l = 1;
  exit (u.c[sizeof (long) - 1] == 1);
}], ac_cv_c_bigendian=no, ac_cv_c_bigendian=yes)])dnl
if test $ac_cv_c_bigendian = yes; then
  AC_DEFINE(WORDS_BIGENDIAN)
fi
])dnl
dnl
define(AC_ARG_ARRAY,
[AC_CHECKING(whether the address of an argument can be used as an array)
AC_CACHE_VAL(ac_cv_c_arg_array,
[AC_TEST_RUN([main() {
/* Return 0 iff arg arrays are ok.  */
exit(!x(1, 2, 3, 4));
}
x(a, b, c, d) {
  return y(a, &b);
}
/* Return 1 iff arg arrays are ok.  */
y(a, b) int *b; {
  return a == 1 && b[0] == 2 && b[1] == 3 && b[2] == 4;
}], ac_cv_c_arg_array=no, ac_cv_c_arg_array=yes)
rm -f core])dnl
if test $ac_cv_c_arg_array = no; then
  AC_DEFINE(NO_ARG_ARRAY)
fi
])dnl
dnl
define(AC_INLINE,
[AC_REQUIRE([AC_PROG_CC])dnl
AC_CHECKING([for inline])
AC_CACHE_VAL(ac_cv_c_inline,
[if test "$GCC" = yes; then
AC_TEST_LINK( , [} inline foo() {], ac_cv_c_inline=yes, ac_cv_c_inline=no)
else
  ac_cv_c_inline=no
fi])dnl
if test $ac_cv_c_inline = no; then
  AC_DEFINE(inline, __inline)
fi
])dnl
define(AC_CONST,
[dnl Do not "break" this again.
AC_CHECKING([for lack of working const])
AC_CACHE_VAL(ac_cv_c_const,
[changequote(,)dnl
dnl Do not put single quotes in the C program text!
ac_prog='/* Ultrix mips cc rejects this.  */
typedef int charset[2]; const charset x;
/* SunOS 4.1.1 cc rejects this.  */
char const *const *ccp;
char **p;
/* AIX XL C 1.02.0.0 rejects this.
   It does not let you subtract one const X* pointer from another in an arm
   of an if-expression whose if-part is not a constant expression */
const char *g = "string";
ccp = &g + (g ? g-g : 0);
/* HPUX 7.0 cc rejects these. */
++ccp;
p = (char**) ccp;
ccp = (char const *const *) p;
{ /* SCO 3.2v4 cc rejects this.  */
  char *t;
  char const *s = 0 ? (char *) 0 : (char const *) 0;

  *t++ = 0;
}
{ /* Someone thinks the Sun supposedly-ANSI compiler will reject this.  */
  int x[] = {25,17};
  const int *foo = &x[0];
  ++foo;
}
{ /* Sun SC1.0 ANSI compiler rejects this -- but not the above. */
  typedef const int *iptr;
  iptr p = 0;
  ++p;
}
{ /* AIX XL C 1.02.0.0 rejects this saying
     "k.c", line 2.27: 1506-025 (S) Operand must be a modifiable lvalue. */
  struct s { int j; const int *ap[3]; };
  struct s *b; b->j = 5;
}
{ /* ULTRIX-32 V3.1 (Rev 9) vcc rejects this */
  const int foo = 10;
}'
changequote([,])dnl
AC_TEST_LINK( , [$ac_prog], ac_cv_c_const=yes, ac_cv_c_const=no)])dnl
if test $ac_cv_c_const = no; then
  AC_DEFINE(const,)
fi
])dnl
dnl
dnl
dnl ### Checks for operating system services
dnl
dnl
define(AC_HAVE_POUNDBANG,
[AC_CHECKING(whether [#]! works in shell scripts)
AC_CACHE_VAL(ac_cv_sys_interpreter,
[echo '#!/bin/cat
exit 69
' > conftest
chmod u+x conftest
(SHELL=/bin/sh; export SHELL; ./conftest > /dev/null)
if test $? -ne 69; then
   ac_cv_sys_interpreter=yes
else
   ac_cv_sys_interpreter=no
fi
rm -f conftest])dnl
if test $ac_cv_sys_interpreter = yes; then
  ifelse([$1], , :, [$1])
ifelse([$2], , , [else
  $2
])dnl
fi
])dnl
define(AC_REMOTE_TAPE,
[AC_CHECKING(for remote tape and socket header files)
AC_HEADER_CHECK(sys/mtio.h, AC_DEFINE(HAVE_SYS_MTIO_H))

if test "$ac_cv_header_mtio_h" = yes; then
AC_CACHE_VAL(ac_cv_header_rmt,
[AC_TEST_CPP([#include <sgtty.h>
#include <sys/socket.h>], ac_cv_header_rmt=yes, ac_cv_header_rmt=no)])dnl
 if test $ac_cv_header_rmt = yes; then
    PROGS="$PROGS rmt"
  fi
fi
AC_SUBST(PROGS)dnl
])dnl
dnl
define(AC_LONG_FILE_NAMES,
[AC_CHECKING(for long file names)
AC_CACHE_VAL(ac_cv_sys_long_file_names,
[ac_cv_sys_long_file_names=yes
# Test for long file names in all the places we know might matter:
#      .		the current directory, where building will happen
#      /tmp		where it might want to write temporary files
#      /var/tmp		likewise
#      /usr/tmp		likewise
#      $prefix/lib	where we will be installing things
#      $exec_prefix/lib	likewise
# eval it to expand exec_prefix.
for ac_dir in `eval echo . /tmp /var/tmp /usr/tmp $prefix/lib $exec_prefix/lib` ; do
  test -d $ac_dir || continue
  test -w $ac_dir || continue # It is less confusing to not echo anything here.
  (echo 1 > $ac_dir/conftest9012345) 2>/dev/null
  (echo 2 > $ac_dir/conftest9012346) 2>/dev/null
  val=`cat $ac_dir/conftest9012345 2>/dev/null`
  if test ! -f $ac_dir/conftest9012345 || test "$val" != 1; then
    ac_cv_sys_long_file_names=no
    rm -f $ac_dir/conftest9012345 $ac_dir/conftest9012346 2> /dev/null
    break
  fi
  rm -f $ac_dir/conftest9012345 $ac_dir/conftest9012346 2> /dev/null
done])dnl
if test $ac_cv_sys_long_file_names = yes; then
  AC_DEFINE(HAVE_LONG_FILE_NAMES)
fi
])dnl
dnl
define(AC_RESTARTABLE_SYSCALLS,
[AC_CHECKING(for restartable system calls)
AC_CACHE_VAL(ac_cv_sys_restartable_syscalls,
[AC_TEST_RUN(
[/* Exit 0 (true) if wait returns something other than -1,
   i.e. the pid of the child, which means that wait was restarted
   after getting the signal.  */
#include <sys/types.h>
#include <signal.h>
ucatch (isig) { }
main () {
  int i = fork (), status;
  if (i == 0) { sleep (3); kill (getppid (), SIGINT); sleep (3); exit (0); }
  signal (SIGINT, ucatch);
  status = wait(&i);
  if (status == -1) wait(&i);
  exit (status == -1);
}
], ac_cv_sys_restartable_syscalls=yes, ac_cv_sys_restartable_syscalls=no)])dnl
if test $ac_cv_sys_restartable_syscalls = yes; then
  AC_DEFINE(HAVE_RESTARTABLE_SYSCALLS)
fi
])dnl
dnl
define(AC_FIND_X,
[AC_REQUIRE_CPP()dnl Set CPP; we run AC_FIND_X_DIRECT conditionally.
AC_PROVIDE([$0])dnl
# If we find X, set shell vars x_includes and x_libraries to the paths.
no_x=yes
if test "x$with_x" != xno; then

# Command line options override cache.
# FIXME We need to allow --x=includes= to work, I think.
test -n "$x_includes" && ac_cv_x_includes="$x_includes"
test -n "$x_libraries" && ac_cv_x_includes="$x_libraries"
if test "${ac_cv_x_includes+set}" = set &&
  test "${ac_cv_x_libraries+set}" = set; then
  AC_VERBOSE(using cached values for ac_cv_x_includes and ac_cv_x_libraries)
else
AC_FIND_X_XMKMF
fi
if test "${ac_cv_x_includes+set}" != set ||
  test "${ac_cv_x_libraries+set}" != set; then
AC_FIND_X_DIRECT
fi
test -z "$ac_cv_x_includes" && ac_cv_x_includes=NONE
test -z "$ac_cv_x_libraries" && ac_cv_x_libraries=NONE

# FIXME can we reliably distinguish cache values that are set to empty
# from those that aren't set?
if test -z "$x_includes" && test "$ac_cv_x_includes" != NONE; then
  x_includes="$ac_cv_x_includes"
fi
if test -z "$x_libraries" && test "$ac_cv_x_libraries" != NONE; then
  x_libraries="$ac_cv_x_libraries"
fi

test -n "$x_includes" && AC_VERBOSE(X11 headers are in $x_includes)
test -n "$x_libraries" && AC_VERBOSE(X11 libraries are in $x_libraries)
fi # No --with-x=no.
])dnl
dnl
dnl Internal subroutine of AC_FIND_X.
define(AC_FIND_X_XMKMF,
[AC_CHECKING(for X include and library files with xmkmf)
rm -fr conftestdir
if mkdir conftestdir; then
  cd conftestdir
  # Make sure to not put "make" in the Imakefile rules, since we grep it out.
  cat > Imakefile <<'EOF'
acfindx:
	@echo 'ac_im_incroot="${INCROOT}"; ac_im_usrlibdir="${USRLIBDIR}"; ac_im_libdir="${LIBDIR}"'
EOF
  if (xmkmf) >/dev/null 2>/dev/null && test -f Makefile; then
    no_x=
    # GNU make sometimes prints "make[1]: Entering...", which would confuse us.
    eval `make acfindx 2>/dev/null | grep -v make`
    # Open Windows xmkmf reportedly sets LIBDIR instead of USRLIBDIR.
    if test ! -f $ac_im_usrlibdir/libX11.a && test -f $ac_im_libdir/libX11.a
    then
      ac_im_usrlibdir=$ac_im_libdir
    fi
    case "$ac_im_incroot" in
	/usr/include) ;;
	*) test -z "$ac_cv_x_includes" && ac_cv_x_includes="$ac_im_incroot" ;;
    esac
    case "$ac_im_usrlibdir" in
	/usr/lib | /lib) ;;
	*) test -z "$ac_cv_x_libraries" && ac_cv_x_libraries="$ac_im_usrlibdir" ;;
    esac
  fi
  cd ..
  rm -fr conftestdir
fi
])dnl
dnl
dnl Internal subroutine of AC_FIND_X.
define(AC_FIND_X_DIRECT,
[AC_CHECKING(for X include and library files directly)
test -z "$x_direct_test_library" && x_direct_test_library=Xt
test -z "$x_direct_test_include" && x_direct_test_include=X11/Intrinsic.h
AC_TEST_CPP([#include <$x_direct_test_include>], no_x=,
  for ac_dir in               \
    /usr/X11R6/include        \
    /usr/X11R5/include        \
    /usr/X11R4/include        \
                              \
    /usr/include/X11R6        \
    /usr/include/X11R5        \
    /usr/include/X11R4        \
                              \
    /usr/local/X11R6/include  \
    /usr/local/X11R5/include  \
    /usr/local/X11R4/include  \
                              \
    /usr/local/include/X11R6  \
    /usr/local/include/X11R5  \
    /usr/local/include/X11R4  \
                              \
    /usr/X11/include          \
    /usr/include/X11          \
    /usr/local/X11/include    \
    /usr/local/include/X11    \
                              \
    /usr/X386/include         \
    /usr/x386/include         \
    /usr/XFree86/include/X11  \
                              \
    /usr/include              \
    /usr/local/include        \
    /usr/unsupported/include  \
    /usr/athena/include       \
    /usr/local/x11r5/include  \
    /usr/lpp/Xamples/include  \
                              \
    /usr/openwin/include      \
    /usr/openwin/share/include \
    ; \
  do
    if test -r "$ac_dir/$x_direct_test_include"; then
      test -z "$ac_cv_x_includes" && ac_cv_x_includes=$ac_dir
      no_x=
      break
    fi
  done)

# Check for the libraries.  First see if replacing the include by
# lib works.
AC_HAVE_LIBRARY("$x_direct_test_library", no_x=,
for ac_dir in `echo "$ac_cv_x_includes" | sed s/include/lib/` \
    /usr/X11R6/lib        \
    /usr/X11R5/lib        \
    /usr/X11R4/lib        \
                          \
    /usr/lib/X11R6        \
    /usr/lib/X11R5        \
    /usr/lib/X11R4        \
                          \
    /usr/local/X11R6/lib  \
    /usr/local/X11R5/lib  \
    /usr/local/X11R4/lib  \
                          \
    /usr/local/lib/X11R6  \
    /usr/local/lib/X11R5  \
    /usr/local/lib/X11R4  \
                          \
    /usr/X11/lib          \
    /usr/lib/X11          \
    /usr/local/X11/lib    \
    /usr/local/lib/X11    \
                          \
    /usr/X386/lib         \
    /usr/x386/lib         \
    /usr/XFree86/lib/X11  \
                          \
    /usr/lib              \
    /usr/local/lib        \
    /usr/unsupported/lib  \
    /usr/athena/lib       \
    /usr/local/x11r5/lib  \
    /usr/lpp/Xamples/lib  \
                          \
    /usr/openwin/lib      \
    /usr/openwin/share/lib \
    ; \
do
  for ac_extension in a so sl; do
    if test -r $ac_dir/lib${x_direct_test_library}.$ac_extension; then
      test -z "$ac_cv_x_libraries" && ac_cv_x_libraries=$ac_dir
      no_x=
      break 2
    fi
  done
done)])dnl
dnl
dnl Find additional X libraries, magic flags, etc.
define(AC_FIND_XTRA,
[AC_REQUIRE([AC_ISC_POSIX])dnl
AC_REQUIRE([AC_FIND_X])dnl
AC_CHECKING(for additional X libraries and flags)
if test -n "$x_includes"; then
  X_CFLAGS="$X_CFLAGS -I$x_includes"
elif test "$no_x" = yes; then 
  # Not all programs may use this symbol, but it does not hurt to define it.
  X_CFLAGS="$X_CFLAGS -DX_DISPLAY_MISSING"
fi

# It would be nice to have a more robust check for the -R ld option than
# just checking for Solaris.
# It would also be nice to do this for all -L options, not just this one.
if test -n "$x_libraries"; then
  X_LIBS="$X_LIBS -L$x_libraries"
  if test "`(uname) 2>/dev/null`" = SunOS &&
    uname -r | grep '^5' >/dev/null; then
    X_LIBS="$X_LIBS -R$x_libraries"
  fi
fi

# Check for additional X libraries.

if test "$ISC" = yes; then
  X_EXTRA_LIBS="$X_EXTRA_LIBS -lnsl_s -linet"
else
  # Martyn.Johnson@cl.cam.ac.uk says this is needed for Ultrix, if the X
  # libraries were built with DECnet support.  And karl@cs.umb.edu says
  # the Alpha needs dnet_stub (dnet does not exist).
  AC_HAVE_LIBRARY(dnet,
    [X_EXTRA_LIBS="$X_EXTRA_LIBS -ldnet" ac_have_dnet=yes], ac_have_dnet=no)
  if test "$ac_have_dnet" = no; then
    AC_HAVE_LIBRARY(dnet_stub, [X_EXTRA_LIBS="$X_EXTRA_LIBS -ldnet_stub"])
  fi
  # lieder@skyler.mavd.honeywell.com says without -lsocket,
  # socket/setsockopt and other routines are undefined under SCO ODT 2.0.
  # But -lsocket is broken on IRIX, according to simon@lia.di.epfl.ch.
  if test "`(uname) 2>/dev/null`" != IRIX; then
    AC_HAVE_LIBRARY(socket, [X_EXTRA_LIBS="$X_EXTRA_LIBS -lsocket"])
  fi
fi
#
AC_VERBOSE(X compiler flags: $X_CFLAGS)
AC_VERBOSE(X library flags: $X_LIBS)
AC_VERBOSE(extra X libraries: $X_EXTRA_LIBS)
AC_SUBST(X_CFLAGS)dnl
AC_SUBST(X_LIBS)dnl
AC_SUBST(X_EXTRA_LIBS)dnl
])dnl
dnl
dnl
dnl ### Checks for UNIX variants
dnl These are kludges; we need a more systematic approach.
dnl
dnl
define(AC_AIX,
[AC_CHECKING(for AIX)
AC_BEFORE([$0], [AC_TEST_LINK])dnl
AC_BEFORE([$0], [AC_TEST_RUN])dnl
AC_BEFORE([$0], [AC_TEST_CPP])dnl
AC_PROGRAM_EGREP(yes,
[#ifdef _AIX
  yes
#endif
], AC_DEFINE(_ALL_SOURCE))
])dnl
dnl
define(AC_MINIX,
[AC_BEFORE([$0], [AC_TEST_LINK])dnl
AC_BEFORE([$0], [AC_TEST_RUN])dnl
AC_BEFORE([$0], [AC_TEST_CPP])dnl
AC_HEADER_CHECK(minix/config.h, MINIX=yes, MINIX=)
# The Minix shell ca not assign to the same variable on the same line!
if test "$MINIX" = yes; then
  AC_DEFINE(_POSIX_SOURCE)
  AC_DEFINE(_POSIX_1_SOURCE, 2)
  AC_DEFINE(_MINIX)
fi
])dnl
dnl
define(AC_ISC_POSIX,
[AC_PROVIDE([$0])dnl
AC_BEFORE([$0], [AC_TEST_LINK])dnl
AC_BEFORE([$0], [AC_TEST_RUN])dnl
AC_BEFORE([$0], [AC_TEST_CPP])dnl
AC_CHECKING(for POSIXized ISC)
if test -d /etc/conf/kconfig.d &&
  grep _POSIX_VERSION [/usr/include/sys/unistd.h] >/dev/null 2>&1
then
  ISC=yes # If later tests want to check for ISC.
  AC_DEFINE(_POSIX_SOURCE)
  if test "$GCC" = yes; then
    CC="$CC -posix"
  else
    CC="$CC -Xp"
  fi
else
  ISC=
fi
])dnl
dnl
define(AC_XENIX_DIR,
[AC_REQUIRE([AC_DIR_HEADER])dnl
AC_CHECKING(for Xenix)
AC_PROGRAM_EGREP(yes,
[#if defined(M_XENIX) && !defined(M_UNIX)
  yes
#endif
], XENIX=yes, XENIX=)
if test "$XENIX" = yes; then
  LIBS="$LIBS -lx"
  case "$DEFS" in
  *SYSNDIR*) ;;
  *) LIBS="-ldir $LIBS" ;; # Make sure -ldir precedes any -lx.
  esac
fi
])dnl
dnl
define(AC_SCO_INTL,
[AC_HAVE_LIBRARY(intl, LIBS="$LIBS -lintl")
])dnl
dnl
define(AC_IRIX_SUN,
[AC_HAVE_LIBRARY(sun, LIBS="$LIBS -lsun")
])dnl
dnl
define(AC_DYNIX_SEQ,
[AC_HAVE_LIBRARY(seq, LIBS="$LIBS -lseq")
])dnl
