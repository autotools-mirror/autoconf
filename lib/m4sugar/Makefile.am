## Process this file with automake to create Makefile.in

m4sugarlibdir = $(pkgdatadir)/m4sugar
dist_m4sugarlib_DATA = m4sugar.m4 m4sh.m4
nodist_m4sugarlib_DATA = version.m4
DISTCLEANFILES         = $(nodist_m4sugarlib_DATA)

## ------------ ##
## version.m4.  ##
## ------------ ##

version.m4: $(top_srcdir)/configure.ac
	{					\
	  echo '# This file is part of -*- Autoconf -*-.'; \
	  echo '# Version of Autoconf.'; \
	  echo '# Copyright 1999, 2000, 2001 Free Software Foundation, Inc.'; \
	  echo ;\
	  echo 'm4_define([m4_PACKAGE_NAME],      [@PACKAGE_NAME@])'; \
	  echo 'm4_define([m4_PACKAGE_TARNAME],   [@PACKAGE_TARNAME@])'; \
	  echo 'm4_define([m4_PACKAGE_VERSION],   [@PACKAGE_VERSION@])'; \
	  echo 'm4_define([m4_PACKAGE_STRING],    [@PACKAGE_STRING@])'; \
	  echo 'm4_define([m4_PACKAGE_BUGREPORT], [@PACKAGE_BUGREPORT@])'; \
	} >version.m4


## --------------- ##
## Building TAGS.  ##
## --------------- ##

TAGS_FILES = $(dist_m4sugarlib_DATA)

ETAGS_ARGS = --lang=none \
  --regex='/\(A[CU]_DEFUN\|m4_\(defun\|define\)\|define\)(\[\([^]]*\)\]/\3/'


## -------- ##
## Checks.  ##
## -------- ##

check-local:
	if (cd $(srcdir) && \
	    egrep '^_?EOF' $(dist_m4sugarlib_DATA)) >eof.log; then \
	  echo "ERROR: user EOF tags were used:" >&2; \
	  sed "s,^,$*.m4: ," <eof.log >&2; \
	  echo >&2; \
	  exit 1; \
	else \
	  rm -f eof.log; \
	fi
