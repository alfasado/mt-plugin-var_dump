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

sub _hdlr_cookiedump {
    my $vars = MT->instance->cookies;
    my $dump = Dumper $vars;
    $dump = encode_html( $dump );
    $dump = '<pre><code style="overflow:auto">' . $dump . '</code></pre>';
    return $dump;
}

sub _hdlr_querydump {
    my $var = MT->instance->query_string;
    return "<pre><code style=\"overflow:auto\">\n\$VAR1 = undef;\n</code></pre>" if ! $var;
    my @vars = split( /;/, $var );
    my $params;
    for my $query ( @vars ) {
        my ( $key, $value ) = split( /=/, $query );
        $params->{ $key } = $value;
    }
    my $dump = Dumper $params;
    $dump = encode_html( $dump );
    $dump = '<pre><code style="overflow:auto">' . $dump . '</code></pre>';
    return $dump;
}

sub _hdlr_envdump {
    my $params;
    for my $key ( keys %ENV ) {
        $params->{ $key } = $ENV{ $key };
    }
    my $dump = Dumper $params;
    $dump = encode_html( $dump );
    $dump = '<pre><code style="overflow:auto">' . $dump . '</code></pre>';
    return $dump;
}

1;