# Make Autoconf man pages.

# Copyright (C) 2001, 2004-2017 Free Software Foundation, Inc.

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
mansrcdir = $(srcdir)/man

dist_man_MANS = \
  $(mansrcdir)/autoconf.1 \
  $(mansrcdir)/autoheader.1 \
  $(mansrcdir)/autom4te.1 \
  $(mansrcdir)/autoreconf.1 \
  $(mansrcdir)/autoscan.1 \
  $(mansrcdir)/autoupdate.1 \
  $(mansrcdir)/ifnames.1

EXTRA_DIST += $(dist_man_MANS:.1=.x) man/common.x
MAINTAINERCLEANFILES += $(dist_man_MANS)

# Depend on .version to get version number changes.
common_dep = $(srcdir)/.version $(srcdir)/man/common.x
$(mansrcdir)/autoconf.1:   $(common_dep) $(binsrcdir)/autoconf.as
$(mansrcdir)/autoheader.1: $(common_dep) $(binsrcdir)/autoheader.in
$(mansrcdir)/autom4te.1:   $(common_dep) $(binsrcdir)/autom4te.in
$(mansrcdir)/autoreconf.1: $(common_dep) $(binsrcdir)/autoreconf.in
$(mansrcdir)/autoscan.1:   $(common_dep) $(binsrcdir)/autoscan.in
$(mansrcdir)/autoupdate.1: $(common_dep) $(binsrcdir)/autoupdate.in
$(mansrcdir)/ifnames.1:    $(common_dep) $(binsrcdir)/ifnames.in

remove_time_stamp = 's/^\(\.TH[^"]*"[^"]*"[^"]*\)"[^"]*"/\1/'

MOSTLYCLEANFILES += $(srcdir)/man/*.t

SUFFIXES += .x .1

.x.1:
	@echo "Updating man page $@"
	PATH="./tests$(PATH_SEPARATOR)$(top_srcdir)/build-aux$(PATH_SEPARATOR)$$PATH"; \
	export PATH; \
	$(HELP2MAN) \
	    --include=$*.x \
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
