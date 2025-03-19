# VS Code Updater

## Overview
This script automates the process of checking, updating, and installing Visual Studio Code on Windows. It ensures a smooth update process by stopping running instances, downloading the latest version, and performing a silent installation.

## Features
- **Checks for Existing Installation**: Detects if VS Code is installed and logs its status.
- **Stops Running Instances**: Terminates all active VS Code processes before proceeding.
- **Automated Download with Retry Logic**: Fetches the latest VS Code installer from Microsoft's official URL, ensuring a reliable download.
- **Silent Installation & Update**: Updates or installs VS Code without requiring user interaction (`/VERYSILENT /NORESTART`).
- **Cleanup**: Removes the installer after the installation is complete.
- **Professional Logging**: Provides clean and informative logs without unnecessary symbols or clutter.

## Usage
1. Run the script with administrative privileges.
2. The script will detect if VS Code is installed and log its status.
3. If an update or installation is needed, all running instances will be closed.
4. The latest VS Code version will be downloaded and installed silently.
5. The installer will be removed after successful installation.

## Requirements
- Windows OS
- Administrator privileges
- Internet connection for downloading the installer

## License
This project is open-source and available under the MIT License.
