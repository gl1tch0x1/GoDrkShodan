#!/bin/bash

# Color codes for beautification
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directory where the tool is installed
TOOL_DIR="/path/to/your/installation/directory"

# GitHub repository URL
REPO_URL="https://github.com/gl1tch0x1/GoDrkShodan"

# Function to check if the directory exists
check_directory() {
    if [ ! -d "$TOOL_DIR" ]; then
        echo -e "${RED}Error: The specified tool directory does not exist.${NC}"
        exit 1
    fi
}

# Function to update the tool
update_tool() {
    echo -e "${BLUE}Starting update process...${NC}"

    # Navigate to the tool directory
    cd "$TOOL_DIR" || { echo -e "${RED}Failed to navigate to tool directory.${NC}"; exit 1; }

    # Check if the directory is a git repository
    if [ -d ".git" ]; then
        echo -e "${YELLOW}Git repository found. Pulling latest changes...${NC}"
        git fetch --all
        git reset --hard origin/main
        git pull origin main
    else
        echo -e "${YELLOW}No Git repository found. Initializing new repository...${NC}"
        git init
        git remote add origin "$REPO_URL"
        git fetch
        git checkout -t origin/main
    fi

    echo -e "${GREEN}Tool updated successfully.${NC}"
}

# Function to prompt the user for confirmation
prompt_confirmation() {
    read -p "Do you want to proceed with the update? (yes/no): " choice
    case "$choice" in
        yes|y)
            update_tool
            ;;
        no|n)
            echo -e "${YELLOW}Update process canceled.${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Exiting.${NC}"
            exit 1
            ;;
    esac
}

# Main script starts here
echo -e "${BLUE}Welcome to the tool update script.${NC}"
check_directory
prompt_confirmation
