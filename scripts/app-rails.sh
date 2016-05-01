#!/usr/bin/env bash

echo ">>> Initializing Rails App"

echo ">>>>>>>>>> sourcing rvm"
. /usr/local/rvm/scripts/rvm
echo ">>>>>>>>>> sourcing rvm.sh"
. /etc/profile.d/rvm.sh

# Ignore the .rvmrc warning in our app project directory.
echo ">>>>>>>>>> ignoring warning"
rvm rvmrc warning ignore /vagrant/.rvmrc

# Trust any .rvmrc in our app project directory.
echo ">>>>>>>>>> trusting rvmrc"
rvm rvmrc trust /vagrant/.rvmrc

echo ">>>>>>>>>> cd-ing into /vagrant"
cd /vagrant
echo ">>>>>>>>>> running bundle install"
bundle install
echo ">>>>>>>>>> running rake db:setup"
rake db:setup
