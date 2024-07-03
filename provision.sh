#!/bin/bash

# This script provisions a new host by updating packages,
# installing necessary Python components, setting up a virtual environment,
# and running Ansible roles and playbooks.

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print messages in bold
function print_bold {
  echo -e "\033[1m$1\033[0m"
}

print_bold "Starting provisioning script..."

# Step 1: Update the apt package list and upgrade installed packages
print_bold "Updating apt package list and upgrading installed packages..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install Python3, Python3-venv, and Python3-pip
print_bold "Installing Python3, Python3-venv, and Python3-pip..."
sudo apt install -y python3 python3-venv python3-pip

# Step 3: Create and activate a virtual environment
VENV_DIR="$HOME/.venv/setup"
print_bold "Creating and activating virtual environment at $VENV_DIR..."
mkdir -p "$VENV_DIR"
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

# Step 4: Install Ansible using pip
print_bold "Installing Ansible..."
pip install ansible

# Step 5: Retrieve requirements.yml and setup.yml from a URL
REQUIREMENTS_URL="http://example.com/path/to/requirements.yml"
SETUP_URL="http://example.com/path/to/setup.yml"
REQUIREMENTS_FILE="$HOME/requirements.yml"
SETUP_FILE="$HOME/setup.yml"

print_bold "Retrieving requirements.yml from $REQUIREMENTS_URL..."
curl -o "$REQUIREMENTS_FILE" "$REQUIREMENTS_URL"

print_bold "Retrieving setup.yml from $SETUP_URL..."
curl -o "$SETUP_FILE" "$SETUP_URL"

# Step 6: Install Ansible roles from requirements.yml
print_bold "Installing Ansible roles from requirements.yml..."
ansible-galaxy role install -r "$REQUIREMENTS_FILE"

# Step 7: Run the Ansible playbook setup.yml
print_bold "Running Ansible playbook setup.yml..."
ansible-playbook "$SETUP_FILE"

print_bold "Provisioning complete. Deactivating virtual environment."
deactivate

print_bold "All done! Your system is now provisioned."
