#!/usr/bin/env bash

wget -q --spider http://google.com

if [ $? -eq 0 ]; then
    echo "Online, calculating ping:"
    ping -c 4 www.google.com | tail -1 | awk '{print $4}' | cut -d '/' -f 2
else
    echo "Offline"
fi
