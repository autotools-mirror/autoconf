include(libm4.m4)#                                          -*- Autoconf -*-
# This file is part of Autoconf.
# Driver that loads the Autoupdate macro files.
# Copyright (C) 1999, 2000 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.
#
# Written by Akim Demaille.
#
# Do not sinclude acsite.m4 here, because it may not be installed
# yet when Autoconf is frozen.
# Do not sinclude ./aclocal.m4 here, to prevent it from being frozen.
m4_include(acversion.m4)
m4_include(acgeneral.m4)
m4_include(aclang.m4)
m4_include(acspecific.m4)
m4_include(acoldnames.m4)
m4_disable(autoconf)
m4_enable(autoupdate)
# Disable m4
m4_disable(libm4)
m4_changequote(, )
divert(0)m4_dnl
