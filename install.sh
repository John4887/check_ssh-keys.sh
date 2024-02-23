#!/bin/bash

# Variables for working directories
BASE_DIR="/usr/local/ncpa/plugins"
CONTROL_DIR="${BASE_DIR}/ssh-keys_control"

# Checking and create control directory if not existing
if [ ! -d "$CONTROL_DIR" ]; then
    sudo mkdir -p "$CONTROL_DIR"
    sudo chown nagios:nagios "$CONTROL_DIR"
    sudo chmod 700 "$CONTROL_DIR"
fi

# Install the script in the NCPA plugins directory
sudo cp check_ssh-keys.sh "$BASE_DIR"
sudo chown nagios:nagios "$BASE_DIR/check_ssh-keys.sh"
sudo chmod +x "$BASE_DIR/check_ssh-keys.sh"
