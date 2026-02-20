.{
    $RepoUrl = "https://github.com/rocketpowerinc/rocketstick.git"
    $Branch  = "main"
    $Destination = Join-Path $env:USERPROFILE "RocketStick"

    # Create directory if it doesn't exist
    if (!(Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination | Out-Null
    }

    # Trust this directory (needed for exFAT/FAT32 sometimes)
    git config --global --add safe.directory $Destination 2>$null

    # Go to destination
    Set-Location $Destination

    git init
    git remote add origin $RepoUrl 2>$null
    git fetch origin
    git switch -c $Branch --track origin/$Branch
}