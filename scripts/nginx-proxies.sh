#!/usr/bin/env bash

# Don't really care. We're proxying past it anyway.
public_folder="/vagrant"

for proxy in "$@"
do
  echo "------------------------------------------------------------"
  echo "Creating Nginx Proxy: $proxy"
  hostname=${proxy%%:*}
  port=${proxy#*:}
  # Create Nginx Server Proxy Block and enable it
  cmd="sudo ngxcp -d $public_folder -n $hostname -s $hostname -p $port -e"
  echo "Running command: $cmd"
  sudo ngxcp -d $public_folder -n $hostname -s $hostname -p $port -e
  echo "------------------------------------------------------------"
done

sudo service nginx restart
