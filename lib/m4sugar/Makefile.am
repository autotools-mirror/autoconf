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
