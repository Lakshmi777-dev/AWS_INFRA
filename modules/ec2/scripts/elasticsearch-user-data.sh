#!/bin/bash
set -e

# Log user data output to file for debug
exec > /var/log/user-data.log 2>&1

# Update and install dependencies
apt-get update -y
apt-get install -y openjdk-17-jdk wget apt-transport-https gnupg curl

# Import the Elasticsearch GPG key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor > /usr/share/keyrings/elasticsearch-keyring.gpg

# Add Elasticsearch 8.x repository
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list

# Update and install Elasticsearch
apt-get update -y
apt-get install -y elasticsearch

# Configure Elasticsearch (development use)
cat >> /etc/elasticsearch/elasticsearch.yml <<EOF
network.host: 0.0.0.0
http.port: 9200
discovery.type: single-node
xpack.security.enabled: false
EOF

# Enable and start Elasticsearch
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
