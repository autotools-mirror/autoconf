#							-*- autoconf -*-

cat <<EOF

Autoheader, autoupdate...

EOF


## -------------------------------------------------------- ##
## Check that the shell scripts are syntactically correct.  ##
## -------------------------------------------------------- ##

# We use `/bin/sh -n script' to check that there are no syntax errors
# in the scripts.  Although incredible, there are /bin/sh that go into
# endless loops with `-n', e.g., SunOS's:
#
#   $ uname -a
#   SunOS ondine 4.1.3 2 sun4m unknown
#   $ cat endless.sh
#   while false
#   do
#     :
#   done
#   exit 0
#   $ time sh endless.sh
#   sh endless.sh  0,02s user 0,03s system 78% cpu 0,064 total
#   $ time sh -nx endless.sh
#   ^Csh -nx endless.sh  3,67s user 0,03s system 63% cpu 5,868 total
#
# So before using `/bin/sh -n' to check our scripts, we first check
# that `/bin/sh -n' is not broken to death.

AT_SETUP(Syntax of the scripts)

# A script that never returns.  We don't care that it never returns,
# broken /bin/sh loop equally with `false', but it makes it easier to
# test the robusteness in a good environment: just remove the `-n'.
AT_DATA(endless.sh,
[[while true
do
  :
done
]])

# A script in charge of testing `/bin/sh -n'.
AT_DATA(syntax.sh,
[[(/bin/sh -n endless.sh) &
sleep 2
if kill $! >/dev/null 2>&1; then
  # We managed to kill the child, which means that we probably
  # can't trust `/bin/sh -n', hence the test failed.
  exit 1
fi
]])

if /bin/sh ./syntax.sh; then
  AT_CHECK([/bin/sh -n ../autoconf],   0)
  AT_CHECK([/bin/sh -n ../autoreconf], 0)
  AT_CHECK([/bin/sh -n ../autoupdate], 0)
  AT_CHECK([/bin/sh -n ../autoreconf], 0)
  AT_CHECK([/bin/sh -n ../ifnames],    0)
fi

AT_CLEANUP





## ------------ ##
## autoheader.  ##
## ------------ ##

# autoheader is intensively used in its modern form throught this
# test suite.  But we also have to check that acconfig.h still works.

AT_SETUP(autoheader)

AT_DATA(acconfig.h,
[[/* Define this to whatever you want. */
#undef this
]])


# 1. Check that `acconfig.h' is still honored.
AT_DATA(configure.in,
[[AC_INIT
AC_CONFIG_HEADERS(config.h)
AC_DEFINE(this, "whatever you want.")
]])

AT_CHECK([../autoheader --autoconf-dir .. -<configure.in], 0,
[[/* config.h.in.  Generated automatically from - by autoheader.  */
/* Define this to whatever you want. */
#undef this
]], ignore)


# 2. Check that missing templates are a fatal error.
AT_DATA(configure.in,
[[AC_INIT
AC_CONFIG_HEADERS(config.h)
AC_DEFINE(that, "whatever you want.")
]])

AT_CHECK([../autoheader --autoconf-dir .. -<configure.in], 1, [],
[autoheader: No template for symbol `that'
])


# 3. Check TOP and BOTTOM.
AT_DATA(acconfig.h,
[[/* Top from acconfig.h. */
@TOP@
/* Middle from acconfig.h. */
@BOTTOM@
/* Bottom from acconfig.h. */
]])

AT_DATA(configure.in,
[[AC_INIT
AC_CONFIG_HEADERS(config.h)
AH_TOP([Top1 from configure.in.])
AH_TOP([Top2 from configure.in.])
AH_VERBATIM([Middle], [Middle from configure.in.])
AH_BOTTOM([Bottom1 from configure.in.])
AH_BOTTOM([Bottom2 from configure.in.])
]])


# Yes, that's right: the `middle' part of `acconfig.h' is still before
# the AH_TOP part.  But so what, you're not supposed to use the two
# together.
AT_CHECK([../autoheader --autoconf-dir .. -<configure.in], 0,
[[/* config.h.in.  Generated automatically from - by autoheader.  */
/* Top from acconfig.h. */

/* Middle from acconfig.h. */

Top1 from configure.in.

Top2 from configure.in.

Middle from configure.in.

Bottom1 from configure.in.

Bottom2 from configure.in.
/* Bottom from acconfig.h. */
]], [])


AT_CLEANUP




## ------------ ##
## autoupdate.  ##
## ------------ ##

# Check that AC_CANONICAL_SYSTEM and AC_OUTPUT are properly updated.
AT_SETUP(autoupdate)

AT_DATA(configure.in,
[[AC_INIT
AC_CANONICAL_SYSTEM
dnl The doc says 27 is a valid fubar.
fubar=27
AC_OUTPUT(Makefile, echo $fubar, fubar=$fubar)
]])

# Checking `autoupdate'.
AT_CHECK([../autoupdate --autoconf-dir $top_srcdir -<configure.in], 0,
[[AC_INIT
AC_CANONICAL_TARGET()
dnl The doc says 27 is a valid fubar.
fubar=27
AC_CONFIG_FILES([Makefile])
AC_CONFIG_COMMANDS([default],[[echo $fubar]],[[fubar=$fubar]])
AC_OUTPUT
]], [])

AT_CLEANUP


AT_SETUP([autoupdating AC_LINK FILES])

AT_DATA(configure.in,
[[AC_INIT
AC_LINK_FILES(dst1 dst2, src1 src2)
AC_OUTPUT
]])

AT_DATA(dst1, dst1
)
AT_DATA(dst2, dst2
)

# Checking `autoupdate'.
AT_CHECK([../autoupdate --autoconf-dir $top_srcdir], 0, [],
         [autoupdate: `configure.in' is updated
])
AT_CHECK([../autoconf --autoconf-dir $top_srcdir], 0)
AT_CHECK([./configure], 0, ignore)
AT_CHECK([cat src1], 0, [dst1
])
AT_CHECK([cat src2], 0, [dst2
])

AT_CLEANUP


## ------------------ ##
## autoconf --trace.  ##
## ------------------ ##

AT_SETUP(autoconf --trace)

AT_DATA(configure.in,
[[define(active, ACTIVE)
AC_DEFUN(TRACE1, [TRACE2(m4_shift($@))])
AC_DEFUN(TRACE2, [[$2], $1])
TRACE1(foo, bar, baz)
TRACE1(foo, AC_TRACE1(bar, baz))
TRACE1(foo, active, baz)
TRACE1(foo, [active], TRACE1(active, [active]))
]])

# Several --traces.
AT_CHECK([../autoconf --autoconf-dir .. -l $at_srcdir -t TRACE1 -t TRACE2], 0,
[[configure.in:4:TRACE1:foo:bar:baz
configure.in:4:TRACE2:bar:baz
configure.in:5:TRACE1:foo:AC_TRACE1(bar, baz)
configure.in:5:TRACE2:AC_TRACE1(bar, baz)
configure.in:6:TRACE1:foo:ACTIVE:baz
configure.in:6:TRACE2:ACTIVE:baz
configure.in:7:TRACE1:ACTIVE:active
configure.in:7:TRACE2:active
configure.in:7:TRACE1:foo:active::ACTIVE
configure.in:7:TRACE2:active::ACTIVE
]])

# Several line requests.
AT_CHECK([[../autoconf --autoconf-dir .. -l $at_srcdir -t TRACE1:'
[$1], [$2], [$3].']], 0,
[[
[foo], [bar], [baz].

[foo], [AC_TRACE1(bar, baz)], [].

[foo], [ACTIVE], [baz].

[ACTIVE], [active], [].

[foo], [active], [].
]])

# ${sep}@.
AT_CHECK([../autoconf --autoconf-dir .. -l $at_srcdir -t TRACE2:'${)===(}@'], 0,
[[[bar])===([baz]
[AC_TRACE1(bar, baz)]
[ACTIVE])===([baz]
[active]
[active])===([])===([ACTIVE]
]])

AT_CLEANUP




## ----------------------------------------------- ##
## autoconf's ability to catch unexpanded macros.  ##
## ----------------------------------------------- ##

AT_SETUP(unexpanded macros)

AT_DATA([configure.in],
[[AC_PLAIN_SCRIPT()dnl
AC_THIS_IS_PROBABLY_NOT_DEFINED
# AC_THIS_IS_A_COMMENT so just shut up.
It would be very bad if Autoconf forgot to expand [AC_]OUTPUT!
]])

AT_CHECK([../autoconf --autoconf-dir .. -l $at_srcdir], 1, [],
[[configure.in:2: error: undefined macro: AC_THIS_IS_PROBABLY_NOT_DEFINED
configure:3: error: undefined macro: AC_OUTPUT
]])

AT_CLEANUP(configure)





## ---------------------------- ##
## autoconf's AWK portability.  ##
## ---------------------------- ##

AT_SETUP(AWK portability)

AT_DATA([configure.in],
[[AC_INIT
]])

if (gawk --version) >/dev/null 2>&1; then
  # Generation of the script.
  AT_CHECK([AWK='gawk --posix' ../autoconf --autoconf-dir .. -l $at_srcdir], 0,
           [], [])
  # Tracing.
  AT_CHECK([AWK='gawk --posix' ../autoconf --autoconf-dir .. -l $at_srcdir -t AC_INIT], 0,
           ignore, [])
fi

AT_CLEANUP(configure)
