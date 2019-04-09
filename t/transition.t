use strict;
use warnings;
use utf8;

use Test::More;
use FSM::Mouse::State;
use FSM::Mouse::Transition;

my $class = 'FSM::Mouse::Transition';
can_ok($class, qw/hooks name result/);

my $trans1 = eval { $class->new(); };
ok(!$trans1 && $@, '$trans1 missing required arguments');

my $trans2 = eval { $class->new(name => 'perform'); };
ok(!$trans2 && $@, '$trans2 missing required arguments');

my $trans3 = $class->new(
    name   => 'perform',
    result => FSM::Mouse::State->new(name => 'performed')
);

is($trans3->name, 'perform', '$trans3 instantiated');
is('HASH', ref($trans3->hooks), '$trans3 hasa default hooks');

done_testing();
