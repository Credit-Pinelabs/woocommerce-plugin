<?php
/**
 * PinePG Payment Method - WooCommerce Blocks Integration
 */

use Automattic\WooCommerce\Blocks\Payments\Integrations\AbstractPaymentMethodType;

final class WC_PinePg_Blocks extends AbstractPaymentMethodType {
    protected $name = 'pinepg';

    public function initialize() {
        $this->settings = get_option( 'woocommerce_pinepg_settings', array() );
    }

    public function is_active() {
            $settings = get_option( 'woocommerce_pinepg_settings', array() );
            $enabled = isset( $settings['enabled'] ) ? $settings['enabled'] : 'no';
            return $enabled === 'yes';
        }

    public function get_payment_method_script_handles() {
        wp_register_script(
            'wc-pinepg-blocks-integration',
            plugin_dir_url( __DIR__ ) . 'blocks/pinepg-blocks.js',
                array( 'wc-blocks-registry', 'wp-element' ),
                '1.0.1',
            true
        );
        return array( 'wc-pinepg-blocks-integration' );
    }

    public function get_payment_method_data() {
            $data = array(
            'title'       => 'Pay securely with Pine Labs',
            'description' => 'Pay securely with Pine Labs',
            'supports'    => array( 'products' ),
        );
            error_log( '[PinePG] get_payment_method_data() returning: ' . json_encode( $data ) );
            return $data;
        }
}