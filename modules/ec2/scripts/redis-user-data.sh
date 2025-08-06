#!/bin/bash
set -e

# Update & install Redis
sudo apt-get update -y
sudo apt-get install -y redis-server

# Enable and start Redis
sudo systemctl enable redis-server
sudo systemctl start redis-server

# Optional: Check status (won’t fail script)
sudo systemctl status redis-server || true
