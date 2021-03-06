package FSM::Mouse::Failure::Transition::Execution;

our $AUTHOR  = 'cpan:potatogim';
our $VERSION = $FSM::Mouse::VERSION;

use Mouse;
use utf8;
use namespace::clean    -except => 'meta';

extends 'FSM::Mouse::Failure::Transition';

#---------------------------------------------------------------------------
#   Attributes
#---------------------------------------------------------------------------
has 'captured' =>
(
    is       => 'ro',
    isa      => 'Any',
    required => 1,
);

#---------------------------------------------------------------------------
#   Methods
#---------------------------------------------------------------------------
sub _build_message
{
    return 'Transition execution failure.';
}

__PACKAGE__->meta->make_immutable;
1;

=encoding utf8

=head1 NAME

FSM::Mouse::Failure::Transition::Execution - FSM::Mouse Transition Execution Failure Class

=head1 SYNOPSIS

=head1 DESCRIPTION

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

