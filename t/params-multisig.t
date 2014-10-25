=pod

=encoding utf-8

=head1 PURPOSE

Test L<Type::Params> C<multisig> function.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.


=cut

use strict;
use warnings;

use Test::More;
use Test::Fatal;

use Type::Params 'multisig';
use Types::Standard -types;

my $Rounded = Int->plus_coercions(Num, 'int($_)');

my $sig = multisig(
	[ Int, ArrayRef[$Rounded] ],
	[ ArrayRef[$Rounded], Int ],
	[ HashRef[Num] ],
);

is_deeply(
	[ $sig->( 1, [2,3,4] ) ],
	[ 1, [2,3,4] ],
	'first choice in multi, no coercion, should pass',
);

is_deeply(
	[ $sig->( 1, [2.2,3.3,4.4] ) ],
	[ 1, [2,3,4] ],
	'first choice in multi, coercion, should pass',
);

like(
	exception { $sig->( 1.1, [2.2,3.3,4.4] ) },
	qr{^Parameter validation failed},
	'first choice in multi, should fail',
);

is_deeply(
	[ $sig->( [2,3,4], 1 ) ],
	[ [2,3,4], 1 ],
	'second choice in multi, no coercion, should pass',
);

is_deeply(
	[ $sig->( [2.2,3.3,4.4], 1 ) ],
	[ [2,3,4], 1 ],
	'second choice in multi, coercion, should pass',
);

like(
	exception { $sig->( [2.2,3.3,4.4], 1.1 ) },
	qr{^Parameter validation failed},
	'second choice in multi, should fail',
);

is_deeply(
	[ $sig->( { a => 1.1, b => 7 } ) ],
	[ { a => 1.1, b => 7 } ],
	'third choice in multi, no coercion, should pass',
);

like(
	exception { $sig->( { a => 1.1, b => 7, c => "Hello" } ) },
	qr{^Parameter validation failed},
	'third choice in multi, should fail',
);

done_testing;
