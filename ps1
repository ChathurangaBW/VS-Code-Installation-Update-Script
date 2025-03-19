# Define Variables
$VSCodePath = "C:\Program Files\Microsoft VS Code\Code.exe"
$InstallerURL = "https://aka.ms/win32-x64-user-stable"
$InstallerPath = "$env:TEMP\VSCodeSetup.exe"
$LogFile = "C:\Temp\VSCodeUpdate.log"

# Ensure Log Directory Exists
If (-Not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp" | Out-Null
}

# Function to Log Messages
function Log-Message {
    param ([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$Timestamp - $Message" | Tee-Object -FilePath $LogFile -Append
}

# Function to Stop Running VS Code Instances
function Stop-VSCode {
    $VSCodeProcesses = Get-Process -Name "Code" -ErrorAction SilentlyContinue
    if ($VSCodeProcesses) {
        Log-Message "Stopping running Visual Studio Code instances..."
        Stop-Process -Name "Code" -Force -ErrorAction SilentlyContinue
    }
}

# Function to Check if VS Code is Installed
function Is-VSCodeInstalled {
    return Test-Path $VSCodePath
}

# Function to Download VS Code Installer with Retry Mechanism
function Download-VSCode {
    $MaxRetries = 3
    $RetryCount = 0
    $Success = $false

    while (-not $Success -and $RetryCount -lt $MaxRetries) {
        try {
            Log-Message "Downloading Visual Studio Code (Attempt: $($RetryCount + 1))..."
            Invoke-WebRequest -Uri $InstallerURL -OutFile $InstallerPath -ErrorAction Stop
            if (Test-Path $InstallerPath -and (Get-Item $InstallerPath).Length -gt 1000000) {
                Log-Message "VS Code download successful."
                $Success = $true
            } else {
                Log-Message "Downloaded file is corrupt. Retrying..."
                Remove-Item -Path $InstallerPath -Force -ErrorAction SilentlyContinue
            }
        } catch {
            Log-Message "Download failed: $_"
        }
        $RetryCount++
    }

    if (-not $Success) {
        Log-Message "Failed to download Visual Studio Code after multiple attempts."
        return $false
    }

    return $true
}

# Stop Running VS Code Before Installation
Stop-VSCode

# Install or Update VS Code
if (Is-VSCodeInstalled) {
    Log-Message "Visual Studio Code is already installed. Checking for updates..."
} else {
    Log-Message "Visual Studio Code is not installed. Proceeding with installation..."
}

if (Download-VSCode) {
    Log-Message "Installing/Updating Visual Studio Code..."
    Start-Process -FilePath $InstallerPath -ArgumentList "/VERYSILENT /NORESTART /MERGETASKS=!runcode" -NoNewWindow -Wait
    Log-Message "Visual Studio Code installation/update completed successfully."
} else {
    Log-Message "Visual Studio Code installation/update failed."
}

# Cleanup Installer
Remove-Item -Path $InstallerPath -Force -ErrorAction SilentlyContinue

Log-Message "==================== VS Code Installation & Update Process Finished ===================="
