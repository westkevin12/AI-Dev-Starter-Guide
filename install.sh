#!/bin/bash

# =============================================================================
# AI Development Environment Installer
# Compatible with: Desktop (Dual Boot/Native), Server (Headless/VM)
# =============================================================================

# Global Configuration
DRY_RUN=false
GITHUB_USER=""
LGIT_NAME=""
LGIT_EMAIL=""

# Colors for pretty output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper Functions
log_info() { echo -e "${BLUE}[INFO] $1${NC}"; }
log_success() { echo -e "${GREEN}[SUCCESS] $1${NC}"; }
log_error() { echo -e "${RED}[ERROR] $1${NC}"; }
log_warn() { echo -e "${RED}[WARN] $1${NC}"; }

execute() {
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] $@"
    else
        "$@"
    fi
}

# Idempotent helper for .bashrc
append_to_bashrc() {
    local line="$1"
    local file="$HOME/.bashrc"
    
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] grep -qF -- \"$line\" \"$file\" || echo \"$line\" >> \"$file\""
    else
        if ! grep -qF -- "$line" "$file"; then
            echo "$line" >> "$file"
            log_success "Added to .bashrc: $line"
        fi
    fi
}

check_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "ubuntu" ]; then
            log_warn "This script is designed for Ubuntu. You are running $ID."
            if [ "$DRY_RUN" = false ]; then
                read -p "Continue anyway? (y/n) " -n 1 -r
                echo
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit 1; fi
            fi
        fi
    else
        log_error "OS release file not found. Are you on Linux?"
        exit 1
    fi
}

request_sudo() {
    if [ "$DRY_RUN" = false ]; then
        log_info "Requesting sudo privileges for installation..."
        sudo -v
        # Keep-alive
        while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    else
        log_info "[DRY RUN] Skipping sudo request"
    fi
}

get_user_input() {
    if [ "$DRY_RUN" = true ]; then
        GITHUB_USER="dry-run-user"
        LGIT_NAME="Dry Run User"
        LGIT_EMAIL="dryrun@example.com"
        return
    fi

    log_info "--- Configuration ---"
    read -p "Enter your GitHub Username (for folder creation): " GITHUB_USER
    read -p "Enter your Name (for git config): " LGIT_NAME
    read -p "Enter your Email (for git config): " LGIT_EMAIL

    if [ -z "$GITHUB_USER" ] || [ -z "$LGIT_NAME" ] || [ -z "$LGIT_EMAIL" ]; then
        log_error "All fields are required."
        exit 1
    fi
}

install_dependencies() {
    log_info "Updating system and installing build dependencies..."
    execute sudo apt update
    if [ "$DRY_RUN" = false ]; then execute sudo apt upgrade -y; fi # Skip upgrade in dry-run to avoid spam
    
    execute sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev git
}

setup_workspace() {
    log_info "Configuring Workspace..."
    local dir="$HOME/github.com/$GITHUB_USER"
    execute mkdir -p "$dir"
    append_to_bashrc "alias projects='cd ~/github.com/$GITHUB_USER'"
}

setup_git() {
    log_info "Configuring Git Identity..."
    execute git config --global user.name "$LGIT_NAME"
    execute git config --global user.email "$LGIT_EMAIL"
    execute git config --global init.defaultBranch main
}

install_github_cli() {
    log_info "Installing GitHub CLI..."
    if ! command -v gh &> /dev/null || [ "$DRY_RUN" = true ]; then
        execute sudo mkdir -p -m 755 /etc/apt/keyrings
        if [ "$DRY_RUN" = true ]; then
             echo "[DRY RUN] wget -qO- ... | sudo tee ..."
             echo "[DRY RUN] echo deb ... | sudo tee ..."
        else
            wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
            sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update 
        fi
        execute sudo apt install gh -y
    else
        log_success "GitHub CLI already installed."
    fi
}

install_pyenv() {
    log_info "Installing Pyenv..."
    if [ ! -d "$HOME/.pyenv" ]; then
        if [ "$DRY_RUN" = true ]; then
             echo "[DRY RUN] curl https://pyenv.run | bash"
        else
            curl https://pyenv.run | bash
        fi
    else
        log_success "Pyenv directory exists. Skipping install."
    fi

    append_to_bashrc 'export PYENV_ROOT="$HOME/.pyenv"'
    append_to_bashrc '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
    append_to_bashrc 'eval "$(pyenv init -)"'

    if [ "$DRY_RUN" = false ]; then
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"

        if ! pyenv versions | grep -q "3.11.9"; then
            log_info "Installing Python 3.11.9..."
            execute pyenv install 3.11.9
        fi
        execute pyenv global 3.11.9
    fi
}

install_nvm() {
    log_info "Installing NVM and Node.js..."
    local nvm_dir="$HOME/.nvm"
    if [ ! -d "$nvm_dir" ]; then
        if [ "$DRY_RUN" = true ]; then
             echo "[DRY RUN] curl ... | bash"
        else
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        fi
    else
        log_success "NVM directory exists."
    fi
    
    # We don't manually append to bashrc for NVM as the install script usually does it, 
    # but we could verify if we wanted strict control. For now trusting the official script.
    
    if [ "$DRY_RUN" = false ]; then
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        execute nvm install --lts
    fi
}

install_gemini() {
    log_info "Installing Gemini CLI..."
    execute npm install -g @google/gemini-cli
}

install_antigravity() {
    log_info "Installing Antigravity IDE..."
    if ! command -v antigravity &> /dev/null || [ "$DRY_RUN" = true ]; then
        execute sudo mkdir -p /etc/apt/keyrings
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN] curl ... | sudo gpg ..."
            echo "[DRY RUN] echo deb ... | sudo tee ..."
        else
            curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
            echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null
            sudo apt update
        fi
        execute sudo apt install antigravity -y
    else
        log_success "Antigravity IDE already installed."
    fi
}

install_docker() {
    log_info "Installing Docker Engine..."
    if ! command -v docker &> /dev/null || [ "$DRY_RUN" = true ]; then
        execute sudo apt-get install -y ca-certificates curl
        execute sudo install -m 0755 -d /etc/apt/keyrings
        
        if [ "$DRY_RUN" = true ]; then
             echo "[DRY RUN] curl ... | sudo tee ..."
        else
             sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
             sudo chmod a+r /etc/apt/keyrings/docker.asc
             echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
              $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
              sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
             sudo apt-get update
        fi
        
        execute sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        
        log_info "Adding user to Docker group..."
        execute sudo usermod -aG docker "$USER"
    else
        log_success "Docker already installed."
    fi
}

verify_installation() {
    if [ "$DRY_RUN" = true ]; then return; fi
    
    echo ""
    log_info "============================================================="
    log_info "          Installation Complete!                             "
    log_info "============================================================="
    echo "Running verification checks..."

    echo -n "NVIDIA Drivers: "
    if command -v nvidia-smi &> /dev/null; then log_success "OK"; else log_error "NOT FOUND"; fi

    echo -n "Git:           "
    if command -v git &> /dev/null; then log_success "OK ($(git --version))"; else log_error "FAIL"; fi

    echo -n "Python (Pyenv):"
    if command -v python &> /dev/null; then log_success "OK ($(python --version))"; else log_error "FAIL"; fi

    echo -n "Node (NVM):    "
    if command -v node &> /dev/null; then log_success "OK ($(node --version))"; else log_error "FAIL"; fi

    echo -n "Gemini CLI:    "
    if command -v gemini &> /dev/null; then log_success "OK"; else log_error "FAIL"; fi

    echo -n "Docker:        "
    if command -v docker &> /dev/null; then log_success "OK"; else log_error "FAIL"; fi
}

# =============================================================================
# Main Execution
# =============================================================================

# Parse Arguments
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            log_info "=== DRY RUN MODE ENABLED ==="
            ;;
        *)
            ;;
    esac
done

check_os
request_sudo
get_user_input
install_dependencies
setup_workspace
setup_git
install_github_cli
install_pyenv
install_nvm
install_gemini
install_antigravity
install_docker
verify_installation

echo ""
log_info "Action Required:"
echo "1. Run: source ~/.bashrc"
echo "2. Run: gh auth login"
echo "3. Run: gemini configure"
echo "4. Reboot to finalize Docker permissions."

