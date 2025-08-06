#!/bin/bash
set -euxo pipefail  # Enable debugging

# Install prerequisites
apt-get update -y
apt-get install -y gnupg curl wget

# Add MongoDB 6.0 repo (for Ubuntu 20.04)
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-archive-keyring.gpg
echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Install MongoDB
apt-get update -y
apt-get install -y mongodb-org

# Configure MongoDB to listen on all interfaces (for testing)
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

# Start MongoDB
sudo systemctl enable mongod
sudo systemctl start mongod

# Verify MongoDB is running
sleep 10  # Wait for service to start
if systemctl is-active --quiet mongod; then
    echo "✅ MongoDB is running!"
else
    echo "❌ MongoDB failed to start!"
    journalctl -u mongod | tail -n 20  # Show recent logs
    exit 1
fi

# (Optional) Create admin user
mongo --eval '
db = db.getSiblingDB("admin");
db.createUser({
  user: "admin",
  pwd: "admin123",
  roles: ["root"]
})'

# Enable authentication (optional)
sudo sed -i 's/#security:/security:\n  authorization: enabled/' /etc/mongod.conf
sudo systemctl restart mongod