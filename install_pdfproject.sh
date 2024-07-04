#!/bin/bash

# Variables
HOMEE="/Users/lenyk/IdeaProjects"

PROJECT_DIR="$HOMEE/pdf-project"
JAR_PATH="$PROJECT_DIR/pdfproject.jar"
GIT_REPO_URL="https://github.com/onelenyk/pdf-project.git"
TARGET_SCRIPT="/usr/local/bin/pdfproject"

# Function to check if JAR file exists
check_jar_exists() {
    if [ -f "$JAR_PATH" ]; then
        echo "JAR file exists at $JAR_PATH."
        return 0
    else
        return 1
    fi
}

# Function to clone the repository and build the project
clone_and_build_project() {
    echo "Cloning repository from $GIT_REPO_URL..."
    git clone "$GIT_REPO_URL" "$PROJECT_DIR"

    echo "Building the project..."
    cd "$PROJECT_DIR" || exit
    ./gradlew clean build

    # Move the built JAR to the desired location
    mv "$PROJECT_DIR/app/build/libs/kotlin-cli-executor.jar" "$JAR_PATH"
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

    # Create the script in /usr/local/bin
    echo "$SCRIPT_CONTENT" | sudo tee "$TARGET_SCRIPT" > /dev/null

    # Make the script executable
    sudo chmod +x "$TARGET_SCRIPT"

    echo "Script created at $TARGET_SCRIPT and made executable."
}

# Main script logic
if check_jar_exists; then
    echo "JAR file is already present. No need to download."
else
    echo "JAR file not found. Downloading and building the project..."
    clone_and_build_project
fi

# Create the execution script
create_execution_script
