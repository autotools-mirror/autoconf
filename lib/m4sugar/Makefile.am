## Process this file with automake to create Makefile.in

distm4sugarlibdir = $(pkgdatadir)/m4sugar
# We ship version.m4 so that it's in src.  `autoconf' wants all the sources
# at the same place...
distm4sugarlib_DATA = version.m4 m4sugar.m4 m4sh.m4

EXTRA_DIST = $(distm4sugarlib_DATA) version.in


## ------------ ##
## version.m4.  ##
## ------------ ##

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

TAGS_FILES = $(m4sugarlib_DATA)

ETAGS_ARGS = --lang=none \
  --regex='/\(A[CU]_DEFUN\|m4_\(defun\|define\)\|define\)(\[\([^]]*\)\]/\3/'


## -------- ##
## Checks.  ##
## -------- ##

check-local:
	if (cd $(srcdir) && \
	    egrep '^_?EOF' $(distm4sugarlib_DATA)) >eof.log; then \
	  echo "ERROR: user EOF tags were used:" >&2; \
	  sed "s,^,$*.m4: ," <eof.log >&2; \
	  echo >&2; \
	  exit 1; \
	else \
	  rm -f eof.log; \
	fi
