FROM wordpress:6.7-php8.2-apache

# Install WP-CLI
RUN curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy the PinePG plugin files
COPY woocommerce-pinepg-gateway/ /usr/src/plugins/woocommerce-pinepg-gateway/

# Copy setup script and combine with original entrypoint
COPY entrypoint-setup.sh /usr/local/bin/entrypoint-setup.sh

# Create a wrapper that chains original entrypoint + our setup
RUN mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint-original.sh \
    && printf '#!/bin/bash\n/usr/local/bin/docker-entrypoint-original.sh "$@" &\nWP_PID=$!\nbash /usr/local/bin/entrypoint-setup.sh\nwait $WP_PID\n' > /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/entrypoint-setup.sh