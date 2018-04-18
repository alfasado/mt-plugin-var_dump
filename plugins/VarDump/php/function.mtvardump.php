<?php
function smarty_function_mtvardump ( $args, &$ctx ) {
    $name = $args[ 'key' ];
    if ( ! isset( $name ) ) {
        $name = $args[ 'name' ];
    }
    ob_start();
    if ( $name ) {
        var_dump( $ctx->__stash[ 'vars' ][ $name ] );
    } else {
        var_dump( $ctx->__stash[ 'vars' ] );
    }
    $dump = ob_get_contents();
    ob_end_clean();
    if ( $args[ 'raw' ] ) {
        return $dump;
    }
    require_once( 'MTUtil.php' );
    $dump = encode_html( $dump );
    $dump = '<pre><code style="overflow:auto">' . $dump . '</code></pre>';
    return $dump;
}
?>