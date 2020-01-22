=head1 NAME

Pegex::App::CLI - Pegex-based application for parsing anything

=head1 DESCRIPTION

L<App::CLI>

L<App::CLI::Command>

=cut

package Pegex::App::CLI;

use strict;
use warnings;

our $VERSION = "0.1";

use base qw(App::CLI App::CLI::Command);

use constant alias => (
	"--help"	=> "help",
	"--version"	=> "version",
);

1;

# =========================================================================

# EOF
