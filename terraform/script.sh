#!/bin/bash
# Update and install Docker
apt-get update -y
apt-get install -y docker.io

# Start Docker and enable on boot
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group (optional)
usermod -aG docker ubuntu

# Pull the Strapi image from Docker Hub
docker pull venkatamahendrakalla/strapi-image:latest

# Run Strapi container (in detached mode)
docker run -d --name cont-01 -p 1337:1337 venkatamahendrakalla/strapi-image:latest

