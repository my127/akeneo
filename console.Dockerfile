ARG VERSION=8.2
ARG BASEOS=bullseye
FROM my127/php:${VERSION}-fpm-${BASEOS}-console

ARG VERSION=8.2
ARG BASEOS=bullseye

RUN apt-get update \
 && apt-get install -y \
  aspell \
  aspell-en \
  aspell-es \
  aspell-fr \
  aspell-de \
  ghostscript \
 && rm -rf /var/lib/apt/lists/*

# MySQL 8 client
# --------------
RUN if [ "$BASEOS" != stretch ]; then \
  apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    dirmngr \
    gnupg2 \
  && [ "$(uname -m)" = aarch64 ] || [ "$BASEOS" = 'bullseye' ] || ( \
  echo "deb https://repo.mysql.com/apt/debian/ $BASEOS mysql-8.0" > /etc/apt/sources.list.d/mysql.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 859BE8D7C586F538430B19C2467B942D3A79BD29 \
  && apt-get update \
  && apt-get install -y \
    mysql-community-client \
  ) \
  && rm -rf /var/lib/apt/lists/*; \
fi

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
