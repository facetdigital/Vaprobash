#!/usr/bin/env bash

echo ">>> Initializing Rails App"

cd /vagrant
su -l vagrant -c "cd /vagrant && bundle install && rake db:setup"
