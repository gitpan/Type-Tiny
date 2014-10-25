=pod

=encoding utf-8

=head1 PURPOSE

Checks role type constraints throw sane error messages.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013-2014 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use strict;
use warnings;
use lib qw( ./lib ./t/lib ../inc ./inc );

use Test::More;
use Test::Fatal;

use Types::Standard qw(Int);
use Type::Tiny::Role;

like(
	exception { Type::Tiny::Role->new(parent => Int) },
	qr/^Role type constraints cannot have a parent constraint/,
);

like(
	exception { Type::Tiny::Role->new(constraint => sub { 1 }) },
	qr/^Role type constraints cannot have a constraint coderef/,
);

like(
	exception { Type::Tiny::Role->new(inlined => sub { 1 }) },
	qr/^Role type constraints cannot have a inlining coderef/,
);

like(
	exception { Type::Tiny::Role->new() },
	qr/^Need to supply role name/,
);

{
	package Bar;
	sub new { bless [], shift }
	sub DOES { 0 }
}

my $e = exception {
	Type::Tiny::Role
		->new(name => "Elsa", role => "Foo")
		->assert_valid( Bar->new );
};

is_deeply(
	$e->explain,
	[
		'"Elsa" requires that the reference does Foo',
		"The reference doesn't Foo",
	],
);

done_testing;
