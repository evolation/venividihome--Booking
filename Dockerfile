FROM php:8.2-cli

# Install system dependencies and Node.js
RUN apt-get update && apt-get install -y \
        git \
        unzip \
        libzip-dev \
        libpng-dev \
        libonig-dev \
        libxml2-dev \
        curl \
    && docker-php-ext-install pdo_mysql mbstring zip gd \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy dependency definitions
COPY composer.json composer.lock package.json package-lock.json* ./

# Install PHP and JS dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader \
    && npm install \
    && npm run build

# Copy application source
COPY . .

EXPOSE 6999
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=6999"]
