FROM php:8.2-cli

# Cài các extension và công cụ cần thiết
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libzip-dev \
    zip \
    php-mysql \
    php-mbstring \
    php-xml \
    php-curl \
    php-bcmath \
    php-gd \
    php-intl \
    nodejs \
    npm

# Cài Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Tạo thư mục app
WORKDIR /app

# Copy source code vào container
COPY . .

# Cài đặt các gói PHP
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Cấp quyền cho thư mục cache và log
RUN chmod -R 777 storage bootstrap/cache

# Khởi động Laravel (chạy bằng PHP built-in server)
CMD php artisan serve --host=0.0.0.0 --port=8000
