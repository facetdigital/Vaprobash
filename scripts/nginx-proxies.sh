#!/usr/bin/env bash

# Don't really care. We're proxying past it anyway.
public_folder="/vagrant"

for proxy in "$@"
do
  hostname=${proxy%%:*}
  port=${proxy#*:}
  echo ">>> Creating Nginx Proxy: $hostname => $port"
  sudo ngxcp -d $public_folder -n $hostname -s $hostname -p $port -e
done

sudo service nginx restart
