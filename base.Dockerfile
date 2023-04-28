ARG VERSION=8.2
ARG BASEOS=bullseye
FROM my127/php:${VERSION}-fpm-${BASEOS}

RUN apt-get update \
 && apt-get install -y \
  aspell \
  aspell-en \
  aspell-es \
  aspell-fr \
  aspell-de \
  ghostscript \
 && rm -rf /var/lib/apt/lists/*

# PHP: additional extensions
# --------------------------
RUN cd /root/installer; ./enable.sh \
  apcu \
  exif \
  mbstring \
  curl \
  gd \
  imagick \
  intl \
  bcmath \
  pdo_mysql \
  xdebug \
  xml \
  zip \
  ldap
