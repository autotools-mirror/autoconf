## Process this file with automake to create Makefile.in

SUBDIRS = Autom4te m4sugar autoconf autotest autoscan
nodist_pkgdata_DATA = autom4te.cfg
EXTRA_DIST = autom4te.in

edit = sed \
	-e 's,@SHELL\@,$(SHELL),g' \
	-e 's,@PERL\@,$(PERL),g' \
	-e 's,@bindir\@,$(bindir),g' \
	-e 's,@datadir\@,$(pkgdatadir),g' \
	-e 's,@prefix\@,$(prefix),g' \
	-e 's,@autoconf-name\@,'`echo autoconf | sed '$(transform)'`',g' \
	-e 's,@autoheader-name\@,'`echo autoheader | sed '$(transform)'`',g' \
	-e 's,@autom4te-name\@,'`echo autom4te | sed '$(transform)'`',g' \
	-e 's,@M4\@,$(M4),g' \
	-e 's,@AWK\@,$(AWK),g' \
	-e 's,@VERSION\@,$(VERSION),g' \
	-e 's,@PACKAGE_NAME\@,$(PACKAGE_NAME),g'

# All the files below depend on configure.ac so that they are rebuilt
# when the Autoconf version changes. Unfortunately, suffix rules
# cannot have additional dependencies, so we have to use explicit rules.
CLEANFILES = autom4te.cfg
autom4te.cfg: $(top_srcdir)/configure.ac $(srcdir)/autom4te.in
	rm -f autom4te.cfg autom4te.tmp
	$(edit) $(srcdir)/autom4te.in >autom4te.tmp
	mv autom4te.tmp autom4te.cfg
