#!/bin/sh
# Validation suite for Autoconf
# Copyright (C) 2000 Free Software Foundation, Inc.

# Still many parts of `autoconf' are not exercised by the test suite.  A few
# FIXME's, below, are used to list tests that we would need.  Do you feel
# like contributing new tests?  If you do, you may tell your intent to
# `autoconf@gnu.org', so no two people work at the same thing.

AT_INIT(autoconf)

cat <<EOF
Some tests might be ignored if you don't have the software which the
macros are supposed to test (e.g., a Fortran compiler).
EOF

dnl Run the tests from the most selective to the easiest.

AT_INCLUDE(torture.m4)
AT_INCLUDE(base.m4)
AT_INCLUDE(semantics.m4)
AT_INCLUDE(syntax.m4)
