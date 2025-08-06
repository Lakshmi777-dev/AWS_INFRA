#!/bin/bash
set -e

# Update system packages
apt-get update -y
apt-get upgrade -y

# Install required packages
apt-get install -y gnupg2 curl software-properties-common apt-transport-https ca-certificates

# Add MongoDB repo key and repo
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Add Pritunl repo key and repo
curl -fsSL https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo.gpg | gpg --dearmor -o /usr/share/keyrings/pritunl.gpg
echo "deb [ signed-by=/usr/share/keyrings/pritunl.gpg ] https://repo.pritunl.com/stable/apt jammy main" | tee /etc/apt/sources.list.d/pritunl.list

# Update again and install MongoDB and Pritunl
apt-get update -y
apt-get install -y mongodb-org pritunl

# Start and enable services
systemctl enable mongod pritunl
systemctl start mongod pritunl
