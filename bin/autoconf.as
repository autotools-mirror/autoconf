AS_INIT[]dnl                                            -*- shell-script -*-
m4_divert_push([HEADER-COPYRIGHT])dnl
# @configure_input@
# autoconf -- create 'configure' using m4 macros.

# Copyright (C) 1992-1994, 1996, 1999-2017, 2020-2021 Free Software
# Foundation, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

m4_divert_pop([HEADER-COPYRIGHT])dnl back to BODY
AS_ME_PREPARE[]dnl

help=["\
Usage: $0 [OPTION]... [TEMPLATE-FILE]

Generate a configuration script from a TEMPLATE-FILE if given, or
'configure.ac' if present, or else 'configure.in'.  Output is sent
to the standard output if TEMPLATE-FILE is given, else into
'configure'.

Operation modes:
  -h, --help                print this help, then exit
  -V, --version             print version number, then exit
  -v, --verbose             verbosely report processing
  -d, --debug               don't remove temporary files
  -f, --force               consider all files obsolete
  -o, --output=FILE         save output in FILE (stdout is the default)
  -W, --warnings=CATEGORY   report the warnings falling in CATEGORY

Warning categories include:
  cross                  cross compilation issues
  gnu                    GNU coding standards (default in gnu and gnits modes)
  obsolete               obsolete features or constructions (default)
  override               user redefinitions of Automake rules or variables
  portability            portability issues (default in gnu and gnits modes)
  portability-recursive  nested Make variables (default with -Wportability)
  extra-portability      extra portability issues related to obscure tools
  syntax                 dubious syntactic constructs (default)
  unsupported            unsupported or incomplete features (default)
  all                    all the warnings
  no-CATEGORY            turn off warnings in CATEGORY
  none                   turn off all the warnings

The environment variables 'M4' and 'WARNINGS' are honored.

Library directories:
  -B, --prepend-include=DIR  prepend directory DIR to search path
  -I, --include=DIR          append directory DIR to search path

Tracing:
  -t, --trace=MACRO[:FORMAT]  report the list of calls to MACRO
  -i, --initialization        also trace Autoconf's initialization process

In tracing mode, no configuration script is created.  FORMAT defaults
to '\$f:\$l:\$n:\$%'; see 'autom4te --help' for information about FORMAT.

Report bugs to <bug-autoconf@gnu.org>.
GNU Autoconf home page: <https://www.gnu.org/software/autoconf/>.
General help using GNU software: <https://www.gnu.org/gethelp/>."]

version=["\
autoconf (@PACKAGE_NAME@) @VERSION@
Copyright (C) @RELEASE_YEAR@ Free Software Foundation, Inc.
License GPLv3+/Autoconf: GNU GPL version 3 or later
<https://gnu.org/licenses/gpl.html>, <https://gnu.org/licenses/exceptions.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by David J. MacKenzie and Akim Demaille."]

usage_err="\
Try '$as_me --help' for more information."

exit_missing_arg='
  m4_bpatsubst([AS_ERROR([option '$[1]' requires an argument$as_nl$usage_err])],
    ['], ['\\''])'
# restore font-lock: '

# Variables.
: ${AUTOM4TE='@bindir@/@autom4te-name@'}
: ${trailer_m4='@pkgdatadir@/autoconf/trailer.m4'}
autom4te_options=
outfile=
verbose=false

# Parse command line.
while test $# -gt 0 ; do
  option=[`expr "x$1" : 'x\(--[^=]*\)' \| \
	       "x$1" : 'x\(-.\)'`]
  optarg=[`expr "x$1" : 'x--[^=]*=\(.*\)' \| \
	       "x$1" : 'x-.\(.*\)'`]
  case $1 in
    --version | -V )
       AS_ECHO(["$version"]); exit ;;
    --help | -h )
       AS_ECHO(["$help"]); exit ;;

    --verbose | -v )
       verbose=:
       autom4te_options="$autom4te_options $1"; shift ;;

    # Arguments passed as is to autom4te.
    --debug      | -d   | \
    --force      | -f   | \
    --include=*  | -I?* | \
    --prepend-include=* | -B?* | \
    --warnings=* | -W?* )
       case $1 in
	 *\'*) arg=`AS_ECHO(["$1"]) | sed "s/'/'\\\\\\\\''/g"` ;; #'
	 *) arg=$1 ;;
       esac
       autom4te_options="$autom4te_options '$arg'"; shift ;;
    # Options with separated arg passed as is to autom4te.
    --include  | -I | \
    --prepend-include  | -B | \
    --warnings | -W )
       test $# = 1 && eval "$exit_missing_arg"
       case $2 in
	 *\'*) arg=`AS_ECHO(["$2"]) | sed "s/'/'\\\\\\\\''/g"` ;; #'
	 *) arg=$2 ;;
       esac
       autom4te_options="$autom4te_options $option '$arg'"
       shift; shift ;;

    --trace=* | -t?* )
       traces="$traces --trace='"`AS_ECHO(["$optarg"]) | sed "s/'/'\\\\\\\\''/g"`"'"
       shift ;;
    --trace | -t )
       test $# = 1 && eval "$exit_missing_arg"
       traces="$traces --trace='"`AS_ECHO(["$[2]"]) | sed "s/'/'\\\\\\\\''/g"`"'"
       shift; shift ;;
    --initialization | -i )
       autom4te_options="$autom4te_options --melt"
       shift;;

    --output=* | -o?* )
       outfile=$optarg
       shift ;;
    --output | -o )
       test $# = 1 && eval "$exit_missing_arg"
       outfile=$2
       shift; shift ;;

    -- )     # Stop option processing
       shift; break ;;
    - )	# Use stdin as input.
       break ;;
    -* )
       exec >&2
       AS_ERROR([invalid option '$[1]'$as_nl$usage_err]) ;;
    * )
       break ;;
  esac
done

# Find the input file.
case $# in
  0)
    if test -f configure.ac; then
      if test -f configure.in; then
	AS_ECHO(["$as_me: warning: both 'configure.ac' and 'configure.in' are present."]) >&2
	AS_ECHO(["$as_me: warning: proceeding with 'configure.ac'."]) >&2
      fi
      infile=configure.ac
    elif test -f configure.in; then
      infile=configure.in
    else
      AS_ERROR([no input file])
    fi
    test -z "$traces" && test -z "$outfile" && outfile=configure;;
  1)
    infile=$1 ;;
  *) exec >&2
     AS_ERROR([invalid number of arguments$as_nl$usage_err]) ;;
esac

# Unless specified, the output is stdout.
test -z "$outfile" && outfile=-

# Don't read trailer.m4 if we are tracing.
if test -n "$traces"; then
    trailer_m4=""
else
    # The extra quotes will be stripped by eval.
    trailer_m4=\""$trailer_m4"\"
fi

# Run autom4te with expansion.
# trailer.m4 is read _before_ $infile, despite the name,
# because putting it afterward screws up autom4te's location tracing.
eval set x "$autom4te_options" \
  --language=autoconf --output=\"\$outfile\" "$traces" \
  $trailer_m4 \"\$infile\"
shift
$verbose && AS_ECHO(["$as_me: running $AUTOM4TE $*"]) >&2
exec "$AUTOM4TE" "$@"
