## Process this file with automake to create Makefile.in.

## Makefile for Autoconf testsuite.
## Copyright (C) 1999 Free Software Foundation, Inc.

## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2, or (at your option)
## any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
## 02111-1307, USA.

AUTOMAKE_OPTIONS = dejagnu

GENERIC_TESTS = autoconf.g/sizeof.exp autoconf.g/init.exp
SPECIFIC_TESTS = autoconf.s/defines.exp autoconf.s/syntax.exp

EXTRA_DIST = config/unix.exp lib/common.exp $(GENERIC_TESTS) $(SPECIFIC_TESTS)

AUTOCONFFLAGS = -m $(top_builddir)
AUTOCONF = $(top_builddir)/autoconf

## FIXME: I don't think it is normal that we need AUTOCONF.  Some scripts
## use it explicitly though.
RUNTESTFLAGS = AUTOCONF="$(AUTOCONF)" AUTOCONFFLAGS="$(AUTOCONFFLAGS)"
