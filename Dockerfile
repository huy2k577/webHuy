FROM php:8.2-cli

# Cài các công cụ hỗ trợ build
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libzip-dev \
    zip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libicu-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libfreetype6-dev \
    nodejs \
    npm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring xml curl bcmath zip gd intl

# Cài composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Tạo thư mục ứng dụng
WORKDIR /app

# Copy toàn bộ source code vào container
COPY . .

# Cài dependency Laravel
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Cấp quyền cho Laravel
RUN chmod -R 777 storage bootstrap/cache

# Chạy server PHP built-in
CMD php artisan serve --host=0.0.0.0 --port=8000
