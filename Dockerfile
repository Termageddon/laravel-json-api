FROM php:8.4-cli

# Install system dependencies and PHP extensions as root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        unzip \
        libcurl4-openssl-dev \
        libonig-dev \
        libxml2-dev \
        libzip-dev \
    && docker-php-ext-install \
        bcmath \
        curl \
        mbstring \
        pdo \
        xml \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Install Composer globally
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# Create non-root user for running the application
RUN useradd -m -s /bin/bash -u 1000 appuser

# Set up working directory with proper ownership
WORKDIR /app
RUN chown appuser:appuser /app

# Configure git safe directory for the non-root user
RUN git config --system --add safe.directory /app

# Switch to non-root user
USER appuser

# Set Composer home directory for the non-root user
ENV COMPOSER_HOME=/home/appuser/.composer
