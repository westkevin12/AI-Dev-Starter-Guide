# AI Development Starter Guide

Welcome to the **AI Development Starter Guide**. This repository contains a comprehensive guide and automated tools for setting up a professional AI development environment.

## 📚 Guides & Tools

- **[install.sh](install.sh)**: The **One-Click Installer**. Automates the entire setup (System, Python, Node, Docker, Local AI, Cloud SDK, ComfyUI).
- **[SETUP.md](SETUP.md)**: The primary, comprehensive Markdown guide. Explains every step in detail.
- **[setup_guide.ipynb](setup_guide.ipynb)**: A Jupyter Notebook version of the guide.
- **[WINDOWS_VIRTUALIZATION.md](WINDOWS_VIRTUALIZATION.md)**: Critical troubleshooting for Windows users needing to enable virtualization.

## 🌟 Quick Start

### Step 1: Get Linux
**You cannot run this on Windows directly.**
Open **[SETUP.md](SETUP.md)** and follow **Part 1** to install Ubuntu (Dual Boot or VM).

### Step 2: Run the Installer
Once you are booted into Ubuntu:

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/westkevin12/AI-Dev-Starter-Guide.git
    cd AI-Dev-Starter-Guide
    ```
2.  **Run the Installer**:
    ```bash
    chmod +x install.sh
    ./install.sh
    ```
    *Use `--dry-run` to see what it will do without making changes.*

## 📦 What gets installed?

The script (and guide) sets up a "Gold Standard" environment including:

1.  **Workspace**: Professional `~/github.com/username` structure.
2.  **Core Tools**: Google Antigravity IDE, Git, GitHub CLI, Docker Engine.
3.  **Languages**: Python 3.11 (via Pyenv), Node.js LTS (via NVM).
4.  **Local AI**: Ollama (for running Llama 3 etc) & Hugging Face CLI.
5.  **Cloud AI**: Google Cloud SDK & Vertex AI tools.
6.  **Creative Studio**: ComfyUI (Environment setup).


