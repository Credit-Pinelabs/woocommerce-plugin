<?php
/**
 * PinePG WooCommerce Blocks Support
 * Registers the gateway with blocks checkout via the proper hook.
 * This file is included from index.php with plugins_loaded timing.
 */

add_action( 'woocommerce_blocks_loaded', function() {
    // Register the blocks integration
    if ( class_exists( 'Automattic\WooCommerce\Blocks\Payments\Integrations\AbstractPaymentMethodType' ) ) {
        require_once __DIR__ . '/PinePgBlocks.php';
        add_action(
            'woocommerce_blocks_payment_method_type_registration',
            function( $registry ) {
                $registry->register( new PinePgBlocks() );
            }
        );
    }
} );

// Also enqueue the JS fallback for the payment method frontend
add_action( 'wp_enqueue_scripts', function() {
    if ( function_exists( 'is_checkout' ) && is_checkout() ) {
        wp_enqueue_script(
            'wc-pinepg-blocks-frontend',
            plugin_dir_url( __DIR__ ) . 'blocks/pinepg-blocks.js',
            array( 'wc-blocks-registry', 'wp-element' ),
            '1.0.3',
            true
        );
    }
} );