;; Guix manifest for testing Autoconf in an isolated environment.
;; Use as e.g.
;;   guix shell --container --manifest=manifest.scm
;; Everything required for the release checks (see HACKING) is included.

;; Copying and distribution of this file, with or without modification,
;; are permitted in any medium without royalty provided the copyright
;; notice and this notice are preserved.  This file is offered as-is,
;; without any warranty.

(specifications->manifest
 '(
   ;; Basic requirements for a standard "gnu build system" build.
   ;; TODO: Make a variant with a stripped-down environment,
   ;; perhaps using busybox or toybox instead of coreutils and friends.
   ;; TODO: Investigate why the syntax error tests fail with bash-minimal.
   "bash" "coreutils" "diffutils" "findutils" "gawk" "grep" "make" "sed"
   "tar" "gzip" "xz" ; bzip2 intentionally left out

   ;; Additional requirements for building and running Autoconf itself.
   "m4" "perl"

   ;; Additional requirements for building from a pristine git checkout.
   "automake" "git" "help2man" "texinfo"
   "texlive"  ; shouldn't be necessary - standards.texi requires ectt which
              ; doesn't seem to be in any smaller package

   ;; All of the compilers and tools that Autoconf is capable of probing.
   ;;
   ;; TODO: Make a variant that *doesn't* install any of this
   ;; and ensure that every test that requires at least one compiler is
   ;; skipped, rather than failing, when run in that environment.  Currently
   ;; lots of tests fail in the absence of a C compiler.
   ;;
   ;; TODO: Investigate why "gcc-toolchain" produces a working compiler,
   ;; and "ld-wrapper" "binutils" "gcc" doesn't, when the former is
   ;; supposedly just a dependency package that pulls in the latter three.
   ;; (It probably has something to do with how "gcc-toolchain" also pulls
   ;; half a dozen "boot" packages that shouldn't be necessary at all,
   ;; even though these are not listed in its dependencies.)
   "gcc-toolchain"  ; C, C++, infrastructure
   "gcc-objc"       ; Objective-C
   "gccgo"          ; Go
   ;"gfortran"      ; Fortran - not currently available??
   "erlang"         ; Erlang

   "bison"
   "flex"
   "libtool"
   ;"shtool"        ; not currently available
))
