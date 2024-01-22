# syntax=docker/dockerfile:1.4
ARG VERSION
ARG BASEOS
FROM my127/php:${VERSION}-fpm-${BASEOS}-console

ARG VERSION=7.3
ARG BASEOS=stretch

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
RUN <<EOF
  set -o errexit
  set -o nounset
  if [ "$(uname -m)" != aarch64 ] && [ "$BASEOS" = buster ]; then
    apt-get update
    apt-get install -y --no-install-recommends \
      apt-transport-https \
      dirmngr \
      gnupg2

    echo "deb https://repo.mysql.com/apt/debian/ $BASEOS mysql-8.0" > /etc/apt/sources.list.d/mysql.list

    GNUPGHOME="$(mktemp -d)"
    echo "disable-ipv6" >> "$GNUPGHOME/dirmngr.conf"
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BCA43417C3B485DD128EC6D4B7B3B788A8D3785C
    rm -rf "$GNUPGHOME"

    apt-get update
    apt-get install -y \
      mysql-community-client
    rm -rf /var/lib/apt/lists/*;
  fi
EOF

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
