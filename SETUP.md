# The Ultimate AI Development Environment Guide

Welcome. This guide is designed to take you from a standard machine to a professional-grade AI Workstation. We assume **zero prior knowledge**. Follow these steps exactly in order.

**Mission:** Safely install Ubuntu Linux and configure it with Google's Antigravity IDE, Local AI models, and Professional Cloud tools.
**Scope:** This is an **Environment Setup Guide**. It covers the fundamentals of getting your tools ready. It is NOT a programming course.
**IDE Choice:** We recommend **Google Antigravity** for its AI-first features, but this environment supports any IDE (VS Code, PyCharm, Vim, etc.).

---

## Part 1: Choose Your Path (OS Installation)

Select the **Route** that matches your hardware situation.

### 🗺️ The Routes
*   **[Route A: The Dual Boot](#route-a-the-dual-boot-windows--linux)** (Recommended for Beginners)
    *   *You have a Windows PC and want to keep Windows but run Linux for AI.*
*   **[Route B: Native Linux](#route-b-native-linux-dedicated-machine)**
    *   *You are wiping the entire computer to be a dedicated Linux machine.*
*   **[Route C: Headless / Cloud](#route-c-headless--cloud--proxmox)**
    *   *You are installing on a remote server, VM, or Proxmox container.*

---

### Route A: The Dual Boot (Windows + Linux)
*Use this if you want to keep Windows available for gaming/other apps.*

#### Step A.1: Windows Preparation
Before we touch Linux, we need to prepare your Windows system and create the installation media.

1.  **Gather Hardware:**
    *   **1x USB Drive (8GB or larger)**: This will be wiped.
    *   **1x Dedicated SSD (NVMe or SATA)**: This is where we will install Ubuntu. *Do not try to install it on the same drive as Windows if you are a beginner.*

2.  **Download Software:**
    *   **Ubuntu:** Go to the [Ubuntu Desktop Download Page](https://ubuntu.com/download/desktop) and download the latest **LTS (Long Term Support)** ISO file.
    *   **Rufus:** Go to [Rufus.ie](https://rufus.ie/) and download the portable version.

3.  **Create Bootable USB:**
    *   Plug in your USB drive.
    *   Open **Rufus**.
    *   **Device:** Select your USB drive.
    *   **Boot selection:** Click "SELECT" and choose the Ubuntu ISO.
    *   Click **START**. (Click "Yes" to prompts, and "OK" to the warning that data will be destroyed).
    *   Wait for **READY**, then close Rufus.

4.  **Critical Windows Settings:**
    *   **Disable Fast Startup** (Prevents corrupting your Windows drive):
        *   Open Control Panel > Hardware and Sound > Power Options.
        *   Click "Choose what the power buttons do".
        *   Click "Change settings that are currently unavailable".
        *   **Uncheck** "Turn on fast startup" -> Save changes.
    *   **Disable BitLocker** (Optional but recommended):
        *   Search for "Manage BitLocker" -> Turn Off.

#### Step A.2: Physical Isolation (Safety First)
We use the "Physical Isolation" method. This guarantees you do not accidentally wipe Windows.

1.  **Shut down** your computer completely.
2.  Unplug the power cable.
3.  Open your PC case.
4.  **Unplug the SATA or Power cable** from your Windows Drive.
    *   *If you have an M.2 NVMe drive that is hard to reach, ensure you are extremely careful in Step A.3.*
5.  Ensure your **Target Drive** (for Ubuntu) is connected.

#### Step A.3: Install Ubuntu
1.  Plug in your Ubuntu USB drive.
2.  Power on and press your **Boot Menu Key** repeatedly (F12 for Dell/Lenovo, F8 for Asus, F11 for MSI, F9 for HP).
3.  Select your **USB Drive** -> **"Try or Install Ubuntu"**.
4.  **Installation Type (CRITICAL):**
    *   Since you disconnected Windows, select **"Erase disk and install Ubuntu"**.
5.  Click **Install Now** -> Follow prompts for Timezone/User.
6.  Restart -> Remove USB.

#### Step A.4: Reconnect Windows
1.  Shut down.
2.  Reconnect your **Windows Drive**.
3.  Power on -> Enter BIOS -> Set **Ubuntu** as first boot option.

---

### Route B: Native Linux (Dedicated Machine)
*Use this if you are building a pure Linux workstation. WARNING: THIS WIPES THE entire drive.*

#### Step B.1: Create Installation Media
1.  **Download Ubuntu:** Get the [Ubuntu LTS ISO](https://ubuntu.com/download/desktop).
2.  **Flash USB:**
    *   **On Windows:** Use Rufus (see Route A steps).
    *   **On Mac/Linux:** Use [BalenaEtcher](https://etcher.balena.io/). Select ISO -> Select USB -> Flash.

#### Step B.2: The Clean Install
1.  Insert USB into the target machine.
2.  Boot and access the **Boot Menu** (F12/Delete/Esc).
3.  Select **"Try or Install Ubuntu"**.
4.  **Language/Keyboard:** Select English (US).
5.  **Updates:** Check "Normal Installation" and "Install third-party software" (Graphics/WiFi drivers).
6.  **Installation Type:** Select **"Erase disk and install Ubuntu"**.
    *   *Note: This utilizes the entire drive for Linux.*
    *   *Advanced:* Click "Advanced Features" -> "Use LVM" if you plan to resize partitions later.
7.  **Account Setup:**
    *   **Your Name:** (Your actual name)
    *   **Computer Name:** (e.g., `ai-station`)
    *   **Username:** (Keep it simple, lowercase, no spaces)
    *   **Password:** (Strong but memorable)
8.  **Finish:** Wait for installation -> Restart -> Remove USB.

---

### Route C: Headless / Cloud / Proxmox
*Use this for VMs, AWS/GCP Instances, or Home Lab Servers.*

#### Step C.1: Provisioning the Instance
*   **OS:** Select **Ubuntu Server 22.04 LTS (Jammy)** or **24.04 LTS (Noble)**.
*   **Specs (Minimum for AI):**
    *   **CPU:** 4 vCPUs+
    *   **RAM:** 16GB+ (32GB recommended for LLMs)
    *   **Storage:** 50GB+ SSD (Models are large)
*   **Proxmox Users:**
    *   Ensure "Host" CPU type is selected for best performance.
    *   If passing through a GPU, verify IOMMU groups and blacklist NVIDIA drivers on the Proxmox host *before* starting the VM.

#### Step C.2: SSH Access
You won't have a monitor. You will connect remotely.

1.  **Get IP Address:**
    *   Cloud: Look at your console dashboard.
    *   Home Lab: Check your router or run `ip addr` on the VM console.
2.  **Connect:**
    ```bash
    ssh username@your-ip-address
    ```
3.  **SSH Key (Recommended):**
    *   On your *local* machine (not the server), run:
        ```bash
        ssh-keygen -t ed25519 -C "your_email@example.com"
        ssh-copy-id username@your-ip-address
        ```
    *   Now you can login without a password.

---

## Part 2: The Setup (First Boot)

**This applies to ALL Routes (`A`, `B`, and `C`).**
Now you have a pristine Linux environment. Let's make it powerful.

### Step 2.1: Update Everything
Open the **Terminal** application (Ctrl+Alt+T) or use your SSH session and run:

```bash
sudo apt update
sudo apt upgrade -y
```

### Step 2.2: Configure Workspace
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

### Step 2.3: Configure Git Identity
Git needs to know who you are for your commits.

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
```

### Step 2.4: Install GitHub CLI
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

## Part 3: The Engine (Coding Tools)

### Step 3.1: Install Core Tools & Build Dependencies
We need a robust set of tools to compile Python versions and run modern web apps.

```bash
# Essentials & Build Dependencies (Required for Pyenv)
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
libffi-dev liblzma-dev git
```

### Step 3.2: Install Pyenv (Python Version Manager)
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

### Step 3.3: Install NVM (Node Version Manager)
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

### Step 3.4: Install Gemini CLI (The Command Line Brain)
The Gemini CLI lets you interact with Google's large language models directly from your Terminal.

```bash
# 1. Install Globally with npm
npm install -g @google/gemini-cli

# 2. Configure API Key
# Get your API key from Google AI Studio and paste it when prompted.
gemini configure
```

### Step 3.5: Install Google Antigravity IDE
The official AI-first IDE by Google.
*Note: If you are on a headless server (Route C), you might skip this or set up a remote backend.*

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

### Step 3.6: Install Docker Engine
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

## Part 4: The Brain (Local AI)

Run AI models privately on your computer.

### Step 4.0: Verify NVIDIA Drivers
Before installing AI tools, ensure your GPU is recognized.
*If you are in Route C (Proxmox), ensure your Passthrough is working first.*

```bash
nvidia-smi
```

*   **Success:** You see a grid with your GPU name and Driver Version.
*   **Failure:** If it says "command not found", run: `sudo ubuntu-drivers autoinstall` and reboot.

### Step 4.1: Ollama
For running chat models like Llama 3.

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama run llama3
```

### Step 4.2: Hugging Face
For downloading models.

```bash
pip install -U "huggingface_hub[cli]"
huggingface-cli login
```

---

## Part 5: The Cloud (Vertex AI)

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

## Part 6: The Studio (ComfyUI)

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

## Part 7: Verification Checklist

Run these commands to verify your "Gold Standard" environment is ready.

- [ ] **NVIDIA Drivers**: `nvidia-smi` (Should show GPU info)
- [ ] **Docker**: `docker run hello-world` (Should say "Hello from Docker!")
- [ ] **Git**: `git config --list` (Should show user.name and email)
- [ ] **Python**: `python3 --version` (Should be 3.x)
- [ ] **Node**: `node --version` (Should be v20.x)

**Congratulations!** You are now ready to build the future.