package FSM::Mouse::State;

our $AUTHOR  = 'cpan:potatogim';
our $VERSION = $FSM::Mouse::VERSION;

use Mouse;
use utf8;
use namespace::clean    -except => 'meta';

use FSM::Mouse::Failure::Transition::Unknown;
use FSM::Mouse::Transition;
use Try::Tiny;

#---------------------------------------------------------------------------
#   Attributes
#---------------------------------------------------------------------------
has 'name' =>
(
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'next' =>
(
    is       => 'rw',
    isa      => 'Str',
    required => 0,
);

has 'transitions' =>
(
    is      => 'ro',
    isa     => 'HashRef[FSM::Mouse::Transition]',
    default => sub { {}; },
);

#---------------------------------------------------------------------------
#   Methods
#---------------------------------------------------------------------------
sub add_transition
{
    my $self = shift;

    my $trans = pop;
    my $name  = shift;

    if ($trans->isa('FSM::Mouse::Transition'))
    {
        $name //= $trans->name;
        $self->transitions->{$name} = $trans;
        return $trans;
    }

    # transition not found
    FSM::Mouse::Failure::Transition::Unknown->throw(
        transition_name => $name,
    );
}

__PACKAGE__->meta->make_immutable;
1;

=encoding utf8

=head1 NAME

FSM::Mouse::State - Finite-State Machine State Class

=head1 SYNOPSIS

    use FSM::Mouse::State;

    my $state = FSM::Mouse::State->new(
        name => 'sleep',
        next => 'resume'
    );

=head1 DESCRIPTION

FSM::Mouse::State represents a state and it's transitions.

=head1 ATTRIBUTES

=head2 name

    my $name = $state->name;
    $name = $state->name('inspired');

The name of the state. The value can be any scalar value.

=head2 next

    my $transition_name = $state->next;
    $transition_name = $state->next('create_art');

The name of the next transition. The value can be any scalar value. This value
is used in automating the transition from one state to the next.

=head2 transitions

    my $transitions = $state->transitions;

The transitions attribute contains the collection of transitions the state can
apply. The C<add_transition> and C<remove_transition> methods should be used to
configure state transitions.

=head1 METHODS

=head2 add_transition

    $trans = $state->add_transition(FSM::Mouse::Transition->new(...));
    $state->add_transition(name => FSM::Mouse::Transition->new(...));

The add_transition method registers a new transition in the transitions
collection. The method requires a L<FSM::Mouse::Transition> object.

=head2 remove_transition

    $trans = $state->remove_transition('transition_name');

The remove_transition method removes a pre-defined transition from the
transitions collection. The method requires a transition name.

=head1 SEE ALSO

=over

=item L<FSM::Mouse>

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

