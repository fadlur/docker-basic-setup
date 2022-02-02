FROM php:8.0-fpm

# tambahan dari blog digitalocean
# Argument defined in docker-compose.yml
ARG user
ARG uid

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip

# clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# install php extentions, ini udah ada tadinya
RUN docker-php-ext-install zip pdo pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# set working directory
WORKDIR /var/www

USER $user