#!/usr/bin/env bash

###############################################################################
# RocketStick Sync Script (Portable Linux Version)
#
# DESCRIPTION:
# Synchronizes your RocketStick directory by:
#   1) Syncing with a RocketStick GitHub repository (if internet is available)
#   2) Mirroring your current working directory into ~/RocketStick (if no internet is available)
#
# FEATURES:
#   • Dependency checks (git, rsync, ping)
#   • Internet detection
#   • Safe repeated execution
#   • Works across most Linux distributions
#
# REQUIREMENTS:
#   git
#   rsync
#   iputils (for ping)
###############################################################################

set -e

# ---- CONFIGURATION ----
REPO_URL="https://github.com/rocketpowerinc/rocketstick.git"
BRANCH="main"
CURRENT_DIR="$(pwd)"
DESTINATION="$HOME/RocketStick"

###############################################################################
# FUNCTION: Check if a command exists
###############################################################################
require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "[ERROR] Required command '$1' is not installed."
        echo "Please install it using your package manager."
        exit 1
    fi
}

###############################################################################
# FUNCTION: Check Internet Connectivity
###############################################################################
check_internet() {
    ping -c 1 -W 2 github.com >/dev/null 2>&1
}

###############################################################################
# ---- Dependency Checks ----
###############################################################################
echo "=== RocketStick Environment Check ==="

require_command git
require_command rsync
require_command ping

echo "[✓] All required commands found."
echo

echo "=== RocketStick Sync Starting ==="

# ---- Ensure Destination Exists ----
mkdir -p "$DESTINATION"

# ---- STEP 1: Git Sync (If Online) ----
if check_internet; then
    echo "[✓] Internet detected. Syncing with GitHub..."

    if [ ! -d "$DESTINATION/.git" ]; then
        echo "[+] Repository not found. Cloning..."
        git clone --branch "$BRANCH" "$REPO_URL" "$DESTINATION"
    else
        echo "[↻] Repository exists. Pulling latest changes..."
        cd "$DESTINATION"
        git pull origin "$BRANCH"
        cd "$CURRENT_DIR"
    fi
else
    echo "[!] No internet connection. Skipping Git sync."
fi

# ---- STEP 2: Mirror Local Files ----
echo "[↻] Mirroring local files to $DESTINATION..."

rsync -av --delete \
    --exclude=".git" \
    "$CURRENT_DIR/" "$DESTINATION/"

echo "=== RocketStick Sync Complete ==="