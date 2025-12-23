# Windows Virtualization Guide

> [!CAUTION]
> **Performance Warning**: While this guide explains how to set up AI tools on Windows, **we highly recommend Route A (Dual Boot) or Route B (Native Linux)** in the main [SETUP.md](SETUP.md) guide.
>
> Running AI models and training workflows directly on Windows (even with WSL) is often slower, more prone to driver conflicts, and harder to debug than on a native Linux environment.

If you must use Windows (e.g., due to strict hardware limitations), you **MUST** enable virtualization at the BIOS/UEFI level.

## 1. Enable Virtualization in BIOS/UEFI

This is the most common reason for installation failures. This step happens **outside** of Windows, before your computer boots up.

1.  **Restart** your computer.
2.  Press your **BIOS Key** repeatedly (F2, F10, F12, Del, or Esc depending on manufacturer).
3.  Look for a setting named:
    *   **Intel:** `Intel Virtualization Technology`, `Intel VT-x`, `Virtualization Extensions`.
    *   **AMD:** `SVM Mode`, `SVM`, `AMD-V`.
4.  Set it to **Enabled**.
5.  Save & Exit (usually F10).

## 2. Enable Windows Features

Once back in Windows:

1.  Click Start and type **"Turn Windows features on or off"**.
2.  Check the boxes for:
    *   ✅ **Virtual Machine Platform**
    *   ✅ **Windows Subsystem for Linux**
3.  Click OK and **Restart** your computer.

## 3. Install WSL 2

1.  Open PowerShell as Administrator.
2.  Run:
    ```powershell
    wsl --install
    ```
3.  Restart your computer if prompted.
4.  After reboot, an Ubuntu terminal window should open. Follow the steps to create your username and password.

## 4. Install Docker for Windows

1.  Download **Docker Desktop** from [docker.com](https://www.docker.com/products/docker-desktop/).
2.  Run the installer.
3.  Ensure "Use WSL 2 instead of Hyper-V" is checked (recommended).
4.  Start Docker Desktop.

---

**Next Steps**: Return to [SETUP.md](SETUP.md) and try to follow **Route C** (treating your WSL terminal as a headless server), but be aware that some low-level hardware commands (like `nvidia-smi`) pass through differently in WSL.
