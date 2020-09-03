#! /bin/sh

: "${WGET=wget}"
: "${PERL=perl}"

gitweb_base="https://git.savannah.gnu.org/gitweb/?p="
gitweb_op=";a=blob_plain;hb=HEAD;f="

gnulib_gitweb="${gitweb_base}gnulib.git${gitweb_op}"
automake_gitweb="${gitweb_base}automake.git${gitweb_op}"

# This list should be in alphabetical order, *except* that this script
# uses move-if-change itself, so that one should be first.
gnulib_files="
	build-aux/move-if-change
	build-aux/announce-gen
	build-aux/config.guess
	build-aux/config.sub
	build-aux/gendocs.sh
	build-aux/git-version-gen
	build-aux/gitlog-to-changelog
	build-aux/gnupload
	build-aux/install-sh
	build-aux/mdate-sh
	build-aux/texinfo.tex
	build-aux/update-copyright
	build-aux/useless-if-before-free
	build-aux/vc-list-files
	doc/fdl.texi
	doc/gendocs_template
	doc/gnu-oids.texi
	doc/make-stds.texi
	doc/standards.texi
	m4/autobuild.m4
	top/GNUmakefile
	top/maint.mk
"

automake_files="
        lib/Automake/Channels.pm
        lib/Automake/FileUtils.pm
        lib/Automake/Getopt.pm
        lib/Automake/XFile.pm
"

srcdir="$1"
shift

move_if_change="${srcdir}/build-aux/move-if-change"

scratch="$(mktemp -p . -d fetch.XXXXXXXXX)"
trap "rm -rf '$scratch'" 0

run () {
    printf '+ %s\n' "$*"
    "$@" || exit 1
}

for file in $gnulib_files; do
    fbase="${file##*/}"
    destdir="${file%/*}"
    if [ "$destdir" = top ]; then
        dest="${srcdir}/${fbase}"
    else
        dest="${srcdir}/${file}"
    fi
    run "$WGET" -nv -O "${scratch}/${fbase}" "${gnulib_gitweb}${file}"
    run "$move_if_change" "${scratch}/${fbase}" "$dest"
done

for file in $automake_files; do
    fbase="${file##*/}"
    dest="${srcdir}/lib/Autom4te/${fbase}"
    run "$WGET" -nv -O "${scratch}/${fbase}" "${automake_gitweb}${file}"
    run "$PERL" -pi -e 's/Automake::/Autom4te::/g' "${scratch}/${fbase}"
    run "$move_if_change" "${scratch}/${fbase}" "$dest"
done
