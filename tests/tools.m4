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
## autoupdate.  ##
## ------------ ##

# Check that AC_LINK_FILES and AC_OUTPUT are properly updated.
# actest.m4 AU_ defines OSBOLETE to UPDATED.

AT_SETUP(autoupdate)

AT_DATA(configure.in,
[[AC_INIT
dnl The doc says 27 is a valid fubar.
fubar=27
AC_OUTPUT(Makefile, echo $fubar, fubar=$fubar)
]])

# Checking `autoupdate'.
AT_CHECK([../autoupdate -m .. -l $at_srcdir -<configure.in], 0,
[[AC_INIT
dnl The doc says 27 is a valid fubar.
fubar=27
AC_CONFIG_FILES(Makefile)
AC_CONFIG_COMMANDS(default, [echo $fubar], [fubar=$fubar])
AC_OUTPUT
]], ignore)

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
AT_CHECK([../autoconf -m .. -l $at_srcdir -t TRACE1 -t TRACE2], 0,
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
AT_CHECK([[../autoconf -m .. -l $at_srcdir -t TRACE1:'
[$1], [$2], [$3].']], 0,
[[
[foo], [bar], [baz].

[foo], [AC_TRACE1(bar, baz)], [].

[foo], [ACTIVE], [baz].

[ACTIVE], [active], [].

[foo], [active], [].
]])

# ${sep}@.
AT_CHECK([../autoconf -m .. -l $at_srcdir -t TRACE2:'${)===(}@'], 0,
[[[bar])===([baz]
[AC_TRACE1(bar, baz)]
[ACTIVE])===([baz]
[active]
[active])===([])===([ACTIVE]
]])

AT_CLEANUP
