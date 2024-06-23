{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  # included by default (since we're not using mkShellNoCC) are:
  #    bash coreutils file findutils gawk gnugrep gnused
  #    gnutar gzip bzip2 xz diffutils patch
  #    binutils gcc glibc gnumake
  packages = with pkgs;
    # custom texliveBasic - metafont and ectt are required to build PDF documentation
    let
       texliveCustom = texliveBasic.withPackages (ps: [ps.metafont ps.ec]);
    in [
      # Additional requirements for building and running Autoconf itself
      m4
      perl

      # Additional requirements for building from a pristine git checkout
      automake
      git
      help2man
      texinfo
      texliveCustom

      # Needed only to run the test suite comprehensively
      # TODO: Make a variant that uses mkShellNoCC and *doesn't* install any
      # of this and ensure that every test that probes some of them is
      # skipped, rather than failing, when run in that environment.
      # Currently lots of tests fail in the absence of a C compiler.

      # Compilers and tools that Autoconf is capable of probing
      bison
      erlang
      flex
      gccgo
      gfortran
      libtool
      # Objective-C compiler seems not to be available
      # shtool is not available

      # Needed to test AC_CHECK_LIB and AC_SEARCH_LIBS
      zlib

  ];
}
