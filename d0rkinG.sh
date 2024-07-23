#!/bin/bash

# Function to validate domain
validate_domain() {
    if [[ ! "$1" =~ ^[a-zA-Z0-9.-]+$ ]]; then
        echo "Invalid domain format. Please enter a valid domain."
        exit 1
    fi
}

# Function to download dork file
download_dorks_file() {
    local url="https://raw.githubusercontent.com/arno0x/DorkNet/master/dorks.txt"
    local file="dorks.txt"
    
    echo "Downloading Google Dork file..."
    curl -o "$file" "$url" --silent
    
    if [[ ! -f "$file" ]]; then
        echo "Failed to download the Google Dork file!"
        echo "Please manually download the dork file from the following URL and save it as 'dorks.txt' in the current directory:"
        echo "$url"
        exit 1
    fi
    
    echo "Google Dork file downloaded successfully."
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
    echo -ne "Progress: $percent% ($current/$total) complete\r"
}

# Function to check if a dork returns a result
check_dork() {
    local dork="$1"
    local domain="$2"
    local query="https://www.google.com/search?q=$dork+$domain"
    
    # Perform the search and check if there are results
    results=$(curl -s -A "Mozilla/5.0" "$query" | grep -o "About [0-9,]* results" | awk '{print $2}')
    
    if [[ -z "$results" || "$results" == "0" ]]; then
        echo "Dork: $dork - Status: Not Found"
    else
        echo "Dork: $dork - Status: Success"
    fi
}

# Function to check Shodan results
check_shodan() {
    local api_key="$1"
    local domain="$2"
    
    # Perform the search using Shodan API
    results=$(curl -s -X GET "https://api.shodan.io/dns/domain/$domain?key=$api_key")
    
    if [[ "$results" == *"error"* ]]; then
        echo "Shodan search - Status: Not Found"
    else
        echo "Shodan search - Status: Success"
    fi
}

# Function to handle Google Dorking
google_dorking() {
    download_dorks_file
    read_dorks

    total_dorks=${#dorks[@]}
    current_dork=0

    echo "Starting Google Dork search for domain: $domain"
    for dork in "${dorks[@]}"; do
        check_dork "$dork" "$domain" &
        current_dork=$((current_dork + 1))
        show_progress "$current_dork" "$total_dorks"
        sleep 1  # Adding delay to prevent being blocked by Google
    done
    wait

    echo -e "\nGoogle Dork search completed."
}

# Function to handle Shodan search
shodan_search() {
    read -sp "Enter your Shodan API key: " shodan_api_key
    echo
    check_shodan "$shodan_api_key" "$domain"
}

# Main script starts here
echo "Select an option:"
echo "1. Google Dorking"
echo "2. Shodan Search"
echo "3. Both"
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
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
