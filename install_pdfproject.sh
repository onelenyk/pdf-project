#!/bin/bash

# Variables
VERSION=0.0.6
TARGET_DIR="/usr/local/bin/pdfproject"
TARGET_SCRIPT="$TARGET_DIR/pdfproject"

# Function to build JAR URL
build_jar_url() {
    JAR_URL="https://jitpack.io/com/github/onelenyk/pdf-project/v$VERSION/pdf-project-v$VERSION.jar"
    JAR_PATH="$TARGET_DIR/pdf-project-v$VERSION.jar"
}

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
    sudo mkdir -p "$TARGET_DIR"
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

    # Create a symlink to the script in /usr/local/bin for easy access
    sudo ln -sf "$TARGET_SCRIPT" /usr/local/bin/pdfproject

    echo "Script created at $TARGET_SCRIPT and made executable."
}

# Main script logic
build_jar_url

if check_jar_exists; then
    echo "JAR file is already present. No need to download."
else
    echo "JAR file not found. Downloading the JAR file..."
    download_jar
fi

# Create the execution script
create_execution_script
