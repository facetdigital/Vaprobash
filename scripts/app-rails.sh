#!/usr/bin/env bash

echo ">>> Initializing Rails App"

# Ignore the .rvmrc warning in our app project directory.
rvm rvmrc warning ignore /vagrant/.rvmrc

# Trust any .rvmrc in our app project directory.
rvm rvmrc trust /vagrant/.rvmrc

cd /vagrant
bundle install
rake db:setup
