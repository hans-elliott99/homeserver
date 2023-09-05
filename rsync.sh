#!/usr/bin/env bash

rsync -avP ~/utils ./
rsync -avp ~/projects/webserver ./

mkdir -p sbp_usage
rsync -avP ~/projects/sbp_usage/scrape.py ./sbp_usage/scrape.py
