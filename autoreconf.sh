#! @SHELL@
# autoreconf - remake all Autoconf configure scripts in a directory tree
# Copyright (C) 1994, 1999 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

usage="\
Usage: autoreconf [OPTION] ... [TEMPLATE-FILE]

Run \`autoconf' (and \`autoheader' and \`automake', where appropriate)
repeatedly to remake the Autoconf \`configure' scripts and
configuration header templates in the directory tree rooted at the
current directory.  By default, it only remakes those files that are
older than their predecessors.  If you install a new version of
Autoconf, running \`autoreconf' remakes all of the files by giving it
the \`--force' option.

  -m, --macrodir=DIR    directory storing macro files
  -l, --localdir=DIR    directory storing \`aclocal.m4' and \`acconfig.h'
  -f, --force           consider every files are obsolete
  -v, --verbose         verbosely report processing
  -h, --help            print this help, then exit
  --version             print version number, then exit

The following options are passed to \`automake':
  --cygnus              assume program is part of Cygnus-style tree
  --foreign             set strictness to foreign
  --gnits               set strictness to gnits
  --gnu                 set strictness to gnu
  -i, --include-deps    include generated dependencies in Makefile.in

Report bugs to <bug-autoconf@gnu.org>."

version="\
autoreconf (GNU @PACKAGE@) @VERSION@
Written by David J. MacKenzie.

Copyright (C) 1994, 1999 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."

localdir=
verbose=:
force=no
automake_mode=--gnu
automake_deps=

test -z "$AC_MACRODIR" && AC_MACRODIR=@datadir@

while test $# -gt 0; do
  case "$1" in
  -h | --help | --h*)
    echo "$usage"; exit 0 ;;
  --localdir=* | --l*=* )
    localdir="`echo \"${1}\" | sed -e 's/^[^=]*=//'`"
    shift ;;
  -l | --localdir | --l*)
    shift
    test $# -eq 0 && { echo "${usage}" 1>&2; exit 1; }
    localdir="${1}"
    shift ;;
  --macrodir=* | --m*=* )
    AC_MACRODIR="`echo \"$1\" | sed -e 's/^[^=]*=//'`"
    shift ;;
  -m | --macrodir | --m*)
    shift
    test $# -eq 0 && { echo "$usage" 1>&2; exit 1; }
    AC_MACRODIR="$1"
    shift ;;
  -v | --verbose | --verb*)
    verbose=echo; shift ;;
  -f | --force)
    force=yes; shift ;;
  --version | --vers*)
    echo "$version"; exit 0 ;;
  --cygnus | --foreign | --gnits | --gnu)
    automake_mode=$1; shift ;;
  --include-deps | -i)
    automake_deps=$1; shift ;;
  --)     # Stop option processing.
    shift; break ;;
  -*) echo "$usage" 1>&2; exit 1 ;;
  *) break ;;
  esac
done

if test $# -ne 0; then
  echo "$usage" 1>&2; exit 1
fi

# The paths to the autoconf and autoheader scripts, at the top of the tree.
top_autoconf=`echo $0|sed s%autoreconf%autoconf%`
top_autoheader=`echo $0|sed s%autoreconf%autoheader%`

# Make a list of directories to process.
# The xargs grep filters out Cygnus configure.in files.
find . -name configure.in -print |
xargs grep -l AC_OUTPUT |
sed 's%/configure\.in$%%; s%^./%%' |
while read dir; do
  (
  cd $dir || continue

  case "$dir" in
  .) dots= ;;
  *) # A "../" for each directory in /$dir.
     dots=`echo /$dir|sed 's%/[^/]*%../%g'` ;;
  esac

  case "$0" in
  /*)  autoconf=$top_autoconf; autoheader=$top_autoheader ;;
  */*) autoconf=$dots$top_autoconf; autoheader=$dots$top_autoheader ;;
  *)   autoconf=$top_autoconf; autoheader=$top_autoheader ;;
  esac

  case "$AC_MACRODIR" in
  /*)  macrodir_opt="--macrodir=$AC_MACRODIR" ;;
  *)   macrodir_opt="--macrodir=$dots$AC_MACRODIR" ;;
  esac

  case "$localdir" in
  "")  localdir_opt=
       aclocal_m4=aclocal.m4 ;;
  /*)  localdir_opt="--localdir=$localdir"
       aclocal_m4=$localdir/aclocal.m4 ;;
  *)   localdir_opt="--localdir=$dots$localdir"
       aclocal_m4=$dots$localdir/aclocal.m4 ;;
  esac

  # Regenerate aclocal.m4 if necessary.
  run_aclocal=no
  aclocal_dir=`echo $aclocal_m4 | sed 's,/*[^/]*$,,;s,^$,.,'`
  if test -f "$aclocal_m4" &&
     grep 'generated automatically by aclocal' $aclocal_m4 > /dev/null
  then
     run_aclocal=yes
  else
     if test -f "$aclocal_dir/acinclude.m4"
     then
	run_aclocal=yes
     fi
  fi
  if test $run_aclocal = yes
  then
      # If there are flags for aclocal, use them.  Makefile.am and Makefile
      # may not exists.
      aclocal_flags=`sed -ne '\
/^ACLOCAL_[A-Z_]*FLAGS/{
  s/.*=//
  p
  q
}' Makefile.in 2>/dev/null`
     if test $force = no &&
        ls -lt configure.in $aclocal_m4 $aclocal_dir/acinclude.m4 2>/dev/null|
	sed 1q |
        grep 'aclocal\.m4$' > /dev/null
     then
	:
     else
	if test x"$aclocal_dir" != x.
	then
	   aclocal_flags="$aclocal_flags -I $aclocal_dir"
	fi
	$verbose "running aclocal $aclocal_flags in $dir, creating $aclocal_m4"
	aclocal $aclocal_flags --output=$aclocal_m4
     fi
  fi

  # Re-run automake if required.  Assumes that there is a Makefile.am
  # in the topmost directory.
  if test -f Makefile.am
  then
     amforce=
     test $force = no && amforce=--no-force
     $verbose running automake $amforce in $dir
     automake $amforce $automake_mode $automake_deps
  fi

  test ! -f $aclocal_m4 && aclocal_m4=

  if test $force = no && test -f configure &&
    ls -lt configure configure.in $aclocal_m4 | sed 1q |
      grep 'configure$' > /dev/null
  then
    :
  else
    $verbose "running autoconf in $dir"
    $autoconf $macrodir_opt $localdir_opt
  fi

  if grep '^[ 	]*A[CM]_CONFIG_HEADER' configure.in >/dev/null; then
    templates=`sed -n '/A[CM]_CONFIG_HEADER/ {
	s%[^#]*A[CM]_CONFIG_HEADER[ 	]*(\([^)]*\).*%\1%
	p
	q
      }' configure.in`
    tcount=`set -- $templates; echo $#`
    template=`set -- $templates; echo $1 | sed '
	s/.*://
	t colon
	s/$/.in/
	: colon
	s/:.*//
      '`
    stamp=`echo $template | sed 's,/*[^/]*$,,;s,^$,.,'`/stamp-h`test "$tcount" -gt 1 && echo "$tcount"`.in
    if test ! -f "$template" || grep autoheader "$template" >/dev/null; then
      if test $force = no && test -f $template &&
	 ls -lt $template configure.in $aclocal_m4 $stamp 2>/dev/null \
	        `echo $localdir_opt | sed -e 's/--localdir=//' \
		                          -e '/./ s%$%/%'`acconfig.h |
	   sed 1q | egrep "$template$|$stamp$" > /dev/null
      then
        :
      else
        $verbose "running autoheader in $dir"
        $autoheader $macrodir_opt $localdir_opt &&
        $verbose "touching $stamp" &&
        touch $stamp
      fi
    fi
  fi
  )
done

# Local Variables:
# mode:shell-script
# sh-indentation:3
# End:
