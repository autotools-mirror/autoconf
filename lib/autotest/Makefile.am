## Process this file with automake to create Makefile.in

## Copyright 2001, 2002 Free Software Foundation, Inc.
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

autotestlibdir = $(pkgdatadir)/autotest
dist_autotestlib_DATA = autotest.m4 general.m4
nodist_autotestlib_DATA = autotest.m4f
CLEANFILES = $(nodist_autotestlib_DATA)

## --------------- ##
## Building TAGS.  ##
## --------------- ##

TAGS_FILES = $(dist_autotestlib_DATA)

ETAGS_ARGS = --lang=none \
  --regex='/\(A[CU]_DEFUN\|m4_\(defun\|define\)\|define\)(\[\([^]]*\)\]/\3/'


## -------- ##
## Checks.  ##
## -------- ##

check-local:
	if (cd $(srcdir) && \
	    egrep '^_?EOF' $(dist_autotestlib_DATA)) >eof.log; then \
	  echo "ERROR: user EOF tags were used:" >&2; \
	  sed "s,^,$*.m4: ," <eof.log >&2; \
	  echo >&2; \
	  exit 1; \
	else \
	  rm -f eof.log; \
	fi


## ------------------ ##
## The frozen files.  ##
## ------------------ ##

autotest.m4f: $(autotest_m4f_dependencies)
include ../freeze.mk
