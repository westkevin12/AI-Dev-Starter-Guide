# The Ultimate AI Development Environment Guide

Welcome. This guide is designed to take you from a standard Windows 11 PC to a professional-grade AI Workstation. We assume **zero prior knowledge**. Follow these steps exactly in order.

**Goal:** Safely install Ubuntu Linux on a dedicated drive and configure it with Google's Antigravity IDE, Local AI models, and Professional Cloud tools.

---

## Part 1: Windows Preparation (Do this FIRST)

Before we touch Linux, we need to prepare your Windows system and create the installation media.

### Step 1.1: Gather Hardware
*   **1x USB Drive (8GB or larger)**: This will be wiped.
*   **1x Dedicated SSD (NVMe or SATA)**: This is where we will install Ubuntu. Do not try to install it on the same drive as Windows if you are a beginner.

### Step 1.2: Download Software
1.  **Download Ubuntu:** Go to the [Ubuntu Desktop Download Page](https://ubuntu.com/download/desktop) and download the latest **LTS (Long Term Support)** ISO file.
2.  **Download Rufus:** Go to [Rufus.ie](https://rufus.ie/) and download the portable version.

### Step 1.3: Create Bootable USB
1.  Plug in your USB drive.
2.  Open **Rufus**.
3.  **Device:** Select your USB drive.
4.  **Boot selection:** Click "SELECT" and choose the Ubuntu ISO you downloaded.
5.  Click **START**. (Click "Yes" to any download prompts, and "OK" to the warning that data will be destroyed).
6.  Wait for it to say **READY**, then close Rufus.

### Step 1.4: Critical Windows Settings
1.  **Disable Fast Startup** (Prevents corrupting your Windows drive from Linux):
    *   Open Control Panel > Hardware and Sound > Power Options.
    *   Click "Choose what the power buttons do".
    *   Click "Change settings that are currently unavailable".
    *   **Uncheck** "Turn on fast startup".
    *   Click "Save changes".
2.  **Disable BitLocker** (Optional but recommended for setup):
    *   Search for "Manage BitLocker" in Windows.
    *   If it is On, click "Turn off BitLocker" (you can re-enable it later).

---

## Part 2: The Installation (Safety First)

We will use the "Physical Isolation" method. This is the only way to guarantee you do not accidentally wipe your Windows installation.

### Step 2.1: Disconnect Windows
1.  **Shut down** your computer completely.
2.  Unplug the power cable.
3.  Open your PC case.
4.  **Unplug the SATA or Power cable** from your Windows Drive.
    *   *If you have an M.2 NVMe drive for Windows that is hard to reach, you can skip this if you are extremely careful in Step 2.3, but physical disconnection is the safest method.*
5.  Ensure your **New Target Drive** (for Ubuntu) is connected.

### Step 2.2: Boot from USB
1.  Plug in your Ubuntu USB drive.
2.  Plug in PC power and turn it on.
3.  Immediately press your **Boot Menu Key** repeatedly (F12 for Dell/Lenovo, F8 for Asus, F11 for MSI, F9 for HP).
4.  Select your **USB Drive** from the menu (look for "UEFI: [USB Name]").
5.  Select **"Try or Install Ubuntu"**.

### Step 2.3: Install Ubuntu
1.  Welcome screen: Select **English** and click **Install Ubuntu**.
2.  Keyboard layout: Select **English (US)** -> Continue.
3.  Updates: Check **Normal installation** and **Install third-party software** (graphics/wifi) -> Continue.
4.  **Installation Type (CRITICAL):**
    *   Since you disconnected your Windows drive, you can safely select **"Erase disk and install Ubuntu"**.
    *   *Warning: If you did NOT disconnect Windows, you must be extremely careful here to select the correct empty drive.*
5.  Click **Install Now** -> Keep clicking **Continue** for the timezone and username setup.
6.  Wait for installation to finish, then click **Restart Now**.
7.  Remove the USB drive when prompted and press Enter.

### Step 2.4: Reconnect Windows
1.  Shut down your new Ubuntu system.
2.  Unplug power and reconnect your **Windows Drive**.
3.  Close the case and power on.
4.  Enter your BIOS (Del or F2) and set **Ubuntu** as the first boot option.

---

## Part 3: The Setup (First Boot)

Now you have a pristine Linux environment. Let's make it powerful.

### Step 3.1: Update Everything
Open the **Terminal** application (Ctrl+Alt+T) and run:

```bash
sudo apt update
sudo apt upgrade -y
```

### Step 3.2: Configure Workspace
We use a professional structure for your code.
1. Copy this command block and paste it into Terminal (Ctrl+Shift+V):

```bash
# Replace with your actual GitHub username
export GITHUB_USER="your-username"

# Create directory
mkdir -p ~/github.com/$GITHUB_USER

# Create alias
echo "alias projects='cd ~/github.com/$GITHUB_USER'" >> ~/.bashrc
source ~/.bashrc

echo "Workspace created at ~/github.com/$GITHUB_USER"
```

### Step 3.3: Configure Git Identity
Git needs to know who you are for your commits.

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
```

### Step 3.4: Install GitHub CLI
The official tool to login to GitHub without messing with SSH keys.

```bash
# 1. Install
sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# 2. Login
gh auth login
# Select: GitHub.com -> HTTPS -> Yes (Authenticate with browser)
```

---

## Part 4: The Engine (Coding Tools)

### Step 4.1: Install Core Tools & Build Dependencies
We need a robust set of tools to compile Python versions and run modern web apps.

```bash
# Essentials & Build Dependencies (Required for Pyenv)
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
libffi-dev liblzma-dev git
```

### Step 4.2: Install Pyenv (Python Version Manager)
Control your Python version per project. Never break your system Python again.

```bash
# 1. Install Pyenv from official script
curl https://pyenv.run | bash

# 2. Add to your shell (Copy ALL lines at once)
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# 3. Apply changes
source ~/.bashrc

# 4. Install Python 3.11 (The "Gold Standard" for current AI tools)
pyenv install 3.11.9
pyenv global 3.11.9

# 5. Verify
python --version
# Output should be: Python 3.11.9
```

### Step 4.3: Install NVM (Node Version Manager)
Avoid "permission denied" errors and switch Node versions easily.

```bash
# 1. Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 2. Add to shell (if not added automatically)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 3. Install latest LTS (Long Term Support) node
nvm install --lts

# 4. Verify
node -v
# Output should be something like v20.x.x
```

### Step 4.4: Install Gemini CLI (The Command Line Brain)
The Gemini CLI lets you interact with Google's large language models directly from your Terminal.

```bash
# 1. Install Globally with npm
npm install -g @google/gemini-cli

# 2. Configure API Key
# Get your API key from Google AI Studio and paste it when prompted.
gemini configure
```

### Step 4.5: Install Google Antigravity IDE
The official AI-first IDE by Google.

```bash
# 1. Setup Keyrings
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
  sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg

# 2. Add Repository
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
  sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null

# 3. Install
sudo apt update
sudo apt install antigravity

# 4. Launch (Sign in with your Google Account)
antigravity
```

### Step 4.6: Install Docker Engine
Docker is essential for running vector databases and containerized AI agents.

```bash
# 1. Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 2. Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# 3. Install Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. Critical: Run Docker without sudo
sudo usermod -aG docker $USER
newgrp docker
```

---

## Part 5: The Brain (Local AI)

Run AI models privately on your computer.

### Step 5.0: Verify NVIDIA Drivers
Before installing AI tools, ensure your GPU is recognized.

```bash
nvidia-smi
```

*   **Success:** You see a grid with your GPU name and Driver Version.
*   **Failure:** If it says "command not found", run: `sudo ubuntu-drivers autoinstall` and reboot.

### Step 5.1: Ollama
For running chat models like Llama 3.

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama run llama3
```

### Step 5.2: Hugging Face
For downloading models.

```bash
pip install -U "huggingface_hub[cli]"
huggingface-cli login
```

---

## Part 6: The Cloud (Vertex AI)

For enterprise-grade AI applications.

```bash
# Install Google Cloud SDK
sudo apt install -y apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update && sudo apt install -y google-cloud-cli

# Login
gcloud auth login
```

---

## Part 7: The Studio (ComfyUI)

The best tool for AI Art and video generation.

```bash
cd ~/github.com/$GITHUB_USER/
git clone https://github.com/comfyanonymous/ComfyUI
cd ComfyUI

# Setup
python3 -m venv venv
source venv/bin/activate
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121
pip install -r requirements.txt

# Run
python main.py
```

---

## Part 8: Verification Checklist

Run these commands to verify your "Gold Standard" environment is ready.

- [ ] **NVIDIA Drivers**: `nvidia-smi` (Should show GPU info)
- [ ] **Docker**: `docker run hello-world` (Should say "Hello from Docker!")
- [ ] **Git**: `git config --list` (Should show user.name and email)
- [ ] **Python**: `python3 --version` (Should be 3.x)
- [ ] **Node**: `node --version` (Should be v20.x)

**Congratulations!** You are now ready to build the future.