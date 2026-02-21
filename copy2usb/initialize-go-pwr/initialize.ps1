.{
  <#
-----------------------------------------
Clone RocketStick (PROS Robotics)
-----------------------------------------
This script:
  1) Verifies Git is installed
  2) Clones the RocketStick repository into the current directory
-----------------------------------------
#>

  # Stop on all errors
  $ErrorActionPreference = "Stop"

  # ---- CONFIGURATION ----
  $RepoUrl = "https://github.com/rocketpowerinc/rocketstick.git"
  $TargetDir = "RocketStick"
  $FullPath = Join-Path (Get-Location) $TargetDir

  Write-Host "📦 Starting clone process…"
  Write-Host "➡️  Repository: $RepoUrl"
  Write-Host "➡️  Target Directory: $FullPath"

  # ---- Check if Git is installed ----
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git is not installed. Please install Git for Windows and try again."
    exit 1
  }

  # ---- Prevent overriding existing directory ----
  if (Test-Path $FullPath) {
    Write-Host "⚠️ Directory '$TargetDir' already exists!"
    $choice = Read-Host "Do you want to remove it and re-clone? (y/N)"

    if ($choice -match '^[Yy]$') {
      Remove-Item $FullPath -Recurse -Force
    }
    else {
      Write-Host "Aborted."
      exit 0
    }
  }

  # ---- Clone the repository ----
  Write-Host "🔁 Cloning..."
  git clone --depth 1 $RepoUrl $TargetDir

  # ---- Confirm success ----
  if (Test-Path $FullPath) {
    Write-Host "✅ Successfully cloned into '$TargetDir'."
  }
  else {
    Write-Host "❌ Clone failed."
    exit 1
  }


  Write-Host "🚀 Done!"
}