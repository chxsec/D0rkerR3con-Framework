#!/bin/bash

# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
NC="\033[0m"

echo -e "\n📦 Installing Requirements for Kali Linux...\n"

function check_install() {
    if command -v "$1" &>/dev/null; then
        echo -e "✅ $1 is already installed"
    else
        echo -e "❌ $1 not found. Installing..."
        sudo apt install -y "$2" && echo -e "${GREEN}✔ Installed: $2${NC}" || echo -e "${RED}✘ Failed to install: $2${NC}"
    fi
}

sudo apt update

check_install "jq" "jq"
check_install "lolcat" "lolcat"
check_install "figlet" "figlet"
check_install "wget" "wget"

# gum is a Go binary, not in apt by default
if ! command -v gum &>/dev/null; then
    echo -e "❌ gum not found. Installing from GitHub..."
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        URL="https://github.com/charmbracelet/gum/releases/latest/download/gum_$(uname -s)_amd64.deb"
    elif [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
        URL="https://github.com/charmbracelet/gum/releases/latest/download/gum_$(uname -s)_arm64.deb"
    else
        echo -e "${RED}Unsupported architecture: $ARCH${NC}"
        exit 1
    fi
    wget "$URL" -O /tmp/gum.deb && sudo dpkg -i /tmp/gum.deb && rm /tmp/gum.deb
    if command -v gum &>/dev/null; then
        echo -e "${GREEN}✔ Installed: gum${NC}"
    else
        echo -e "${RED}✘ Failed to install gum${NC}"
    fi
else
    echo -e "✅ gum is already installed"
fi

echo -e "\n${GREEN}🎉 All requirements checked and installed!${NC}\n"
