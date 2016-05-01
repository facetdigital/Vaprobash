#!/usr/bin/env bash

echo ">>> Initializing Rails App"

cd /vagrant
bundle install
rake db:setup
