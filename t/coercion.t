=pod

=encoding utf-8

=head1 PURPOSE

Checks Type::Coercion works.

(Very limited at the moment.)

=head1 DEPENDENCIES

Uses the bundled BiggerLib.pm type library.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use strict;
use warnings;
use lib qw( ./lib ./t/lib ../inc ./inc );

use Test::More;
use Test::Fatal;

use BiggerLib -types;

is(
	BigInteger->coercion->coerce(2),
	12,
	'coercion works',
);

is(
	BigInteger->coercion->(2),
	12,
	'coercion overloads &{}',
);

ok(
	BigInteger->coercion->has_coercion_for_type(ArrayRef),
	'BigInteger has_coercion_for_type ArrayRef',
);

ok(
	BigInteger->coercion->has_coercion_for_type(SmallInteger),
	'BigInteger has_coercion_for_type SmallInteger',
);

ok(
	!BigInteger->coercion->has_coercion_for_type(HashRef),
	'not BigInteger has_coercion_for_type SmallInteger',
);

ok(
	BigInteger->coercion->has_coercion_for_value([]),
	'BigInteger has_coercion_for_value []',
);

ok(
	BigInteger->coercion->has_coercion_for_value(2),
	'BigInteger has_coercion_for_value 2',
);

ok(
	!BigInteger->coercion->has_coercion_for_value({}),
	'not BigInteger has_coercion_for_value {}',
);

is(
	exception { BigInteger->coerce([]) },
	undef,
	"coerce doesn't throw an exception if it can coerce",
);

is(
	exception { BigInteger->coerce({}) },
	undef,
	"coerce doesn't throw an exception if it can't coerce",
);

is(
	exception { BigInteger->assert_coerce([]) },
	undef,
	"assert_coerce doesn't throw an exception if it can coerce",
);

like(
	exception { BigInteger->assert_coerce({}) },
	qr{^value "HASH\(\w+\)" did not pass type constraint "BigInteger"},
	"assert_coerce DOES throw an exception if it can't coerce",
);

done_testing;
