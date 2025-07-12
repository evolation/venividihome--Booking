FROM php:8.2-cli

# Install PHP dependencies
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libonig-dev libxml2-dev curl \
    && docker-php-ext-install pdo_mysql mbstring zip gd

# Install Node.js 22.9.0
RUN curl -fsSL https://nodejs.org/dist/v22.9.0/node-v22.9.0-linux-x64.tar.xz -o node.tar.xz \
    && tar -xf node.tar.xz \
    && mv node-v22.9.0-linux-x64 /usr/local/node \
    && ln -sf /usr/local/node/bin/node /usr/local/bin/node \
    && ln -sf /usr/local/node/bin/npm /usr/local/bin/npm \
    && ln -sf /usr/local/node/bin/npx /usr/local/bin/npx \
    && rm node.tar.xz

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html
