=pod

=encoding utf-8

=head1 PURPOSE

Checks various values against structured types from Types::Standard.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013-2014 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use strict;
use warnings;
use lib qw( . ./t ../inc ./inc );

use Test::More;
use Test::TypeTiny;

use Types::Standard -all, "slurpy";

my $struct1 = Map[Int, Num];

should_pass({1=>111,2=>222}, $struct1);
should_pass({1=>1.1,2=>2.2}, $struct1);
should_fail({1=>"Str",2=>222}, $struct1);
should_fail({1.1=>1,2=>2.2}, $struct1);

my $struct2 = Tuple[Int, Num, Optional([Int]), slurpy ArrayRef[Num]];
my $struct3 = Tuple[Int, Num, Optional[Int]];

should_pass([1, 1.1], $struct2);
should_pass([1, 1.1, 2], $struct2);
should_pass([1, 1.1, 2, 2.2], $struct2);
should_pass([1, 1.1, 2, 2.2, 2.3], $struct2);
should_pass([1, 1.1, 2, 2.2, 2.3, 2.4], $struct2);
should_fail({}, $struct2);
should_fail([], $struct2);
should_fail([1], $struct2);
should_fail([1.1, 1.1], $struct2);
should_fail([1, 1.1, 2.1], $struct2);
should_fail([1, 1.1, 2.1], $struct2);
should_fail([1, 1.1, 2, 2.2, 2.3, 2.4, "xyz"], $struct2);
should_fail([1, 1.1, undef], $struct2);
should_pass([1, 1.1], $struct3);
should_pass([1, 1.1, 2], $struct3);
should_fail([1, 1.1, 2, 2.2], $struct3);
should_fail([1, 1.1, 2, 2.2, 2.3], $struct3);
should_fail([1, 1.1, 2, 2.2, 2.3, 2.4], $struct3);
should_fail({}, $struct3);
should_fail([], $struct3);
should_fail([1], $struct3);
should_fail([1.1, 1.1], $struct3);
should_fail([1, 1.1, 2.1], $struct3);
should_fail([1, 1.1, 2.1], $struct3);
should_fail([1, 1.1, 2, 2.2, 2.3, 2.4, "xyz"], $struct3);
should_fail([1, 1.1, undef], $struct3);

my $struct4 = Dict[ name => Str, age => Int, height => Optional[Num] ];

should_pass({ name => "Bob", age => 40, height => 1.76 }, $struct4);
should_pass({ name => "Bob", age => 40 }, $struct4);
should_fail({ name => "Bob" }, $struct4);
should_fail({ age => 40 }, $struct4);
should_fail({ name => "Bob", age => 40.1 }, $struct4);
should_fail({ name => "Bob", age => 40, weight => 80.3 }, $struct4);
should_fail({ name => "Bob", age => 40, height => 1.76, weight => 80.3 }, $struct4);
should_fail({ name => "Bob", age => 40, height => "xyz" }, $struct4);
should_fail({ name => "Bob", age => 40, height => undef }, $struct4);
should_fail({ name => "Bob", age => undef, height => 1.76 }, $struct4);

my $opt1 = Optional[Int];
ok( $opt1->check(1), "$opt1 check (1)");
ok(!$opt1->check('xxx'), "$opt1 check ('xxx')");

my $slurper = Tuple[ArrayRef, slurpy Map[Num, Int]];

should_pass([ [], 1.1 => 1, 2.1 => 2 ], $slurper);
should_pass([ [] ], $slurper);
should_fail([ [], 1.1 => 1, xxx => 2 ], $slurper);
should_fail([ [], 1.1 => 1, 2.1 => undef ], $slurper);

my $struct5 = Dict[ i => Maybe[Int], b => Bool ];
should_pass({ i => 42, b => undef }, $struct5);
should_pass({ i => 42, b => '' }, $struct5);
should_pass({ i => 42, b => 0 }, $struct5);
should_pass({ i => 42, b => 1 }, $struct5);
should_pass({ i => undef, b => 1 }, $struct5);
should_fail({ b => 42, i => 1 }, $struct5);
should_fail({ i => 42 }, $struct5);
should_fail({ b => 1 }, $struct5);
should_fail({ i => 42, b => 1, a => 1 }, $struct5);
should_fail({ i => 42, a => 1 }, $struct5);
should_fail({ a => 42, b => 1 }, $struct5);

my $anyany = Tuple[Any, Any];

should_pass([1,1], $anyany);
should_pass([1,undef], $anyany);
should_pass([undef,undef], $anyany);
should_pass([undef,1], $anyany);
should_fail([1], $anyany);
should_fail([undef], $anyany);
should_fail([1,1,1], $anyany);
should_fail([1,1,undef], $anyany);

note "Tuple[] vs Tuple";
should_pass([ ], Tuple[]);
should_fail([1], Tuple[]);
should_pass([ ], Tuple);
should_pass([1], Tuple);

note "Dict[] vs Dict";
should_pass(+{      }, Dict[]);
should_fail(+{foo=>1}, Dict[]);
should_pass(+{      }, Dict);
should_pass(+{foo=>1}, Dict);

my $gazetteer = Dict[ foo => Int, bar => Optional[Int], slurpy HashRef[Num] ];
note "Dict[ ..., slurpy ... ]";
should_pass({ foo => 42 }, $gazetteer);
should_pass({ foo => 42, bar => 666 }, $gazetteer);
should_fail({ foo => 4.2 }, $gazetteer);
should_fail({ foo => 42, bar => 6.66 }, $gazetteer);
should_fail({ foo => 4.2, bar => 6.66 }, $gazetteer);
should_fail({ foo => undef }, $gazetteer);
should_fail({ }, $gazetteer);
should_pass({ foo => 42, baz => 999 }, $gazetteer);
should_pass({ foo => 42, bar => 666, baz => 999 }, $gazetteer);
should_fail({ foo => 4.2, baz => 999 }, $gazetteer);
should_fail({ foo => 42, bar => 6.66, baz => 999 }, $gazetteer);
should_fail({ foo => 4.2, bar => 6.66, baz => 999 }, $gazetteer);
should_fail({ foo => undef, baz => 999 }, $gazetteer);
should_fail({ baz => 999 }, $gazetteer);
should_pass({ foo => 42, baz => 9.99 }, $gazetteer);
should_pass({ foo => 42, bar => 666, baz => 9.99 }, $gazetteer);
should_fail({ foo => 4.2, baz => 9.99 }, $gazetteer);
should_fail({ foo => 42, bar => 6.66, baz => 9.99 }, $gazetteer);
should_fail({ foo => 4.2, bar => 6.66, baz => 9.99 }, $gazetteer);
should_fail({ foo => undef, baz => 9.99 }, $gazetteer);
should_fail({ baz => 9.99 }, $gazetteer);
should_fail({ foo => 42, baz => "x" }, $gazetteer);
should_fail({ foo => 42, bar => 666, baz => "x" }, $gazetteer);
should_fail({ foo => 4.2, baz => "x" }, $gazetteer);
should_fail({ foo => 42, bar => 6.66, baz => "x" }, $gazetteer);
should_fail({ foo => 4.2, bar => 6.66, baz => "x" }, $gazetteer);
should_fail({ foo => undef, baz => "x" }, $gazetteer);
should_fail({ baz => "x" }, $gazetteer);

subtest my_dict_is_slurpy => sub
{
	ok(!$struct5->my_dict_is_slurpy, 'On a non-slurpy Dict');
	ok($gazetteer->my_dict_is_slurpy, 'On a slurpy Dict');
	ok(!$struct5->create_child_type->my_dict_is_slurpy, 'On a child of a non-slurpy Dict');
	ok($gazetteer->create_child_type->my_dict_is_slurpy, 'On a child of a slurpy Dict');
};

subtest my_hashref_allows_key => sub
{
	ok(HashRef->my_hashref_allows_key('foo'), 'HashRef allows key "foo"');
	ok(!HashRef->my_hashref_allows_key(undef), 'HashRef disallows key undef');
	ok(!HashRef->my_hashref_allows_key([]), 'HashRef disallows key []');
	ok((HashRef[Int])->my_hashref_allows_key('foo'), 'HashRef[Int] allows key "foo"');
	ok(!(HashRef[Int])->my_hashref_allows_key(undef), 'HashRef[Int] disallows key undef');
	ok(!(HashRef[Int])->my_hashref_allows_key([]), 'HashRef[Int] disallows key []');
	ok(Map->my_hashref_allows_key('foo'), 'Map allows key "foo"');
	ok(!Map->my_hashref_allows_key(undef), 'Map disallows key undef');
	ok(!Map->my_hashref_allows_key([]), 'Map disallows key []');
	ok(!(Map[Int,Int])->my_hashref_allows_key('foo'), 'Map[Int,Int] disallows key "foo"');
	ok(!(Map[Int,Int])->my_hashref_allows_key(undef), 'Map[Int,Int] disallows key undef');
	ok(!(Map[Int,Int])->my_hashref_allows_key([]), 'Map[Int,Int] disallows key []');
	ok((Map[Int,Int])->my_hashref_allows_key('42'), 'Map[Int,Int] allows key "42"');
	ok(Dict->my_hashref_allows_key('foo'), 'Dict allows key "foo"');
	ok(!Dict->my_hashref_allows_key(undef), 'Dict disallows key undef');
	ok(!Dict->my_hashref_allows_key([]), 'Dict disallows key []');
	ok(!(Dict[])->my_hashref_allows_key('foo'), 'Dict[] disallows key "foo"');
	ok(!(Dict[])->my_hashref_allows_key(undef), 'Dict[] disallows key undef');
	ok(!(Dict[])->my_hashref_allows_key([]), 'Dict[] disallows key []');
	ok(!(Dict[bar=>Int])->my_hashref_allows_key('foo'), 'Dict[bar=>Int] disallows key "foo"');
	ok((Dict[bar=>Int])->my_hashref_allows_key('bar'), 'Dict[bar=>Int] allows key "bar"');
	ok(!(Dict[bar=>Int])->my_hashref_allows_key(undef), 'Dict[bar=>Int] disallows key undef');
	ok(!(Dict[bar=>Int])->my_hashref_allows_key([]), 'Dict[bar=>Int] disallows key []');
	ok((Dict[bar=>Int, slurpy Any])->my_hashref_allows_key('foo'), 'Dict[bar=>Int,slurpy Any] allows key "foo"');
	ok((Dict[bar=>Int, slurpy Any])->my_hashref_allows_key('bar'), 'Dict[bar=>Int,slurpy Any] allows key "bar"');
	ok(!(Dict[bar=>Int, slurpy Any])->my_hashref_allows_key(undef), 'Dict[bar=>Int,slurpy Any] disallows key undef');
	ok(!(Dict[bar=>Int, slurpy Any])->my_hashref_allows_key([]), 'Dict[bar=>Int,slurpy Any] disallows key []');
	ok((Dict[bar=>Int, slurpy Ref])->my_hashref_allows_key('foo'), 'Dict[bar=>Int,slurpy Ref] allows key "foo"');
	ok((Dict[bar=>Int, slurpy Ref])->my_hashref_allows_key('bar'), 'Dict[bar=>Int,slurpy Ref] allows key "bar"');
	ok(!(Dict[bar=>Int, slurpy Ref])->my_hashref_allows_key(undef), 'Dict[bar=>Int,slurpy Ref] disallows key undef');
	ok(!(Dict[bar=>Int, slurpy Ref])->my_hashref_allows_key([]), 'Dict[bar=>Int,slurpy Ref] disallows key []');
	ok(!(Dict[bar=>Int, slurpy Map[Int,Int]])->my_hashref_allows_key('foo'), 'Dict[bar=>Int,slurpy Map[Int,Int]] disallows key "foo"');
	ok((Dict[bar=>Int, slurpy Map[Int,Int]])->my_hashref_allows_key('bar'), 'Dict[bar=>Int,slurpy Map[Int,Int]] allows key "bar"');
	ok(!(Dict[bar=>Int, slurpy Map[Int,Int]])->my_hashref_allows_key(undef), 'Dict[bar=>Int,slurpy Map[Int,Int]] disallows key undef');
	ok(!(Dict[bar=>Int, slurpy Map[Int,Int]])->my_hashref_allows_key([]), 'Dict[bar=>Int,slurpy Map[Int,Int]] disallows key []');
	ok((Dict[bar=>Int, slurpy Map[Int,Int]])->my_hashref_allows_key('42'), 'Dict[bar=>Int,slurpy Map[Int,Int]] allows key "42"');
	ok(HashRef->create_child_type->my_hashref_allows_key('foo'), 'A child of HashRef allows key "foo"');
	ok(!HashRef->create_child_type->my_hashref_allows_key(undef), 'A child of HashRef disallows key undef');
	ok(!HashRef->create_child_type->my_hashref_allows_key([]), 'A child of HashRef disallows key []');
	ok((HashRef[Int])->create_child_type->my_hashref_allows_key('foo'), 'A child of HashRef[Int] allows key "foo"');
	ok(!(HashRef[Int])->create_child_type->my_hashref_allows_key(undef), 'A child of HashRef[Int] disallows key undef');
	ok(!(HashRef[Int])->create_child_type->my_hashref_allows_key([]), 'A child of HashRef[Int] disallows key []');
	ok(Map->create_child_type->my_hashref_allows_key('foo'), 'A child of Map allows key "foo"');
	ok(!Map->create_child_type->my_hashref_allows_key(undef), 'A child of Map disallows key undef');
	ok(!Map->create_child_type->my_hashref_allows_key([]), 'A child of Map disallows key []');
	ok(!(Map[Int,Int])->create_child_type->my_hashref_allows_key('foo'), 'A child of Map[Int,Int] disallows key "foo"');
	ok(!(Map[Int,Int])->create_child_type->my_hashref_allows_key(undef), 'A child of Map[Int,Int] disallows key undef');
	ok(!(Map[Int,Int])->create_child_type->my_hashref_allows_key([]), 'A child of Map[Int,Int] disallows key []');
	ok((Map[Int,Int])->create_child_type->my_hashref_allows_key('42'), 'A child of Map[Int,Int] allows key "42"');
	ok(Dict->create_child_type->my_hashref_allows_key('foo'), 'A child of Dict allows key "foo"');
	ok(!Dict->create_child_type->my_hashref_allows_key(undef), 'A child of Dict disallows key undef');
	ok(!Dict->create_child_type->my_hashref_allows_key([]), 'A child of Dict disallows key []');
	ok(!(Dict[])->create_child_type->my_hashref_allows_key('foo'), 'A child of Dict[] disallows key "foo"');
	ok(!(Dict[])->create_child_type->my_hashref_allows_key(undef), 'A child of Dict[] disallows key undef');
	ok(!(Dict[])->create_child_type->my_hashref_allows_key([]), 'A child of Dict[] disallows key []');
	ok(!(Dict[bar=>Int])->create_child_type->my_hashref_allows_key('foo'), 'A child of Dict[bar=>Int] disallows key "foo"');
	ok((Dict[bar=>Int])->create_child_type->my_hashref_allows_key('bar'), 'A child of Dict[bar=>Int] allows key "bar"');
	ok(!(Dict[bar=>Int])->create_child_type->my_hashref_allows_key(undef), 'A child of Dict[bar=>Int] disallows key undef');
	ok(!(Dict[bar=>Int])->create_child_type->my_hashref_allows_key([]), 'A child of Dict[bar=>Int] disallows key []');
	ok((Dict[bar=>Int, slurpy Any])->create_child_type->my_hashref_allows_key('foo'), 'A child of Dict[bar=>Int,slurpy Any] allows key "foo"');
	ok((Dict[bar=>Int, slurpy Any])->create_child_type->my_hashref_allows_key('bar'), 'A child of Dict[bar=>Int,slurpy Any] allows key "bar"');
	ok(!(Dict[bar=>Int, slurpy Any])->create_child_type->my_hashref_allows_key(undef), 'A child of Dict[bar=>Int,slurpy Any] disallows key undef');
	ok(!(Dict[bar=>Int, slurpy Any])->create_child_type->my_hashref_allows_key([]), 'A child of Dict[bar=>Int,slurpy Any] disallows key []');
	ok((Dict[bar=>Int, slurpy Ref])->create_child_type->my_hashref_allows_key('foo'), 'A child of Dict[bar=>Int,slurpy Ref] allows key "foo"');
	ok((Dict[bar=>Int, slurpy Ref])->create_child_type->my_hashref_allows_key('bar'), 'A child of Dict[bar=>Int,slurpy Ref] allows key "bar"');
	ok(!(Dict[bar=>Int, slurpy Ref])->create_child_type->my_hashref_allows_key(undef), 'A child of Dict[bar=>Int,slurpy Ref] disallows key undef');
	ok(!(Dict[bar=>Int, slurpy Ref])->create_child_type->my_hashref_allows_key([]), 'A child of Dict[bar=>Int,slurpy Ref] disallows key []');
	ok(!(Dict[bar=>Int, slurpy Map[Int,Int]])->create_child_type->my_hashref_allows_key('foo'), 'A child of Dict[bar=>Int,slurpy Map[Int,Int]] disallows key "foo"');
	ok((Dict[bar=>Int, slurpy Map[Int,Int]])->create_child_type->my_hashref_allows_key('bar'), 'A child of Dict[bar=>Int,slurpy Map[Int,Int]] allows key "bar"');
	ok(!(Dict[bar=>Int, slurpy Map[Int,Int]])->create_child_type->my_hashref_allows_key(undef), 'A child of Dict[bar=>Int,slurpy Map[Int,Int]] disallows key undef');
	ok(!(Dict[bar=>Int, slurpy Map[Int,Int]])->create_child_type->my_hashref_allows_key([]), 'A child of Dict[bar=>Int,slurpy Map[Int,Int]] disallows key []');
	ok((Dict[bar=>Int, slurpy Map[Int,Int]])->create_child_type->my_hashref_allows_key('42'), 'A child of Dict[bar=>Int,slurpy Map[Int,Int]] allows key "42"');
};

# This could probably be expanded...
subtest my_hashref_allows_value => sub
{
	ok(HashRef->my_hashref_allows_value(foo => "bar"), 'HashRef allows key "foo" with value "bar"');
	ok(HashRef->my_hashref_allows_value(foo => undef), 'HashRef allows key "foo" with value undef');
	ok(!HashRef->my_hashref_allows_value(undef, "bar"), 'HashRef disallows key undef with value "bar"');
	ok(!(HashRef[Int])->my_hashref_allows_value(foo => "bar"), 'HashRef[Int] disallows key "foo" with value "bar"');
	ok((Dict[bar=>Int, slurpy Map[Int,Int]])->create_child_type->my_hashref_allows_value(bar => 42), 'A child of Dict[bar=>Int,slurpy Map[Int,Int]] allows key "bar" with value 42');
	ok((Dict[bar=>Int, slurpy Map[Int,Int]])->create_child_type->my_hashref_allows_value(21, 42), 'A child of Dict[bar=>Int,slurpy Map[Int,Int]] allows key "21" with value 42');
	ok(!(Dict[bar=>Int, slurpy Map[Int,Int]])->create_child_type->my_hashref_allows_value(baz => 42), 'A child of Dict[bar=>Int,slurpy Map[Int,Int]] disallows key "baz" with value 42');
};

done_testing;
