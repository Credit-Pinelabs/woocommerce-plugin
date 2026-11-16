#!/bin/bash
# Auto-install WooCommerce + activate PinePG plugin after WordPress is ready.
# The Dockerfile wrapper already starts the original entrypoint in background.
set -e

echo "[PinePG] Waiting for WordPress setup..."
for i in $(seq 1 30); do
    if wp core is-installed --path=/var/www/html --allow-root 2>/dev/null; then
        echo "[PinePG] WordPress installed."
        break
    fi
    sleep 3
done

# Copy plugin from build location if not already present
PLUGIN_DIR="/var/www/html/wp-content/plugins/woocommerce-pinepg-gateway"
if [ -d "/usr/src/plugins/woocommerce-pinepg-gateway" ] && [ ! -f "$PLUGIN_DIR/index.php" ]; then
    echo "[PinePG] Installing PinePG plugin..."
    mkdir -p "$PLUGIN_DIR"
    cp -r /usr/src/plugins/woocommerce-pinepg-gateway/* "$PLUGIN_DIR/"
    chown -R www-data:www-data "$PLUGIN_DIR"
fi

if wp core is-installed --path=/var/www/html --allow-root 2>/dev/null; then
    if ! wp plugin is-installed woocommerce --path=/var/www/html --allow-root 2>/dev/null; then
        echo "[PinePG] Installing WooCommerce..."
        wp plugin install woocommerce --activate --path=/var/www/html --allow-root
    else
        wp plugin activate woocommerce --path=/var/www/html --allow-root 2>/dev/null || true
    fi

    wp plugin activate woocommerce-pinepg-gateway --path=/var/www/html --allow-root 2>/dev/null || true
    echo "[PinePG] WooCommerce + PinePG plugin active."

    echo "[PinePG] Setting up demo store..."
    wp option set woocommerce_store_address "MG Road" --path=/var/www/html --allow-root
    wp option set woocommerce_store_city "Mumbai" --path=/var/www/html --allow-root
    wp option set woocommerce_default_country "IN:MH" --path=/var/www/html --allow-root
    wp option set woocommerce_currency "INR" --path=/var/www/html --allow-root

    PRODUCT_COUNT=$(wp post list --post_type=product --format=count --path=/var/www/html --allow-root 2>/dev/null || echo "0")
    if [ "$PRODUCT_COUNT" -eq "0" ]; then
        wp wc product create --name="Test Product" --regular_price="100" \
            --description="A test product to verify the payment gateway integration." \
            --user=1 --path=/var/www/html --allow-root
        echo "[PinePG] Demo product created."
    fi

    wp wc tool run install_pages --user=1 --path=/var/www/html --allow-root 2>/dev/null || true
    wp rewrite structure '/%postname%/' --path=/var/www/html --allow-root

    echo "[PinePG] Demo store ready at http://localhost:8080"
fi