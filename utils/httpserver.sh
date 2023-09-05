#!/usr/bin/env bash
port=$1
echo "If on LAN, navigate to http://$LAN_IP:$port"
echo "If remote, navigate to http://$DOMAIN_ADDR:$port"

python3 -m http.server "$port"
