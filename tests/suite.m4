#! /bin/sh
# Validation suite for Autoconf
# Copyright 2000 Free Software Foundation, Inc.

# Still many parts of `autoconf' are not exercised by the test suite.  A few
# FIXME's, below, are used to list tests that we would need.  Do you feel
# like contributing new tests?  If you do, you may tell your intent to
# `autoconf@gnu.org', so no two people work at the same thing.

AT_INIT(autoconf)

cat <<EOF
Some tests might be ignored if you don't have the software which the
macros are supposed to test (e.g., a Fortran compiler).
EOF

# Run the tests from the lowest level to the highest level, and from
# the most selective to the easiest.

# M4sugar.
AT_INCLUDE(m4sugar.m4)

# shell.m4.
AT_INCLUDE(shell.m4)

# Autoconf base macros.
AT_INCLUDE(base.m4)

# The executables.
AT_INCLUDE(tools.m4)

# Checking that AC_CHECK_FOO macros work properly.
AT_INCLUDE(semantics.m4)

# Stressing config.status.
AT_INCLUDE(torture.m4)

# Checking all the AC_DEFUN'd macros.
AT_INCLUDE(syntax.m4)

# Checking that updatiing an obsolete macro produces a valid configure.in
AT_INCLUDE(update.m4)
