=head1 NAME

Pegex::App::CLI::Help - Print usage

=head1 USAGE

    pegex-cli help [command]

=head1 DESCRIPTION

Print usage and exit.

=head1 OPTIONS

=over 4

=item B<commands>

Print the brief usage for all commands.

=back

=cut

package Pegex::App::CLI::Help;

use base qw(App::CLI::Command::Help);

# =========================================================================

=pod

=begin comment

sub brief_usage {
    my ( $self, $file ) = @_;

    open my ($podfh), '<', ( $file || $self->filename ) or return;
    local $/ = undef;
    my $buf  = <$podfh>;
    close $podfh;

    my $base = ref $self->app;

    my $cmd;
    my $brief;

    if ( $buf =~ /^=head1\s+NAME\s*\Q$base\E::(\w+) - (.+)$/m ) {
        $cmd = $1;
        $brief = $2;
    } else {
        $cmd = $file || $self->filename;
        $cmd =~ s/^(?:.*)\/(.*?).pm$/$1/;
        $brief = "undocumented";
    }

    use Locale::Maketext::Simple;

    $cmd = lc($cmd);
    $brief = loc($brief);

    my $indent = "    ";

    if ( defined wantarray ) {
        return [ $cmd, $brief ];
    } else {
        print "$indent$cmd - $brief\n";
    }
}

=end comment

=cut

1;

# =========================================================================

# EOF
