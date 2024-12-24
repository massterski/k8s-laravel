# Указываем официальный образ PHP с нужной версией и расширениями
FROM php:8.1-fpm

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install intl zip pdo pdo_mysql

# Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Создаём директорию для приложения
WORKDIR /var/www/html

# Копируем файлы приложения в контейнер
COPY . /var/www/html

# Установка зависимостей Laravel
RUN composer install --no-dev --optimize-autoloader

# Права доступа к storage/logs и bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Указываем, что FPM будет слушать 9000 порт
EXPOSE 9000

# Запуск php-fpm
CMD ["php-fpm"]

