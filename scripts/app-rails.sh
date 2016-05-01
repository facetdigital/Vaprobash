#!/usr/bin/env bash

# IMPORTANT: You cannot call this directly from Vagrantfile, even with
#              :privileged => false
#            because it needs to be run in a login shell as the `vagrant`
#            user. Use the `app-rails-install.sh` provisioner instead,
#            because all that does is run this script as the
#            appropriate user.

echo ">>> Initializing Rails App"

# Ignore the .rvmrc warning in our app project directory.
rvm rvmrc warning ignore /vagrant/.rvmrc

# Trust the .rvmrc in our app project directory.
rvm rvmrc trust /vagrant/.rvmrc

# Moving into the mounted project directory will
# cause its .rvmrc to install the gemset via bundler
cd /vagrant

# Init the rails app database
rake db:setup
