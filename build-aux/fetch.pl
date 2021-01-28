#! /usr/bin/perl
# Copyright (C) 2020-2021 Free Software Foundation, Inc.

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

# From outside to inside: locations in our source tree where to put
# files retrieved from other projects; the savannah.gnu.org project
# name of each project to retrieve files from; and the set of files
# to retrieve from that project into that location.
# Files put into a directory named 'Autom4te' are subject to "editing"
# (see the $edit parameter to sub fetch).
our %to_fetch = (
  '.' => {
    gnulib => [
      'top/GNUmakefile',
      'top/maint.mk',
    ],
  },
  'build-aux' => {
    automake => [
      'lib/install-sh',
    ],
    config => [
      'config.guess',
      'config.sub',
    ],
    gnulib => [
      'build-aux/announce-gen',
      'build-aux/gendocs.sh',
      'build-aux/git-version-gen',
      'build-aux/gitlog-to-changelog',
      'build-aux/gnupload',
      'build-aux/move-if-change',
      'build-aux/update-copyright',
      'build-aux/useless-if-before-free',
      'build-aux/vc-list-files',
    ],
    texinfo => [
      'doc/texinfo.tex',
    ],
  },
  'doc' => {
    gnulib => [
      'doc/gendocs_template',
    ],
    gnustandards => [
      'gnustandards/fdl.texi',
      'gnustandards/gnu-oids.texi',
      'gnustandards/make-stds.texi',
      'gnustandards/standards.texi',
    ],
  },
  'lib/Autom4te' => {
    automake => [
      'lib/Automake/ChannelDefs.pm',
      'lib/Automake/Channels.pm',
      'lib/Automake/Configure_ac.pm',
      'lib/Automake/FileUtils.pm',
      'lib/Automake/Getopt.pm',
      'lib/Automake/XFile.pm',
    ],
  },
  'm4' => {
    gnulib => [
      'm4/autobuild.m4',
    ],
  },
);


# Shorthands for catfile and splitpath.
# File::Spec::Functions was only added in 5.30, which is much too new.
sub catfile
{
  return File::Spec->catfile (@_);
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

  $repo = urlquote ($repo);
  $filename = urlquote ($filename);

  # The GNU Coding Standards are still maintained in CVS.
  if ($repo eq 'gnustandards')
    {
      my $cvsweb_base = 'https://cvs.savannah.gnu.org/viewvc/*checkout*/';
      return $cvsweb_base . $repo . '/' . $filename;
    }
  else
    {
      my $cgit_base = 'https://git.savannah.gnu.org/cgit/';
      my $cgit_op   = '.git/plain/';

      return $cgit_base . $repo . $cgit_op . $filename;
  }
}


# slurp ($filename)
# Read the contents of $filename into a scalar and return them.
# If $filename does not exist, return undef; any other error is fatal.
sub slurp ($)
{
  my ($filename) = @_;
  local $/; # engage slurp mode
  if (open my $fh, '<', $filename)
    {
      return scalar <$fh>;
    }
  elsif ($!{ENOENT})
    {
      return undef;
    }
  else
    {
      die "$filename: $!\n";
    }
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

  if (defined $oldcontents && $oldcontents eq $newcontents)
    {
      print STDERR "$file is unchanged\n" unless $quiet;
      return;
    }

  my (undef, $subdir, undef) = splitpath $file;
  my ($tmp_fh, $tmp_name) = tempfile (DIR => $subdir);

  {
    local $\;
    local $,;
    print $tmp_fh $newcontents;
  }
  close $tmp_fh
    or die "$0: writing to $tmp_name: $!\n";

  # Preserve the permissions of the original file, if it exists.
  if (defined $oldcontents)
    {
      my $st = stat $file;
      chmod (S_IMODE ($st->mode), $tmp_name)
        or die "$0: setting permissions on $tmp_name: $!\n";
    }

  rename $tmp_name, $file
    or die "$0: rename($tmp_name, $file): $!\n";

  print STDERR "$file updated\n";
}


# fetch ($path, $repo, $destdir, $edit, $quiet, $client)
# Retrieve $path from repository $repo,
# writing it to $destdir/$(basename $path).
# If $edit is true, perform s/\bAutomake::/Autom4te::/g on the file's
# contents.
# If $quiet is true, don't print progress reports.
# $client must be a HTTP::Tiny instance.
sub fetch ($$$$$$)
{
  my ($path, $repo, $destdir, $edit, $quiet, $client) = @_;
  my (undef, undef, $file) = splitpath ($path);
  my $destpath = catfile ($destdir, $file);

  my $uri = savannah_url ($repo, $path);
  print STDERR "fetch $destpath <- $uri ...\n" unless $quiet;

  my $resp = $client->get ($uri);

  die "$uri: $resp->{status} $resp->{reason}\n"
    unless $resp->{success};

  my $content = $resp->{content};
  # don't use \s here or it will eat blank lines
  $content =~ s/[ \t]+$//gm;
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

  while (my ($subdir, $groups) = each %to_fetch)
    {
      my $edit = $subdir =~ m!/Autom4te$!;
      my $destdir = catfile ($topdestdir, $subdir);
      while (my ($project, $files) = each %$groups)
        {
          fetch $_, $project, $destdir, $edit, $quiet, $client
            foreach @$files;
        }
      }
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
