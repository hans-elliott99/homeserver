#!/usr/bin/env bash

echo "If on LAN, navigate to http://$LAN_IP:8080"
echo "If remote, navigate to http://$DOMAIN_ADDR:8080"

python3 -m http.server 8080
