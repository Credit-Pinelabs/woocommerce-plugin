<?php
use Automattic\WooCommerce\Blocks\Payments\Integrations\AbstractPaymentMethodType;

final class WC_PinePg_Blocks extends AbstractPaymentMethodType {
    protected $name = 'pinepg';

    public function initialize() {
        $this->settings = get_option( 'woocommerce_pinepg_settings', array() );
    }

    public function is_active() {
        $settings = get_option( 'woocommerce_pinepg_settings', array() );
        return ( $settings['enabled'] ?? 'no' ) === 'yes';
    }

    public function get_payment_method_script_handles() {
        wp_register_script(
            'wc-pinepg-blocks-integration',
            plugin_dir_url( __DIR__ ) . 'blocks/pinepg-blocks.js',
            array( 'wc-blocks-registry', 'wp-element' ),
            '1.0.2',
            true
        );
        return array( 'wc-pinepg-blocks-integration' );
    }

    public function get_payment_method_data() {
        return array(
            'title' => 'Pay securely with Pine Labs',
            'description' => 'Pay securely with Pine Labs',
            'supports' => array( 'products' ),
        );
    }
}