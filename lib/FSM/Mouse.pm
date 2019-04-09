package FSM::Mouse;

our $AUTHOR  = 'cpan:potatogim';
our $VERSION = '0.1';

use Mouse;
use utf8;
use namespace::clean    -except => 'meta';

use FSM::Mouse::Failure::Transition::Execution;
use FSM::Mouse::Failure::Transition::Missing;
use FSM::Mouse::Failure::Transition::Unknown;
use Try::Tiny;


#---------------------------------------------------------------------------
#   Attributes
#---------------------------------------------------------------------------
has '_state' =>
(
    is       => 'rw',
    isa      => 'Object',
    init_arg => 'state',
    required => 1,
);

has 'topic' =>
(
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

#---------------------------------------------------------------------------
#   Methods
#---------------------------------------------------------------------------
sub apply
{
    my $self = shift;

    my $state = $self->_state;
    my $next  = $self->next;

    # cannot transition
    FSM::Mouse::Failure::Transition::Missing->throw
        if (ref($next) ne '');

    # find transition
    if (my $trans = $state->transitions->{$next})
    {
        try {
            # attempt transition
            $self->_state($trans->execute($state, @_));
        }
        catch {
            # transition execution failure
            FSM::Mouse::Failure::Transition::Execution->throw(
                captured          => $_,
                transition_name   => $next,
                transition_object => $trans,
            );
        };
    }
    else
    {
        # transition unknown
        FSM::Mouse::Failure::Transition::Unknown->throw(
            transition_name => $next
        );
    }

    return $self->state;
}

sub next
{
    my $self = shift;

    my $state = $self->_state;
    my $next  = shift // $state->next;

    if ($state && !$next)
    {
        # deduce transition unless defined
        if (scalar(keys(%{$state->transitions})) == 1)
        {
            $next = (keys(%{$state->transitions}))[0];
        }
    }

    return $next;
}

sub state
{
    return shift->_state->name;
}

__PACKAGE__->meta->make_immutable;
1;

=encoding utf8

=head1 NAME

FSM::Mouse - Finite-State Machine with Mouse

=head1 SYNOPSIS

    use FSM::Mouse;
    use FSM::Mouse::State;
    use FSM::Mouse::Transition;

    # light-switch circular-state example

    my $is_on  = FSM::Mouse::State->new(name => 'is_on');
    my $is_off = FSM::Mouse::State->new(name => 'is_off');

    my $turn_on  = FSM::Mouse::Transition->new(
        name   => 'turn_on',
        result => $is_on
    );
    my $turn_off = FSM::Mouse::Transition->new(
        name   => 'turn_off',
        result => $is_off
    );

    $is_on->add_transition($turn_off); # on -> turn off
    $is_off->add_transition($turn_on); # off -> turn on

    my $lightswitch = FSM::Mouse->new(
        topic => 'typical light switch',
        state => $is_off
    );

    $lightswitch->apply('turn_on');
    $lightswitch->status; # is_on

=head1 DESCRIPTION

A finite-state machine (FSM) or finite-state automaton (plural: automata), or
simply a state machine, is an abstract machine that can be in one of a finite
number of states. The machine is in only one state at a time. It can change from
one state to another when initiated by a triggering event or condition; this is
called a transition. FSM::Mouse is a system for creating state machines and
managing their transitions; It is also a great mechanism for enforcing and
tracking workflow, especially in distributed computing. This library is a
Mouse-based implementation of the L<State::Machine> library.

State machines are useful for modeling systems with perform a predetermined
sequence of event and result in deterministic state. FSM::Mouse, as you
might expect, allows for the definition of events, states, state transitions
and user defined actions that can be executed before or after transitions. All
features of the state machine itself can be configured via a DSL,
L<FSM::Mouse>. B<Note: This is an early release available for testing and
feedback and as such is subject to change.>

=head1 ATTRIBUTES

=head2 topic

    my $topic = $machine->topic;
    $topic = $machine->topic('Take over the world');

The topic or purpose of the state machine. The value can be any arbitrary
string describing intent.

=head1 METHODS

=head2 state

    my $state = $machine->state;
    $state = $machine->state(FSM::Mouse::State->new(...));

The current state of the state machine. The value should be a
L<FSM::Mouse::State> object.

=head2 apply

    my $state = $machine->apply('transition_name');
    $state = $machine->apply; # apply known next transition

The apply method transitions the state machine from the current state into the
resulting state. If the apply method is called without a transition name, the
machine will transition into the next known state of the current state.

=head2 next

    my $transition_name = $machine->next;

The next method returns the name of the next known transition of the current
state if exists, otherwise it will return undefined.

=head2 status

    my $state_name = $machine->status;

The status method returns the name of the current state.

=head1 SEE ALSO

=over

=item L<State::Machine>

=item L<Mouse>

=item L<namespace::clean>

=item L<Throwable::Error>

=item L<Try::Tiny>

=back

=head1 AUTHORS

Ji-Hyeon Gim E<lt>potatogim@gluesys.comE<gt>

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.
Please report any bugs to L<https://github.com/potatogim/FSM-Mouse/issues>.

=head1 COPYRIGHT AND LICENSE

Copyright 2019 by Ji-Hyeon Gim.

This is free software; you can redistribute it and/or modify it
under the same terms as Perl 5 itself at:

L<http://www.perlfoundation.org/artistic_license_2_0>

You may obtain a copy of the full license at:

L<http://www.perl.com/perl/misc/Artistic.html>

=cut

