## Process this file with automake to create Makefile.in

m4sugarlibdir = $(pkgdatadir)/m4sugar

m4sugarlib_DATA = m4sugar.m4 m4sh.m4

EXTRA_DIST = $(m4sugarlib_DATA)


## --------------- ##
## Building TAGS.  ##
## --------------- ##

TAGS_FILES = $(m4sugarlib_DATA)

ETAGS_ARGS = --lang=none \
  --regex='/\(A[CU]_DEFUN\|m4_\(defun\|define\)\|define\)(\[\([^]]*\)\]/\3/'


## -------- ##
## Checks.  ##
## -------- ##

check-local:
	if (cd $(srcdir) && \
	    egrep '^_?EOF' $(m4sugarlib_DATA)) >eof.log; then \
	  echo "ERROR: user EOF tags were used:" >&2; \
	  sed "s,^,$*.m4: ," <eof.log >&2; \
	  echo >&2; \
	  exit 1; \
	else \
	  rm -f eof.log; \
	fi
