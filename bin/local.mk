# Make Autoconf commands.

# Copyright (C) 1999-2007, 2009-2017, 2020-2021 Free Software
# Foundation, Inc.

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

bin_SCRIPTS = \
  bin/autoconf \
  bin/autoheader \
  bin/autom4te \
  bin/autoreconf \
  bin/autoscan \
  bin/autoupdate \
  bin/ifnames

EXTRA_DIST += \
  bin/autoconf.as \
  bin/autoheader.in \
  bin/autom4te.in \
  bin/autoreconf.in \
  bin/autoscan.in \
  bin/autoupdate.in \
  bin/ifnames.in

# Files that should be removed, but which Automake does not know.
MOSTLYCLEANFILES += $(bin_SCRIPTS) bin/autoconf.in bin/*.tmp

## ------------- ##
## The scripts.  ##
## ------------- ##

# autoconf is written in M4sh.
# FIXME: this target should depend on the frozen files below lib/m4sugar,
# otherwise autom4te may pick up a frozen m4sh.m4f from an earlier
# installation below the same $(prefix); work around this with --melt.
bin/autoconf.in: $(srcdir)/bin/autoconf.as $(m4sh_m4f_dependencies)
	$(MY_AUTOM4TE) --language M4sh --cache '' \
	  --melt $(srcdir)/bin/autoconf.as -o $@

## All the scripts depend on Makefile so that they are rebuilt when the
## prefix etc. changes.  It took quite a while to have the rule correct,
## don't break it!
## Use chmod -w to prevent people from editing the wrong file by accident.
$(bin_SCRIPTS): Makefile
	rm -f $@ $@.tmp
	$(MKDIR_P) $(@D)
	srcdir=''; \
	  test -f ./$@.in || srcdir=$(srcdir)/; \
	  $(edit) $${srcdir}$@.in >$@.tmp
	chmod +x $@.tmp
	chmod a-w $@.tmp
	mv $@.tmp $@

bin/autoconf: bin/autoconf.in
bin/autoheader: $(srcdir)/bin/autoheader.in
bin/autom4te: $(srcdir)/bin/autom4te.in
bin/autoreconf: $(srcdir)/bin/autoreconf.in
bin/autoscan: $(srcdir)/bin/autoscan.in
bin/autoupdate: $(srcdir)/bin/autoupdate.in
bin/ifnames: $(srcdir)/bin/ifnames.in


## --------------- ##
## Building TAGS.  ##
## --------------- ##

TAGS_DEPENDENCIES = $(EXTRA_DIST)

letters = abcdefghijklmnopqrstuvwxyz
LETTERS = ABCDEFGHIJKLMNOPQRSTUVWXYZ
DIGITS = 0123456789
WORD_REGEXP = [$(LETTERS)$(letters)_][$(LETTERS)$(letters)$(DIGITS)_]*
ETAGS_PERL = --lang=perl \
  bin/autoheader.in \
  bin/autoreconf.in \
  bin/autoupdate.in \
  bin/autoscan.in \
  bin/autom4te.in \
  bin/ifnames.in
ETAGS_SH = --lang=none --regex='/\($(WORD_REGEXP)\)=/\1/' \
  bin/autoconf.in

ETAGS_ARGS += $(ETAGS_PERL) $(ETAGS_SH)
