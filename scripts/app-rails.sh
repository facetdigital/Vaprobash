#!/usr/bin/env bash

echo ">>> Initializing Rails App"

cd /vagrant
su vagrant -c "bundle install"
su vagrant -c "rake db:setup"
