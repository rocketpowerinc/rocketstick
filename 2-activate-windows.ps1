# ---- CONFIG ----
$RepoUrl = "https://github.com/rocketpowerinc/rocketstick.git"
$Branch = "main"
$CurrentDir = Get-Location
$Destination = Join-Path $env:USERPROFILE "RocketStick"

# ---- FUNCTION: Check Internet ----
function Test-Internet {
    try {
        return Test-Connection -ComputerName "github.com" -Count 1 -Quiet -ErrorAction Stop
    }
    catch {
        return $false
    }
}

Write-Host "=== RocketStick Sync Starting ==="

# ---- Ensure destination exists ----
if (!(Test-Path $Destination)) {
    New-Item -ItemType Directory -Path $Destination | Out-Null
}

# ---- STEP 1: Git Sync (if internet available) ----
if (Test-Internet) {

    Write-Host "Internet detected. Syncing with GitHub..."

    # Trust directory (important for USB / exFAT)
    git config --global --add safe.directory $Destination 2>$null

    Set-Location $Destination

    if (!(Test-Path ".git")) {
        git init
        git remote add origin $RepoUrl
    }

    git fetch origin
    git checkout -B $Branch origin/$Branch

}
else {
    Write-Host "No internet connection. Skipping git sync."
}

# ---- STEP 2: Copy files ----
Write-Host "Copying files to $Destination"

robocopy $CurrentDir $Destination /MIR

Write-Host "=== RocketStick Sync Complete ==="