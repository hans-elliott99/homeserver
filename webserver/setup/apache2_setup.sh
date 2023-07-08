#!/usr/bin/env bash
# apache2 web server initialization

sudo apt update && sudo apt upgrade -y

# install apache
sudo apt install apache2
systemctl status apache2
sudo ufw allow "Apache"  # opens port 80
sudo ufw allow 'Apache Full'  # opens port 80 and 443
sudo ufw allow 'Apache Secure'  # opens port 443 

echo "Basic setup finished."
echo "visit http://<server-ip> to test if apache works."
