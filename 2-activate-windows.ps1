.{
# ---- CONFIG ----
$RepoUrl    = "https://github.com/rocketpowerinc/rocketstick.git"
$Branch     = "main"
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

    if (!(Test-Path (Join-Path $Destination ".git"))) {
        Write-Host "Cloning repository..."
        git clone --branch $Branch $RepoUrl $Destination
    }
    else {
        Write-Host "Repository exists. Pulling latest changes..."
        Set-Location $Destination
        git pull origin $Branch
        Set-Location $CurrentDir
    }
}
else {
    Write-Host "No internet connection. Skipping git sync."
}

# ---- STEP 2: Mirror Local Files (Optional) ----
Write-Host "Copying files from current directory to $Destination"
robocopy $CurrentDir $Destination /MIR /XD ".git"

Write-Host "=== RocketStick Sync Complete ==="
}