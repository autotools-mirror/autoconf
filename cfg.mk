# Customize maint.mk for Autoconf.            -*- Makefile -*-
# Copyright (C) 2003, 2004, 2006, 2008 Free Software Foundation, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This file is '-include'd into GNUmakefile.

# Build with our own versions of these tools, when possible.
export PATH = $(shell echo "`pwd`/tests:$$PATH")

# Remove the autoreconf-provided INSTALL, so that we regenerate it.
_autoreconf = autoreconf -i -v && rm -f INSTALL

# Version management.
announce_gen   = $(srcdir)/build-aux/announce-gen

# Use alpha.gnu.org for alpha and beta releases.
# Use ftp.gnu.org for major releases.
gnu_ftp_host-alpha = alpha.gnu.org
gnu_ftp_host-beta = alpha.gnu.org
gnu_ftp_host-major = ftp.gnu.org
gnu_rel_host = $(gnu_ftp_host-$(RELEASE_TYPE))

url_dir_list = \
  ftp://$(gnu_rel_host)/gnu/autoconf

# The GnuPG ID of the key used to sign the tarballs.
gpg_key_ID = F4850180

# The local directory containing the checked-out copy of gnulib used in this
# release.
gnulib_dir = '$(abs_srcdir)'/../gnulib

# Update files from gnulib.
.PHONY: fetch
fetch:
	cp $(gnulib_dir)/build-aux/announce-gen $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/config.guess $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/config.sub $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/elisp-comp $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/git-version-gen $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/gnupload $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/install-sh $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/mdate-sh $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/missing $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/vc-list-files $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/texinfo.tex $(srcdir)/build-aux
	cp $(gnulib_dir)/doc/fdl-1.3.texi $(srcdir)/doc
	cp $(gnulib_dir)/doc/gnu-oids.texi $(srcdir)/doc
	cp $(gnulib_dir)/doc/make-stds.texi $(srcdir)/doc
	cp $(gnulib_dir)/doc/standards.texi $(srcdir)/doc
	cp $(gnulib_dir)/top/GNUmakefile $(srcdir)

# Tests not to run.
local-checks-to-skip ?= \
  changelog-check sc_unmarked_diagnostics

.PHONY: web-manual
web-manual:
	@cd $(srcdir)/doc ; \
	GENDOCS_TEMPLATE_DIR=$(gnulib_dir)/doc; export GENDOCS_TEMPLATE_DIR; \
	$(SHELL) $(gnulib_dir)/build-aux/gendocs.sh autoconf \
	    "$(PACKAGE_NAME) - Creating Automatic Configuration Scripts"
	@echo " *** Upload the doc/manual directory to web-cvs."
