#!/usr/bin/env bash

# Show the usage for NGXCP
function show_usage {
cat <<EOF

NGXCP:
Create a new Nginx Server Proxy Block (Ubuntu Server).
Assumes /etc/nginx/sites-available and /etc/nginx/sites-enabled setup used.

    -f    Force ngxcp to overwrite given server block file name
    -e    Enable the Server Block right away with NGXEN - i.e -e (without any value)
    -d    DocumentRoot - i.e. -d /vagrant/yoursite
    -h    Help - Show this menu.
    -n    The Server Block file name - default: vagrant - i.e. -n yoursite
    -s    ServerName - i.e. -s yoursite.com
    -p    UpstreamPort - localhost port number of upstream server to proxy to

EOF
exit 1
}

if [ $EUID -ne 0 ]; then
    echo "!!! Please use root: \"sudo ngxcp\""
    show_usage
fi

# Output Nginx Server Block Config
function create_server_block {

# Main Nginx Server Block Config
cat <<EOF
    upstream $UpstreamServer {
        server localhost:$UpstreamPort;
    }

    server {
        listen 80;

        root $DocumentRoot;
        index index.html;

        # Make site accessible from ...
        server_name $ServerName;

        access_log /var/log/nginx/$ServerName-access.log;
        error_log  /var/log/nginx/$ServerName-error.log error;

        charset utf-8;

        location / {
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_redirect off;
            proxy_pass http://$UpstreamServer;
            break;
        }
    }

    server {
        listen 443;

        ssl on;
        ssl_certificate     /etc/ssl/xip.io/xip.io.crt;
        ssl_certificate_key /etc/ssl/xip.io/xip.io.key;

        root $DocumentRoot;
        index index.html;

        # Make site accessible from ...
        server_name $ServerName;

        access_log /var/log/nginx/$ServerName-access.log;
        error_log  /var/log/nginx/$ServerName-error.log error;

        charset utf-8;

        location / {
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto https;
            proxy_set_header Host $http_host;
            proxy_redirect off;
            proxy_pass http://$UpstreamServer;
            break;
        }
    }
EOF
}

# Check if there are enough arguments provided (2 arguments and there 2 values)
if [[ $# -lt 4 ]]; then
    echo "!!! Not enough arguments. Please read the below for NGXCB useage:"
    show_usage
fi

# The default for the optional argument's:
ServerBlockName="vagrant"
EnableServerBlock=0
NeedsReload=0
ForceOverwrite=0
UpstreamPort=3000

# Parse flags:
# - Run it in "silence"-mode by starting with a ":"
# - Single ":" after an argument means "required"
# - Double ":" after an argument means "optional"
while getopts ":hd:s:n:p::ef" OPTION; do
    case $OPTION in
        h)
            show_usage
            ;;
        d)
            DocumentRoot=$OPTARG
            ;;
        s)
            ServerName=$OPTARG
            ;;
        n)
            ServerBlockName=$OPTARG
            ;;
        p)
            UpstreamPort=$OPTARG
            ;;
        e)
            EnableServerBlock=1
            ;;
        f)
            ForceOverwrite=1
            ;;
        *)
            show_usage
            ;;
    esac
done

# Get a name to use for the upstream server by grabbing
# the fisrt part of the ServerName before the first dot.
UpstreamServer=${ServerName%%.*}

if [[ ! -d $DocumentRoot ]]; then
    mkdir -p $DocumentRoot
fi

if [[ $ForceOverwrite -eq 1 ]]; then
    # remove symlink from sites-enabled directory
    rm -f "/etc/nginx/sites-enabled/${ServerBlockName}" &>/dev/null
    if [[ $? -eq 0 ]]; then
        # if file has been removed, provide user with information that existing server 
        # block is being overwritten
        echo ">>> ${ServerBlockName} is enabled and will be overwritten"
        echo ">>> to enable this server block execute 'ngxen ${ServerBlockName}' or use the -e flag"
        NeedsReload=1
    fi
elif [[ -f "/etc/nginx/sites-available/${ServerBlockName}" ]]; then
    echo "!!! Nginx Server Block already exists. Aborting!"
    show_usage
fi

# Create the Server Block config
create_server_block > /etc/nginx/sites-available/${ServerBlockName}

# Enable the Server Block and reload Nginx
if [[ $EnableServerBlock -eq 1 ]]; then
    # Enable Server Block
    ngxen -q ${ServerBlockName}

    # Reload Nginx
    NeedsReload=1
fi

[[ $NeedsReload -eq 1 ]] && service nginx reload
