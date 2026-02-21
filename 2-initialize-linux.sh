#!/usr/bin/env bash
###############################################################################
# RocketStick Sync Script (Professional Portable Linux Edition)
#
# PURPOSE
# -------
# Keeps $HOME/RocketStick synchronized safely and predictably.
#
# BEHAVIOR
# --------
# ONLINE MODE:
#   • If DESTINATION is not a git repo → fresh clone
#   • If it is a git repo → pull latest changes
#
# OFFLINE MODE:
#   • Mirrors CURRENT_DIR into DESTINATION using rsync
#   • Preserves .git directory
#   • Deletes removed files
#
# POST-SYNC:
#   • Ensures all .sh files inside DESTINATION are executable
#
# REQUIREMENTS:
#   git
#   rsync
###############################################################################

set -euo pipefail

# ---- CONFIGURATION ----
REPO_URL="https://github.com/rocketpowerinc/rocketstick.git"
BRANCH="main"
CURRENT_DIR="$(pwd)"
DESTINATION="$HOME/RocketStick"

###############################################################################
# FUNCTION: require_command
###############################################################################
require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "[ERROR] Required command '$1' is not installed."
        exit 1
    fi
}

###############################################################################
# FUNCTION: check_internet
###############################################################################
check_internet() {
    git ls-remote "$REPO_URL" &>/dev/null
}

###############################################################################
# FUNCTION: ensure_executables
###############################################################################
ensure_executables() {
    echo "[↻] Ensuring all .sh files are executable..."
    if [ -d "$DESTINATION" ]; then
        find "$DESTINATION" -type f -name "*.sh" -exec chmod +x {} \;
        echo "[✓] Shell script permissions verified."
    else
        echo "[!] Destination directory missing. Skipping permission fix."
    fi
}

###############################################################################
# ENVIRONMENT VALIDATION
###############################################################################
echo "=== RocketStick Environment Check ==="

require_command git
require_command rsync

echo "[✓] All required commands found."
echo

###############################################################################
# START SYNC PROCESS
###############################################################################
echo "=== RocketStick Sync Starting ==="

mkdir -p "$DESTINATION"

if check_internet; then
    echo "[✓] Internet detected. Syncing with remote repository..."

    if [ -d "$DESTINATION/.git" ]; then
        echo "[↻] Existing repository detected. Pulling latest changes..."
        git -C "$DESTINATION" fetch origin "$BRANCH"
        git -C "$DESTINATION" reset --hard "origin/$BRANCH"
    else
        echo "[+] No repository found. Performing fresh clone..."
        rm -rf "$DESTINATION"
        git clone --branch "$BRANCH" "$REPO_URL" "$DESTINATION"
    fi
else
    echo "[↻] Offline mode detected."
    echo "[↻] Mirroring local directory into $DESTINATION..."

    rsync -av --delete \
        --exclude=".git" \
        "$CURRENT_DIR/" "$DESTINATION/"
fi

###############################################################################
# POST-SYNC FIXES
###############################################################################
ensure_executables

echo
echo "=== RocketStick Sync Complete ==="