# autoconf -- create `configure' using m4 macros
# Copyright (C) 2001, 2002, 2003  Free Software Foundation, Inc.

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

=head1 NAME

Autom4te::General - general support functions for Autoconf and Automake

=head1 SYNOPSIS

  use Autom4te::General

=head1 DESCRIPTION

This perl module provides various general purpose support functions
used in several executables of the Autoconf and Automake packages.

=cut

use 5.005_03;
use Exporter;
use File::Basename;
use File::Spec;
use File::stat;
use IO::File;
use Carp;
use strict;

use vars qw (@ISA @EXPORT);

@ISA = qw (Exporter);

# Variables we define and export.
my @export_vars =
  qw ($debug $force $help $me $tmp $verbose $version);

# Functions we define and export.
my @export_subs =
  qw (&catfile &canonpath &contents &debug &error
      &file_name_is_absolute &find_configure_ac &find_file
      &getopt &mktmpdir &mtime
      &uniq &update_file &up_to_date_p &verbose &xsystem &xqx);

# Functions we forward (coming from modules we use).
my @export_forward_subs =
  qw (&basename &dirname &fileparse);

@EXPORT = (@export_vars, @export_subs, @export_forward_subs);


# Variable we share with the main package.  Be sure to have a single
# copy of them: using `my' together with multiple inclusion of this
# package would introduce several copies.

=head2 Global Variables

=over 4

=item C<$debug>

Set this variable to 1 if debug messages should be enabled.  Debug
messages are meant for developpers only, or when tracking down an
incorrect execution.

=cut

use vars qw ($debug);
$debug = 0;

=item C<$force>

Set this variable to 1 to recreate all the files, or to consider all
the output files are obsolete.

=cut

use vars qw ($force);
$force = undef;

=item C<$help>

Set to the help message associated to the option C<--help>.

=cut

use vars qw ($help);
$help = undef;

=item C<$me>

The name of this application, as should be used in diagostic messages.

=cut

use vars qw ($me);
$me = basename ($0);

=item C<$tmp>

The name of the temporary directory created by C<mktmpdir>.  Left
C<undef> otherwise.

=cut

# Our tmp dir.
use vars qw ($tmp);
$tmp = undef;

=item C<$verbose>

Enable verbosity messages.  These messages are meant for ordinary
users, and typically make explicit the steps being performed.

=cut

use vars qw ($verbose);
$verbose = 0;

=item C<$version>

Set to the version message associated to the option C<--version>.

=cut

use vars qw ($version);
$version = undef;

=back

=cut


## ------------ ##
## Prototypes.  ##
## ------------ ##

sub verbose (@);


## ----- ##
## END.  ##
## ----- ##

=head2 Functions

=over 4

=item C<END>

Filter Perl's exit codes, delete any temporary directory (unless
C<$debug>), and exit nonzero whenever closing C<STDOUT> fails.

=cut

# END
# ---
sub END
{
  # $? contains the exit status we will return.
  # It was set using one of the following ways:
  #
  #  1) normal termination
  #     this sets $? = 0
  #  2) calling `exit (n)'
  #     this sets $? = n
  #  3) calling die or friends (croak, confess...):
  #     a) when $! is non-0
  #        this set $? = $!
  #     b) when $! is 0 but $? is not
  #        this sets $? = ($? >> 8)   (i.e., the exit code of the
  #        last program executed)
  #     c) when both $! and $? are 0
  #        this sets $? = 255
  #
  # Cases 1), 2), and 3b) are fine, but we prefer $? = 1 for 3a) and 3c).
  $? = 1 if ($! && $! == $?) || $? == 255;
  # (Note that we cannot safely distinguish calls to `exit (n)'
  # from calls to die when `$! = n'.  It's not big deal because
  # we only call `exit (0)' or `exit (1)'.)

  if (!$debug && defined $tmp && -d $tmp)
    {
      if (<$tmp/*>)
	{
	  if (! unlink <$tmp/*>)
	    {
	      print STDERR "$me: cannot empty $tmp: $!\n";
	      $? = 1;
	      return;
	    }
	}
      if (! rmdir $tmp)
	{
	  print STDERR "$me: cannot remove $tmp: $!\n";
	  $? = 1;
	  return;
	}
    }

  # This is required if the code might send any output to stdout
  # E.g., even --version or --help.  So it's best to do it unconditionally.
  if (! close STDOUT)
    {
      print STDERR "$me: closing standard output: $!\n";
      $? = 1;
      return;
    }
}


## ----------- ##
## Functions.  ##
## ----------- ##

=item C<catfile ()>

Wrapper around C<File::Spec->catfile>.  Concatenate one or more
directory names and a filename to form a complete path ending with a
filename.

=cut

# $FILE
# &catfile (@COMPONENT)
# ---------------------
sub catfile (@)
{
  my (@component) = @_;
  return File::Spec->catfile (@component);
}


=item C<canonpath ()>

Wrapper around C<File::Spec->canonpath>.  No physical check on the
filesystem, but a logical cleanup of a path. On UNIX eliminates
successive slashes and successive "/.".

    $cpath = canonpath ($path) ;

=cut

# $FILE
# &canonpath ($FILE)
# ------------------
sub canonpath ($)
{
  my ($file) = @_;
  return File::Spec->canonpath ($file);
}


=item C<contents ($filename)>

Return the contents of c<$filename>.  Exit with diagnostic on failure.

=cut

# &contents ($FILENAME)
# ---------------------
# Swallow the contents of file $FILENAME.
sub contents ($)
{
  my ($file) = @_;
  verbose "reading $file";
  local $/;			# Turn on slurp-mode.
  my $f = new Autom4te::XFile "< $file";
  my $contents = $f->getline;
  $f->close;
  return $contents;
}


=item C<debug (@message)>

If the debug mode is enabled (C<$debug> and C<$verbose>), report the
C<@message> on C<STDERR>, signed with the name of the program.

=cut

# &debug(@MESSAGE)
# ----------------
# Messages displayed only if $DEBUG and $VERBOSE.
sub debug (@)
{
  print STDERR "$me: ", @_, "\n"
    if $verbose && $debug;
}


=item C<error (@message)>

Report the C<@message> on C<STDERR>, signed with the name of the
program, and exit with failure.  If the debug mode is enabled
(C<$debug>), then in addition dump the call stack.

=cut

# &error (@MESSAGE)
# -----------------
# Same as die or confess, depending on $debug.
sub error (@)
{
  if ($debug)
    {
      confess "$me: ", @_, "\n";
    }
  else
    {
      die "$me: ", @_, "\n";
    }
}


=item C<file_name_is_absolute ($filename)>

Wrapper around C<File::Spec->file_name_is_absolute>.  Return true iff
C<$filename> is absolute.

=cut

# $BOOLEAN
# &file_name_is_absolute ($FILE)
# ------------------------------
sub file_name_is_absolute ($)
{
  my ($file) = @_;
  return File::Spec->file_name_is_absolute ($file);
}


=item C<find_configure_ac ([$directory = C<.>])>

Look for C<configure.ac> or C<configure.in> in the C<$directory> and
return the one which should be used.  Report ambiguities to the user,
but prefer C<configure.ac>.

=cut

# $CONFIGURE_AC
# &find_configure_ac ([$DIRECTORY = `.'])
# ---------------------------------------
sub find_configure_ac (;$)
{
  my ($directory) = @_;
  $directory ||= '.';
  my $configure_ac = canonpath (catfile ($directory, 'configure.ac'));
  my $configure_in = canonpath (catfile ($directory, 'configure.in'));

  if (-f $configure_ac)
    {
      if (-f $configure_in)
	{
	  carp "$me: warning: `$configure_ac' and `$configure_in' both present.\n";
	  carp "$me: warning: proceeding with `$configure_ac'.\n";
	}
      return $configure_ac;
    }
  elsif (-f $configure_in)
    {
      return $configure_in;
    }
  return;
}


=item C<find_file ($filename, @include)>

Return the first path for a C<$filename> in the C<include>s.

We match exactly the behavior of GNU M4: first look in the current
directory (which includes the case of absolute file names), and, if
the file is not absolute, just fail.  Otherwise, look in C<@include>.

If the file is flagged as optional (ends with C<?>), then return undef
if absent, otherwise exit with error.

=cut

# $FILENAME
# find_file ($FILENAME, @INCLUDE)
# -------------------------------
sub find_file ($@)
{
  my ($filename, @include) = @_;
  my $optional = 0;

  $optional = 1
    if $filename =~ s/\?$//;

  return canonpath ($filename)
    if -e $filename;

  if (file_name_is_absolute ($filename))
    {
      error "no such file or directory: $filename"
	unless $optional;
      return undef;
    }

  foreach my $path (@include)
    {
      return canonpath (catfile ($path, $filename))
	if -e catfile ($path, $filename);
    }

  error "no such file or directory: $filename"
    unless $optional;

  return undef;
}


=item C<getopt (%option)>

Wrapper around C<Getopt::Long>.  In addition to the user C<option>s,
support C<-h>/C<--help>, C<-V>/C<--version>, C<-v>/C<--verbose>,
C<-d>/C<--debug>, C<-f>/C<--force>.  Conform to the GNU Coding
Standards for error messages.  Try to work around a weird behavior
from C<Getopt::Long> to preserve C<-> as an C<@ARGV> instead of
rejecting it as a broken option.

=cut

# getopt (%OPTION)
# ----------------
# Handle the %OPTION, plus all the common options.
# Work around Getopt bugs wrt `-'.
sub getopt (%)
{
  my (%option) = @_;
  use Getopt::Long;

  # F*k.  Getopt seems bogus and dies when given `-' with `bundling'.
  # If fixed some day, use this: '' => sub { push @ARGV, "-" }
  my $stdin = grep /^-$/, @ARGV;
  @ARGV = grep !/^-$/, @ARGV;
  %option = ("h|help"     => sub { print $help; exit 0 },
	     "V|version"  => sub { print $version; exit 0 },

	     "v|verbose"    => \$verbose,
	     "d|debug"      => \$debug,
	     'f|force'      => \$force,

	     # User options last, so that they have precedence.
	     %option);
  Getopt::Long::Configure ("bundling", "pass_through");
  GetOptions (%option)
    or exit 1;

  foreach (grep { /^-./ } @ARGV)
    {
      print STDERR "$0: unrecognized option `$_'\n";
      print STDERR "Try `$0 --help' for more information.\n";
      exit (1);
    }

  push @ARGV, '-'
    if $stdin;
}


=item C<mktmpdir ($signature)>

Create a temporary directory which name is based on C<$signature>.
Store its name in C<$tmp>.  C<END> is in charge of removing it, unless
C<$debug>.

=cut

# mktmpdir ($SIGNATURE)
# ---------------------
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


=item C<mtime ($file)>

Return the mtime of C<$file>.  Missing files, or C<-> standing for
C<STDIN> or C<STDOUT> are ``obsolete'', i.e., as old as possible.

=cut

# $MTIME
# MTIME ($FILE)
# -------------
sub mtime ($)
{
  my ($file) = @_;

  return 0
    if $file eq '-' || ! -f $file;

  my $stat = stat ($file)
    or croak "$me: cannot stat $file: $!\n";

  return $stat->mtime;
}


=item C<uniq (@list)>

Return C<@list> with no duplicates, keeping only the first
occurrences.

=cut

# @RES
# uniq (@LIST)
# ------------
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


=item C<up_to_date_p ($file, @dep)>

Is C<$file> more recent than C<@dep>?

=cut

# $BOOLEAN
# &up_to_date_p ($FILE, @DEP)
# ---------------------------
sub up_to_date_p ($@)
{
  my ($file, @dep) = @_;
  my $mtime = mtime ($file);

  foreach my $dep (@dep)
    {
      if ($mtime < mtime ($dep))
	{
	  debug "up_to_date ($file): outdated: $dep";
	  return 0;
	}
    }

  debug "up_to_date ($file): up to date";
  return 1;
}


=item C<update_file ($from, $to)>

Rename C<$from> as C<$to>, preserving C<$to> timestamp if it has not
changed.  Recognize C<$to> = C<-> standing for C<STDIN>.  C<$from> is
always removed/renamed.

=cut

# &update_file ($FROM, $TO)
# -------------------------
sub update_file ($$)
{
  my ($from, $to) = @_;
  my $SIMPLE_BACKUP_SUFFIX = $ENV{'SIMPLE_BACKUP_SUFFIX'} || '~';
  use File::Compare;
  use File::Copy;

  if ($to eq '-')
    {
      my $in = new IO::File ("$from");
      my $out = new IO::File (">-");
      while ($_ = $in->getline)
	{
	  print $out $_;
	}
      $in->close;
      unlink ($from)
	or error "cannot not remove $from: $!";
      return;
    }

  if (-f "$to" && compare ("$from", "$to") == 0)
    {
      # File didn't change, so don't update its mod time.
      verbose "`$to' is unchanged";
      unlink ($from)
	or error "cannot not remove $from: $!";
      return
    }

  if (-f "$to")
    {
      # Back up and install the new one.
      move ("$to",  "$to$SIMPLE_BACKUP_SUFFIX")
	or error "cannot not backup $to: $!";
      move ("$from", "$to")
	or error "cannot not rename $from as $to: $!";
      verbose "`$to' is updated";
    }
  else
    {
      move ("$from", "$to")
	or error "cannot not rename $from as $to: $!";
      verbose "`$to' is created";
    }
}


=item C<verbose (@message)>

If the verbose mode is enabled (C<$verbose>), report the C<@message>
on C<STDERR>, signed with the name of the program.  These messages are
meant for ordinary users, and typically make explicit the steps being
performed.

=cut

# verbose(@MESSAGE)
# -----------------
sub verbose (@)
{
  print STDERR "$me: ", @_, "\n"
    if $verbose;
}


=item C<handle_exec_errors ($command)>

Display an error message for C<$command>, based on the content of
C<$?> and C<$!>.

=cut


# handle_exec_errors ($COMMAND)
# -----------------------------
sub handle_exec_errors ($)
{
  my ($command) = @_;

  $command = (split (' ', $command))[0];
  if ($!)
    {
      error "failed to run $command: $!";
    }
  else
    {
      use POSIX qw (WIFEXITED WEXITSTATUS WIFSIGNALED WTERMSIG);

      if (WIFEXITED ($?))
	{
	  my $status = WEXITSTATUS ($?);
	  # WIFEXITED and WEXITSTATUS can alter $!, reset it so that
	  # error() actually propagates the command's exit status, not $!.
	  $! = 0;
	  error "$command failed with exit status: $status";
	}
      elsif (WIFSIGNALED ($?))
	{
	  my $signal = WTERMSIG ($?);
	  # In this case we prefer to exit with status 1.
	  $! = 1;
	  error "$command terminated by signal: $signal";
	}
      else
	{
	  error "$command exited abnormally";
	}
    }
}


=item C<xqx ($command)>

Same as C<qx> (but in scalar context), but fails on errors.

=cut

# xqx ($COMMAND)
# --------------
sub xqx ($)
{
  my ($command) = @_;

  verbose "running: $command";

  $! = 0;
  my $res = `$command`;
  handle_exec_errors $command
    if $?;

  return $res;
}


=item C<xqx ($command)>

Same as C<xsystem>, but fails on errors, and reports the C<$command>
in verbose mode.

=cut

# xsystem ($COMMAND)
# ------------------
sub xsystem ($)
{
  my ($command) = @_;

  verbose "running: $command";

  $! = 0;
  handle_exec_errors $command
    if system $command;
}

=back

=head1 SEE ALSO

L<Autom4te::XFile>

=head1 HISTORY

Written by Alexandre Duret-Lutz E<lt>F<adl@gnu.org>E<gt> and Akim
Demaille E<lt>F<akim@freefriends.org>E<gt>.

=cut



1; # for require

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
