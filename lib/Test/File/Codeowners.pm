package Test::File::Codeowners;
# ABSTRACT: Write tests for CODEOWNERS files

=head1 SYNOPSIS

    use Test::More;

    eval 'use Test::File::Codeowners';
    plan skip_all => 'Test::File::Codeowners required for testing CODEOWNERS' if $@;

    codeowners_syntax_ok();
    done_testing;

=head1 DESCRIPTION

This package has assertion subroutines for testing F<CODEOWNERS> files.

=cut

use warnings;
use strict;

use Encode qw(encode);
use File::Codeowners::Util qw(find_codeowners_in_directory find_nearest_codeowners git_ls_files git_toplevel);
use File::Codeowners;
use Test::Builder;

our $VERSION = '9999.999'; # VERSION

my $Test = Test::Builder->new;

sub import {
    my $self = shift;
    my $caller = caller;
    no strict 'refs';   ## no critic (TestingAndDebugging::ProhibitNoStrict)
    *{$caller.'::codeowners_syntax_ok'} = \&codeowners_syntax_ok;
    *{$caller.'::codeowners_git_files_ok'} = \&codeowners_git_files_ok;

    $Test->exported_to($caller);
    $Test->plan(@_);
}

=func codeowners_syntax_ok

    codeowners_syntax_ok();     # search up the tree for a CODEOWNERS file
    codeowners_syntax_ok($filepath);

Check the syntax of a F<CODEOWNERS> file.

=cut

sub codeowners_syntax_ok {
    my $filepath = shift || find_nearest_codeowners();

    if (!$filepath) {
        $Test->ok(0, "Check syntax: <missing>");
        $Test->diag('No CODEOWNERS file could be found.');
        return;
    }

    eval { File::Codeowners->parse($filepath) };
    my $err = $@;

    $Test->ok(!$err, "Check syntax: $filepath");
    $Test->diag($err) if $err;
}

=func codeowners_git_files_ok

    codeowners_git_files_ok();  # use git repo in cwd
    codeowners_git_files_ok($repopath);

=cut

sub codeowners_git_files_ok {
    my $repopath = shift || '.';

    my $git_toplevel = git_toplevel($repopath);
    if (!$git_toplevel) {
        $Test->skip('No git repo could be found.');
        return;
    }

    my $filepath = find_codeowners_in_directory($git_toplevel);
    if (!$filepath) {
        $Test->ok(0, "Check syntax: <missing>");
        $Test->diag("No CODEOWNERS file could be found in repo $repopath.");
        return;
    }

    $Test->subtest('codeowners_git_files_ok' => sub {
        my $codeowners = eval { File::Codeowners->parse($filepath) };
        if (my $err = $@) {
            $Test->plan(tests => 1);
            $Test->ok(0, "Parse $filepath");
            $Test->diag($err);
            return;
        }

        my ($proc, @files) = git_ls_files($git_toplevel);
        if ($proc->wait != 0) {
            $Test->plan(skip_all => 'git ls-files failed');
            return;
        }

        $Test->plan(tests => scalar @files);

        for my $filepath (@files) {
            my $msg = encode('UTF-8', "Check file: $filepath");

            my $match = $codeowners->match($filepath);
            my $is_unowned = $codeowners->is_unowned($filepath);

            if (!$match && !$is_unowned) {
                $Test->ok(0, $msg);
                $Test->diag("File is unowned\n");
            }
            elsif ($match && $is_unowned) {
                $Test->ok(0, $msg);
                $Test->diag("File is owned but listed as unowned\n");
            }
            else {
                $Test->ok(1, $msg);
                if ($match) {
                    my $owners = encode('UTF-8', join(',', @{$match->{owners}}));
                    $Test->note("File is owned by $owners");
                }
            }
        }
    });
}

1;
