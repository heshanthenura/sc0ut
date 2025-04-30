#!/bin/bash

GREEN='\e[32m'
PURPLE='\e[35m'
CYAN='\e[36m'
GRAY='\e[90m'
RESET='\e[0m'

TARGET="$1"
SAVE_FOLDER="$2"

echo -e "${GREEN}███████╗ ██████╗ ██████╗ ██╗   ██╗████████╗
██╔════╝██╔════╝██╔═████╗██║   ██║╚══██╔══╝
███████╗██║     ██║██╔██║██║   ██║   ██║"
echo -e "${PURPLE}╚════██║██║     ████╔╝██║██║   ██║   ██║   
███████║╚██████╗╚██████╔╝╚██████╔╝   ██║   
╚══════╝ ╚═════╝ ╚═════╝  ╚═════╝    ╚═╝"
echo -e "${RESET}"
echo -e "${CYAN}            Recon Automater${RESET}"
echo -e "${GRAY}        github.com/heshanthenura/sc0ut${RESET}"
echo

if [ -z "$TARGET" ] || [ -z "$SAVE_FOLDER" ]; then
    echo -e "${CYAN}[Usage]${RESET} ./sc0ut <domain/IP> <save_folder>"
    echo -e "${CYAN}[Example]${RESET} ./sc0ut https://example.com ./output"
    echo -e "\e[31m[!] Missing arguments. Exiting...\e[0m"
    exit 1
fi

CLEAN_TARGET=$(echo "$TARGET" | sed -E 's~https?://~~' | cut -d/ -f1)

if [[ $CLEAN_TARGET =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo -e "\e[32m[*] Valid IP address.\e[0m"
    TARGET_TYPE="IP"
elif [[ $CLEAN_TARGET =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo -e "\e[32m[*] Valid domain name.\e[0m"
    TARGET_TYPE="Domain"
else
    echo -e "\e[31m[!] Invalid domain or IP format. Exiting...\e[0m"
    exit 1
fi

if [ -d "$SAVE_FOLDER" ]; then
    echo -e "\e[32m[*] Folder exists: $SAVE_FOLDER\e[0m"
else
    echo -e "\e[33m[!] Folder does not exist: $SAVE_FOLDER\e[0m"
    echo -e "\e[32m[*] Creating folder...\e[0m"
    mkdir -p "$SAVE_FOLDER"
    echo -e "\e[32m[*] Folder created: $SAVE_FOLDER\e[0m"
fi

echo
echo -e "${CYAN}==========[ SETUP COMPLETE ]==========${RESET}"
echo -e "${GREEN}Target: ${RESET}$TARGET ($TARGET_TYPE)"
echo -e "${GREEN}Save Folder: ${RESET}$SAVE_FOLDER"
echo -e "${CYAN}======================================${RESET}"
echo

if command -v whatweb >/dev/null 2>&1; then
    echo -e "\e[32m[+] Running whatweb on $TARGET\e[0m"
    whatweb "$TARGET"| sed 's/\x1b\[[0-9;]*m//g'> "$SAVE_FOLDER/whatweb.txt"
    echo -e "\e[32m[+] Output saved to $SAVE_FOLDER/whatweb.txt\e[0m"
else
    echo -e "\e[31m[!] whatweb is not installed. Skipping...\e[0m"
fi

echo 


CLEAN_TARGET=$(echo "$TARGET" | sed -E 's~https?://~~' | cut -d/ -f1)


if command -v nslookup >/dev/null 2>&1; then
    echo -e "\e[32m[+] Running nslookup on $CLEAN_TARGET\e[0m"
    nslookup "$CLEAN_TARGET" | sed 's/\x1b\[[0-9;]*m//g' > "$SAVE_FOLDER/nslookup.txt"
    echo -e "\e[32m[+] Output saved to $SAVE_FOLDER/nslookup.txt\e[0m"
else
    echo -e "\e[31m[!] nslookup is not installed. Skipping...\e[0m"
fi

echo 

if command -v dig >/dev/null 2>&1; then
    echo -e "\e[32m[+] Running dig on $CLEAN_TARGET\e[0m"
    dig "$CLEAN_TARGET" | sed 's/\x1b\[[0-9;]*m//g' > "$SAVE_FOLDER/dig.txt"
    echo -e "\e[32m[+] Output saved to $SAVE_FOLDER/dig.txt\e[0m"
else
    echo -e "\e[31m[!] dig is not installed. Skipping...\e[0m"
fi