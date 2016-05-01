#!/usr/bin/env bash

# IMPORTANT: You cannot call app-rails.sh privisioner directly
#            from Vagrantfile, even with
#              :privileged => false
#            because it needs to be run in a login shell as the `vagrant`
#            user. Use this provisioner instead,
#            because all it does is run this script as the
#            appropriate user.

if [[ -z $1 ]]; then
    github_url="https://raw.githubusercontent.com/facetdigital/Vaprobash/master"
else
    github_url="$1"
fi

\curl -sSL $github_url/scripts/app-rails.sh | su -l vagrant
