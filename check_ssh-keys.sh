#!/bin/bash

script="check_ssh-keys.sh"
version="1.0.0"
author="John Gonzalez"

# Handle long options before getopts
for arg in "$@"; do
  shift
  case "$arg" in
    "--update")
      update=1
      ;;
    *)
      set -- "$@" "$arg"
  esac
done

# Variables for control directory and state files
CONTROL_DIR="/usr/local/ncpa/plugins/ssh-keys_control"
STATE_FILE="${CONTROL_DIR}/ssh_keys_state.txt"
TEMP_STATE_FILE="${CONTROL_DIR}/ssh_keys_temp_state.txt"

# Function to generate current keys and fingerprints state
generate_current_state() {
    for key_file in /etc/ssh/ssh_host_*_key.pub; do
        fingerprint=$(ssh-keygen -lf "$key_file" | awk '{print $2}')
        echo "$key_file $fingerprint"
    done
}

# Option to update the file after manual check in case of key and/or fingerprint change
if [ ! -z "$update" ]; then
    if [ -f "$TEMP_STATE_FILE" ]; then
        mv "$TEMP_STATE_FILE" "$STATE_FILE"
        echo "State file updated with success."
        exit 0
    else
        echo "Error: Temp file is missing, impossible to update."
        exit 1
    fi
fi

# Process short options with getopts
while getopts ":v" opt; do
  case $opt in
    v)
      echo "$script - $author - $version"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Generate current state and temporary store it
generate_current_state > "$TEMP_STATE_FILE"

# Compare current state with previous state file
if [ -f "$STATE_FILE" ]; then
    DIFF=$(diff "$STATE_FILE" "$TEMP_STATE_FILE")
    if [ ! -z "$DIFF" ]; then
        echo "WARNING: Change detected in SSH key(s)/fingerprint(s). Check is required. Execute manually the script with --update argument after checking if the change is valid."
        exit 2
    else
        echo "OK: No SSH keys/fingerprints change detected."
        exit 0
    fi
else
    echo "Init state file created. Monitoring will be active after the next execution."
    mv "$TEMP_STATE_FILE" "$STATE_FILE"
    exit 0
fi

