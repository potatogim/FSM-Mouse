package FSM::Mouse::Transition;

our $AUTHOR  = 'cpan:potatogim';
our $VERSION = $FSM::Mouse::VERSION;

use Mouse;
use utf8;
use namespace::clean    -except => 'meta';

use FSM::Mouse::Failure::Transition::Hook;
use FSM::Mouse::State;
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

has 'result' =>
(
    is       => 'rw',
    isa      => 'Object',
    required => 1,
);

has 'hooks' =>
(
    traits  => ['Hash'],
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {
        {
            before => [],
            during => [],
            after  => [],
        };
    },
    handles => {
        get_hook => 'get',
    }
);

has 'executable' =>
(
    is      => 'rw',
    isa     => 'Int',
    default => 1,
);

has 'terminated' =>
(
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

#---------------------------------------------------------------------------
#   Methods
#---------------------------------------------------------------------------
sub execute
{
    my $self = shift;

    return if (!$self->executable);

    my @schedules = (
        $self->get_hook('before'),
        $self->get_hook('during'),
        $self->get_hook('after'),
    );

    foreach my $schedule (@schedules)
    {
        next if (ref($schedule) ne 'ARRAY');

        foreach my $task (@{$schedule})
        {
            next if (ref($task) ne 'CODE');
            $task->($self, @_);
        }
    }

    return $self->result;
}

sub hook
{
    my $self = shift;

    my $name = shift;
    my $code = shift;

    if (ref($name) ne '')
    {
        die 'Not a string';
    }

    if (ref($code) ne 'CODE')
    {
        die 'Not a coderef';
    }

    my $list = $self->get_hook($name);

    if (ref($list) ne 'ARRAY')
    {
        # transition hooking failure
        FSM::Mouse::Failure::Transition::Hook->throw(
            hook_name         => $name,
            transition_name   => $self->name,
            transition_object => $self,
        );
    }

    push(@{$list}, $code);

    return $self;
}

__PACKAGE__->meta->make_immutable;
1;

=encoding utf8

=head1 NAME

FSM::Mouse::Transition - Finite-State Machine State Transition Class


=head1 SYNOPSIS

    use FSM::Mouse::Transition;

    my $trans = FSM::Mouse::Transition->new(
        name   => 'resume',
        result => FSM::Mouse::State->new(name => 'awake')
    );

    $trans->hook(during => sub {
        my ($trans, $state, @args) = @_;
        # do something during resume
    });

=head1 DESCRIPTION

FSM::Mouse::Transition represents a state transition and it's resulting
state.

=head1 ATTRIBUTES

=head2 executable

    my $executable = $trans->executable;
    $trans->executable(1);

The executable flag determines whether a transition can be execute.

=head2 hooks

    my $hooks = $trans->hooks;

The hooks attribute contains the collection of triggers and events to be fired
when the transition is executed. The C<hook> method should be used to configure
any hooks into the transition processing.

=head2 name

    my $name = $trans->name;
    $name = $trans->name('suicide');

The name of the transition. The value can be any scalar value.

=head2 result

    my $state = $trans->result;
    $state = $trans->result(FSM::Mouse::State->new(...));

The result represents the resulting state of a transition. The value must be a
L<FSM::Mouse::State> object.

=head1 METHODS

=head2 hook

    $trans = $trans->hook(during => sub {...});
    $trans->hook(before => sub {...});
    $trans->hook(after => sub {...});

The hook method registers a new hook in the append-only hooks collection to be
fired when the transition is executed. The method requires an event name,
either C<before>, C<during>, or C<after>, and a code reference.

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

