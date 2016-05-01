#!/usr/bin/env bash

echo ">>> Initializing Rails App"

# Ignore the .rvmrc warning in our app project directory.
rvm rvmrc warning ignore /vagrant/.rvmrc

# Trust any .rvmrc in our app project directory.
rvm rvmrc trust /vagrant/.rvmrc

echo ">>>>>>>>>> cd-ing into /vagrant"
cd /vagrant
echo ">>>>>>>>>> sourcing .rvmrc"
source .rvmrc
echo ">>>>>>>>>> running bundle install"
bundle install
echo ">>>>>>>>>> running rake db:setup"
rake db:setup
