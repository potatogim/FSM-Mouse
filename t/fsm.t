use strict;
use warnings;
use utf8;

use Test::More;
use FSM::Mouse;
use FSM::Mouse::State;
use FSM::Mouse::Transition;

my $class = 'FSM::Mouse';

can_ok($class, qw/apply state topic/);

my $mach1 = eval { $class->new; };

ok(!$mach1 && $@, '$mach1 missing required arguments');

my $mach2 = eval { $class->new(desc => 'switch'); };

ok(!$mach2 && $@, '$mach2 missing required arguments');

subtest 'light-switch circular-state example' => sub
{
    my $m = 'FSM::Mouse';
    my $s = 'FSM::Mouse::State';
    my $t = 'FSM::Mouse::Transition';

    # state
    my $is_on  = $s->new(name => 'is_on');
    my $is_off = $s->new(name => 'is_off');

    # transition
    my $turn_on  = $t->new(name => 'turn_on', result => $is_on);
    my $turn_off = $t->new(name => 'turn_off', result => $is_off);

    # bind
    $is_on->add_transition($turn_off);
    $is_off->add_transition($turn_on);

    # automate the next transition
    $is_on->next('turn_off');
    $is_off->next('turn_on');

    # build machine
    my $light = $m->new(
        topic => 'light switch',
        state => $is_off            # initial state
    );

    # add hooks
    my $a = 1;
    my $b = 1;
    my $d = 1;

    $turn_on->hook(during => sub { $a++; });
    $turn_on->hook(during => sub { $b++; });
    $turn_on->hook(during => sub { $d++; });

    $turn_off->hook(during => sub { $a--; });
    $turn_off->hook(during => sub { $b--; });
    $turn_off->hook(during => sub { $d--; });

    # is_off -> is_on
    $light->apply;

    is($light->state, 'is_on', 'light-switch was toggled on');
    is($a, 2, '$turn_on -after- hook executed');
    is($b, 2, '$turn_on -before- hook executed');
    is($d, 2, '$turn_on -during- hook executed');

    # is_on -> is_off
    $light->apply;

    is($light->state, 'is_off', 'light-switch was toggled off');
    is($a, 1, '$turn_off -after- hook executed');
    is($b, 1, '$turn_off -after- hook executed');
    is($d, 1, '$turn_off -after- hook executed');
};

done_testing();
