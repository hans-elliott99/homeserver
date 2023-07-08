#!/usr/bin/env bash
# docker setup 
# https://docs.docker.com/engine/install/ubuntu/

echo "Setting up repository..."
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker engine..."
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world

echo "If you want to run docker as non-root user then you need to add it to the docker group:"
cat << EOF
$ sudo groupadd docker
$ sudo usermod -aG docker \$USER
$ newgrp docker
$ docker run hello-world
EOF
