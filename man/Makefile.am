## Process this file with automake to produce Makefile.in -*-Makefile-*-
man_MANS = autoconf.1 autoreconf.1 autoheader.1 autoupdate.1 ifnames.1 \
autoscan.1 config.guess.1 config.sub.1

man_aux = autoconf.x autoreconf.x autoheader.x autoupdate.x ifnames.x \
autoscan.x config.guess.x config.sub.x

EXTRA_DIST = $(man_MANS) $(man_aux) common.x
MAINTAINERCLEANFILES = $(man_MANS)

# Depend on configure.in to get version number changes.
common_dep = $(top_srcdir)/configure.in $(srcdir)/common.x
autoconf.1:   $(common_dep) $(srcdir)/autoconf.x   $(top_srcdir)/autoconf.sh
autoreconf.1: $(common_dep) $(srcdir)/autoreconf.x $(top_srcdir)/autoreconf.sh
autoheader.1: $(common_dep) $(srcdir)/autoheader.x $(top_srcdir)/autoheader.sh
autoupdate.1: $(common_dep) $(srcdir)/autoupdate.x $(top_srcdir)/autoupdate.sh
ifnames.1:    $(common_dep) $(srcdir)/ifnames.x    $(top_srcdir)/ifnames.sh
autoscan.1:   $(common_dep) $(srcdir)/autoscan.x   $(top_srcdir)/autoscan.pl

# Independent from this package.
config.guess.1: $(srcdir)/config.guess.x  $(top_srcdir)/config.guess
config.sub.1:   $(srcdir)/config.sub.x    $(top_srcdir)/config.sub

SUFFIXES = .x .1

.x.1:
	@if test -f $(top_builddir)/$*; then \
	  echo "Updating man page $@"; \
	  $(HELP2MAN) \
	    --include=$(srcdir)/$*.x \
	    --include=$(srcdir)/common.x \
	    --output=$@ \
	    $(top_builddir)/$*; \
	else \
	  echo "WARNING: The man page $@ cannot be updated yet."; \
	  echo "         Retry once the corresponding executable is built."; \
	fi
