package VarDump::Tags;

use strict;
use Data::Dumper;

use MT::Util qw( encode_html );

sub _hdlr_stashdump {
    my ( $ctx, $args, $cond ) = @_;
    my $stash = $ctx->{ __stash } || {};
    my $name = $args->{ key } || $args->{ name };
    if ( $name && ref( $stash ) eq 'HASH' ) {
        $stash = $stash->{ $name };
    }
    if ( my $depth = $args->{ depth } ) {
        unless ( $depth eq 'all' ) {
            $Data::Dumper::Maxdepth = $depth;
        }
    } else {
        $Data::Dumper::Maxdepth = 3;
    }
    my $dump = Dumper $stash;
    return $dump if $args->{ raw };
    $dump = encode_html( $dump );
    $dump = '<pre><code style="overflow:auto">' . $dump . '</code></pre>';
    return $dump;
}

sub _hdlr_vardump {
    my ( $ctx, $args, $cond ) = @_;
    my $vars = $ctx->{ __stash }{ vars } ||= {};
    my $name = $args->{ key } || $args->{ name };
    if ( $name && ref( $vars ) eq 'HASH' ) {
        $vars = $vars->{ $name };
    }
    if ( my $depth = $args->{ depth } ) {
        unless ( $depth eq 'all' ) {
            $Data::Dumper::Maxdepth = $depth;
        }
    } else {
        $Data::Dumper::Maxdepth = 1;
    }
    my $dump = Dumper $vars;
    return $dump if $args->{ raw };
    $dump = encode_html( $dump );
    $dump = '<pre><code style="overflow:auto">' . $dump . '</code></pre>';
    return $dump;
}

sub _hdlr_cookiedump {
    my ( $ctx, $args, $cond ) = @_;
    my $vars = MT->instance->cookies;
    my $name = $args->{ key } || $args->{ name };
    if ( $name && ref( $vars ) eq 'HASH' ) {
        $vars = $vars->{ $name };
    }
    my $dump = Dumper $vars;
    return $dump if $args->{ raw };
    $dump = encode_html( $dump );
    $dump = '<pre><code style="overflow:auto">' . $dump . '</code></pre>';
    return $dump;
}

sub _hdlr_querydump {
    my ( undef, $args ) = @_;
    my $var = MT->instance->query_string;
    return "<pre><code style=\"overflow:auto\">\n\$VAR1 = undef;\n</code></pre>" if ! $var;
    my $name = $args->{ key } || $args->{ name };
    my @vars = split( /;/, $var );
    my $params;
    for my $query ( @vars ) {
        my ( $key, $value ) = split( /=/, $query );
        if ( $name ) {
            if ( $key eq $name ) {
                $params->{ $key } = $value;
                last;
            } else {
                next;
            }
        }
        $params->{ $key } = $value;
    }
    my $dump = Dumper $params;
    return $dump if $args->{ raw };
    $dump = encode_html( $dump );
    $dump = '<pre><code style="overflow:auto">' . $dump . '</code></pre>';
    return $dump;
}

sub _hdlr_envdump {
    my ( undef, $args ) = @_;
    my $params;
    my $name = $args->{ key } || $args->{ name };
    if ( $name ) {
        $params = $ENV{ $name };
    } else {
        for my $key ( keys %ENV ) {
            $params->{ $key } = $ENV{ $key };
        }
    }
    my $dump = Dumper $params;
    return $dump if $args->{ raw };
    $dump = encode_html( $dump );
    $dump = '<pre><code style="overflow:auto">' . $dump . '</code></pre>';
    return $dump;
}

1;
