#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison
apt-get -y install imagemagick libmagickwand-dev
apt-get -y -q install mysql-server libmysqlclient-dev
apt-get -y install libcurl3 libcurl3-gnutls libcurl4-openssl-dev
apt-get -y install ruby1.9.3 nodejs
apt-get -f -y install 

gem install bundler

# rm -rf /var/www
# ln -fs /vagrant /var/www