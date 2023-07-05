#!/usr/bin/env bash
set -o xtrace

sudo lshw -c network | egrep 'description|name|link'
watch ip -s link

set +o xtrace
echo "see 'vnstat' for more"
