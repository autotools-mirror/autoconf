# autoconf -- create `configure' using m4 macros
# Copyright 2001 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

package Autom4te::General;

use 5.005;
use Exporter;
use File::Basename;
use File::stat;
use Carp;
use strict;

use vars qw (@ISA @EXPORT);

@ISA = qw (Exporter);
@EXPORT = qw (&find_configure_ac &find_peer &mktmpdir &mtime
              &uniq &verbose &xsystem
	      $me $verbose $debug $tmp);

# Variable we share with the main package.  Be sure to have a single
# copy of them: using `my' together with multiple inclusion of this
# package would introduce several copies.
use vars qw ($me);
$me = basename ($0);

use vars qw ($verbose);
$verbose = 0;

use vars qw ($debug);
$debug = 0;

# Our tmp dir.
use vars qw ($tmp);
$tmp = undef;


# END
# ---
# Exit nonzero whenever closing STDOUT fails.
# Ideally we should `exit ($? >> 8)', unfortunately, for some reason
# I don't understand, whenever we `exit (1)' somewhere in the code,
# we arrive here with `$? = 29'.  I suspect some low level END routine
# might be responsible.  In this case, be sure to exit 1, not 29.
sub END
{
  my $exit_status = $? ? 1 : 0;

  use POSIX qw (_exit);

  if (!$debug && defined $tmp && -d $tmp)
    {
      if (<$tmp/*>)
	{
	  unlink <$tmp/*>
	    or carp ("$me: cannot empty $tmp: $!\n"), _exit (1);
	}
      rmdir $tmp
	or carp ("$me: cannot remove $tmp: $!\n"), _exit (1);
    }

  # This is required if the code might send any output to stdout
  # E.g., even --version or --help.  So it's best to do it unconditionally.
  close STDOUT
    or (carp "$me: closing standard output: $!\n"), _exit (1);

  _exit ($exit_status);
}


# $CONFIGURE_AC
# &find_configure_ac ()
# ---------------------
sub find_configure_ac ()
{
  if (-f 'configure.ac')
    {
      if (-f 'configure.in')
	{
	  carp "warning: `configure.ac' and `configure.in' both present.\n";
	  carp "warning: proceeding with `configure.ac'.\n";
	}
      return 'configure.ac';
    }
  elsif (-f 'configure.in')
    {
      return 'configure.in';
    }
  return;
}


# $PEER_PATH
# find_peer($PEER, $BINDIR, $PEER-NAME)
# -------------------------------------
# Look for $PEER executables: autoconf, autoheader etc.
# $BINDIR is @bindir@, and $PEER-NAME the transformed peer name
# (when configured with --transform-program-names etc.).
# We could have it AC_SUBST'ed in here, but it then means General.pm
# is in builddir, hence more paths to adjust etc.  Yick.
sub find_peer ($$$)
{
  my ($peer, $bindir, $peer_name) = @_;
  my $res = undef;
  my $PEER = uc $peer;
  my $dir = dirname ($0);

  # We test "$dir/autoconf" in case we are in the build tree, in which case
  # the names are not transformed yet.
  foreach my $file ($ENV{"$PEER"} || '',
		    "$dir/$peer_name",
		    "$dir/$peer",
		    "$bindir/$peer_name")
    {
      # FIXME: This prevents passing options...  Maybe run --version?
      if (-x $file)
	{
	  $res = $file;
	  last;
	}
    }

  # This is needed because perl's '-x' isn't a smart as bash's; that
  # is, it won't find `autoconf.sh' etc.
  $res ||= $peer;

  return $res;
}


# mktmpdir ($SIGNATURE)
# ---------------------
# Create a temporary directory which name is based on $SIGNATURE.
sub mktmpdir ($)
{
  my ($signature) = @_;
  my $TMPDIR = $ENV{'TMPDIR'} || '/tmp';

  # If mktemp supports dirs, use it.
  $tmp = `(umask 077 &&
           mktemp -d -q "$TMPDIR/${signature}XXXXXX") 2>/dev/null`;
  chomp $tmp;

  if (!$tmp || ! -d $tmp)
    {
      $tmp = "$TMPDIR/$signature" . int (rand 10000) . ".$$";
      mkdir $tmp, 0700
	or croak "$me: cannot create $tmp: $!\n";
    }

  print STDERR "$me:$$: working in $tmp\n"
    if $debug;
}


# $MTIME
# MTIME ($FILE)
# -------------
# Return the mtime of $FILE.  Missing files, or `-' standing for STDIN
# or STDOUT are ``obsolete'', i.e., as old as possible.
sub mtime ($)
{
  my ($file) = @_;

  return 0
    if $file eq '-' || ! -f $file;

  my $stat = stat ($file)
    or croak "$me: cannot stat $file: $!\n";

  return $stat->mtime;
}


# @RES
# uniq (@LIST)
# ------------
# Return LIST with no duplicates.
sub uniq (@)
{
   my @res = ();
   my %seen = ();
   foreach my $item (@_)
     {
       if (! exists $seen{$item})
	 {
	   $seen{$item} = 1;
	   push (@res, $item);
	 }
     }
   return wantarray ? @res : "@res";
}


# verbose
# -------
sub verbose (@)
{
  print STDERR "$me: ", @_, "\n"
    if $verbose;
}


# xsystem ($COMMAND)
# ------------------
sub xsystem ($)
{
  my ($command) = @_;

  verbose "running: $command";

  (system $command) == 0
    or croak ("$me: "
	      . (split (' ', $command))[0]
	      . " failed with exit status: "
	      . ($? >> 8)
	      . "\n");
}


1; # for require
