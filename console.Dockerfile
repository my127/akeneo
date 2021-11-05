ARG VERSION=7.3
ARG BASEOS=stretch
FROM my127/php:${VERSION}-fpm-${BASEOS}-console

ARG VERSION=7.3

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
RUN if [ "$VERSION" != "7.2" ]; then \
  apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    dirmngr \
    gnupg2 \
  && [ "$(uname -m)" = aarch64 ] || ( \
  echo "deb https://repo.mysql.com/apt/debian/ buster mysql-8.0" > /etc/apt/sources.list.d/mysql.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5 \
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
