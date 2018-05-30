#!/usr/bin/env bash

echo ">>> Installing PostgreSQL"

[[ -z "$1" ]] && { echo "!!! PostgreSQL root password not set. Check the Vagrant file."; exit 1; }
[[ -z "$2" ]] && { echo "!!! PostgreSQL version not set. Check the Vagrant file."; exit 1; }

# Add PostgreSQL GPG public key
# to get latest stable
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Add PostgreSQL Apt repository
# to get latest stable
sudo touch /etc/apt/sources.list.d/pgdg.list
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

# Update Apt repos
sudo apt-get update

# Install PostgreSQL
# -qq implies -y --force-yes
if [ "$2" eq "latest" ]; then
  sudo apt-get install -qq postgresql postgresql-contrib libpq-dev
else
  sudo apt-get install -qq postgresql-$2 postgresql-contrib-$2 libpq-dev
fi

# Get the version that was installed
POSTGRE_VERSION=`ls -1 /etc/postgresql | sort | tail -1`

# Configure PostgreSQL

# Listen for localhost connections
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/$POSTGRE_VERSION/main/postgresql.conf

# Identify users via "md5", rather than "ident", allowing us
# to make PG users separate from system users. "md5" lets us
# simply use a password
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/$POSTGRE_VERSION/main/pg_hba.conf
sudo service postgresql start

# Create new superuser "vagrant"
sudo -u postgres createuser -s vagrant

# Create new user "root" w/ defined password
# Not a superuser, just tied to new db "vagrant"
sudo -u postgres psql -c "CREATE ROLE root LOGIN UNENCRYPTED PASSWORD '$1' SUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION;"

# Make sure changes are reflected by restarting
sudo service postgresql restart
