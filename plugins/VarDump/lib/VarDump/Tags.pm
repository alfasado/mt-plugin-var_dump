package VarDump::Tags;

use strict;
use Data::Dumper;

use MT::Util qw( encode_html );

sub _hdlr_vardump {
    my ( $ctx, $args, $cond ) = @_;
    my $vars = $ctx->{ __stash }{ vars } ||= {};
    my $dump = Dumper $vars;
    $dump = encode_html( $dump );
    $dump = '<pre><code style="overflow:auto">' . $dump . '</code></pre>';
    return $dump;
}

1;