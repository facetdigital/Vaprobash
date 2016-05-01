#!/usr/bin/env bash

# Don't really care. We're proxying past it anyway.
public_folder="/vagrant"

for proxy in "$@"
do
  # Create Nginx Server Proxy Block and enable it
  sudo ngxcp -d $public_folder -n $hostname -s $hostname -p $port -e
done

sudo service nginx restart
