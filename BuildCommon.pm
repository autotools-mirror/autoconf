# Written by Zack Weinberg <zackw at panix.com> in 2017, 2020, 2021.
# To the extent possible under law, Zack Weinberg has waived all
# copyright and related or neighboring rights to this work.
#
# See https://creativecommons.org/publicdomain/zero/1.0/ for further
# details.

package BuildCommon;

use v5.14;    # implicit use strict, use feature ':5.14'
use warnings FATAL => 'all';
use utf8;
use open qw(:utf8);
no  if $] >= 5.018, warnings => 'experimental::smartmatch';
no  if $] >= 5.022, warnings => 'experimental::re_strict';
use if $] >= 5.022, re       => 'strict';

use Cwd qw(realpath);
use File::Spec::Functions qw(
    catfile
    catpath
    file_name_is_absolute
    path
    splitpath
);
use FindBin ();
use POSIX   ();

our @EXPORT_OK;
use Exporter qw(import);

BEGIN {
    @EXPORT_OK = qw(
        ensure_C_locale
        error
        popen
        run
        sh_split
        sh_quote
        subprocess_error
        which
    );
}

#
# Utilities for dealing with subprocesses.
#

# Diagnostics: report some kind of catastrophic internal error.
# Exit code 99 tells the Automake test driver to mark a test as
# 'errored' rather than 'failed'.
sub error {    ## no critic (Subroutines::RequireArgUnpacking)
    my $msg = join q{ }, @_;
    print {*STDERR} $FindBin::Script, ': ERROR: ', $msg, "\n";
    exit 99;
}

# Like 'error', but the problem was with a subprocess, detected upon
# trying to start the program named as @_.
sub invocation_error {    ## no critic (Subroutines::RequireArgUnpacking)
    my $err = "$!";
    my $cmd = join q{ }, @_;
    error("failed to invoke $cmd: $err");
}

# Like 'error', but the problem was with a subprocess, detected upon
# termination of the program named as @_; interpret both $! and $?
# appropriately.
sub subprocess_error {    ## no critic (Subroutines::RequireArgUnpacking)
    my $syserr = $!;
    my $status = $?;
    my $cmd    = join q{ }, @_;
    if ($syserr) {
        error("system error with pipe to $cmd: $syserr");

    } elsif ($status == 0) {
        return;

    } elsif (($status & 0xFF) == 0) {
        # we wouldn't be here if the exit status was zero
        error("$cmd: exit " . ($status >> 8));

    } else {
        my $sig = ($status & 0x7F);
        # Neither Perl core nor the POSIX module exposes strsignal.
        # This is the least terrible kludge I can presently find;
        # it decodes the numbers to their <signal.h> constant names
        # (e.g. "SIGKILL" instead of "Killed" for signal 9).
        # Linear search through POSIX's hundreds of symbols is
        # acceptable because this function terminates the process,
        # so it can only ever be called once per run.
        my $signame;
        while (my ($name, $glob) = each %{'POSIX::'}) {
            if ($name =~ /^SIG(?!_|RT)/ && (${$glob} // -1) == $sig) {
                $signame = $name;
                last;
            }
        }
        $signame //= "signal $sig";
        error("$cmd: killed by $signame");
    }
}

# Split a string into words, exactly the way the Bourne shell would do
# it, with the default setting of IFS, when the string is the result
# of a variable expansion.  If any of the resulting words would be
# changed by filename expansion, throw an exception, otherwise return
# a list of the words.
#
# Note: the word splitting process does *not* look for nested
# quotation, substitutions, or operators.  For instance, if a
# shell variable was set with
#    var='"ab cd"'
# then './a.out $var' would pass two arguments to a.out:
# '"ab' and 'cd"'.
sub sh_split {
    my @words = split /[ \t\n]+/, shift;
    for my $w (@words) {
        die "sh_split: '$w' could be changed by filename expansion"
            if $w =~ / (?<! \\) [\[?*] /ax;
    }
    return @words;
}

# Quote a string, or list of strings, so that they will pass
# unmolested through the shell.  Avoids adding quotation whenever
# possible.  Algorithm copied from Python's shlex.quote.
sub sh_quote {    ## no critic (Subroutines::RequireArgUnpacking)
    my @quoted;
    for my $w (@_) {
        if ($w =~ m{[^\w@%+=:,./-]}a) {
            my $q = $w;
            $q =~ s/'/'\\''/g;
            $q =~ s/^/'/;
            $q =~ s/$/'/;
            push @quoted, $q;
        } else {
            push @quoted, $w;
        }
    }
    return wantarray ? @quoted : $quoted[0];
}

# Emit a logging message for the execution of a subprocess whose
# argument vector is @_.
sub log_execution {    ## no critic (Subroutines::RequireArgUnpacking)
    print {*STDERR} '+ ', join(q{ }, sh_quote(@_)), "\n";
    return;
}

# Run, and log execution of, a subprocess, with no I/O redirection.
# @_ should be an argument vector.
# Calls invocation_error() and/or subprocess_error() as appropriate.
# Does *not* call which(); do that yourself if you need it.
sub run {    ## no critic (Subroutines::RequireArgUnpacking)
    die 'run: no command to execute'
        if scalar(@_) == 0;
    log_execution(@_);
    my $status = system { $_[0] } @_;

    return                  if $status == 0;
    invocation_error($_[0]) if $status == -1;
    subprocess_error(@_);
}

# Run, and log execution of, a subprocess.  @_ should be one of the
# open modes that creates a pipe, followed by an argument vector.
# An anonymous filehandle for the pipe is returned.
# Calls invocation_error() if open() fails.
# Does *not* call which(); do that yourself if you need it.
sub popen {
    my ($mode, @args) = @_;
    die "popen: inappropriate mode argument '$mode'"
        unless $mode eq '-|' || $mode eq '|-';
    die 'popen: no command to execute'
        if scalar(@args) == 0;

    log_execution(@args);
    open my $fh, $mode, @args
        or invocation_error($args[0]);
    return $fh;
}

# Force use of the C locale for this process and all subprocesses.
# This is necessary because subprocesses' output may be locale-
# dependent.  If the C.UTF-8 locale is available, it is used,
# otherwise the plain C locale.  Note that we do *not*
# 'use locale' here or anywhere else!
sub ensure_C_locale {
    use POSIX qw(setlocale LC_ALL);

    for my $k (keys %ENV) {
        if ($k eq 'LANG' || $k eq 'LANGUAGE' || $k =~ /^LC_/) {
            delete $ENV{$k};
        }
    }
    if (defined(setlocale(LC_ALL, 'C.UTF-8'))) {
        $ENV{LC_ALL} = 'C.UTF-8'; ## no critic (RequireLocalizedPunctuationVars)
    } elsif (defined(setlocale(LC_ALL, 'C'))) {
        $ENV{LC_ALL} = 'C';       ## no critic (RequireLocalizedPunctuationVars)
    } else {
        error("could not set 'C' locale: $!");
    }
    return;
}

# Clean up $ENV{PATH}, and return the cleaned path as a list.
sub clean_PATH {
    state @path;
    if (!@path) {
        for my $d (path()) {
            # Discard all entries that are not absolute paths.
            next unless file_name_is_absolute($d);
            # Discard all entries that are not directories, or don't
            # exist.  (This is not just for tidiness; realpath()
            # behaves unpredictably if called on a nonexistent
            # pathname.)
            next unless -d $d;
            # Resolve symlinks in all remaining entries.
            $d = realpath($d);
            # Discard duplicates.
            push @path, $d unless grep { $_ eq $d } @path;
        }
        error('nothing left after cleaning PATH')
            unless @path;

        # File::Spec knows internally whether $PATH is colon-separated
        # or semicolon-separated, but it won't tell us.  Assume it's
        # colon-separated unless the first element of $PATH has a
        # colon in it (and is therefore probably a DOS-style absolute
        # path, with a drive letter).
        my $newpath;
        if ($path[0] =~ /:/) {
            $newpath = join ';', @path;
        } else {
            $newpath = join ':', @path;
        }
        $ENV{PATH} = $newpath;    ## no critic (RequireLocalizedPunctuationVars)
    }
    return @path;
}

# Locate a program that we need.
# $_[0] is the name of the program along with any options that are
# required to use it correctly.  Split this into an argument list,
# exactly as /bin/sh would do it, and then search $PATH for the
# executable.  If we find it, return a list whose first element is
# the absolute pathname of the executable, followed by any options.
# Otherwise return an empty list.
sub which {
    my ($command) = @_;
    my @PATH = clean_PATH();

    # Split the command name from any options attached to it.
    my ($cmd, @options) = sh_split($command);
    my ($vol, $path, $file) = splitpath($cmd);

    if ($file eq 'false') {
        # Special case: the command 'false' is never considered to be
        # available.  Autoconf sets config variables like $CC and $NM to
        # 'false' if it can't find the requested tool.
        return ();

    } elsif ($file ne $cmd) {
        # $cmd was not a bare filename.  Do not do path search, but do
        # verify that $cmd exists and is executable, then convert it
        # to a canonical absolute path.
        #
        # Note: the result of realpath() is unspecified if its
        # argument does not exist, so we must test its existence
        # first.
        #
        # Note: if $file is a symlink, we must *not* resolve that
        # symlink, because that may change the name of the program,
        # which in turn may change what the program does.
        # For instance, suppose $CC is /usr/lib/ccache/cc, and this
        # 'cc' is a symlink to /usr/bin/ccache.  Resolving the symlink
        # will cause ccache to be invoked as 'ccache' instead of 'cc'
        # and it will error out because it's no longer being told
        # it's supposed to run the compiler.
        if (-f -x $cmd) {
            return (catfile(realpath(catpath($vol, $path, q{})), $file),
                @options);
        } else {
            return ();
        }

    } else {
        for my $d (@PATH) {
            my $cand = catfile($d, $cmd);
            if (-f -x $cand) {
                # @PATH came from clean_PATH, so all of the directories
                # have already been canonicalized.  If the last element
                # of $cand is a symlink, we should *not* resolve it (see
                # above).  Therefore, we do not call realpath here.
                return ($cand, @options);
            }
        }
        return ();

    }
}

1;
