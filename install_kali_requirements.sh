#!/usr/bin/env bash
# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
NC="\033[0m"

# Check and add /usr/games to PATH if missing
if [[ ":$PATH:" != *":/usr/games:"* ]]; then
    echo -e "${GREEN}📍 Adding /usr/games to PATH globally...${NC}"
    
    # Add to current session
    export PATH="$PATH:/usr/games:/usr/local/games"
    
    # Detect current shell
    CURRENT_SHELL=$(basename "$SHELL")
    echo -e "${GREEN}🐚 Detected shell: $CURRENT_SHELL${NC}"
    
    # Add to .bashrc if it exists or if bash is the shell
    if [[ -f ~/.bashrc ]] || [[ "$CURRENT_SHELL" == "bash" ]]; then
        if ! grep -q '/usr/games' ~/.bashrc 2>/dev/null; then
            echo 'export PATH="$PATH:/usr/games:/usr/local/games"' >> ~/.bashrc
            echo -e "${GREEN}✔ Added to ~/.bashrc${NC}"
        else
            echo -e "✅ ~/.bashrc already contains /usr/games"
        fi
    fi
    
    # Add to .zshrc if it exists or if zsh is the shell
    if [[ -f ~/.zshrc ]] || [[ "$CURRENT_SHELL" == "zsh" ]]; then
        if ! grep -q '/usr/games' ~/.zshrc 2>/dev/null; then
            echo 'export PATH="$PATH:/usr/games:/usr/local/games"' >> ~/.zshrc
            echo -e "${GREEN}✔ Added to ~/.zshrc${NC}"
        else
            echo -e "✅ ~/.zshrc already contains /usr/games"
        fi
    fi
    
    # Add to .profile as backup for login shells
    if ! grep -q '/usr/games' ~/.profile 2>/dev/null; then
        echo 'export PATH="$PATH:/usr/games:/usr/local/games"' >> ~/.profile
        echo -e "${GREEN}✔ Added to ~/.profile for login shells${NC}"
    else
        echo -e "✅ ~/.profile already contains /usr/games"
    fi
    
    echo -e "${GREEN}✔ PATH updated${NC}"
fi

echo -e "\n📦 Installing Requirements for Kali Linux...\n"

# Detect if we need sudo or can run commands directly
if [ "$EUID" -eq 0 ]; then
    # Running as root, no sudo needed
    SUDO_CMD=""
    echo -e "${GREEN}🔓 Running as root${NC}"
else
    # Not root, check if sudo exists
    if command -v sudo &>/dev/null; then
        SUDO_CMD="sudo"
        echo -e "${GREEN}🔐 Using sudo for installations${NC}"
    else
        echo -e "${RED}❌ Not running as root and sudo not found!${NC}"
        echo -e "${RED}Please run this script as root or install sudo first.${NC}"
        exit 1
    fi
fi

function check_install() {
    if command -v "$1" &>/dev/null; then
        echo -e "✅ $1 is already installed"
    else
        echo -e "❌ $1 not found. Installing..."
        $SUDO_CMD apt install -y "$2" && echo -e "${GREEN}✔ Installed: $2${NC}" || echo -e "${RED}✘ Failed to install: $2${NC}"
    fi
}

$SUDO_CMD apt update

check_install "jq" "jq"
check_install "lolcat" "lolcat"
check_install "figlet" "figlet"
check_install "wget" "wget"
check_install "gum" "gum"

echo -e "\n${GREEN}🎉 All requirements checked and installed!${NC}\n"

# Provide appropriate reload instructions based on detected shell
CURRENT_SHELL=$(basename "$SHELL")
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
    echo -e "${GREEN}⚠️  If this is your first time running this script, please run:${NC}"
    echo -e "${GREEN}   source ~/.zshrc${NC}"
    echo -e "${GREEN}   OR restart your terminal for PATH changes to take effect.${NC}\n"
elif [[ "$CURRENT_SHELL" == "bash" ]]; then
    echo -e "${GREEN}⚠️  If this is your first time running this script, please run:${NC}"
    echo -e "${GREEN}   source ~/.bashrc${NC}"
    echo -e "${GREEN}   OR restart your terminal for PATH changes to take effect.${NC}\n"
else
    echo -e "${GREEN}⚠️  Please restart your terminal for PATH changes to take effect.${NC}\n"
fi