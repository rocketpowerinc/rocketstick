#!/usr/bin/env bash

# ----------------------------------------
# Clone RocketStick (PROS Robotics)
# ----------------------------------------
# This script:
#   1) Verifies git is installed
#   2) Clones the RocketStick repository to pwd
#   3) Makes all .sh files executable recursively
# ----------------------------------------

set -euo pipefail
IFS=$'\n\t'

REPO_URL="https://github.com/rocketpowerinc/rocketstick.git"
TARGET_DIR="RocketStick"

echo "📦 Starting clone process…"
echo "➡️  Repository: $REPO_URL"
echo "➡️  Target Directory: $PWD/$TARGET_DIR"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install git to continue."
    exit 1
fi

# Prevent overriding existing directory
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️ Directory '$TARGET_DIR' already exists!"
    read -p "Do you want to remove it and re-clone? (y/N): " yn
    case "$yn" in
        [Yy]* ) rm -rf "$TARGET_DIR";;
        * ) echo "Aborted."; exit 0;;
    esac
fi

# Clone the repo
echo "🔁 Cloning..."
git clone "$REPO_URL" "$TARGET_DIR"

# Confirm success
if [ -d "$TARGET_DIR" ]; then
    echo "✅ Successfully cloned into '$TARGET_DIR'."
else
    echo "❌ Clone failed."
    exit 1
fi

# Make all .sh files executable recursively
echo "🔧 Making all .sh files executable..."
find "$TARGET_DIR" -type f -name "*.sh" -exec chmod +x {} \;

echo "🚀 Done!"