use strict;
use warnings;
use utf8;

use Test::More;
use FSM::Mouse::State;

my $class = 'FSM::Mouse::State';
can_ok($class, qw/name next transitions/);

my $state1 = eval { $class->new() };
ok(!$state1 && $@, '$state1 missing required arguments');

my $state2 = eval { $class->new(name => 'performed'); };
is($state2->name, 'performed', '$state2 instantiated');

is_deeply($state2->transitions, {}, '$state2 has no transitions');

done_testing();
