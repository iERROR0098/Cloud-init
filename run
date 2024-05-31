#!/bin/bash

# Install HAProxy
sudo apt-get update
sudo apt-get install -y haproxy vnstat


# Multi-line text to append
text_to_append=$(cat <<EOF

listen front
    mode tcp
    bind *:443
    use_backend to443

backend to443
    mode tcp
    server server1 37.27.80.144:443


EOF
)

# Append the text to the file
echo "$text_to_append" >> "/etc/haproxy/haproxy.cfg"

sudo systemctl restart haproxy
