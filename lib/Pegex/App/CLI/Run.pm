=head1 NAME

Pegex::App::CLI::Run - Run a particular Pegex loader and parser

=head1 USAGE

    pegex-cli run [OPTIONS] filename

=head1 DESCRIPTION

The Pegex loader and parser.

=head1 OPTIONS

=over 4

=item B<-h>, B<--help>

Print this help and exit.

=item B<--syntax>=I<SYNTAX>

Load or run the input with the SYNTAX.

Internally the SYNTAX is implemented as the C<Pegex::SYNTAX> module. It should implement one of the methods: C<load> or C<run>.

B<Take your attention!>

The syntax name is case sensitive, For instance, if you have the module C<Pegex::JSON>, you have to specify the syntax exactly as C<JSON>, not C<json> or whatever else, because C<JSON> and C<json> and others are different strings.

=item B<--debug>

Turn on debugging.

=back

=head1 SEE ALSO

L<App::CLI::Command>

L<Pegex::Parser>

L<Pegex::Grammar>

L<Pegex::Receiver>

=cut

package Pegex::App::CLI::Run;

use strict;
use warnings;

use base qw(App::CLI::Command);

use constant options => (
	"h|help"	=> "help",

	"syntax=s"	=> "syntax",
	"debug"		=> "debug",
);

# =========================================================================

# This method can be invoked from the Pegex::* modules to recongnize what 
# is the current command and what to do further in the case if the module 
# can process the input in more than one way.

sub get_command_name {
	my $self = shift;
	( my $command = ref $self ) =~ s/.*:://;
	lc $command;
}

# Read STDIN or a file(s) as @ARGV.
# Overwrite it, if you need something more specific.

sub read_input {
	local $/;
	<>;
}

sub run {
	my $self = shift;

	if ( $self->{help} ) {
		$self->usage(1);
		return;
	}

	$ENV{PERL_PEGEX_DEBUG} = 1 if $self->{debug};

	my $syntax = $self->{syntax} or die "Syntax required.\n";

	my $module = "Pegex::$syntax";

	eval "use $module; 1" or die "$@\n";
	die "Not a syntax $syntax in $module\n"
		if grep { $module->isa($_) } qw(App::CLI App::CLI::Command);

	my ( $method ) = grep { $module->can($_) } qw(load run)
		or die "Can't invoke $module->load() or $module->run() for $syntax\n";

	my $input = $self->read_input;
	my $output = $module->$method($input);

	return unless defined $output;

	print ! ref $output ? $output : do {
		use Data::Dumper;
		$Data::Dumper::Indent = 1;
		Dumper $output;
	};
}
 
1;

# =========================================================================

# EOF
