## Process this file with automake to create Makefile.in

autotestlibdir = $(pkgdatadir)/autotest

autotestlib_DATA = general.m4

EXTRA_DIST = $(autotestlib_DATA)


## --------------- ##
## Building TAGS.  ##
## --------------- ##

TAGS_FILES = $(autotestlib_DATA)

ETAGS_ARGS = --lang=none \
  --regex='/\(A[CU]_DEFUN\|m4_\(defun\|define\)\|define\)(\[\([^]]*\)\]/\3/'


## -------- ##
## Checks.  ##
## -------- ##

check-local:
	if (cd $(srcdir) && \
	    egrep '^_?EOF' $(autotestlib_DATA)) >eof.log; then \
	  echo "ERROR: user EOF tags were used:" >&2; \
	  sed "s,^,$*.m4: ," <eof.log >&2; \
	  echo >&2; \
	  exit 1; \
	else \
	  rm -f eof.log; \
	fi
