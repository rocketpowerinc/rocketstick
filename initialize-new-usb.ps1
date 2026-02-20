$RepoUrl = "https://github.com/rocketpowerinc/rocketstick.git"

Write-Host "Cloning RocketStick into current directory..."
git clone $RepoUrl .

if ($LASTEXITCODE -eq 0) {
    Write-Host "Clone complete."
} else {
    Write-Host "Clone failed."
}