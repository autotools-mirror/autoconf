## Process this file with automake to create Makefile.in

## Copyright 2001 Free Software Foundation, Inc.
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2, or (at your option)
## any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
## 02111-1307, USA.

distautoconflibdir = $(pkgdatadir)/autoconf
distautoconflib_DATA = autoconf.m4 \
                       general.m4 oldnames.m4 specific.m4 \
		       lang.m4 c.m4 fortran.m4 \
                       functions.m4 headers.m4 types.m4
nodistautoconflibdir = $(pkgdatadir)/autoconf
# The order matters: we need version.m4 to build autoconf.m4f.
nodistautoconflib_DATA = version.m4 autoconf.m4f

EXTRA_DIST = $(distautoconflib_DATA) version.in version.m4

## version.m4.  ##

# - version.m4 needs to be updated only once, since it depends on
#   configure.ac, not on the results of a 'configure' run.
# - It is guaranteed (with GNU Make) that when the version in configure.ac
#   is changed, version.m4 is built only after the new version number is
#   propagated to the Makefile.  (Libtool uses the same guarantee.)

$(srcdir)/version.m4: $(srcdir)/version.in $(top_srcdir)/configure.ac
	sed 's,@VERSION\@,$(VERSION),g' $(srcdir)/version.in >version.tm4
	mv version.tm4 $(srcdir)/version.m4


## --------------- ##
## Building TAGS.  ##
## --------------- ##

TAGS_FILES = $(distautoconflib_DATA)

ETAGS_ARGS = --lang=none \
  --regex='/\(A[CU]_DEFUN\|m4_\(defun\|define\)\|define\)(\[\([^]]*\)\]/\3/'





## ------------------ ##
## The frozen files.  ##
## ------------------ ##

SUFFIXES = .m4 .m4f
M4_INCLUDES =  --include $(srcdir) \
               --include $(top_builddir)/lib \
               --include $(top_srcdir)/lib

# When processing the file with diversion disabled, there must be no
# output but comments and empty lines.
# If freezing produces output, something went wrong: a bad `divert',
# or an improper paren etc.
# It may happen that the output does not end with a end of line, hence
# force an end of line when reporting errors.
.m4.m4f:
	$(M4) $(M4_INCLUDES) --fatal-warning --define divert \
	      $*.m4 2>error.log | \
	  sed 's/#.*//;/^$$/d' >process.log
	if grep . error.log >/dev/null 2>&1; then \
	  echo "ERROR: Processing $*.m4 produced errors:" >&2; \
	  sed "s,^,$*.m4: ," <error.log >&2; \
	  echo >&2; \
	  exit 1; \
	else \
	  rm -f error.log; \
	fi
	if grep . process.log >/dev/null 2>&1; then \
	  echo "ERROR: Processing $*.m4 produced output:" >&2; \
	  sed "s,^,$*.m4: ," <process.log >&2; \
	  echo >&2; \
	  exit 1; \
	else \
	  rm -f process.log; \
	fi
	$(M4) $(M4_INCLUDES) --fatal-warning --freeze-state=$*.m4f \
	      $*.m4 >freeze.log
	if grep . freeze.log >/dev/null 2>&1; then \
	  echo "ERROR: Freezing $(libdir)/$*.m4 produced output:" >&2; \
	  sed "s,^,$*.m4: ," <freeze.log >&2; \
	  echo >&2; \
	  exit 1; \
	else \
	  rm -f freeze.log; \
	fi

# Some day we should explain to Automake how to use autom4te to compute
# the dependencies...
srclibdir = $(top_srcdir)/lib
autoconf.m4f: $(srclibdir)/m4sugar/m4sugar.m4	\
              $(srclibdir)/m4sugar/m4sh.m4	\
              $(srclibdir)/autoconf/autoconf.m4	\
              $(srclibdir)/autoconf/general.m4	\
              $(srclibdir)/autoconf/oldnames.m4	\
              $(srclibdir)/autoconf/specific.m4	\
              $(srclibdir)/autoconf/lang.m4 \
              $(srclibdir)/autoconf/c.m4 \
              $(srclibdir)/autoconf/fortran.m4	\
              $(srclibdir)/autoconf/functions.m4 \
              $(srclibdir)/autoconf/headers.m4	\
              $(srclibdir)/autoconf/types.m4

# Files that should be removed, but which Automake does not know.
CLEANFILES = autoconf.m4f
