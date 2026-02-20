.{
# ---- CONFIG ----
$RepoUrl = "https://github.com/rocketpowerinc/rocketstick.git"
$CurrentDir = Get-Location
$Destination = Join-Path $env:USERPROFILE "RocketStick"

# ---- FUNCTION: Check Internet ----
function Test-Internet {
    try {
        Test-Connection -ComputerName "github.com" -Count 1 -Quiet -ErrorAction Stop
    }
    catch {
        return $false
    }
}

Write-Host "=== RocketStick Sync Starting ==="

# ---- STEP 1: If internet available, git pull ----
if (Test-Internet) {
    Write-Host "Internet detected."

    if (Test-Path ".git") {
        Write-Host "Git repo detected. Pulling latest changes..."
        git pull
    }
    else {
        Write-Host "Not a git repo. Cloning..."
        git clone $RepoUrl .
    }
}
else {
    Write-Host "No internet connection. Skipping git pull."
}

# ---- STEP 2: Copy files to USERPROFILE\RocketStick ----
Write-Host "Copying files to $Destination"

# Create destination if it doesn't exist
if (!(Test-Path $Destination)) {
    New-Item -ItemType Directory -Path $Destination | Out-Null
}

# Use robocopy (more reliable than Copy-Item)
robocopy $CurrentDir $Destination /MIR
robocopy $CurrentDir $Destination /MIR

Write-Host "=== RocketStick Sync Complete ==="

}