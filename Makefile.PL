use strict;
use ExtUtils::MakeMaker 6.17;

my $EUMM = eval( $ExtUtils::MakeMaker::VERSION );

my $meta = {
  "abstract"       => "tiny, yet Moo(se)-compatible type constraint",
  "author"         => ["Toby Inkster (TOBYINK) <tobyink\@cpan.org>"],
  "dynamic_config" => 1,
  "generated_by"   => "Dist::Inkt::Profile::TOBYINK version 0.013, CPAN::Meta::Converter version 2.120921",
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
                        configure => { requires => { "ExtUtils::MakeMaker" => 6.17 } },
                        develop   => { suggests => { "Dist::Inkt" => 0.007 } },
                        runtime   => {
                                       recommends => { "Devel::LexAlias" => 0.05, "Devel::StackTrace" => 0, "Type::Tie" => 0 },
                                       requires   => { "Exporter::Tiny" => 0.026 },
                                       suggests   => { Moo => "1.000000", Moose => "2.0400", Mouse => "1.00", Reply => 0 },
                                     },
                        test      => { requires => { "Test::More" => 0.96 } },
                      },
  "provides"       => {
                        "Devel::TypeTiny::Perl56Compat"            => { file => "lib/Devel/TypeTiny/Perl56Compat.pm", version => "0.030" },
                        "Devel::TypeTiny::Perl58Compat"            => { file => "lib/Devel/TypeTiny/Perl58Compat.pm", version => "0.030" },
                        "Error::TypeTiny"                          => { file => "lib/Error/TypeTiny.pm", version => "0.030" },
                        "Error::TypeTiny::Assertion"               => { file => "lib/Error/TypeTiny/Assertion.pm", version => "0.030" },
                        "Error::TypeTiny::Compilation"             => { file => "lib/Error/TypeTiny/Compilation.pm", version => "0.030" },
                        "Error::TypeTiny::WrongNumberOfParameters" => {
                                                                        file => "lib/Error/TypeTiny/WrongNumberOfParameters.pm",
                                                                        version => "0.030",
                                                                      },
                        "Eval::TypeTiny"                           => { file => "lib/Eval/TypeTiny.pm", version => "0.030" },
                        "Exporter::TypeTiny"                       => { file => "lib/Exporter/TypeTiny.pm", version => "0.030" },
                        "Reply::Plugin::TypeTiny"                  => { file => "lib/Reply/Plugin/TypeTiny.pm", version => "0.030" },
                        "Test::TypeTiny"                           => { file => "lib/Test/TypeTiny.pm", version => "0.030" },
                        "Type::Coercion"                           => { file => "lib/Type/Coercion.pm", version => "0.030" },
                        "Type::Coercion::FromMoose"                => { file => "lib/Type/Coercion/FromMoose.pm", version => "0.030" },
                        "Type::Coercion::Union"                    => { file => "lib/Type/Coercion/Union.pm", version => "0.030" },
                        "Type::Library"                            => { file => "lib/Type/Library.pm", version => "0.030" },
                        "Type::Params"                             => { file => "lib/Type/Params.pm", version => "0.030" },
                        "Type::Parser"                             => { file => "lib/Type/Parser.pm", version => "0.030" },
                        "Type::Registry"                           => { file => "lib/Type/Registry.pm", version => "0.030" },
                        "Type::Tiny"                               => { file => "lib/Type/Tiny.pm", version => "0.030" },
                        "Type::Tiny::Class"                        => { file => "lib/Type/Tiny/Class.pm", version => "0.030" },
                        "Type::Tiny::Duck"                         => { file => "lib/Type/Tiny/Duck.pm", version => "0.030" },
                        "Type::Tiny::Enum"                         => { file => "lib/Type/Tiny/Enum.pm", version => "0.030" },
                        "Type::Tiny::Intersection"                 => { file => "lib/Type/Tiny/Intersection.pm", version => "0.030" },
                        "Type::Tiny::Role"                         => { file => "lib/Type/Tiny/Role.pm", version => "0.030" },
                        "Type::Tiny::Union"                        => { file => "lib/Type/Tiny/Union.pm", version => "0.030" },
                        "Type::Utils"                              => { file => "lib/Type/Utils.pm", version => "0.030" },
                        "Types::Standard"                          => { file => "lib/Types/Standard.pm", version => "0.030" },
                        "Types::TypeTiny"                          => { file => "lib/Types/TypeTiny.pm", version => "0.030" },
                      },
  "release_status" => "stable",
  "resources"      => {
                        bugtracker   => { web => "http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny" },
                        homepage     => "https://metacpan.org/release/Type-Tiny",
                        license      => ["http://dev.perl.org/licenses/"],
                        repository   => { type => "git", web => "https://github.com/tobyink/p5-type-tiny" },
                        X_identifier => "http://purl.org/NET/cpan-uri/dist/Type-Tiny/project",
                      },
  "version"        => "0.030",
  "x_contributors" => [
                        "Diab Jerius (DJERIUS) <djerius\@cpan.org>",
                        "Vyacheslav Matyukhin (MMCLERIC) <mmcleric\@cpan.org>",
                        "Pierre Masci",
                        "Mark Stosberg (MARKSTOS) <markstos\@cpan.org>",
                      ],
};

my %dynamic_config;
do {
$meta->{prereqs}{runtime}{requires}{'Scalar::Util'}   = '1.13' if $] < 5.007003;
$meta->{prereqs}{runtime}{requires}{'Text::Balanced'} = '1.95' if $] < 5.007003;
$meta->{prereqs}{runtime}{requires}{'Exporter'}       = '5.57' if $] < 5.009001;
$meta->{prereqs}{runtime}{requires}{'Class::ISA'}     = '0.32' if $] < 5.009005;

if ($ENV{EXTENDED_TESTING} and $meta->{version} =~ /_/)
{
	$meta->{prereqs}{test}{requires}{'Moose'} = '2.0600';
}

};

my %WriteMakefileArgs = (
	ABSTRACT   => $meta->{abstract},
	AUTHOR     => ($EUMM >= 6.5702 ? $meta->{author} : $meta->{author}[0]),
	DISTNAME   => $meta->{name},
	VERSION    => $meta->{version},
	EXE_FILES  => [ map $_->{file}, values %{ $meta->{x_provides_scripts} || {} } ],
	NAME       => do { my $n = $meta->{name}; $n =~ s/-/::/g; $n },
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

