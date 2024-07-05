#!/bin/bash

# Variables
VERSION_FILE="app/version.properties"
SETUP_SCRIPT="install_pdfproject.sh"

# Function to read version from version.properties
read_version() {
    if [ -f "$VERSION_FILE" ]; then
        VERSION=$(grep 'version=' "$VERSION_FILE" | cut -d'=' -f2)
        if [ -z "$VERSION" ]; then
            echo "Error: version not found in $VERSION_FILE."
            exit 1
        else
            echo "Version found: $VERSION"
        fi
    else
        echo "Error: $VERSION_FILE not found."
        exit 1
    fi
}

# Function to update the VERSION variable in setup.sh
update_setup_script() {
    if [ -f "$SETUP_SCRIPT" ]; then
        # Update the VERSION variable in setup.sh without creating a backup file
        sed -i "" "s/VERSION=.*/VERSION=$VERSION/" "$SETUP_SCRIPT"
        echo "Updated $SETUP_SCRIPT with VERSION=$VERSION"
    else
        echo "Error: $SETUP_SCRIPT not found."
        exit 1
    fi
}

# Main script logic
read_version
update_setup_script
