FROM wordpress:6.7-php8.2-apache

RUN curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY woocommerce-pinepg-gateway/ /usr/src/plugins/woocommerce-pinepg-gateway/

COPY entrypoint-setup.sh /usr/local/bin/entrypoint-setup.sh

RUN mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint-original.sh \
    && printf '#!/bin/bash\n/usr/local/bin/docker-entrypoint-original.sh "$@" &\nWP_PID=$!\nbash /usr/local/bin/entrypoint-setup.sh\nwait $WP_PID\n' > /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/entrypoint-setup.sh

# Pre-configure database connection — skips setup wizard on EKS
ENV WORDPRESS_DB_HOST=wp-demo-db-svc.plural-uat.svc.cluster.local \
    WORDPRESS_DB_USER=wordpress \
    WORDPRESS_DB_PASSWORD=wordpress123 \
    WORDPRESS_DB_NAME=wordpress