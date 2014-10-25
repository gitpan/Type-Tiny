=pod

=encoding utf-8

=head1 PURPOSE

Checks C<< B::perlstring() >> works.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2014 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use strict;
use warnings;
use lib qw( ./lib ./t/lib ../inc ./inc );

use B;
use Test::More;
use Types::Standard;

is(
	+eval(sprintf "use strict; %s", B::perlstring("foo")),
	"foo",
	'eval(sprintf "use strict; %s", B::perlstring("foo"))',
);

done_testing;
