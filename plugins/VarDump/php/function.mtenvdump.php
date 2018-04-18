<?php
function smarty_function_mtenvdump ( $args, &$ctx ) {
    $name = $args[ 'key' ];
    if ( ! isset( $name ) ) {
        $name = $args[ 'name' ];
    }
    ob_start();
    if ( $name ) {
        var_dump( $_SERVER[ $name ] );
    } else {
        var_dump( $_SERVER );
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