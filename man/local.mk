# Make Autoconf man pages.

# Copyright (C) 2001, 2004-2017, 2020 Free Software Foundation, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

binsrcdir = $(srcdir)/bin

dist_man_MANS = \
  man/autoconf.1 \
  man/autoheader.1 \
  man/autom4te.1 \
  man/autoreconf.1 \
  man/autoscan.1 \
  man/autoupdate.1 \
  man/ifnames.1

EXTRA_DIST += $(dist_man_MANS:.1=.x) man/common.x
MAINTAINERCLEANFILES += $(dist_man_MANS)

# Depend on .version to get version number changes.
# Don't depend on the generated scripts, because then we would try to
# regenerate the manpages after building the scripts, which would
# defeat the purpose of shipping the manpages in the tarball.
# (Instead we have recursive makes in the .x.1 rule below, which is
# not ideal, but at least it prevents us from generating a manpage
# from the *installed* utility.)
common_dep = $(srcdir)/.version $(srcdir)/man/common.x
man/autoconf.1:   $(common_dep) $(binsrcdir)/autoconf.as
man/autoheader.1: $(common_dep) $(binsrcdir)/autoheader.in
man/autom4te.1:   $(common_dep) $(binsrcdir)/autom4te.in
man/autoreconf.1: $(common_dep) $(binsrcdir)/autoreconf.in
man/autoscan.1:   $(common_dep) $(binsrcdir)/autoscan.in
man/autoupdate.1: $(common_dep) $(binsrcdir)/autoupdate.in
man/ifnames.1:    $(common_dep) $(binsrcdir)/ifnames.in

remove_time_stamp = 's/^\(\.TH[^"]*"[^"]*"[^"]*\)"[^"]*"/\1/'

MOSTLYCLEANFILES += $(srcdir)/man/*.t

SUFFIXES += .x .1

.x.1:
	@set -e; cmd=`basename $*`; \
	test -x bin/$$cmd || $(MAKE) bin/$$cmd; \
	test -x tests/$$cmd || $(MAKE) tests/$$cmd;
	@echo "Updating man page $@"
	@test -d $(@D) || mkdir $(@D)
	PATH="./tests$(PATH_SEPARATOR)$(top_srcdir)/build-aux$(PATH_SEPARATOR)$$PATH"; \
	export PATH; \
	$(HELP2MAN) \
	    --include=$(srcdir)/$*.x \
	    --include=$(srcdir)/man/common.x \
	    --source='$(PACKAGE_STRING)' \
	    --output=$@.t `echo '$*' | sed 's,.*/,,'`
	if sed $(remove_time_stamp) $@ >$@a.t 2>/dev/null && \
	   sed $(remove_time_stamp) $@.t | cmp $@a.t - >/dev/null 2>&1; then \
		touch $@; \
	else \
		mv $@.t $@; \
	fi
	rm -f $@*.t
