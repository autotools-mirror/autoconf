## Process this file with automake to create Makefile.in

autotestlibdir = $(pkgdatadir)/autotest

dist_autotestlib_DATA = autotest.m4 general.m4



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
