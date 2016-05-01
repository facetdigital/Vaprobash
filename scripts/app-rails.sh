#!/usr/bin/env bash

echo ">>> Initializing Rails App"

cd /vagrant
rake db:setup
