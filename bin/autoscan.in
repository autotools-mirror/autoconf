#! @PERL@ -w
# autoscan - Create configure.scan (a preliminary configure.in) for a package.
# Copyright (C) 1994, 99, 2000 Free Software Foundation, Inc.

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

require "find.pl";
use Getopt::Long;

$datadir = $ENV{"AC_MACRODIR"} || "@datadir@";
($me = $0) =~ s,.*/,,;
$verbose = 0;

# Reference these variables to pacify perl -w.
undef %identifiers_macros;
undef %makevars_macros;
undef %programs_macros;

&parse_args;
&init_tables;
&find('.');
&scan_files;
&output;

exit 0;

# Display usage (--help).
sub print_usage
{
  print "Usage: $0 [OPTION] ... [SRCDIR]

Examine source files in the directory tree rooted at SRCDIR, or the
current directory if none is given.  Search the source files for
common portability problems and create a file `configure.scan' which
is a preliminary `configure.in' for that package.

  -h, --help            print this help, then exit
  -V, --version         print version number, then exit
  -v, --verbose         verbosely report processing

Library directories:
  -A, --autoconf-dir=ACDIR  Autoconf's files location (rarely needed)
  -l, --localdir=DIR        location of `aclocal.m4' and `acconfig.h'

Report bugs to <bug-autoconf\@gnu.org>.\n";
  exit 0;
}

# Display version (--version).
sub print_version
{
  print "autoscan (GNU @PACKAGE@) @VERSION@
Written by David J. MacKenzie.

Copyright (C) 1994, 99, 2000 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n";
  exit 0;
}

# Process any command line arguments.
sub parse_args
{
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
    if !defined($srcdir);

  print "srcdir=$srcdir\n" if $verbose;
  chdir $srcdir || die "$me: cannot cd to $srcdir: $!\n";

  open (CONF, ">configure.scan") ||
    die "$me: cannot create configure.scan: $!\n";
}

# Put values in the tables of what to do with each token.
sub init_tables
{
  local($kind, $word, $macro);

  # Initialize a table of C keywords (to ignore).
  # Taken from K&R 1st edition p. 180.
  # ANSI C, GNU C, and C++ keywords can introduce portability problems,
  # so don't ignore them.
  foreach $word ('int', 'char', 'float', 'double', 'struct', 'union',
		 'long', 'short', 'unsigned', 'auto', 'extern', 'register',
		 'typedef', 'static', 'goto', 'return', 'sizeof', 'break',
		 'continue', 'if', 'else', 'for', 'do', 'while', 'switch',
		 'case', 'default') {
    $c_keywords{$word} = 0;
  }

  # The data file format supports only one line of macros per function.
  # If more than that is required for a common portability problem,
  # a new Autoconf macro should probably be written for that case,
  # instead of duplicating the code in lots of configure.in files.

  foreach $kind ('functions', 'headers', 'identifiers', 'programs',
		 'makevars') {
    open(TABLE, "<$datadir/ac$kind") ||
      die "$me: cannot open $datadir/ac$kind: $!\n";
    while (<TABLE>) {
      next if /^\s*$/ || /^\s*#/; # Ignore blank lines and comments.
	($word, $macro) = split;
      eval "\$$kind" . "_macros{\$word} = \$macro";
    }
    close(TABLE);
  }
}

# Collect names of various kinds of files in the package.
# Called by &find on each file.
sub wanted
{
  if (/^.*\.[chlymC]$/ || /^.*\.cc$/) {
    $name =~ s?^\./??; push(@cfiles, $name);
  }
  elsif (/^[Mm]akefile$/ || /^[Mm]akefile\.in$/ || /^GNUmakefile$/) {
    $name =~ s?^\./??; push(@makefiles, $name);
  }
  elsif (/^.*\.sh$/) {
    $name =~ s?^\./??; push(@shfiles, $name);
  }
}

# Read through the files and collect lists of tokens in them
# that might create nonportabilities.
sub scan_files
{
  $initfile = $cfiles[0];		# Pick one at random.

  if ($verbose) {
    print "cfiles:", join(" ", @cfiles), "\n";
    print "makefiles:", join(" ", @makefiles), "\n";
    print "shfiles:", join(" ", @shfiles), "\n";
  }

  foreach $file (@cfiles) {
    $programs{"cc"}++;
    &scan_c_file($file);
  }

  foreach $file (@makefiles) {
    &scan_makefile($file);
  }

  foreach $file (@shfiles) {
    &scan_sh_file($file);
  }
}

sub scan_c_file
{
  local($file) = @_;
  local($in_comment) = 0;	# Nonzero if in a multiline comment.

  open(CFILE, "<$file") || die "$me: cannot open $file: $!\n";
  while (<CFILE>) {
    # Strip out comments, approximately.
    # Ending on this line.
    if ($in_comment && m,\*/,) {
      s,.*\*/,,;
      $in_comment = 0;
    }
    # All on one line.
    s,/\*.*\*/,,g;
    # Starting on this line.
    if (m,/\*,) {
      $in_comment = 1;
    }
    # Continuing on this line.
    next if $in_comment;

    # Preprocessor directives.
    if (/^\s*\#\s*include\s*<([^>]*)>/) {
      $headers{$1}++;
    }
    # Ignore other preprocessor directives.
    next if /^\s*\#/;

    # Remove string and character constants.
    s,\"[^\"]*\",,g;
    s,\'[^\']*\',,g;

    # Tokens in the code.
    # Maybe we should ignore function definitions (in column 0)?
    while (s/\W([a-zA-Z_]\w*)\s*\(/ /) {
      $functions{$1}++ if !defined($c_keywords{$1});
    }
    while (s/\W([a-zA-Z_]\w*)\W/ /) {
      $identifiers{$1}++ if !defined($c_keywords{$1});
    }
  }
  close(CFILE);

  if ($verbose) {
    local($word);

    print "\n$file functions:\n";
    foreach $word (sort keys %functions) {
      print "$word $functions{$word}\n";
    }

    print "\n$file identifiers:\n";
    foreach $word (sort keys %identifiers) {
      print "$word $identifiers{$word}\n";
    }

    print "\n$file headers:\n";
    foreach $word (sort keys %headers) {
      print "$word $headers{$word}\n";
    }
  }
}

sub scan_makefile
{
  local($file) = @_;

  open(MFILE, "<$file") || die "$me: cannot open $file: $!\n";
  while (<MFILE>) {
    # Strip out comments and variable references.
    s/#.*//;
    s/\$\([^\)]*\)//g;
    s/\${[^\}]*}//g;
    s/@[^@]*@//g;

    # Variable assignments.
    while (s/\W([a-zA-Z_]\w*)\s*=/ /) {
      $makevars{$1}++;
    }
    # Libraries.
    while (s/\W-l([a-zA-Z_]\w*)\W/ /) {
      $libraries{$1}++;
    }
    # Tokens in the code.
    while (s/\W([a-zA-Z_]\w*)\W/ /) {
      $programs{$1}++;
    }
  }
  close(MFILE);

  if ($verbose) {
    local($word);

    print "\n$file makevars:\n";
    foreach $word (sort keys %makevars) {
      print "$word $makevars{$word}\n";
    }

    print "\n$file libraries:\n";
    foreach $word (sort keys %libraries) {
      print "$word $libraries{$word}\n";
    }

    print "\n$file programs:\n";
    foreach $word (sort keys %programs) {
      print "$word $programs{$word}\n";
    }
  }
}

sub scan_sh_file
{
  local($file) = @_;

  open(MFILE, "<$file") || die "$me: cannot open $file: $!\n";
  while (<MFILE>) {
    # Strip out comments and variable references.
    s/#.*//;
    s/\${[^\}]*}//g;
    s/@[^@]*@//g;

    # Tokens in the code.
    while (s/\W([a-zA-Z_]\w*)\W/ /) {
      $programs{$1}++;
    }
  }
  close(MFILE);

  if ($verbose) {
    local($word);

    print "\n$file programs:\n";
    foreach $word (sort keys %programs) {
      print "$word $programs{$word}\n";
    }
  }
}

# Print a configure.in.
sub output
{
  local (%unique_makefiles);

  print CONF "# Process this file with autoconf to produce a configure script.\n";
  print CONF "AC_INIT($initfile)\n";

  &output_programs;
  &output_headers;
  &output_identifiers;
  &output_functions;

  # Change DIR/Makefile.in to DIR/Makefile.
  foreach $_ (@makefiles) {
    s/\.in$//;
    $unique_makefiles{$_}++;
  }
  print CONF "\nAC_OUTPUT([", join("\n           ", keys(%unique_makefiles)), "])\n";

  close CONF;
}

# Print Autoconf macro $1 if it's not undef and hasn't been printed already.
sub print_unique
{
  local($macro) = @_;

  if (defined($macro) && !defined($printed{$macro})) {
    print CONF "$macro\n";
    $printed{$macro} = 1;
  }
}

sub output_programs
{
  local ($word);

  print CONF "\n# Checks for programs.\n";
  foreach $word (sort keys %programs) {
    &print_unique($programs_macros{$word});
  }
  foreach $word (sort keys %makevars) {
    &print_unique($makevars_macros{$word});
  }
  print CONF "\n# Checks for libraries.\n";
  foreach $word (sort keys %libraries) {
    print CONF "# FIXME: Replace `main' with a function in `-l$word':\n";
    print CONF "AC_CHECK_LIB([$word], [main])\n";
  }
}

sub output_headers
{
  local ($word);

  print CONF "\n# Checks for header files.\n";
  foreach $word (sort keys %headers) {
    if (defined($headers_macros{$word}) &&
	$headers_macros{$word} eq 'AC_CHECK_HEADERS') {
      push(@have_headers, $word);
    } else {
      &print_unique($headers_macros{$word});
    }
  }
  print CONF "AC_CHECK_HEADERS([" . join(' ', sort(@have_headers)) . "])\n"
    if defined(@have_headers);
}

sub output_identifiers
{
  local ($word);

  print CONF "\n# Checks for typedefs, structures, and compiler characteristics.\n";
  foreach $word (sort keys %identifiers) {
    if (defined ($identifiers_macros{$word}) &&
	$identifiers_macros{$word} eq 'AC_CHECK_TYPES') {
      push (@have_types, $word);
    } else {
      &print_unique ($identifiers_macros{$word});
    }
  }
  print CONF "AC_CHECK_TYPES([" . join(', ', sort(@have_types)) . "])\n"
    if defined (@have_types);
}

sub output_functions
{
  local ($word);

  print CONF "\n# Checks for library functions.\n";
  foreach $word (sort keys %functions) {
    if (defined($functions_macros{$word}) &&
	$functions_macros{$word} eq 'AC_CHECK_FUNCS') {
      push(@have_funcs, $word);
    } else {
      &print_unique($functions_macros{$word});
    }
  }
  print CONF "AC_CHECK_FUNCS([" . join(' ', sort(@have_funcs)) . "])\n"
    if defined(@have_funcs);
}
