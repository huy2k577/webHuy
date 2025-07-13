# Dựa trên hình ảnh PHP chính thức có sẵn Composer
FROM composer:latest

# Cài thêm PHP, extensions, NodeJS, npm
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
    php-mysqli \
    php-pdo \
    php-tokenizer \
    php-zip \
    php-gd \
    php-intl \
    nodejs \
    npm

# Cài Laravel nếu cần
# RUN composer global require laravel/installer

# Tạo thư mục ứng dụng
WORKDIR /app

# Copy toàn bộ dự án vào
COPY . .

# Cài đặt thư viện PHP bằng Composer
RUN composer install --no-dev --optimize-autoloader

# Cài frontend nếu có (tùy dự án)
# RUN npm install && npm run build

# Tạo file .env nếu chưa có
RUN cp .env.example .env || true

# Generate app key
RUN php artisan key:generate

# Migrate database nếu dùng SQLite/MySQL
# RUN php artisan migrate --force

# Mở cổng Laravel
EXPOSE 8000

# Chạy Laravel khi container khởi động
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
