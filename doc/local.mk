# Make Autoconf documentation.

# Copyright (C) 2000-2003, 2007-2017, 2020-2024 Free Software
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

# ASCII_DASHES_AND_QUOTES=0 is needed for makeinfo versions ≥ 7.1.
# CHECK_NORMAL_MENU_STRUCTURE=1 is needed for makeinfo versions ≥ 6.8.
AM_MAKEINFOFLAGS = --no-split \
 -c ASCII_DASHES_AND_QUOTES=0 \
 -c CHECK_NORMAL_MENU_STRUCTURE=1
TEXI2HTML_FLAGS = -split_chapter
TEXINFO_TEX = build-aux/texinfo.tex

info_TEXINFOS = doc/autoconf.texi doc/standards.texi
doc_autoconf_TEXINFOS = doc/fdl.texi doc/install.texi
doc_standards_TEXINFOS = doc/fdl.texi doc/gnu-oids.texi doc/make-stds.texi

EXTRA_DIST += doc/gendocs_template

# Files from texi2dvi that should be removed, but which Automake does
# not know.
CLEANFILES += \
  autoconf.ACs \
  autoconf.cvs \
  autoconf.MSs \
  autoconf.prs \
  autoconf.ATs \
  autoconf.evs \
  autoconf.fns \
  autoconf.ovs \
  autoconf.ca  \
  autoconf.CA  \
  autoconf.cas \
  autoconf.CAs \
  autoconf.tmp
