package Type::Tiny::Intersection;

use 5.008001;
use strict;
use warnings;

BEGIN {
	$Type::Tiny::Intersection::AUTHORITY = 'cpan:TOBYINK';
	$Type::Tiny::Intersection::VERSION   = '0.000_06';
}

use Scalar::Util qw< blessed >;

sub _croak ($;@)
{
	require Carp;
	@_ = sprintf($_[0], @_[1..$#_]) if @_ > 1;
	goto \&Carp::croak;
}

use overload q[@{}] => 'type_constraints';

use base "Type::Tiny";

sub new {
	my $proto = shift;
	my %opts = @_;
	_croak "need to supply list of type constraints" unless exists $opts{type_constraints};
	$opts{type_constraints} = [
		map { $_->isa(__PACKAGE__) ? @$_ : $_ }
		@{ ref $opts{type_constraints} eq "ARRAY" ? $opts{type_constraints} : [$opts{type_constraints}] }
	];
	return $proto->SUPER::new(%opts);
}

sub type_constraints { $_[0]{type_constraints} }
sub constraint       { $_[0]{constraint} ||= $_[0]->_build_constraint }

sub _build_display_name
{
	my $self = shift;
	join q[&], @$self;
}

sub _build_constraint
{
	my @tcs = @{+shift};
	return sub
	{
		my $val = $_;
		$_->check($val) || return for @tcs;
		return !!1;
	}
}

sub can_be_inlined
{
	my $self = shift;
	not grep !$_->can_be_inlined, @$self;
}

sub inline_check
{
	my $self = shift;
	sub { join " and ", map $_->inline_check($_[1]), @$self };
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Type::Tiny::Intersection - intersection type constraints

=head1 DESCRIPTION

Intersection type constraints.

This package inherits from L<Type::Tiny>; see that for most documentation.
Major differences are listed below:

=head2 Attributes

=over

=item C<type_constraints>

Arrayref of type constraints.

=item C<constraint>

Unlike Type::Tiny, you should generally I<not> pass a constraint to the
constructor. Instead rely on the default.

=item C<inlined>

Unlike Type::Tiny, you should generally I<not> pass an inlining coderef to
the constructor. Instead rely on the default.

=back

=head2 Overloading

=over

=item *

Arrayrefification calls C<type_constraints>.

=back

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

=head1 SEE ALSO

L<Type::Tiny::Manual>.

L<Type::Tiny>.

L<MooseX::Meta::TypeConstraint::Intersection>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

