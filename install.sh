#!/bin/bash

# =============================================================================
# AI Development Environment Installer
# Based on the "Gold Standard" Setup Guide
# =============================================================================

# Colors for pretty output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=============================================================${NC}"
echo -e "${BLUE}       AI Development Workstation Setup Script               ${NC}"
echo -e "${BLUE}=============================================================${NC}"
echo "This script will automate the installation of:"
echo "- Essential Tools & Git Config"
echo "- GitHub CLI"
echo "- Pyenv (Python 3.11)"
echo "- NVM (Node.js LTS)"
echo "- Gemini CLI"
echo "- Google Antigravity IDE"
echo "- Docker Engine"
echo ""

# Check for Ubuntu
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "ubuntu" ]; then
        echo -e "${RED}Warning: This script is designed for Ubuntu. You are running $ID.${NC}"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit 1; fi
    fi
else
    echo -e "${RED}Error: OS release file not found. Are you on Linux?${NC}"
    exit 1
fi

# Ask for sudo upfront
echo -e "${BLUE}[*] Requesting sudo privileges for installation...${NC}"
sudo -v
# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# =============================================================================
# 1. User Configuration
# =============================================================================
echo -e "${BLUE}--- Configuration ---${NC}"
read -p "Enter your GitHub Username (for folder creation): " GITHUB_USER
read -p "Enter your Name (for git config): " LGIT_NAME
read -p "Enter your Email (for git config): " LGIT_EMAIL

if [ -z "$GITHUB_USER" ] || [ -z "$LGIT_NAME" ] || [ -z "$LGIT_EMAIL" ]; then
    echo -e "${RED}Error: All fields are required.${NC}"
    exit 1
fi

# =============================================================================
# 2. System Update & Essentials
# =============================================================================
echo -e "${GREEN}[+] Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

echo -e "${GREEN}[+] Installing build dependencies...${NC}"
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
libffi-dev liblzma-dev git

# =============================================================================
# 3. Workspace & Git
# =============================================================================
echo -e "${GREEN}[+] Configuring Workspace...${NC}"
mkdir -p "$HOME/github.com/$GITHUB_USER"
echo "alias projects='cd ~/github.com/$GITHUB_USER'" >> "$HOME/.bashrc"

echo -e "${GREEN}[+] Configuring Git Identity...${NC}"
git config --global user.name "$LGIT_NAME"
git config --global user.email "$LGIT_EMAIL"
git config --global init.defaultBranch main

echo -e "${GREEN}[+] Installing GitHub CLI...${NC}"
if ! command -v gh &> /dev/null; then
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update && sudo apt install gh -y
else
    echo "GitHub CLI already installed."
fi

# =============================================================================
# 4. Python (Pyenv)
# =============================================================================
echo -e "${GREEN}[+] Installing Pyenv...${NC}"
if [ ! -d "$HOME/.pyenv" ]; then
    curl https://pyenv.run | bash

    # Add to bashrc
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME/.bashrc"
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'eval "$(pyenv init -)"' >> "$HOME/.bashrc"

    # Enable for current script execution
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
else
    echo "Pyenv directory exists. Skipping install."
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

echo -e "${GREEN}[+] Installing Python 3.11.9 (Gold Standard)...${NC}"
# Check if python version is already installed to save time
if ! pyenv versions | grep -q "3.11.9"; then
    pyenv install 3.11.9
fi
pyenv global 3.11.9

# =============================================================================
# 5. Node.js (NVM)
# =============================================================================
echo -e "${GREEN}[+] Installing NVM...${NC}"
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
else
    echo "NVM directory exists. Skipping install."
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
fi

echo -e "${GREEN}[+] Installing Node.js LTS...${NC}"
nvm install --lts

# =============================================================================
# 6. Gemini CLI
# =============================================================================
echo -e "${GREEN}[+] Installing Gemini CLI...${NC}"
npm install -g @google/gemini-cli

# =============================================================================
# 7. Antigravity IDE
# =============================================================================
echo -e "${GREEN}[+] Installing Antigravity IDE...${NC}"
if ! command -v antigravity &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null
    sudo apt update && sudo apt install antigravity -y
else
    echo "Antigravity IDE already installed."
fi

# =============================================================================
# 8. Docker
# =============================================================================
echo -e "${GREEN}[+] Installing Docker Engine...${NC}"
if ! command -v docker &> /dev/null; then
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Group setup
    echo -e "${GREEN}[+] Adding user to Docker group...${NC}"
    sudo usermod -aG docker $USER
else
    echo "Docker already installed."
fi

# =============================================================================
# 9. Verification Summary
# =============================================================================
echo -e "${BLUE}=============================================================${NC}"
echo -e "${BLUE}          Installation Complete!                             ${NC}"
echo -e "${BLUE}=============================================================${NC}"
echo "Running verification checks..."

echo -n "NVIDIA Drivers: "
if command -v nvidia-smi &> /dev/null; then echo -e "${GREEN}OK${NC}"; else echo -e "${RED}NOT FOUND (Run: sudo ubuntu-drivers autoinstall)${NC}"; fi

echo -n "Git:           "
if command -v git &> /dev/null; then echo -e "${GREEN}OK ($(git --version))${NC}"; else echo -e "${RED}FAIL${NC}"; fi

echo -n "Python (Pyenv):"
if command -v python &> /dev/null; then echo -e "${GREEN}OK ($(python --version))${NC}"; else echo -e "${RED}FAIL (Try restarting shell)${NC}"; fi

echo -n "Node (NVM):    "
if command -v node &> /dev/null; then echo -e "${GREEN}OK ($(node --version))${NC}"; else echo -e "${RED}FAIL (Try restarting shell)${NC}"; fi

echo -n "Gemini CLI:    "
if command -v gemini &> /dev/null; then echo -e "${GREEN}OK${NC}"; else echo -e "${RED}FAIL${NC}"; fi

echo -n "Docker:        "
if command -v docker &> /dev/null; then echo -e "${GREEN}OK${NC}"; else echo -e "${RED}FAIL${NC}"; fi

echo ""
echo -e "${BLUE}Action Required:${NC}"
echo "1. Run: source ~/.bashrc (or restart your terminal)"
echo "2. Run: gh auth login"
echo "3. Run: gemini configure"
echo "4. Reboot your system to finalize Docker permissions."
echo ""
echo "Enjoy your AI Workstation!"
