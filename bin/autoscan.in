#! @PERL@ -w
# autoscan - Create configure.scan (a preliminary configure.ac) for a package.
# Copyright 1994, 1999, 2000, 2001 Free Software Foundation, Inc.

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

# Written by David MacKenzie <djm@gnu.ai.mit.edu>.

use 5.005;
require "find.pl";
use Getopt::Long;
use strict;

use vars qw($autoconf $datadir $initfile $me $name $verbose
            @cfiles @makefiles @shfiles
            %functions_macros %headers_macros %identifiers_macros
            %programs_macros %makevars_macros %needed_macros
            %c_keywords %programs %headers %identifiers %makevars
            %libraries %functions %printed);

($me = $0) =~ s,.*/,,;
$verbose = 0;

# Reference these variables to pacify perl -w.
%identifiers_macros = ();
%makevars_macros = ();
%programs_macros = ();
%needed_macros = ();

my @kinds = qw (functions headers identifiers programs makevars);

# For each kind, the default macro.
my %generic_macro =
  (
   'functions'   => 'AC_CHECK_FUNCS',
   'headers'     => 'AC_CHECK_HEADERS',
   'identifiers' => 'AC_CHECK_TYPES',
   'programs'    => 'AC_CHECK_PROGS'
  );


my $configure_scan = 'configure.scan';


# Exit nonzero whenever closing STDOUT fails.
sub END
{
  use POSIX qw (_exit);
  # This is required if the code might send any output to stdout
  # E.g., even --version or --help.  So it's best to do it unconditionally.
  close STDOUT
    or (warn "$me: closing standard output: $!\n"), _exit (1);
}

# find_autoconf
# -------------
# Find the lib files and autoconf.
sub find_autoconf
{
  $datadir = $ENV{"AC_MACRODIR"} || "@datadir@";
  (my $dir = $0) =~ s,[^/]*$,,;
  $autoconf = '';
  # We test "$dir/autoconf" in case we are in the build tree, in which case
  # the names are not transformed yet.
  foreach my $file ($ENV{"AUTOCONF"} || '',
		    "$dir/@autoconf-name@",
		    "$dir/autoconf",
		    "@bindir@/@autoconf-name@")
    {
      if (-x $file)
	{
	  $autoconf = $file;
	  last;
	}
    }
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
	  warn "warning: `configure.ac' and `configure.in' both present.\n";
	  warn "warning: proceeding with `configure.ac'.\n";
	}
      return 'configure.ac';
    }
  elsif (-f 'configure.in')
    {
      return 'configure.in';
    }
  return;
}


# print_usage ()
# --------------
# Display usage (--help).
sub print_usage ()
{
  print "Usage: $0 [OPTION] ... [SRCDIR]

Examine source files in the directory tree rooted at SRCDIR, or the
current directory if none is given.  Search the source files for
common portability problems and create a file `$configure_scan' which
is a preliminary `configure.ac' for that package.

  -h, --help            print this help, then exit
  -V, --version         print version number, then exit
  -v, --verbose         verbosely report processing

Library directories:
  -A, --autoconf-dir=ACDIR  Autoconf's files location (rarely needed)
  -l, --localdir=DIR        location of `aclocal.m4' and `acconfig.h'

Report bugs to <bug-autoconf\@gnu.org>.\n";
  exit 0;
}


# print_version ()
# ----------------
# Display version (--version).
sub print_version
{
  print "autoscan (@PACKAGE_NAME@) @VERSION@
Written by David J. MacKenzie.

Copyright 1994, 1999, 2000, 2001 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n";
  exit 0;
}


# parse_args ()
# -------------
# Process any command line arguments.
sub parse_args ()
{
  my $srcdir;
  Getopt::Long::config ("bundling");
  Getopt::Long::GetOptions ("A|autoconf-dir|m|macrodir=s" => \$datadir,
			    "h|help" => \&print_usage,
			    "V|version" => \&print_version,
			    "v|verbose" => \$verbose)
    or exit 1;

  die "$me: too many arguments
Try `$me --help' for more information.\n"
    if (@ARGV > 1);
  ($srcdir) = @ARGV;
  $srcdir = "."
    if !defined $srcdir;

  print "srcdir=$srcdir\n" if $verbose;
  chdir $srcdir || die "$me: cannot cd to $srcdir: $!\n";
}


# init_tables ()
# --------------
# Put values in the tables of what to do with each token.
sub init_tables ()
{
  # Initialize a table of C keywords (to ignore).
  # Taken from K&R 1st edition p. 180.
  # ANSI C, GNU C, and C++ keywords can introduce portability problems,
  # so don't ignore them.
  foreach my $word (qw (int char float double struct union long short
                        unsigned auto extern register typedef static
                        goto return sizeof break continue if else for
                        do while switch case default))
    {
      $c_keywords{$word} = 0;
    }

  # The data file format supports only one line of macros per function.
  # If more than that is required for a common portability problem,
  # a new Autoconf macro should probably be written for that case,
  # instead of duplicating the code in lots of configure.ac files.

  foreach my $kind (@kinds)
    {
      my $file = "$datadir/ac$kind";
      open TABLE, $file or
	die "$me: cannot open $file: $!\n";
      while (<TABLE>)
	{
	  # Ignore blank lines and comments.
	  next
	    if /^\s*$/ || /^\s*\#/;
	  unless (/^(\S+)\s+(\S.*)$/ || /^(\S+)\s*$/)
	    {
	      die "$me: cannot parse definition in $file:\n$_\n";
	    }
	  my $word = $1;
	  my $macro = $2 || $generic_macro{$kind};
	  eval "\$$kind" . "_macros{\$word} = \$macro";
	}
      close(TABLE);
    }
}


# wanted ()
# ---------
# Collect names of various kinds of files in the package.
# Called by &find on each file.
sub wanted ()
{
  # Strip a useless leading `./'.
  $name =~ s,^\./,,;

  if (/^.*\.[chlymC]$/ || /^.*\.cc$/)
    {
      push (@cfiles, $name);
    }
  elsif (/^[Mm]akefile$/ || /^GNUmakefile$/)
    {
      # Wanted only if there is no corresponding Makefile.in.
      # Using Find, $_ contains the current filename with the current
      # directory of the walk through.
      push (@makefiles, $name)
	if ! -f "$_.in";
    }
  elsif (/^[Mm]akefile\.in$/)
    {
      push (@makefiles, $name);
    }
  elsif (/^.*\.sh$/)
    {
      push (@shfiles, $name);
    }
}


# scan_files ()
# -------------
# Read through the files and collect lists of tokens in them
# that might create nonportabilities.
sub scan_files ()
{
  my $file;
  if (defined $cfiles[0])
    {
      $initfile = $cfiles[0];		# Pick one at random.
    }

  foreach $file (@cfiles)
    {
      push (@{$programs{"cc"}}, $file);
      scan_c_file ($file);
    }

  foreach $file (@makefiles)
    {
      scan_makefile ($file);
    }

  foreach $file (@shfiles)
    {
      scan_sh_file ($file);
    }

  if ($verbose)
    {
      print "cfiles:", join(" ", @cfiles), "\n";
      print "makefiles:", join(" ", @makefiles), "\n";
      print "shfiles:", join(" ", @shfiles), "\n";

      foreach my $class (qw (functions identifiers headers
                       makevars libraries programs))
	{
	  print "\n$class:\n";
	  my $h = eval "\\\%$class";
	  foreach my $word (sort keys %$h)
	    {
	      print "$word: @{$h->{$word}}\n";
	    }
	}
    }
}


# scan_c_file(FILE)
# -----------------
sub scan_c_file ($)
{
  my ($file) = @_;
  my ($in_comment) = 0;	# Nonzero if in a multiline comment.

  open(CFILE, "<$file") || die "$me: cannot open $file: $!\n";
  while (<CFILE>)
    {
      # Strip out comments, approximately.
      # Ending on this line.
      if ($in_comment && m,\*/,)
	{
	  s,.*\*/,,;
	  $in_comment = 0;
	}
      # All on one line.
      s,/\*.*\*/,,g;
      # Starting on this line.
      if (m,/\*,)
	{
	  $in_comment = 1;
	}
      # Continuing on this line.
      next if $in_comment;

      # Preprocessor directives.
      if (/^\s*\#\s*include\s*<([^>]*)>/)
	{
	  push (@{$headers{$1}}, "$file:$.");
	}
      # Ignore other preprocessor directives.
      next if /^\s*\#/;

      # Remove string and character constants.
      s,\"[^\"]*\",,g;
      s,\'[^\']*\',,g;

      # Tokens in the code.
      # Maybe we should ignore function definitions (in column 0)?
      while (s/\b([a-zA-Z_]\w*)\s*\(/ /)
	{
	  push (@{$functions{$1}}, "$file:$.")
	    if !defined $c_keywords{$1};
	}
      while (s/\b([a-zA-Z_]\w*)\b/ /)
	{
	  push (@{$identifiers{$1}}, "$file:$.")
	    if !defined $c_keywords{$1};
	}
    }
  close(CFILE);
}


# scan_makefile(MAKEFILE)
# -----------------------
sub scan_makefile ($)
{
  my ($file) = @_;

  open(MFILE, "<$file") || die "$me: cannot open $file: $!\n";
  while (<MFILE>)
    {
      # Strip out comments and variable references.
      s/#.*//;
      s/\$\([^\)]*\)//g;
      s/\${[^\}]*}//g;
      s/@[^@]*@//g;

      # Variable assignments.
      while (s/\b([a-zA-Z_]\w*)\s*=/ /)
	{
	  push (@{$makevars{$1}}, "$file:$.");
	}
      # Libraries.
      while (s/\B-l([a-zA-Z_]\w*)\b/ /)
	{
	  push (@{$libraries{$1}}, "$file:$.");
	}
      # Tokens in the code.
      while (s/\b([a-zA-Z_]\w*)\b/ /)
	{
	  push (@{$programs{$1}}, "$file:$.");
	}
    }
  close(MFILE);
}


# scan_sh_file(SHELL-SCRIPT)
# --------------------------
sub scan_sh_file ($)
{
  my ($file) = @_;

  open(MFILE, "<$file") || die "$me: cannot open $file: $!\n";
  while (<MFILE>)
    {
      # Strip out comments and variable references.
      s/#.*//;
      s/\${[^\}]*}//g;
      s/@[^@]*@//g;

      # Tokens in the code.
      while (s/\b([a-zA-Z_]\w*)\b/ /)
	{
	  push (@{$programs{$1}}, "$file:$.");
	}
    }
  close(MFILE);
}


# print_unique ($MACRO, @WHERE)
# -----------------------------
# $MACRO is wanted from $WHERE, hence (i) print $MACRO in $configure_scan
# if it exists and hasn't been printed already, (ii), remember it's needed.
sub print_unique ($@)
{
  my ($macro, @where) = @_;

  if (defined $macro && !defined $printed{$macro})
    {
      print CONF "$macro\n";
      $printed{$macro} = 1;

      push (@{$needed_macros{$macro}}, @where);
    }
}


# output_programs ()
# ------------------
sub output_programs ()
{
  print CONF "\n# Checks for programs.\n";
  foreach my $word (sort keys %programs)
    {
      print_unique ($programs_macros{$word}, @{$programs{$word}});
    }
  foreach my $word (sort keys %makevars)
    {
      print_unique ($makevars_macros{$word}, @{$makevars{$word}});
    }
}


# output_libraries ()
# -------------------
sub output_libraries ()
{
  print CONF "\n# Checks for libraries.\n";
  foreach my $word (sort keys %libraries)
    {
      print CONF "# FIXME: Replace `main' with a function in `-l$word':\n";
      print CONF "AC_CHECK_LIB([$word], [main])\n";
    }
}


# output_headers ()
# -----------------
sub output_headers ()
{
  my @have_headers;

  print CONF "\n# Checks for header files.\n";
  foreach my $word (sort keys %headers)
    {
      if (defined $headers_macros{$word})
	{
	  if ($headers_macros{$word} eq 'AC_CHECK_HEADERS')
	    {
	      push (@have_headers, $word);
	      push (@{$needed_macros{"AC_CHECK_HEADERS([$word])"}},
		    @{$headers{$word}});
	    }
	  else
	    {
	      print_unique ($headers_macros{$word}, @{$headers{$word}});
	    }
	}
    }
  print CONF "AC_CHECK_HEADERS([" . join(' ', sort(@have_headers)) . "])\n"
    if @have_headers;
}


# output_identifiers ()
# ---------------------
sub output_identifiers ()
{
  my @have_types;

  print CONF "\n# Checks for typedefs, structures, and compiler characteristics.\n";
  foreach my $word (sort keys %identifiers)
    {
      if (defined $identifiers_macros{$word})
	{
	  if ($identifiers_macros{$word} eq 'AC_CHECK_TYPES')
	    {
	      push (@have_types, $word);
	      push (@{$needed_macros{"AC_CHECK_TYPES([$word])"}},
		    @{$identifiers{$word}});
	    }
	  else
	    {
	      print_unique ($identifiers_macros{$word},
			    @{$identifiers{$word}});
	    }
	}
    }
  print CONF "AC_CHECK_TYPES([" . join(', ', sort(@have_types)) . "])\n"
    if @have_types;
}


# output_functions ()
# -------------------
sub output_functions ()
{
  my @have_funcs;

  print CONF "\n# Checks for library functions.\n";
  foreach my $word (sort keys %functions)
    {
      if (defined $functions_macros{$word})
	{
	  if ($functions_macros{$word} eq 'AC_CHECK_FUNCS')
	    {
	      push (@have_funcs, $word);
	      push (@{$needed_macros{"AC_CHECK_FUNCS([$word])"}},
		    @{$functions{$word}});
	    }
	  else
	    {
	      print_unique ($functions_macros{$word},
			    @{$functions{$word}});
	    }
	}
    }
  print CONF "AC_CHECK_FUNCS([" . join(' ', sort(@have_funcs)) . "])\n"
    if @have_funcs;
}


# output (CONFIGURE_SCAN)
# -----------------------
# Print a proto configure.ac.
sub output ($)
{
  my $configure_scan = shift;
  my %unique_makefiles;

  open (CONF, ">$configure_scan") ||
    die "$me: cannot create $configure_scan: $!\n";

  print CONF "# Process this file with autoconf to produce a configure script.\n";
  print CONF "AC_INIT\n";
  if (defined $initfile)
    {
      print CONF "AC_CONFIG_SRCDIR([$initfile])\n";
    }
  if (defined $cfiles[0])
    {
      print CONF "AC_CONFIG_HEADER([config.h])\n";
    }

  output_programs;
  output_libraries;
  output_headers;
  output_identifiers;
  output_functions;

  # Change DIR/Makefile.in to DIR/Makefile.
  foreach my $m (@makefiles)
    {
      $m =~ s/\.in$//;
      $unique_makefiles{$m}++;
    }
  print CONF "\nAC_CONFIG_FILES([",
       join ("\n                 ", keys(%unique_makefiles)), "])\n";
  print CONF "AC_OUTPUT\n";

  close CONF ||
    die "$me: closing $configure_scan: $!\n";
}


# check_configure_ac (CONFIGURE_AC)
# ---------------------------------
# Use autoconf to check if all the suggested macros are included
# in CONFIGURE_AC.
sub check_configure_ac ($)
{
  my ($configure_ac) = $@;
  my ($trace_option) = '';

  foreach my $macro (sort keys %needed_macros)
    {
      $macro =~ s/\(.*//;
      $trace_option .= " -t $macro";
    }

  open (TRACES, "$autoconf -A $datadir $trace_option $configure_ac|") ||
    die "$me: cannot create read traces: $!\n";

  while (<TRACES>)
    {
      chomp;
      my ($file, $line, $macro, @args) = split (/:/, $_);
      if ($macro =~ /^AC_CHECK_(HEADER|FUNC|TYPE|MEMBER)S$/)
	{
	  # To be rigorous, we should distinguish between space and comma
	  # separated macros.  But there is no point.
	  foreach my $word (split (/\s|,/, $args[0]))
	    {
	      # AC_CHECK_MEMBERS wants `struct' or `union'.
	      if ($macro eq "AC_CHECK_MEMBERS"
		  && $word =~ /^stat.st_/)
		{
		  $word = "struct " . $word;
		}
	      delete ($needed_macros{"$macro([$word])"});
	    }
	}
      else
	{
	  delete ($needed_macros{$macro});
	}
    }

  close (TRACES) ||
    die "$me: cannot close traces: $!\n";

  foreach my $macro (sort keys %needed_macros)
    {
      warn "$me: warning: missing $macro wanted by: \n";
      foreach my $need (@{$needed_macros{$macro}})
        {
          warn "\t$need\n";
        }
    }
}


## -------------- ##
## Main program.  ##
## -------------- ##

# Find the lib files and autoconf.
find_autoconf;
my $configure_ac = find_configure_ac;
parse_args;
init_tables;
find ('.');
scan_files;
output ('configure.scan');
if ($configure_ac)
  {
    check_configure_ac ($configure_ac);
  }

exit 0;
