#							-*- autoconf -*-

cat <<EOF

Base layer.

EOF

dnl AU_DEFUN
dnl --------
dnl
AT_SETUP(m4_wrap)

dnl m4_wrap is used to display the help strings.
dnl Also, check that commas are not swallowed.  This can easily happen
dnl because of m4-listification.
AT_DATA(libm4.in,
[[include(libm4.m4)divert(0)dnl
m4_wrap([Short string */], [   ], [/* ], 20)

m4_wrap([Much longer string */], [   ], [/* ], 20)

m4_wrap([Short doc.], [          ], [  --short ], 30)

m4_wrap([Short doc.], [          ], [  --too-wide], 30)

m4_wrap([Super long documentation.], [          ], [  --too-wide], 30)

m4_wrap([First, second  , third, [,quoted]])
]])

AT_DATA(expout,
[[/* Short string */

/* Much longer
   string */

  --short Short doc.

  --too-wide
          Short doc.

  --too-wide
          Super long
          documentation.

First, second , third, [,quoted]
]])

AT_CHECK([m4 -I $at_top_srcdir libm4.in], 0, expout)


AT_CLEANUP()
