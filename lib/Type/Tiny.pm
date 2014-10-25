package Type::Tiny;

use 5.008001;
use strict;
use warnings;

BEGIN {
	$Type::Tiny::AUTHORITY = 'cpan:TOBYINK';
	$Type::Tiny::VERSION   = '0.000_02';
}

use Scalar::Util qw< blessed weaken >;

sub _confess ($;@)
{
	require Carp;
	@_ = sprintf($_[0], @_[1..$#_]) if @_ > 1;
	goto \&Carp::confess;
}

sub _swap { $_[2] ? @_[1,0] : @_[0,1] }

use overload
	q("")      => sub { $_[0]->display_name },
	q(bool)    => sub { 1 },
	q(&{})     => sub { my $t = shift; sub { $t->assert_valid(@_) } },
	q(|)       => sub { my @tc = _swap(@_); require Type::Tiny::Union; "Type::Tiny::Union"->new(type_constraints => \@tc) },
	q(&)       => sub { my @tc = _swap(@_); require Type::Tiny::Intersection; "Type::Tiny::Intersection"->new(type_constraints => \@tc) },
	q(~)       => sub { shift->complementary_type },
	fallback   => 1,
;
use if ($] >= 5.010001), overload =>
	q(~~)      => sub { $_[0]->check($_[1]) },
;

sub new
{
	my $class  = shift;
	my %params = (@_==1) ? %{$_[0]} : @_;
	
	if (exists $params{parent})
	{
		_confess "parent must be an instance of %s", __PACKAGE__
			unless blessed($params{parent}) && $params{parent}->isa(__PACKAGE__);
	}
	
	$params{name} = "__ANON__" unless exists $params{name};
	
	my $self = bless \%params, $class;
	
	if ($self->has_library and not $self->is_anon)
	{
		$Moo::HandleMoose::TYPE_MAP{"$self"} = sub { $self->moose_type };
	}
	
	return $self;
}

sub name                     { $_[0]{name} }
sub display_name             { $_[0]{display_name}   ||= $_[0]->_build_display_name }
sub parent                   { $_[0]{parent} }
sub constraint               { $_[0]{constraint}     ||= $_[0]->_build_constraint }
sub coercion                 { $_[0]{coercion}       ||= $_[0]->_build_coercion }
sub message                  { $_[0]{message}        ||= $_[0]->_build_message }
sub library                  { $_[0]{library} }
sub inlined                  { $_[0]{inlined} }
sub constraint_generator     { $_[0]{constraint_generator} }
sub inline_generator         { $_[0]{inline_generator} }
sub name_generator           { $_[0]{name_generator} ||= $_[0]->_build_name_generator }
sub parameters               { $_[0]{parameters} }
sub moose_type               { $_[0]{moose_type}     ||= $_[0]->_build_moose_type }
sub mouse_type               { $_[0]{mouse_type}     ||= $_[0]->_build_mouse_type }

sub has_parent               { exists $_[0]{parent} }
sub has_library              { exists $_[0]{library} }
sub has_coercion             { exists $_[0]{coercion} }
sub has_inlined              { exists $_[0]{inlined} }
sub has_constraint_generator { exists $_[0]{constraint_generator} }
sub has_inline_generator     { exists $_[0]{inline_generator} }
sub has_parameters           { exists $_[0]{parameters} }

sub _assert_coercion
{
	my $self = shift;
	$self->has_coercion or _confess "no coercion for this type constraint";
	return $self->coercion;
}

my $null_constraint = sub { !!1 };

sub _build_display_name
{
	shift->name;
}

sub _build_constraint
{
	return $null_constraint;
}

sub _is_null_constraint
{
	shift->constraint == $null_constraint;
}

sub _build_coercion
{
	require Type::Coercion;
	my $self = shift;
	return "Type::Coercion"->new(type_constraint => $self);
}

sub _build_message
{
	my $self = shift;
	return sub { sprintf 'value "%s" did not pass type constraint', $_[0] } if $self->is_anon;
	my $name = "$self";
	return sub { sprintf 'value "%s" did not pass type constraint "%s"', $_[0], $name };
}

sub _build_name_generator
{
	my $self = shift;
	return sub {
		my ($s, @a) = @_;
		sprintf('%s[%s]', $s, join q[,], @a);
	};
}

sub qualified_name
{
	my $self = shift;
	
	if ($self->has_library and not $self->is_anon)
	{
		return sprintf("%s::%s", $self->library, $self->name);
	}
	
	return $self->name;
}

sub is_anon
{
	my $self = shift;
	$self->name eq "__ANON__";
}

sub parents
{
	my $self = shift;
	return unless $self->has_parent;
	return ($self->parent, $self->parent->parents);
}

sub _get_failure_level
{
	my $self = shift;
	
	if ($self->has_parent)
	{
		my $failed_at = $self->parent->_get_failure_level(@_);
		return $failed_at if defined $failed_at;
	}
	
	local $_ = $_[0];
	return if $self->constraint->(@_);
	return $self;
}

sub check
{
	my $self = shift;
	return !$self->_get_failure_level(@_);
}

sub get_message
{
	my $self = shift;
	$self->message->(@_);
}

sub validate
{
	my $self = shift;
	
	my $failed_at = $self->_get_failure_level(@_);
	return undef unless defined $failed_at;
	
	local $_ = $_[0];
	return $failed_at->get_message(@_);
}

sub assert_valid
{
	my $self = shift;
	
	my $failed_at = $self->_get_failure_level(@_);
	return !!1 unless defined $failed_at;
	
	local $_ = $_[0];
	_confess $failed_at->get_message(@_);
}

sub can_be_inlined
{
	my $self = shift;
	return $self->parent->can_be_inlined
		if $self->has_parent && $self->_is_null_constraint;
	return $self->has_inlined;
}

sub inline_check
{
	my $self = shift;
	_confess "cannot inline type constraint check for %s", $self
		unless $self->can_be_inlined;
	return $self->parent->inline_check(@_)
		if $self->has_parent && $self->_is_null_constraint;
	my $r = $self->inlined->($self, @_);
	$r =~ /[;{}]/ ? "(do { $r })" : "($r)";
}

sub _inline_check
{
	shift->inline_check(@_);
}

sub coerce
{
	my $self = shift;
	$self->_assert_coercion->coerce(@_);
}

sub assert_coerce
{
	my $self = shift;
	$self->_assert_coercion->assert_coerce(@_);
}

sub is_parameterizable
{
	shift->has_constraint_generator;
}

sub is_parameterized
{
	!shift->has_parameters;
}

sub parameterize
{
	my $self = shift;
	return $self unless @_;
	$self->is_parameterizable
		or _confess "type '%s' does not accept parameters", $self;
	
	local $_ = $_[0];
	my %options = (
		constraint   => $self->constraint_generator->(@_),
		display_name => $self->name_generator->($self, @_),
		parameters   => [@_],
	);
	$options{inlined} = $self->inline_generator->(@_)
		if $self->has_inline_generator;
	delete $options{inlined} unless defined $options{inlined};
	
	return $self->create_child_type(%options);
}

sub child_type_class
{
	__PACKAGE__;
}

sub create_child_type
{
	my $self = shift;
	return $self->child_type_class->new(parent => $self, @_);
}

sub complementary_type
{
	my $self = shift;
	my $r    = ($self->{complementary_type} ||= $self->_build_complementary_type);
	weaken($self->{complementary_type});
	return $r;
}

sub _build_complementary_type
{
	my $self = shift;
	my %opts = (
		constraint   => sub { not $self->check($_) },
		display_name => sprintf("~%s", $self),
	);
	$opts{display_name} =~ s/^\~{2}//;
	$opts{inlined} = sub { shift; "not ".$self->inline_check(@_) }
		if $self->can_be_inlined;
	return "Type::Tiny"->new(%opts);
}

sub _build_moose_type
{
	my $self = shift;
	
	my %options = (name => $self->qualified_name);
	$options{parent}     = $self->parent->moose_type if $self->has_parent;
	$options{constraint} = $self->constraint         unless $self->_is_null_constraint;
	$options{message}    = $self->message;
	$options{inlined}    = $self->inlined            if $self->has_inlined;
	
	require Moose::Meta::TypeConstraint;
	my $r = "Moose::Meta::TypeConstraint"->new(%options);
	
	$self->{moose_type} = $r;  # prevent recursion
	$r->coercion($self->coercion->moose_coercion) if $self->has_coercion;
	
	return $r;
}

sub _build_mouse_type
{
	my $self = shift;
	
	my %options = (name => $self->qualified_name);
	$options{parent}     = $self->parent->mouse_type if $self->has_parent;
	$options{constraint} = $self->constraint         unless $self->_is_null_constraint;
	$options{message}    = $self->message;
		
	require Mouse::Meta::TypeConstraint;
	my $r = "Mouse::Meta::TypeConstraint"->new(%options);
		
	# XXX - coercions
	
	return $r;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Type::Tiny - tiny, yet Moo(se)-compatible type constraint

=head1 SYNOPSIS

   use Scalar::Util qw(looks_like_number);
   use Type::Tiny;
   
   my $NUM = "Type::Tiny"->new(
      name       => "Number",
      constraint => sub { looks_like_number($_) },
      message    => sub { "$_ ain't a number" },
   );
   
   package Ermintrude {
      use Moo;
      has favourite_number => (is => "ro", isa => $NUM);
   }
   
   package Bullwinkle {
      use Moose;
      has favourite_number => (is => "ro", isa => $NUM->moose_type);
   }
   
   package Maisy {
      use Mouse;
      has favourite_number => (is => "ro", isa => $NUM->mouse_type);
   }

=head1 DESCRIPTION

L<Type::Tiny> is a tiny class for creating Moose-like type constraint
objects which are compatible with Moo, Moose and Mouse.

Maybe now we won't need to have separate MooseX, MouseX and MooX versions
of everything? We can but hope...

This documents the internals of L<Type::Tiny>. L<Type::Tiny::Manual> is
a better starting place if you're new.

=head2 Constructor

=over

=item C<< new(%attributes) >>

Moose-style constructor function.

=back

=head2 Attributes

=over

=item C<< name >>

The name of the type constraint. These need to conform to certain naming
rules. Optional; if not supplied will be an anonymous type constraint.

=item C<< display_name >>

A name to display for the type constraint when stringified. These don't
have to conform to any naming rules. Optional.

=item C<< parent >>

Optional attribute; parent type constraint. For example, an "Integer"
type constraint might have a parent "Number".

If provided, must be a Type::Tiny object.

=item C<< constraint >>

Coderef to validate a value (C<< $_ >>) against the type constraint. The
coderef will not be called unless the value is known to pass any parent
type constraint.

Defaults to C<< sub { 1 } >> - i.e. a coderef that passes all values.

=item C<< message >>

Coderef that returns an error message when C<< $_ >> does not validate
against the type constraint. Optional (there's a vaguely sensible default.)

=item C<< inlined >>

A coderef which returns a string of Perl code suitable for inlining this
type. Optional.

=item C<< library >>

The package name of the type library this type is associated with.
Optional. Informational only: setting this attribute does not install
the type into the package.

=item C<< coercion >>

A L<Type::Coercion> object associated with this type.

Generally speaking this attribute should not be passed to the constructor;
you should rely on the default lazily-built coercion object.

=item C<< complementary_type >>

A complementary type for this type. For example, the complementary type
for an integer type would be all things that are not integers, including
floating point numbers, but also alphabetic strings, arrayrefs, filehandles,
etc.

Generally speaking this attribute should not be passed to the constructor;
you should rely on the default lazily-built complementary type.

=item C<< moose_type >>, C<< mouse_type >>

Objects equivalent to this type constraint, but as a
L<Moose::Meta::TypeConstraint> or L<Mouse::Meta::TypeConstraint>.

Generally speaking this attribute should not be passed to the constructor;
you should rely on the default lazily-built objects.

=back

The following additional attributes are used for parameterizable (e.g.
C<ArrayRef>) and parameterized (e.g. C<< ArrayRef[Int] >>) type
constraints. Unlike Moose, these aren't handled by separate subclasses.

=over

=item C<< parameters >>

In parameterized types, returns an arrayref of the parameters.

=item C<< name_generator >>

A coderef which generates a new display_name based on parameters.

=item C<< constraint_generator >>

Coderef that generates a new constraint coderef based on parameters.
Optional.

=item C<< inline_generator >>

A coderef which generates a new inlining coderef based on parameters.

=back

=head2 Methods

=over

=item C<has_parent>, C<has_coercion>, C<has_library>, C<has_constraint_generator>, C<has_inlined>, C<has_inline_generator>, C<has_parameters>

Predicate methods.

=item C<< is_anon >>

Returns true iff the type constraint does not have a C<name>.

=item C<< is_parameterized >>, C<< is_parameterizable >>

Indicates whether a type has been parameterized (e.g. C<< ArrayRef[Int] >>)
or could potentially be (e.g. C<< ArrayRef >>).

=item C<< qualified_name >>

For non-anonymous type constraints that have a library, returns a qualified
C<< "Library::Type" >> sort of name. Otherwise, returns the same as C<name>.

=item C<< parents >>

Returns a list of all this type constraint's all ancestor constraints.

=item C<< check($value) >>

Returns true iff the value passes the type constraint.

=item C<< validate($value) >>

Returns the error message for the value; returns an explicit undef if the
value passes the type constraint.

=item C<< assert_valid($value) >>

Like C<< check($value) >> but dies if the value does not pass the type
constraint.

Yes, that's three very similar methods. Blame L<Moose::Meta::TypeConstraint>
whose API I'm attempting to emulate. :-)

=item C<< get_message($value) >>

Returns the error message for the value; even if the value passes the type
constraint.

=item C<< coerce($value) >>

Attempt to coerce C<< $value >> to this type.

=item C<< assert_coerce($value) >>

Attempt to coerce C<< $value >> to this type. Throws an exception if this is
not possible.

=item C<< can_be_inlined >>

Returns boolean indicating if this type can be inlined.

=item C<< inline_check($varname) >>

Creates a type constraint check for a particular variable as a string of
Perl code. For example:

	print( Type::Standard::Num->inline_check('$foo') );

prints the following output:

	(!ref($foo) && Scalar::Util::looks_like_number($foo))

For Moose-compat, there is an alias C<< _inline_check >> for this method.

=item C<< parameterize(@parameters) >>

Creates a new parameterized type; throws an exception if called on a
non-parameterizable type.

=item C<< create_child_type(%attributes) >>

Construct a new Type::Tiny object with this object as its parent.

=item C<< child_type_class >>

The class that create_child_type will construct.

=back

=head2 Overloading

=over

=item *

Stringification is overloaded to return the qualified name.

=item *

Boolification is overloaded to always return true.

=item *

Coderefification is overloaded to call C<assert_value>.

=item *

On Perl 5.10.1 and above, smart match is overloaded to call C<check>.

=item *

The C<< ~ >> operator is overloaded to call C<complementary_type>.

=item *

The C<< | >> operator is overloaded to build a union of two type constraints.
See L<Type::Tiny::Union>.

=item *

The C<< & >> operator is overloaded to build the intersection of two type
constraints. See L<Type::Tiny::Intersection>.

=back

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

=head1 SEE ALSO

L<Type::Tiny::Manual>.

L<Type::Library>, L<Type::Utils>, L<Type::Standard>, L<Type::Coercion>.

L<Type::Tiny::Class>, L<Type::Tiny::Role>, L<Type::Tiny::Duck>,
L<Type::Tiny::Enum>, L<Type::Tiny::Union>.

L<Moose::Meta::TypeConstraint>,
L<Mouse::Meta::TypeConstraint>.

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

