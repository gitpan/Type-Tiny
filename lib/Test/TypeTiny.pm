package Test::TypeTiny;

use strict;
use warnings;

use Test::More ();
use base qw< Exporter::TypeTiny >;

BEGIN {
	*EXTENDED_TESTING = $ENV{EXTENDED_TESTING} ? sub(){!!1} : sub(){!!0};
};

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.007_06';
our @EXPORT    = qw( should_pass should_fail ok_subtype );
our @EXPORT_OK = qw( EXTENDED_TESTING );

sub _mk_message
{
	require Type::Tiny;
	my ($template, $value) = @_;
	sprintf($template, Type::Tiny::_dd($value));
}

sub ok_subtype
{
	my ($type, @s) = @_;
	@_ = (
		not(scalar grep !$_->is_subtype_of($type), @s),
		sprintf("%s subtype: %s", $type, join q[, ], @s),
	);
	goto \&Test::More::ok;
}

eval(EXTENDED_TESTING ? <<'SLOW' : <<'FAST');

sub should_pass
{
	my ($value, $type, $message) = @_;
	
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	my $test = "Test::Builder"->new->child(
		$message || _mk_message("%s passes type constraint $type", $value),
	);
	$test->plan(tests => 2);
	$test->ok(!!$type->check($value), '->check');
	$test->ok(!!$type->_strict_check($value), '->_strict_check');
	$test->finalize;
	return $test->is_passing;
}

sub should_fail
{
	my ($value, $type, $message) = @_;
	
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	my $test = "Test::Builder"->new->child(
		$message || _mk_message("%s fails type constraint $type", $value),
	);
	$test->plan(tests => 2);
	$test->ok(!$type->check($value), '->check');
	$test->ok(!$type->_strict_check($value), '->_strict_check');
	$test->finalize;
	return $test->is_passing;
}

SLOW

sub should_pass
{
	my ($value, $type, $message) = @_;
	@_ = (
		!!$type->check($value),
		$message || _mk_message("%s passes type constraint $type", $value),
	);
	goto \&Test::More::ok;
}

sub should_fail
{
	my ($value, $type, $message) = @_;
	@_ = (
		!$type->check($value),
		$message || _mk_message("%s fails type constraint $type", $value),
	);
	goto \&Test::More::ok;
}

FAST

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Test::TypeTiny - useful functions for testing the efficacy of type constraints

=head1 SYNOPSIS

   use strict;
   use warnings;
   use Test::More;
   use Test::TypeTiny;
   
   use Types::Mine qw(Integer);
   
   should_pass(1, Integer);
   should_pass(-1, Integer);
   should_pass(0, Integer);
   should_fail(2.5, Integer);
   
   ok_subtype(Number, Integer);
   
   done_testing;

=head1 DESCRIPTION

L<Test::TypeTiny> provides a few handy functions for testing type constraints.

=head2 Functions

=over

=item C<< should_pass($value, $type, $test_name) >>

=item C<< should_pass($value, $type) >>

Test that passes iff C<< $value >> passes C<< $type->check >>.

=item C<< should_fail($value, $type, $test_name) >>

=item C<< should_fail($value, $type) >>

Test that passes iff C<< $value >> fails C<< $type->check >>.

=item C<< ok_subtype($type, @subtypes) >>

Test that passes iff all C<< @subtypes >> are subtypes of C<< $type >>.

=item C<< EXTENDED_TESTING >>

Exportable boolean constant.

=back

=head1 ENVIRONMENT

If the C<EXTENDED_TESTING> environment variable is set to true, this
module will promote each C<should_pass> or C<should_fail> test into a
subtest block and test the type constraint in both an inlined and
non-inlined manner.

This variable must be set at compile time (i.e. before this module is
loaded).

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

=head1 SEE ALSO

L<Type::Tiny>.

For an alternative to C<should_pass>, see L<Test::Deep::Type> which will
happily accept a Type::Tiny type constraint instead of a MooseX::Types one.

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

