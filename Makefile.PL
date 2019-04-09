use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

sub MY::postamble
{
    return <<EOM
testcover:
	cover -delete
	make HARNESS_PERL_SWITCHES=-MDevel::Cover test TEST_VERBOSE=1
	cover
EOM
}

WriteMakefile(
    NAME               => 'FSM::Mouse',
    DISTNAME           => 'FSM-Mouse',
    AUTHOR             => 'Ji-Hyeon Gim <potatogim@gluesys.com>',
    VERSION_FROM       => 'lib/FSM/Mouse.pm',
    ABSTRACT_FROM      => 'lib/FSM/Mouse.pm',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    PREREQ_PM => {
        'utf8'                 => 0,
        'strict'               => 0,
        'warnings'             => 0,
        'Mouse'                => 0,
        'MouseX::NativeTraits' => 0,
        'namespace::clean'     => 0,
        'Throwable::Error'     => 0,
        'Try::Tiny'            => 0,
    },
    TEST_REQUIRES => {
        'utf8'                 => 0,
        'strict'               => 0,
        'warnings'             => 0,
        'Mouse'                => 0,
        'MouseX::NativeTraits' => 0,
        'namespace::clean'     => 0,
        'Throwable::Error'     => 0,
        'Try::Tiny'            => 0,
        'Test::More'           => 0,
        'Test::Harness'        => 0,
        'Devel::Cover'         => 0,
    },
    PL_FILES => {},
    clean => {
        FILES => ['FSM-Mouse-*', 'cover_db', 'MYMETA.json.lock'],
    },
    test => {
        TESTS => 't/*.t',
    },
    (
        eval { ExtUtils::MakeMaker->VERSION(6.46) }
            ? (
                META_MERGE => {
                    'meta-spec' => { version => 2 },
                    license     => ['perl_5'],
                    resources   => {
                        homepage   => 'https://github.com/potatogim/FSM-Mouse',
                        repository => {
                            type => 'git',
                            url  => 'https://github.com/potatogim/FSM-Mouse.git',
                            web  => 'https://github.com/potatogim/FSM-Mouse',
                        },
                        bugtracker => {
                            web => 'https://github.com/potatogim/FSM-Mouse/issues',
                        },
                    },
                }
            )
            : ()
    ),
);
