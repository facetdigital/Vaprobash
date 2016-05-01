#!/usr/bin/env bash

echo ">>> Initializing Rails App"

cd /vagrant
su -l vagrant -c "bundle install"
su -l vagrant -c "rake db:setup"
