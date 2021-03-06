<?php
function smarty_function_mtquerydump ( $args, &$ctx ) {
    $name = $args[ 'key' ];
    if ( ! isset( $name ) ) {
        $name = $args[ 'name' ];
    }
    $to_encoding = $ctx->mt->config( 'PublishCharset' );
    $to_encoding or $to_encoding = 'UTF-8';
    $vars = $_REQUEST;
    $params = array();
    foreach ( $vars as $key => $value ) {
        if ( $_GET[ $key ] || $_POST[ $key ] ) {    
            if ( $name ) {
                if ( $key == $name ) {
                    $params[ $key ] = $value;
                    break;
                } else {
                    continue;
                }
            }
            if ( is_string( $value ) ) {
                $from_encoding = mb_detect_encoding( $value, 'UTF-8,EUC-JP,SJIS,JIS' );
                $value = mb_convert_encoding( $value, $to_encoding, $from_encoding );
            }
            $params[ $key ] = $value;
        }
    }
    ob_start();
    var_dump( $params );
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