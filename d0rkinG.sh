#!/bin/bash

# Color codes for beautification
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if the script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Error: This script must be run as root.${NC}"
        exit 1
    fi
}

# Function to validate domain
validate_domain() {
    if [[ ! "$1" =~ ^[a-zA-Z0-9.-]+$ ]]; then
        echo -e "${RED}Invalid domain format. Please enter a valid domain.${NC}"
        exit 1
    fi
}

# Function to download dork file
download_dorks_file() {
    local url="https://raw.githubusercontent.com/arno0x/DorkNet/master/dorks.txt"
    local file="dorks.txt"
    
    echo -e "${BLUE}Downloading Google Dork file...${NC}"
    curl -o "$file" "$url" --silent
    
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}Failed to download the Google Dork file!${NC}"
        echo -e "${YELLOW}Please manually download the dork file from the following URL and save it as 'dorks.txt' in the current directory:${NC}"
        echo -e "${YELLOW}$url${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Google Dork file downloaded successfully.${NC}"
}

# Function to read dorks from file
read_dorks() {
    local file="dorks.txt"
    mapfile -t dorks < "$file"
}

# Function to display progress
show_progress() {
    local current="$1"
    local total="$2"
    local percent=$((current * 100 / total))
    echo -ne "${BLUE}Progress: $percent% ($current/$total) complete\r${NC}"
}

# Function to check if a dork returns a result
check_dork() {
    local dork="$1"
    local domain="$2"
    local query="https://www.google.com/search?q=$dork+$domain"
    
    # Perform the search and check if there are results
    results=$(curl -s -A "Mozilla/5.0" "$query" | grep -o "About [0-9,]* results" | awk '{print $2}')
    
    if [[ -z "$results" || "$results" == "0" ]]; then
        echo -e "${RED}Dork: $dork - Status: Not Found${NC}"
    else
        echo -e "${GREEN}Dork: $dork - Status: Success${NC}"
    fi
}

# Function to check Shodan results
check_shodan() {
    local api_key="$1"
    local domain="$2"
    
    # Perform the search using Shodan API
    results=$(curl -s -X GET "https://api.shodan.io/dns/domain/$domain?key=$api_key")
    
    if [[ "$results" == *"error"* ]]; then
        echo -e "${RED}Shodan search - Status: Not Found${NC}"
    else
        echo -e "${GREEN}Shodan search - Status: Success${NC}"
    fi
}

# Function to handle Google Dorking
google_dorking() {
    download_dorks_file
    read_dorks

    total_dorks=${#dorks[@]}
    current_dork=0

    echo -e "${BLUE}Starting Google Dork search for domain: $domain${NC}"
    for dork in "${dorks[@]}"; do
        check_dork "$dork" "$domain" &
        current_dork=$((current_dork + 1))
        show_progress "$current_dork" "$total_dorks"
        sleep 1  # Adding delay to prevent being blocked by Google
    done
    wait

    echo -e "\n${GREEN}Google Dork search completed.${NC}"
}

# Function to handle Shodan search
shodan_search() {
    read -sp "Enter your Shodan API key: " shodan_api_key
    echo
    check_shodan "$shodan_api_key" "$domain"
}

# Main script starts here
check_root

echo -e "${BLUE}Select an option:${NC}"
echo -e "${YELLOW}1. Google Dorking${NC}"
echo -e "${YELLOW}2. Shodan Search${NC}"
echo -e "${YELLOW}3. Both${NC}"
read -p "Enter your choice (1/2/3): " choice

read -p "Enter the target domain: " domain
validate_domain "$domain"

case "$choice" in
    1)
        google_dorking
        ;;
    2)
        shodan_search
        ;;
    3)
        google_dorking
        shodan_search
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac
