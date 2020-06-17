#!/usr/bin/env bash

echo ">>> Installing Java Runtime - Default JRE"

# Java
# -qq implies -y --force-yes
sudo apt-get install -qq default-jre
