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
