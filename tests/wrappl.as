AS_INIT[]dnl                                         -*- shell-script -*-
# @configure_input@
# Running `$0' as if it were installed.

AUTOCONF=@abs_top_builddir@/bin/autoconf
AUTOHEADER=@abs_top_builddir@/bin/autoheader
AUTOM4TE=@abs_top_builddir@/bin/autom4te
AUTOM4TE_CFG=@abs_top_builddir@/lib/autom4te.cfg
autom4te_perllibdir=@abs_top_srcdir@/lib
export AUTOCONF AUTOHEADER AUTOM4TE AUTOM4TE_CFG autom4te_perllibdir

case $as_me in
  ifnames)
     # Does not have lib files.
     exec @abs_top_builddir@/bin/$as_me ${1+"$@"}
     ;;
esac
# We might need files from build (frozen files), in addition of src files.
exec @abs_top_builddir@/bin/$as_me \
	-I @abs_top_builddir@/lib \
	-I @abs_top_srcdir@/lib ${1+"$@"}
