AS_INIT[]dnl                                         -*- shell-script -*-
# @configure_input@
# Running `$0' as if it were installed.

# Be sure to use the non installed Perl modules.
autom4te_perllibdir=@abs_top_srcdir@/lib
export autom4te_perllibdir

case $as_me in
  ifnames)
     # Does not have lib files.
     exec @abs_top_builddir@/bin/$as_me ${1+"$@"}
     ;;

  autom4te)
     AUTOM4TE_CFG=@abs_top_builddir@/lib/autom4te.cfg
     export AUTOM4TE_CFG
     ;;

esac
# We might need files from build (frozen files), in addition of src files.
exec @abs_top_builddir@/bin/$as_me \
	-I @abs_top_builddir@/lib \
	-I @abs_top_srcdir@/lib ${1+"$@"}
