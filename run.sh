#!/bin/bash

# Install HAProxy
sudo apt-get update
sudo apt-get install -y haproxy vnstat


# Multi-line text to append
text_to_append=$(cat <<EOF


listen front
 mode tcp
 bind *:443

 tcp-request inspect-delay 5s
 tcp-request content accept if { req_ssl_hello_type 1 }
 use_backend reality if { req.ssl_sni -m end app.hubspot.com | www.sephora.com | cdn.discordapp.com | icloud.com }

backend reality
 mode tcp
 server ru 85.159.231.30:6000 send-proxy

frontend http_front
 bind *:80
 mode http
 redirect location https://nextcloud.technologiewerk-qua.de code 301

backend http_back
 mode http
 balance roundrobin


EOF
)

# Append the text to the file
echo "$text_to_append" >> "/etc/haproxy/haproxy.cfg"

sudo systemctl restart haproxy

# Check firewall status
sudo ufw status | grep -q "Status: active"
ufw_status=$?

if [ $ufw_status -eq 0 ]; then
  # Firewall is active, check if port 443 is open
  sudo ufw status | grep -q "443"
  port_443_status=$?

  if [ $port_443_status -ne 0 ]; then
    # Port 443 is closed, open ports 22, 80, and 443
    sudo ufw allow 22
    sudo ufw allow 80
    sudo ufw allow 443
    sudo ufw allow 8008
    echo "Opened ports 22, 80, and 443"
  else
    echo "Port 443 is already open"
  fi
else
  echo "Firewall is not active"
fi
