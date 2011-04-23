<?php
function smarty_function_mtenvdump ( $args, &$ctx ) {
    ob_start();
    var_dump( $_SERVER );
    $dump = ob_get_contents();
    ob_end_clean();
    require_once( 'MTUtil.php' );
    $dump = encode_html( $dump );
    $dump = '<pre><code style="overflow:auto">' . $dump . '</code></pre>';
    return $dump;
}
?>