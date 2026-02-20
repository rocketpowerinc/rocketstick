.{
    $RepoUrl = "https://github.com/rocketpowerinc/rocketstick.git"
    $Branch  = "main"

    # Trust USB (required for exFAT/FAT32)
    git config --global --add safe.directory H:/ 2>$null

    git init
    git remote add origin $RepoUrl 2>$null
    git fetch origin
    git switch -c $Branch --track origin/$Branch
}