#!/bin/bash

# Determine the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/pdf"
# Variables
VERSION="0.0.6" # This will be updated by the modify_setup.sh script
JAR_NAME="pdfproject.jar"
JAR_PATH="$PROJECT_DIR/$JAR_NAME"
JAR_URL="https://jitpack.io/com/github/onelenyk/pdf-project/$VERSION/pdf-project-$VERSION.jar"
TARGET_SCRIPT="$PROJECT_DIR/pdfproject"

# Function to check if JAR file exists
check_jar_exists() {
    if [ -f "$JAR_PATH" ]; then
        echo "JAR file exists at $JAR_PATH."
        return 0
    else
        return 1
    fi
}

# Function to download the JAR file from JitPack repository
download_jar() {
    echo "Downloading JAR file from $JAR_URL..."
    sudo mkdir -p "$PROJECT_DIR"
    sudo curl -L -o "$JAR_PATH" "$JAR_URL"
}

# Function to create the execution script
create_execution_script() {
    echo "Creating execution script at $TARGET_SCRIPT..."

    # Content of the script
    SCRIPT_CONTENT="#!/bin/bash
# Define the path to the JAR file
JAR_PATH=\"${JAR_PATH}\"

# Run the JAR file
java -jar \"\$JAR_PATH\" \"\$@\"
"

    # Create the script in the target directory
    echo "$SCRIPT_CONTENT" | sudo tee "$TARGET_SCRIPT" > /dev/null

    # Make the script executable
    sudo chmod +x "$TARGET_SCRIPT"

    echo "Script created at $TARGET_SCRIPT and made executable."

    # Create a symlink to the script in /usr/local/bin for easy access
    echo "Creating symlink to /usr/local/bin/pdfproject..."
    sudo ln -sf "$TARGET_SCRIPT" /usr/local/bin/pdfproject

    echo "Symlink created."
}

# Main script logic
if check_jar_exists; then
    echo "JAR file is already present. No need to download."
else
    echo "JAR file not found. Downloading the JAR file..."
    download_jar
fi

# Create the execution script
create_execution_script
