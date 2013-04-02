=pod

=encoding utf-8

=head1 PURPOSE

Checks type complements, unions and intersections.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use strict;
use warnings;
use lib qw( . ./t ../inc ./inc );

use Test::More;

use Type::Standard -all;

sub should_pass
{
	my ($value, $type) = @_;
	@_ = (
		!!$type->check($value),
		defined $value
			? sprintf("value '%s' passes type constraint '%s'", $value, $type)
			: sprintf("undef passes type constraint '%s'", $type),
	);
	goto \&Test::More::ok;
}

sub should_fail
{
	my ($value, $type) = @_;
	@_ = (
		!$type->check($value),
		defined $value
			? sprintf("value '%s' fails type constraint '%s'", $value, $type)
			: sprintf("undef fails type constraint '%s'", $type),
	);
	goto \&Test::More::ok;
}

my $var = 123;
should_fail(\$var, ~ScalarRef);
should_fail([], ~ArrayRef);
should_fail(+{}, ~HashRef);
should_fail(sub {0}, ~CodeRef);
should_fail(\*STDOUT, ~GlobRef);
should_fail(\(\"Hello"), ~Ref);
should_fail(\*STDOUT, ~FileHandle);
should_fail(qr{x}, ~RegexpRef);
should_fail(1, ~Str);
should_fail(1, ~Num);
should_fail(1, ~Int);
should_fail(1, ~Defined);
should_fail(1, ~Value);
should_fail(undef, ~Undef);
should_fail(undef, ~Item);
should_fail(undef, ~Any);
should_fail('Type::Tiny', ~ClassName);
should_fail('Type::Library', ~RoleName);

should_fail(undef, ~Bool);
should_fail('', ~Bool);
should_fail(0, ~Bool);
should_fail(1, ~Bool);
should_pass(7, ~Bool);
should_fail(\(\"Hello"), ~ScalarRef);
should_pass('Type::Tiny', ~RoleName);

should_pass([], ~Str);
should_pass([], ~Num);
should_pass([], ~Int);
should_fail("4x4", ~Str);
should_pass("4x4", ~Num);
should_pass("4.2", ~Int);

should_pass(undef, ~Str);
should_pass(undef, ~Num);
should_pass(undef, ~Int);
should_pass(undef, ~Defined);
should_pass(undef, ~Value);

{
	package Local::Class1;
	use strict;
}

{
	no warnings 'once';
	$Local::Class2::VERSION = 0.001;
	@Local::Class3::ISA     = qw(UNIVERSAL);
	@Local::Dummy1::FOO     = qw(UNIVERSAL);
}

{
	package Local::Class4;
	sub XYZ () { 1 }
}

should_pass(undef, ~ClassName);
should_pass([], ~ClassName);
should_fail("Local::Class$_", ~ClassName) for 2..4;
should_pass("Local::Dummy1", ~ClassName);

should_fail([], ~(ArrayRef[Int]));
should_fail([1,2,3], ~(ArrayRef[Int]));
should_pass([1.1,2,3], ~(ArrayRef[Int]));
should_pass([1,2,3.1], ~(ArrayRef[Int]));
should_pass([[]], ~(ArrayRef[Int]));
should_fail([[3]], ~(ArrayRef[ArrayRef[Int]]));
should_pass([["A"]], ~(ArrayRef[ArrayRef[Int]]));

should_fail(undef, ~(Maybe[Int]));
should_fail(123, ~(Maybe[Int]));
should_pass(1.3, ~(Maybe[Int]));

my $even = "Type::Tiny"->new(
	name       => "Even",
	parent     => Int,
	constraint => sub { !(abs($_) % 2) },
);

my $odd = "Type::Tiny"->new(
	name       => "Even",
	parent     => Int,
	constraint => sub { !!(abs($_) % 2) },
);

my $positive = "Type::Tiny"->new(
	name       => "Positive",
	parent     => Int,
	constraint => sub { $_ > 0 },
);

my $negative = "Type::Tiny"->new(
	name       => "Negative",
	parent     => Int,
	constraint => sub { $_ < 0 },
);

should_pass(-2, $even & $negative);
should_pass(-1, $odd & $negative);
should_pass(0, $even & ~$negative & ~$positive);
should_pass(1, $odd & $positive);
should_pass(2, $even & $positive);
should_pass(3, $even | $odd);
should_pass(4, $even | $odd);
should_pass(5, $negative | $positive);
should_pass(-6, $negative | $positive);

should_fail(-3, $even & $negative);
should_fail(1, $odd & $negative);
should_fail(1, $even & ~$negative & ~$positive);
should_fail(2, $odd & $positive);
should_fail(1, $even & $positive);
should_fail("Str", $even | $odd);
should_fail(1.1, $even | $odd);
should_fail(0, $negative | $positive);
should_fail("Str", $negative | $positive);

is(
	($even & ~$negative & ~$positive)->display_name,
	"Even&~Negative&~Positive",
	"coolio stringification",
);

done_testing;
