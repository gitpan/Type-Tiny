use strict;
use ExtUtils::MakeMaker 6.17;

my $EUMM = eval( $ExtUtils::MakeMaker::VERSION );

my $meta = {
  "abstract"       => "tiny, yet Moo(se)-compatible type constraint",
  "author"         => ["Toby Inkster (TOBYINK) <tobyink\@cpan.org>"],
  "dynamic_config" => 1,
  "generated_by"   => "Dist::Inkt::Profile::TOBYINK version 0.023, CPAN::Meta::Converter version 2.142690",
  "keywords"       => [
                        "Argument Checking",
                        "Argument Validation",
                        "Moo",
                        "Moose",
                        "Mouse",
                        "Parameter Checking",
                        "Parameter Validation",
                        "Schema",
                        "Type Coercion",
                        "Type Constraint",
                        "Type Library",
                        "Validation",
                      ],
  "license"        => ["perl_5"],
  "meta-spec"      => {
                        url => "http://search.cpan.org/perldoc?CPAN::Meta::Spec",
                        version => 2,
                      },
  "name"           => "Type-Tiny",
  "no_index"       => { directory => ["eg", "examples", "inc", "t", "xt"] },
  "prereqs"        => {
                        configure => {
                                       recommends => { "CPAN::Meta::Requirements" => "2.000" },
                                       requires   => { "ExtUtils::MakeMaker" => 6.17 },
                                     },
                        develop   => { suggests => { "Dist::Inkt::Profile::TOBYINK" => 0 } },
                        runtime   => {
                                       conflicts  => { "Kavorka" => "<= 0.013", "Types::ReadOnly" => "<= 0.001" },
                                       recommends => {
                                                       "Devel::LexAlias" => 0.05,
                                                       "Devel::StackTrace" => 0,
                                                       "perl" => 5.010001,
                                                       "Sub::Name" => 0,
                                                       "Type::Tie" => 0,
                                                       "Type::Tiny::XS" => 0.011,
                                                     },
                                       requires   => { "Exporter::Tiny" => 0.026, "perl" => 5.006001 },
                                       suggests   => { Moo => "1.000000", Moose => "2.0000", Mouse => "1.00", Reply => 0 },
                                     },
                        test      => {
                                       recommends => { "Test::Tester" => 0.109, "Test::Warnings" => 0 },
                                       requires   => { "Test::More" => 0.96 },
                                     },
                      },
  "provides"       => {
                        "Devel::TypeTiny::Perl56Compat"            => {
                                                                        file => "lib/Devel/TypeTiny/Perl56Compat.pm",
                                                                        version => "1.001_002",
                                                                      },
                        "Devel::TypeTiny::Perl58Compat"            => {
                                                                        file => "lib/Devel/TypeTiny/Perl58Compat.pm",
                                                                        version => "1.001_002",
                                                                      },
                        "Error::TypeTiny"                          => { file => "lib/Error/TypeTiny.pm", version => "1.001_002" },
                        "Error::TypeTiny::Assertion"               => { file => "lib/Error/TypeTiny/Assertion.pm", version => "1.001_002" },
                        "Error::TypeTiny::Compilation"             => { file => "lib/Error/TypeTiny/Compilation.pm", version => "1.001_002" },
                        "Error::TypeTiny::WrongNumberOfParameters" => {
                                                                        file => "lib/Error/TypeTiny/WrongNumberOfParameters.pm",
                                                                        version => "1.001_002",
                                                                      },
                        "Eval::TypeTiny"                           => { file => "lib/Eval/TypeTiny.pm", version => "1.001_002" },
                        "Reply::Plugin::TypeTiny"                  => { file => "lib/Reply/Plugin/TypeTiny.pm", version => "1.001_002" },
                        "Test::TypeTiny"                           => { file => "lib/Test/TypeTiny.pm", version => "1.001_002" },
                        "Type::Coercion"                           => { file => "lib/Type/Coercion.pm", version => "1.001_002" },
                        "Type::Coercion::FromMoose"                => { file => "lib/Type/Coercion/FromMoose.pm", version => "1.001_002" },
                        "Type::Coercion::Union"                    => { file => "lib/Type/Coercion/Union.pm", version => "1.001_002" },
                        "Type::Library"                            => { file => "lib/Type/Library.pm", version => "1.001_002" },
                        "Type::Params"                             => { file => "lib/Type/Params.pm", version => "1.001_002" },
                        "Type::Parser"                             => { file => "lib/Type/Parser.pm", version => "1.001_002" },
                        "Type::Registry"                           => { file => "lib/Type/Registry.pm", version => "1.001_002" },
                        "Type::Tiny"                               => { file => "lib/Type/Tiny.pm", version => "1.001_002" },
                        "Type::Tiny::Class"                        => { file => "lib/Type/Tiny/Class.pm", version => "1.001_002" },
                        "Type::Tiny::Duck"                         => { file => "lib/Type/Tiny/Duck.pm", version => "1.001_002" },
                        "Type::Tiny::Enum"                         => { file => "lib/Type/Tiny/Enum.pm", version => "1.001_002" },
                        "Type::Tiny::Intersection"                 => { file => "lib/Type/Tiny/Intersection.pm", version => "1.001_002" },
                        "Type::Tiny::Role"                         => { file => "lib/Type/Tiny/Role.pm", version => "1.001_002" },
                        "Type::Tiny::Union"                        => { file => "lib/Type/Tiny/Union.pm", version => "1.001_002" },
                        "Type::Utils"                              => { file => "lib/Type/Utils.pm", version => "1.001_002" },
                        "Types::Common::Numeric"                   => { file => "lib/Types/Common/Numeric.pm", version => "1.001_002" },
                        "Types::Common::String"                    => { file => "lib/Types/Common/String.pm", version => "1.001_002" },
                        "Types::Standard"                          => { file => "lib/Types/Standard.pm", version => "1.001_002" },
                        "Types::Standard::ArrayRef"                => { file => "lib/Types/Standard/ArrayRef.pm", version => "1.001_002" },
                        "Types::Standard::Dict"                    => { file => "lib/Types/Standard/Dict.pm", version => "1.001_002" },
                        "Types::Standard::HashRef"                 => { file => "lib/Types/Standard/HashRef.pm", version => "1.001_002" },
                        "Types::Standard::Map"                     => { file => "lib/Types/Standard/Map.pm", version => "1.001_002" },
                        "Types::Standard::ScalarRef"               => { file => "lib/Types/Standard/ScalarRef.pm", version => "1.001_002" },
                        "Types::Standard::Tuple"                   => { file => "lib/Types/Standard/Tuple.pm", version => "1.001_002" },
                        "Types::TypeTiny"                          => { file => "lib/Types/TypeTiny.pm", version => "1.001_002" },
                      },
  "release_status" => "testing",
  "resources"      => {
                        bugtracker   => { web => "http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny" },
                        homepage     => "https://metacpan.org/release/Type-Tiny",
                        license      => ["http://dev.perl.org/licenses/"],
                        repository   => {
                                          type => "git",
                                          url  => "git://github.com/tobyink/p5-type-tiny.git",
                                          web  => "https://github.com/tobyink/p5-type-tiny",
                                        },
                        x_identifier => "http://purl.org/NET/cpan-uri/dist/Type-Tiny/project",
                        x_IRC        => "irc://irc.perl.org/#moops",
                      },
  "version"        => "1.001_002",
  "x_breaks"       => { "Kavorka" => "<= 0.013", "Types::ReadOnly" => "<= 0.001" },
  "x_contributors" => [
                        "Diab Jerius (DJERIUS) <djerius\@cpan.org>",
                        "Vyacheslav Matyukhin (MMCLERIC) <mmcleric\@cpan.org>",
                        "Peter Flanigan (PJFL) <pjfl\@cpan.org>",
                        "Pierre Masci",
                        "Mark Stosberg (MARKSTOS) <markstos\@cpan.org>",
                        "David Steinbrunner <dsteinbrunner\@pobox.com>",
                        "Samuel Kaufman (SKAUFMAN) <skaufman\@cpan.org>",
                        "Graham Knop (HAARG) <haarg\@cpan.org>",
                        "Peter Karman (KARMAN) <karman\@cpan.org>",
                        "Alexander Hartmaier (ABRAXXA) <abraxxa\@cpan.org>",
                        "Dagfinn Ilmari Manns\xE5ker (ILMARI) <ilmari\@cpan.org>",
                        "Gianni Ceccarelli (DAKKAR) <dakkar\@cpan.org>",
                      ],
};

my %dynamic_config;
do {
$meta->{prereqs}{runtime}{requires}{'Scalar::Util'}   = '1.13'  if $] < 5.007003;
$meta->{prereqs}{runtime}{requires}{'Data::Dumper'}   = '1.121' if $] < 5.008001;
$meta->{prereqs}{runtime}{requires}{'Text::Balanced'} = '1.95'  if $] < 5.007003;
$meta->{prereqs}{runtime}{requires}{'Exporter'}       = '5.57'  if $] < 5.009001;

if ($ENV{EXTENDED_TESTING} and $meta->{version} =~ /_/)
{
	$meta->{prereqs}{test}{requires}{'Moose'} = '2.0600';
}

};
for my $stage (keys %{$meta->{prereqs}})
{
	my $conflicts = $meta->{prereqs}{$stage}{conflicts} or next;
	eval { require CPAN::Meta::Requirements } or last;
	$conflicts = 'CPAN::Meta::Requirements'->from_string_hash($conflicts);
	
	for my $module ($conflicts->required_modules)
	{
		eval "require $module" or next;
		my $installed = eval(sprintf('$%s::VERSION', $module));
		$conflicts->accepts_module($module, $installed) or next;
		
		my $message = "\n".
			"** This version of $meta->{name} conflicts with the version of\n".
			"** module $module ($installed) you have installed.\n";
		die($message . "\n" . "Bailing out")
			if $stage eq 'build' || $stage eq 'configure';
		
		$message .= "**\n".
			"** It's strongly recommended that you update it after\n".
			"** installing this version of $meta->{name}.\n";
		warn("$message\n");
	}
}

my %WriteMakefileArgs = (
	ABSTRACT   => $meta->{abstract},
	AUTHOR     => ($EUMM >= 6.5702 ? $meta->{author} : $meta->{author}[0]),
	DISTNAME   => $meta->{name},
	VERSION    => $meta->{version},
	EXE_FILES  => [ map $_->{file}, values %{ $meta->{x_provides_scripts} || {} } ],
	NAME       => do { my $n = $meta->{name}; $n =~ s/-/::/g; $n },
	test       => { TESTS => "t/*.t t/20-unit/Devel-TypeTiny-Perl56Compat/*.t t/20-unit/Devel-TypeTiny-Perl58Compat/*.t t/20-unit/Error-TypeTiny-Assertion/*.t t/20-unit/Error-TypeTiny-Compilation/*.t t/20-unit/Error-TypeTiny-WrongNumberOfParameters/*.t t/20-unit/Error-TypeTiny/*.t t/20-unit/Eval-TypeTiny/*.t t/20-unit/Test-TypeTiny/*.t t/20-unit/Type-Coercion-FromMoose/*.t t/20-unit/Type-Coercion-Union/*.t t/20-unit/Type-Coercion/*.t t/20-unit/Type-Library/*.t t/20-unit/Type-Params/*.t t/20-unit/Type-Parser/*.t t/20-unit/Type-Registry/*.t t/20-unit/Type-Tiny-Class/*.t t/20-unit/Type-Tiny-Duck/*.t t/20-unit/Type-Tiny-Enum/*.t t/20-unit/Type-Tiny-Intersection/*.t t/20-unit/Type-Tiny-Role/*.t t/20-unit/Type-Tiny-Union/*.t t/20-unit/Type-Tiny-_HalfOp/*.t t/20-unit/Type-Tiny/*.t t/20-unit/Type-Utils/*.t t/20-unit/Types-Common-Numeric/*.t t/20-unit/Types-Common-String/*.t t/20-unit/Types-Standard/*.t t/20-unit/Types-TypeTiny/*.t t/30-integration/Class-InsideOut/*.t t/30-integration/Exporter-Tiny/*.t t/30-integration/Function-Parameters/*.t t/30-integration/Kavorka/*.t t/30-integration/Moo/*.t t/30-integration/Moops/*.t t/30-integration/Moose/*.t t/30-integration/MooseX-Getopt/*.t t/30-integration/MooseX-Types/*.t t/30-integration/Mouse/*.t t/30-integration/MouseX-Types/*.t t/30-integration/Object-Accessor/*.t t/30-integration/Return-Type/*.t t/30-integration/Sub-Quote/*.t t/30-integration/Switcheroo/*.t t/30-integration/Type-Tie/*.t t/30-integration/Validation-Class-Simple/*.t t/30-integration/match-simple/*.t t/40-regression/*.t" },
	%dynamic_config,
);

$WriteMakefileArgs{LICENSE} = $meta->{license}[0] if $EUMM >= 6.3001;

sub deps
{
	my %r;
	for my $stage (@_)
	{
		for my $dep (keys %{$meta->{prereqs}{$stage}{requires}})
		{
			next if $dep eq 'perl';
			my $ver = $meta->{prereqs}{$stage}{requires}{$dep};
			$r{$dep} = $ver if !exists($r{$dep}) || $ver >= $r{$dep};
		}
	}
	\%r;
}

my ($build_requires, $configure_requires, $runtime_requires, $test_requires);
if ($EUMM >= 6.6303)
{
	$WriteMakefileArgs{BUILD_REQUIRES}     ||= deps('build');
	$WriteMakefileArgs{CONFIGURE_REQUIRES} ||= deps('configure');
	$WriteMakefileArgs{TEST_REQUIRES}      ||= deps('test');
	$WriteMakefileArgs{PREREQ_PM}          ||= deps('runtime');
}
elsif ($EUMM >= 6.5503)
{
	$WriteMakefileArgs{BUILD_REQUIRES}     ||= deps('build', 'test');
	$WriteMakefileArgs{CONFIGURE_REQUIRES} ||= deps('configure');
	$WriteMakefileArgs{PREREQ_PM}          ||= deps('runtime');	
}
elsif ($EUMM >= 6.52)
{
	$WriteMakefileArgs{CONFIGURE_REQUIRES} ||= deps('configure');
	$WriteMakefileArgs{PREREQ_PM}          ||= deps('runtime', 'build', 'test');	
}
else
{
	$WriteMakefileArgs{PREREQ_PM}          ||= deps('configure', 'build', 'test', 'runtime');	
}

{
	my ($minperl) = reverse sort(
		grep defined && /^[0-9]+(\.[0-9]+)?$/,
		map $meta->{prereqs}{$_}{requires}{perl},
		qw( configure build runtime )
	);
	
	if (defined($minperl))
	{
		die "Installing $meta->{name} requires Perl >= $minperl"
			unless $] >= $minperl;
		
		$WriteMakefileArgs{MIN_PERL_VERSION} ||= $minperl
			if $EUMM >= 6.48;
	}
}

sub FixMakefile
{
	return unless -d 'inc';
	my $file = shift;
	
	local *MAKEFILE;
	open MAKEFILE, "< $file" or die "FixMakefile: Couldn't open $file: $!; bailing out";
	my $makefile = do { local $/; <MAKEFILE> };
	close MAKEFILE or die $!;
	
	$makefile =~ s/\b(test_harness\(\$\(TEST_VERBOSE\), )/$1'inc', /;
	$makefile =~ s/( -I\$\(INST_ARCHLIB\))/ -Iinc$1/g;
	$makefile =~ s/( "-I\$\(INST_LIB\)")/ "-Iinc"$1/g;
	$makefile =~ s/^(FULLPERL = .*)/$1 "-Iinc"/m;
	$makefile =~ s/^(PERL = .*)/$1 "-Iinc"/m;
	
	open  MAKEFILE, "> $file" or die "FixMakefile: Couldn't open $file: $!; bailing out";
	print MAKEFILE $makefile or die $!;
	close MAKEFILE or die $!;
}

my $mm = WriteMakefile(%WriteMakefileArgs);
FixMakefile($mm->{FIRST_MAKEFILE} || 'Makefile');
exit(0);

