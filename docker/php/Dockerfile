FROM php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    cron \
    sudo \
    git \
    curl \
    libmcrypt-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    libpq5 \
    libpq-dev \
    libjpeg-dev \
    libxpm-dev \
    libpng-dev \
    libfreetype6-dev \
    libicu-dev \
    unzip \
    postgresql \
    libreoffice \
    supervisor
#----------------------#

# Install xdebug 
RUN pecl install xdebug-2.9.0 \
    && docker-php-ext-enable xdebug
#----------------------#

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
#----------------------#

# Install PHP extensions
RUN docker-php-ext-configure intl && docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    --with-xpm=/usr/include

RUN pecl install mcrypt-1.0.4 && \
    docker-php-ext-enable mcrypt

RUN docker-php-ext-install -j$(nproc) pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd soap sockets intl zip

# Get latest Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
#---------------------#

COPY ./cron /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab

# Apply cron job
RUN crontab /etc/cron.d/crontab
RUN touch /var/log/cron.log

RUN chgrp crontab /usr/bin/crontab
RUN chmod g+s /usr/bin/crontab

# Set working directory
WORKDIR /var/www

# RUN useradd -G www-data,root,sudo -u $uid -p $(openssl passwd -1 '123') -d /home/$user $user
RUN mkdir -p /home/$user/.composer # && \
    # chown -R $user:$user /home/$user

USER $user