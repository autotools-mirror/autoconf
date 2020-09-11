#! /usr/bin/perl
# Copyright (C) 2020 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

use 5.014;  # first version with HTTP::Tiny
use strict;
use utf8;
use feature 'unicode_strings';
use warnings FATAL => 'all';

use Fcntl qw (S_IMODE);
use File::Spec;
use File::stat;
use File::Temp qw (tempfile);
use Getopt::Long;
use HTTP::Tiny;

our @gnulib_files = qw(
  build-aux/announce-gen
  build-aux/config.guess
  build-aux/config.sub
  build-aux/gendocs.sh
  build-aux/git-version-gen
  build-aux/gitlog-to-changelog
  build-aux/gnupload
  build-aux/install-sh
  build-aux/mdate-sh
  build-aux/move-if-change
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
);

our @automake_files = qw(
  lib/Automake/Channels.pm
  lib/Automake/Configure_ac.pm
  lib/Automake/FileUtils.pm
  lib/Automake/Getopt.pm
  lib/Automake/XFile.pm
);


# Shorthands for catpath and splitpath.
# File::Spec::Functions was only added in 5.30, which is much too new.
sub catpath
{
  return File::Spec->catpath (@_);
}

sub splitpath
{
  return File::Spec->splitpath (@_);
}


# urlquote($s)
# Returns $s, %-quoted appropriately for interpolation into the
# path or query component of a URL.  Assumes that non-ASCII characters
# should be encoded in UTF-8 before quoting.
sub urlquote($)
{
  my ($s) = @_;

  utf8::encode($s);
  use bytes;
  $s =~ s!
    [^./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~-]
   !
    sprintf("%%%02X", ord($&))
   !egx;
  return $s;
}


# savannah_url($repo, $filename)
# Returns the URL from which the contents of $filename within $repo
# can be retrieved, assuming $repo is the name of a savannah.gnu.org
# Git repository.
sub savannah_url($$)
{
  my ($repo, $filename) = @_;

  my $gitweb_base = 'https://git.savannah.gnu.org/gitweb/?p=';
  my $gitweb_op   = '.git;a=blob_plain;hb=HEAD;f=';

  return $gitweb_base . urlquote ($repo) . $gitweb_op . urlquote ($filename);
}


# slurp ($filename)
# Read the contents of $filename into a scalar and return them.
sub slurp ($)
{
  my ($filename) = @_;
  local $/; # engage slurp mode
  open my $fh, '<', $filename
    or die "$filename: $!\n";
  return scalar <$fh>;
}


# replace_if_change ($file, $newcontents, $quiet)
# If $newcontents is different from the contents of $file,
# atomically replace $file's contents with $newcontents.
# This function assumes POSIX semantics for rename over an existing
# file (i.e.  atomic replacement, not an error).
sub replace_if_change ($$$)
{
  my ($file, $newcontents, $quiet) = @_;
  my $oldcontents = slurp $file;

  if ($oldcontents eq $newcontents)
    {
      print STDERR "$file is unchanged\n" unless $quiet;
      return;
    }

  my ($vol, $subdir, $base) = splitpath $file;
  my ($tmp_fh, $tmp_name) = tempfile (DIR => catpath ($vol, $subdir));

  {
    local $\;
    local $,;
    print $tmp_fh $newcontents;
  }
  close $tmp_fh
    or die "$0: writing to $tmp_name: $!\n";

  # Preserve the permissions of the original file.
  my $st = stat $file;
  chmod (S_IMODE ($st->mode), $tmp_name)
    or die "$0: setting permissions on $tmp_name: $!\n";

  rename $tmp_name, $file
    or die "$0: rename($tmp_name, $file): $!\n";

  print STDERR "$file updated\n" unless $quiet;
}


# fetch ($path, $repo, $topdestdir, $edit, $quiet, $client)
# Retrieve $path from repository $repo, writing it to $topdestdir/$path.
# As a special case, if the dirname of $path is "top/", then write it
# to $topdestdir/$(basename $file) instead.
# If $edit is true, perform s/\bAutomake::/Autom4te::/g on the file's
# contents.
# If $quiet is true, don't print progress reports.
# $client must be a HTTP::Tiny instance.
sub fetch ($$$$$$)
{
  my ($path, $repo, $topdestdir, $edit, $quiet, $client) = @_;
  my ($vol, $subdir, $file) = splitpath ($path);
  my $destpath = ($subdir eq 'top/')
    ? catpath($topdestdir, $file)
    : catpath($topdestdir, $path);

  $destpath =~ s!/Automake/!/Autom4te/!g if $edit;

  my $uri = savannah_url ($repo, $path);
  print STDERR "fetch $path <- $uri ...\n" unless $quiet;

  my $resp = $client->get ($uri);

  die "$uri: $resp->{status} $resp->{reason}\n"
    unless $resp->{success};

  my $content = $resp->{content};
  $content =~ s/\bAutomake::/Autom4te::/g if $edit;

  replace_if_change ($destpath, $content, $quiet);
}


sub main
{
  my $quiet = 0;
  GetOptions ('quiet|q' => \$quiet)
    or die "usage: $0 [-q] destination-directory\n";

  my $topdestdir = shift @ARGV
    or die "usage: $0 [-q] destination-directory\n";

  $#ARGV == -1
    or die "usage: $0 [-q] destination-directory\n";

  my $client = HTTP::Tiny->new(
    agent => 'autoconf-fetch.pl/1.0 ',
    keep_alive => 1,
    verify_SSL => 1
  );

  my ($can_ssl, $whynot) = $client->can_ssl;
  die "$0: HTTPS support not available"
    . " (do you need to install IO::Socket::SSL?\n"
    . $whynot . "\n"
    unless $can_ssl;

  fetch $_, 'gnulib', $topdestdir, 0, $quiet, $client
    foreach @gnulib_files;

  fetch $_, 'automake', $topdestdir, 1, $quiet, $client
    foreach @automake_files;
}

main ();

### Setup "GNU" style for perl-mode and cperl-mode.
## Local Variables:
## perl-indent-level: 2
## perl-continued-statement-offset: 2
## perl-continued-brace-offset: 0
## perl-brace-offset: 0
## perl-brace-imaginary-offset: 0
## perl-label-offset: -2
## cperl-indent-level: 2
## cperl-brace-offset: 0
## cperl-continued-brace-offset: 0
## cperl-label-offset: -2
## cperl-extra-newline-before-brace: t
## cperl-merge-trailing-else: nil
## cperl-continued-statement-offset: 2
## End:
