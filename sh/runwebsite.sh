#!/bin/bash

# Define the Git clone link as a variable
repo_url="https://github.com/sid-brest/testwebsite.git"

# Check if Nginx is installed
if ! command -v nginx &> /dev/null; then
    echo "Nginx is not installed. Installing Nginx..."
    sudo apt update
    sudo apt install -y nginx
else
    echo "Nginx is already installed."
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Installing Git..."
    sudo apt install -y git
else
    echo "Git is already installed."
fi

# Check if Nginx is enabled
if sudo systemctl is-enabled nginx &> /dev/null; then
    echo "Nginx is already enabled."
else
    echo "Enabling Nginx..."
    sudo systemctl enable nginx
fi

# Remove existing testwebsite directory
if [ -d "testwebsite" ]; then
    echo "Removing existing testwebsite directory..."
    sudo rm -rf testwebsite
fi

# Clone the repository
echo "Cloning the repository..."
git clone $repo_url

# Move the files to the default Nginx directory
echo "Copying files to /var/www/html/..."
sudo rm -rf /var/www/html/*
sudo cp -r -v testwebsite/* /var/www/html/

# Check if ufw is installed
if ! dpkg -s ufw &> /dev/null; then
    echo "ufw is not installed. Installing..."
    sudo apt install -y ufw
else
    echo "ufw is already installed."
fi

# Configure firewall rules for SSH (port 22) and Nginx (port 80) using ufw
echo "Configuring firewall rules using ufw..."
sudo ufw allow 22/tcp     # Allow SSH traffic
sudo ufw allow 80/tcp     # Allow Nginx (HTTP) traffic
sudo ufw --force enable   # Enable the firewall

# Start Nginx service
echo "Starting Nginx..."
sudo systemctl start nginx

# Retrieve IPv4 addresses
ipv4_addresses=$(hostname -I | tr ' ' '\n')

# Filter local LAN addresses starting with "192"
matching_addresses=()
for address in $ipv4_addresses; do
    if [[ $address == 192.* ]]; then
        matching_addresses+=("$address")
    fi
done

if [ ${#matching_addresses[@]} -gt 0 ]; then
    # Multiple network interfaces with addresses starting with "192" are detected
    echo "Website successfully deployed. You can access it at http://${matching_addresses[0]}:80"
elif [ ${#ipv4_addresses[@]} -gt 0 ]; then
    # Only one network interface is detected
    echo "Website successfully deployed. You can access it at private http://${ipv4_addresses[0]}:80"
else
    echo "Failed to retrieve the server IP address."
fi

# Retrieve the Public IPv4 address using AWS CLI
public_ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

if [ -n "$public_ip" ]; then
    # Public IPv4 address is available
    echo "Website successfully deployed. You can access it at public http://${public_ip}:80"
else
    echo "Failed to retrieve the Public IPv4 address."
fi
