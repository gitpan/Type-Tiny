package Type::Standard;

use strict;
use warnings;

BEGIN {
	$Type::Standard::AUTHORITY = 'cpan:TOBYINK';
	$Type::Standard::VERSION   = '0.000_01';
}

use base "Type::Library";
use Type::Utils;

our @EXPORT_OK = qw( slurpy );

use Scalar::Util qw( blessed looks_like_number );

sub _is_class_loaded {
	return !!0 if ref $_[0];
	return !!0 if !defined $_[0];
	my $stash = do { no strict 'refs'; \%{"$_[0]\::"} };
	return !!1 if exists $stash->{'ISA'};
	return !!1 if exists $stash->{'VERSION'};
	foreach my $globref (values %$stash) {
		return !!1 if *{$globref}{CODE};
	}
	return !!0;
}

declare "Any",
	inline_as { "!!1" };

declare "Item",
	inline_as { "!!1" };

declare "Bool",
	as "Item",
	where { !defined $_ or $_ eq q() or $_ eq '0' or $_ eq '1' },
	inline_as { "!defined $_ or $_ eq q() or $_ eq '0' or $_ eq '1'" };

declare "Undef",
	as "Item",
	where { !defined $_ },
	inline_as { "!defined($_)" };

declare "Defined",
	as "Item",
	where { defined $_ },
	inline_as { "defined($_)" };

declare "Value",
	as "Defined",
	where { not ref $_ },
	inline_as { "defined($_) and not ref($_)" };

declare "Str",
	as "Value",
	where { ref(\$_) eq 'SCALAR' or ref(\(my $val = $_)) eq 'SCALAR' },
	inline_as { "defined($_) and (ref(\\$_) eq 'SCALAR' or ref(\\(my \$val = $_)) eq 'SCALAR')" };

declare "Num",
	as "Str",
	where { looks_like_number $_ },
	inline_as { "!ref($_) && Scalar::Util::looks_like_number($_)" };

declare "Int",
	as "Num",
	where { /\A-?[0-9]+\z/ },
	inline_as { "defined $_ and $_ =~ /\\A-?[0-9]+\\z/" };

declare "ClassName",
	as "Str",
	where { goto \&_is_class_loaded },
	inline_as { "Type::Standard::_is_class_loaded($_)" };

declare "RoleName",
	as "ClassName",
	where { not $_->can("new") },
	inline_as { "Type::Standard::_is_class_loaded($_) and not $_->can('new')" };

declare "Ref",
	as "Defined",
	where { ref $_ },
	inline_as { "!!ref($_)" },
	constraint_generator => sub
	{
		my $reftype = shift;
		return sub {
			ref($_[0]) and Scalar::Util::reftype($_[0]) eq $reftype;
		}
	},
	inline_generator => sub
	{
		my $reftype = shift;
		return sub {
			my $v = $_[1];
			"ref($v) and Scalar::Util::reftype($v) eq q($reftype)";
		};
	};

declare "CodeRef",
	as "Ref",
	where { ref $_ eq "CODE" },
	inline_as { "ref($_) eq 'CODE'" };

declare "RegexpRef",
	as "Ref",
	where { ref $_ eq "Regexp" },
	inline_as { "ref($_) eq 'Regexp'" };

declare "GlobRef",
	as "Ref",
	where { ref $_ eq "GLOB" },
	inline_as { "ref($_) eq 'GLOB'" };

declare "FileHandle",
	as "Ref",
	where {
		(ref($_) eq "GLOB" && Scalar::Util::openhandle($_))
		or (blessed($_) && $_->isa("IO::Handle"))
	},
	inline_as {
		"(ref($_) eq \"GLOB\" && Scalar::Util::openhandle($_)) ".
		"or (Scalar::Util::blessed($_) && $_->isa(\"IO::Handle\"))"
	};

declare "ArrayRef",
	as "Ref",
	where { ref $_ eq "ARRAY" },
	inline_as { "ref($_) eq 'ARRAY'" },
	constraint_generator => sub
	{
		my $param = shift;
		return sub
		{
			my $array = shift;
			$param->check($_) || return for @$array;
			return !!1;
		};
	},
	inline_generator => sub {
		my $param = shift;
		return unless $param->can_be_inlined;
		my $param_check = $param->inline_check('$i');
		return sub {
			my $v = $_[1];
			"ref($v) eq 'ARRAY' and do { "
			.  "my \$ok = 1; "
			.  "for my \$i (\@{$v}) { "
			.    "\$ok = 0 && last unless $param_check "
			.  "}; "
			.  "\$ok "
			."}"
		};
	};

declare "HashRef",
	as "Ref",
	where { ref $_ eq "HASH" },
	inline_as { "ref($_) eq 'HASH'" },
	constraint_generator => sub
	{
		my $param = shift;
		return sub
		{
			my $hash = shift;
			$param->check($_) || return for values %$hash;
			return !!1;
		};
	},
	inline_generator => sub {
		my $param = shift;
		return unless $param->can_be_inlined;
		my $param_check = $param->inline_check('$i');
		return sub {
			my $v = $_[1];
			"ref($v) eq 'HASH' and do { "
			.  "my \$ok = 1; "
			.  "for my \$i (values \%{$v}) { "
			.    "\$ok = 0 && last unless $param_check "
			.  "}; "
			.  "\$ok "
			."}"
		};
	};

declare "ScalarRef",
	as "Ref",
	where { ref $_ eq "SCALAR" or ref $_ eq "REF" },
	inline_as { "ref($_) eq 'SCALAR' or ref($_) eq 'REF'" },
	constraint_generator => sub
	{
		my $param = shift;
		return sub
		{
			my $ref = shift;
			$param->check($$ref) || return;
			return !!1;
		};
	},
	inline_generator => sub {
		my $param = shift;
		return unless $param->can_be_inlined;
		my $param_check = $param->inline_check('$i');
		# kinda clumsy, but it does the job...
		return sub {
			my $v = $_[1];
			"ref($v) eq 'SCALAR' or ref($v) eq 'REF' and do { "
			.  "my \$ok = 1; "
			.  "for my \$i (${$v}) { "
			.    "\$ok = 0 unless $param_check "
			.  "}; "
			.  "\$ok "
			."}"
		};
	};

declare "Object",
	as "Ref",
	where { blessed $_ },
	inline_as { "Scalar::Util::blessed($_)" };

declare "Maybe",
	as "Item",
	constraint_generator => sub
	{
		my $param = shift;
		return sub
		{
			my $value = shift;
			return !!1 unless defined $value;
			return $param->check($value);
		};
	},
	inline_generator => sub {
		my $param = shift;
		return unless $param->can_be_inlined;
		return sub {
			my $v = $_[1];
			my $param_check = $param->inline_check($v);
			"!defined($v) or $param_check";
		};
	};

use overload ();
declare "Overload",
	as "Object",
	where { overload::Overloaded($_) },
	inline_as { "Scalar::Util::blessed($_) and overload::Overloaded($_)" },
	constraint_generator => sub
	{
		my @operations = @_;
		return sub {
			my $value = shift;
			for my $op (@operations) {
				return unless overload::Method($value, $op);
			}
			return !!1;
		}
	},
	inline_generator => sub {
		my @operations = @_;
		return sub {
			my $v = $_[1];
			join " and ",
				"Scalar::Util::blessed($v)",
				map "overload::Method($v, q[$_])", @operations;
		};
	};

# TODO: things from MooseX::Types::Structured

declare "Map",
	as "HashRef",
	where { ref $_ eq "HASH" },
	inline_as { "ref($_) eq 'HASH'" },
	constraint_generator => sub
	{
		my ($keys, $values) = @_;
		return sub
		{
			my $hash = shift;
			$keys->check($_)   || return for keys %$hash;
			$values->check($_) || return for values %$hash;
			return !!1;
		};
	},
	inline_generator => sub {
		my ($k, $v) = @_;
		return unless $k->can_be_inlined && $v->can_be_inlined;
		my $k_check = $k->inline_check('$k');
		my $v_check = $v->inline_check('$v');
		return sub {
			my $h = $_[1];
			"ref($h) eq 'HASH' and do { "
			.  "my \$ok = 1; "
			.  "for my \$v (values \%{$h}) { "
			.    "\$ok = 0 && last unless $v_check "
			.  "}; "
			.  "for my \$k (keys \%{$h}) { "
			.    "\$ok = 0 && last unless $k_check "
			.  "}; "
			.  "\$ok "
			."}"
		};
	};

declare "Optional",
	as "Item",
	constraint_generator => sub
	{
		my $param = shift;
		sub { exists($_[0]) ? $param->check($_[0]) : !!1 }
	};

sub slurpy ($) { +{ slurpy => $_[0] } }

declare "Tuple",
	as "ArrayRef",
	where { ref $_ eq "ARRAY" },
	inline_as { "ref($_) eq 'ARRAY'" },
	name_generator => sub
	{
		my ($s, @a) = @_;
		sprintf('%s[%s]', $s, join q[,], map { ref($_) eq "HASH" ? sprintf("slurpy %s", $_->{slurpy}) : $_ } @a);
	},
	constraint_generator => sub
	{
		my @constraints = @_;
		my $slurpy;
		if (exists $constraints[-1] and ref $constraints[-1] eq "HASH")
		{
			$slurpy = pop(@constraints)->{slurpy};
		}
		
		return sub
		{
			my $value = $_[0];
			if ($#constraints < $#$value)
			{
				$slurpy or return;
				$slurpy->check([@$value[$#constraints+1 .. $#$value]]) or return;
			}
			for my $i (0 .. $#constraints)
			{
				$constraints[$i]->check(exists $value->[$i] ? $value->[$i] : ()) or return;
			}
			return !!1;
		};
	};

declare "Dict",
	as "HashRef",
	where { ref $_ eq "HASH" },
	inline_as { "ref($_) eq 'HASH'" },
	name_generator => sub
	{
		my ($s, %a) = @_;
		sprintf('%s[%s]', $s, join q[,], map sprintf("%s=>%s", $_, $a{$_}), sort keys %a);
	},
	constraint_generator => sub
	{
		my %constraints = @_;
		return sub
		{
			my $value = $_[0];
			exists ($constraints{$_}) || return for sort keys %$value;
			$constraints{$_}->check(exists $value->{$_} ? $value->{$_} : ()) || return for sort keys %constraints;
			return !!1;
		};
	};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Type::Standard - bundled set of built-in types for Type::Tiny

=head1 DESCRIPTION

L<Type::Tiny> bundles a few types which seem to be useful.

=head2 Moose-like

The following types are similar to those described in
L<Moose::Util::TypeConstraints>.

=over

=item C<< Any >>

=item C<< Item >>

=item C<< Bool >>

=item C<< Maybe[`a] >>

=item C<< Undef >>

=item C<< Defined >>

=item C<< Value >>

=item C<< Str >>

=item C<< Num >>

=item C<< Int >>

=item C<< ClassName >>

=item C<< RoleName >>

=item C<< Ref[`a] >>

=item C<< ScalarRef[`a] >>

=item C<< ArrayRef[`a] >>

=item C<< HashRef[`a] >>

=item C<< CodeRef >>

=item C<< RegexpRef >>

=item C<< GlobRef >>

=item C<< FileHandle >>

=item C<< Object >>

=back

Unlike Moose, C<Ref> is a parameterized type, allowing Scalar::Util::reftype
checks, a la

   Ref["HASH"]  # hashrefs, including blessed hashrefs

=head2 Structured

OK, so I stole some ideas from L<MooseX::Types::Structured>.

=over

=item C<< Map[`a] >>

=item C<< Tuple[`a] >>

=item C<< Dict[`a] >>

=item C<< Optional[`a] >>

=back

This module also exports a C<slurpy> function.

=begin trustme

=item slurpy

=end trustme

=head2 More

There are a couple of other types exported by this function:

=over

=item C<< Overload[`a] >>

With no parameters, checks that the value is an overloaded object. Can
be given one or more string parameters, which are specific operations
to check are overloaded. For example, the following checks for objects
which overload addition and subtraction.

   Overload["+", "-"]

=back

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

=head1 SEE ALSO

L<Type::Tiny::Manual>.

L<Type::Tiny>, L<Type::Library>, L<Type::Utils>, L<Type::Coercion>.

L<Moose::Util::TypeConstraints>,
L<Mouse::Util::TypeConstraints>.

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

