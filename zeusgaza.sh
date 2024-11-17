#!/bin/bash

# Colors for output
GREEN="\033[0;32m"
RED="\033[0;31m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
BOLD="\033[1m"
NC="\033[0m" # No Color

# Logo
show_logo() {
    echo -e "${CYAN}"
    echo "###############################################"
    echo "#            ${BOLD}ZeusGaza Scanner${NC}${CYAN}             #"
    echo "#    The Ultimate Bug Bounty Toolkit          #"
    echo "###############################################"
    echo -e "${NC}"
}

# Directories for outputs
OUTPUT_DIR="zeusgaza_results"
TARGET_DOMAIN=""
SUBDOMAIN_FILE="$OUTPUT_DIR/subdomains_$TARGET_DOMAIN.txt"
WAYBACK_OUTPUT="$OUTPUT_DIR/wayback_$TARGET_DOMAIN.txt"
KATANA_OUTPUT="$OUTPUT_DIR/katana_$TARGET_DOMAIN.txt"
WHATWEB_OUTPUT="$OUTPUT_DIR/whatweb_$TARGET_DOMAIN.txt"

# Ensure required directories exist
mkdir -p $OUTPUT_DIR

# Function to display help
show_help() {
    echo -e "${YELLOW}Usage: $0 [OPTIONS]${NC}"
    echo -e ""
    echo -e "${CYAN}Options:${NC}"
    echo -e "  -u <URL>       Specify the target URL (e.g., example.com)"
    echo -e "  -h             Display this help message"
    echo -e ""
    echo -e "${CYAN}Example:${NC}"
    echo -e "  $0 -u example.com"
    exit 0
}

# Check dependencies
check_dependencies() {
    echo -e "${CYAN}[+] Checking dependencies...${NC}"
    for tool in subfinder sublist3r waybackurls katana whatweb; do
        if ! command -v $tool &> /dev/null; then
            echo -e "${RED}[-] $tool is not installed. Please install it before running this script.${NC}"
            exit 1
        fi
    done
    echo -e "${GREEN}[+] All dependencies are installed.${NC}"
}

# Parse command-line arguments
TARGET_URL=""
while getopts "u:h" opt; do
    case ${opt} in
        u)
            TARGET_URL=$OPTARG
            TARGET_DOMAIN=$(echo $TARGET_URL | sed 's/https\?:\/\///g' | sed 's/www\.//g')  # Clean URL to get domain name
            SUBDOMAIN_FILE="$OUTPUT_DIR/subdomains_$TARGET_DOMAIN.txt"
            WAYBACK_OUTPUT="$OUTPUT_DIR/wayback_$TARGET_DOMAIN.txt"
            KATANA_OUTPUT="$OUTPUT_DIR/katana_$TARGET_DOMAIN.txt"
            WHATWEB_OUTPUT="$OUTPUT_DIR/whatweb_$TARGET_DOMAIN.txt"
            ;;
        h)
            show_logo
            show_help
            ;;
        *)
            show_help
            ;;
    esac
done

# Validate input
if [[ -z $TARGET_URL ]]; then
    echo -e "${RED}[-] Error: Target URL is required. Use -u to specify the URL.${NC}"
    show_help
fi

# Main workflow
show_logo
check_dependencies

# Step 1: Run WhatWeb to identify technologies
echo -e "${CYAN}[+] Running WhatWeb to identify technologies for $TARGET_URL...${NC}"
whatweb "$TARGET_URL" > $WHATWEB_OUTPUT
echo -e "${GREEN}[+] WhatWeb completed. Results saved to $WHATWEB_OUTPUT.${NC}"

# Step 2: Gather subdomains using Subfinder and Sublist3r
echo -e "${CYAN}[+] Gathering subdomains...${NC}"
echo -e "${YELLOW}Running Subfinder to gather subdomains for $TARGET_URL...${NC}"
subfinder -d $TARGET_URL -silent -o $SUBDOMAIN_FILE
python3 $(which sublist3r) -d $TARGET_URL -o temp_sublist3r.txt
cat temp_sublist3r.txt >> $SUBDOMAIN_FILE && rm temp_sublist3r.txt
echo -e "${GREEN}[+] Subdomain discovery completed. Results saved to $SUBDOMAIN_FILE.${NC}"

# Step 3: Use Waybackurls to gather URLs
echo -e "${CYAN}[+] Running Waybackurls to gather URLs...${NC}"
echo -e "${YELLOW}Running Waybackurls to crawl through discovered subdomains...${NC}"
cat $SUBDOMAIN_FILE | while read domain; do
    # Add protocol (http:// or https://) if not present
    if [[ ! $domain =~ ^https?:// ]]; then
        domain="http://$domain"
    fi
    waybackurls "$domain" >> $WAYBACK_OUTPUT
done
echo -e "${GREEN}[+] Waybackurls completed. Results saved to $WAYBACK_OUTPUT.${NC}"

# Step 4: Run Katana to gather more URLs
echo -e "${CYAN}[+] Running Katana to gather additional URLs...${NC}"
echo -e "${YELLOW}Running Katana on $TARGET_URL for deeper crawling...${NC}"
cat $SUBDOMAIN_FILE | while read domain; do
    # Add protocol (http:// or https://) if not present
    if [[ ! $domain =~ ^https?:// ]]; then
        domain="http://$domain"
    fi
    katana -u "$domain" -d 2 >> $KATANA_OUTPUT
done
echo -e "${GREEN}[+] Katana completed. Results saved to $KATANA_OUTPUT.${NC}"

# Step 5: Summarize results
echo -e "${CYAN}[+] Summary of results:${NC}"
echo -e "${GREEN}[Subdomains]${NC} $SUBDOMAIN_FILE"
echo -e "${GREEN}[Waybackurls Results]${NC} $WAYBACK_OUTPUT"
echo -e "${GREEN}[Katana Results]${NC} $KATANA_OUTPUT"
echo -e "${GREEN}[WhatWeb Results]${NC} $WHATWEB_OUTPUT"
echo -e "${CYAN}[+] Process completed.${NC}"
