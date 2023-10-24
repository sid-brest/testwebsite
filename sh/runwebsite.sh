#!/bin/bash

set -e

# Check if the URL parameter is provided
if [ -z "$1" ]; then
    echo "Error: URL parameter is missing."
    echo "Please provide the URL to clone the repository as a parameter."
    echo "Example: ./script.sh https://github.com/username/reponame.git"
    exit 1
fi

# Define the Git clone link as a variable
repo_url="$1"

# Create a temporary directory inside the home directory
temp_dir="$HOME/temp_website"
echo "Creating temporary directory: $temp_dir"
mkdir -p "$temp_dir"

# Install required packages
packages=("nginx" "git" "ufw")
for package in "${packages[@]}"; do
    if ! command -v "$package" &> /dev/null; then
        echo "$package is not installed. Installing $package..."
        sudo apt update
        sudo apt install -y "$package"
    else
        echo "$package is already installed."
    fi
done

# Enable Nginx if not already enabled
if ! sudo systemctl is-enabled nginx &> /dev/null; then
    echo "Enabling Nginx..."
    sudo systemctl enable nginx
fi

# Remove existing files in the default Nginx directory
echo "Clearing /var/www/html/..."
sudo rm -rf /var/www/html/*

# Clone the repository into the temporary directory
echo "Cloning the repository into $temp_dir..."
git clone "$repo_url" "$temp_dir"

# Move the files to the default Nginx directory
echo "Copying files to /var/www/html/..."
sudo cp -r -v "$temp_dir"/* /var/www/html/

# Configure firewall rules for SSH (port 22) and Nginx (port 80) using ufw
echo "Configuring firewall rules using ufw..."
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw --force enable

# Start Nginx service
echo "Starting Nginx..."
sudo systemctl start nginx

# Retrieve IPv4 addresses
ipv4_addresses=($(hostname -I | tr ' ' '\n'))

# Filter local LAN addresses starting with "192"
matching_addresses=()
for address in "${ipv4_addresses[@]}"; do
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
public_ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || true)

if [ -n "$public_ip" ]; then
    # Public IPv4 address is available
    echo "Website successfully deployed. You can access it at public http://${public_ip}:80"
else
    echo "Failed to retrieve the Public IPv4 address."
fi

# Clean up the temporary directory
echo "Cleaning up the temporary directory: $temp_dir"
rm -rf "$temp_dir"