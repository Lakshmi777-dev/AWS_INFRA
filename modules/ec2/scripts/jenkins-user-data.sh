#!/bin/bash

set -e

# Retry wrapper for apt operations to avoid lock errors
retry() {
  local n=0
  local try=5
  local cmd="$@"

  until [ $n -ge $try ]
  do
    echo "Attempt $((n+1)) to run: $cmd"
    $cmd && break || {
      echo "Command failed. Retrying in 10s..."
      n=$((n+1))
      sleep 10;
    }
  done
}

# Update and install Java
retry sudo apt update -y
retry sudo apt install -y openjdk-17-jdk

# Add Jenkins key and repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update and install Jenkins
retry sudo apt update -y
retry sudo apt install -y jenkins

# Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Wait for Jenkins to open port 8080
echo "Waiting for Jenkins to start on port 8080..."
until curl -s http://localhost:8080 > /dev/null; do
  sleep 5
done

echo "Jenkins is up and running!"
