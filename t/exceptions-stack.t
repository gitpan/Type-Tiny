=pod

=encoding utf-8

=head1 PURPOSE

Tests that L<Type::Exception> is capable of providing stack traces.

=head1 DEPENDENCIES

Requires L<Devel::StackTrace>; skipped otherwise.

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

local $Type::Exception::StackTrace;

use Test::More;
use Test::Fatal;
use Test::Requires { "Devel::StackTrace" => 0 };

use Types::Standard slurpy => -types;

sub foo {
	local $Type::Exception::StackTrace = 1;
	Int->(@_);
}

my $e = exception { foo(undef) };

is(
	$e->stack_trace->frame(1)->subroutine,
	"main::foo",
);

done_testing;
