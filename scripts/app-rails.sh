#!/usr/bin/env bash

echo ">>> Initializing Rails App"

pushd /vagrant > /dev/null
  bundle install
  rake db:setup
popd /vagrant > /dev/null
