#!/usr/bin/env bash
###############################################################################
# RocketStick Sync Script (Professional Portable Linux Edition)
#
# PURPOSE
# -------
# This script ensures that your $HOME/RocketStick directory stays synchronized
# in a predictable and reliable way.
#
# BEHAVIOR
# --------
# 1) If internet connectivity to the Git repository is available:
#       • If $HOME/RocketStick is NOT a Git repository:
#             - It will be removed and freshly cloned from GitHub.
#       • If it IS already a Git repository:
#             - It will pull the latest changes from the configured branch.
#
# 2) If internet connectivity is NOT available:
#       • The script switches to OFFLINE MODE.
#       • It mirrors the current working directory into $HOME/RocketStick
#         using rsync.
#       • Files deleted locally are also deleted in the destination.
#       • The .git directory is preserved (not overwritten).
#
# DESIGN GOALS
# ------------
# • Safe repeated execution (idempotent)
# • Works across most Linux distributions
# • No directory state pollution (uses git -C)
# • Strict error handling
# • Minimal assumptions about environment
#
# REQUIREMENTS
# ------------
#   git
#   rsync
#
# CONFIGURATION
# -------------
#   REPO_URL   - Git repository to sync from when online
#   BRANCH     - Branch to track
#   DESTINATION - Target directory (defaults to $HOME/RocketStick)
#
# EXIT BEHAVIOR
# -------------
# Script exits immediately if:
#   • A required dependency is missing
#   • A command fails
#   • An undefined variable is used
#
###############################################################################

set -euo pipefail

# ---- CONFIGURATION ----
REPO_URL="https://github.com/rocketpowerinc/rocketstick.git"
BRANCH="main"
CURRENT_DIR="$(pwd)"
DESTINATION="$HOME/RocketStick"

###############################################################################
# FUNCTION: require_command
# Checks if a required command exists in PATH.
###############################################################################
require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "[ERROR] Required command '$1' is not installed."
        echo "Install it using your system package manager and try again."
        exit 1
    fi
}

###############################################################################
# FUNCTION: check_internet
# Tests connectivity to the Git repository directly.
# This avoids unreliable ICMP/ping-based detection.
###############################################################################
check_internet() {
    git ls-remote "$REPO_URL" &>/dev/null
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

# Ensure destination directory exists
mkdir -p "$DESTINATION"

if check_internet; then
    echo "[✓] Internet detected. Syncing with remote repository..."

    if [ -d "$DESTINATION/.git" ]; then
        echo "[↻] Existing repository detected. Pulling latest changes..."
        git -C "$DESTINATION" pull origin "$BRANCH"
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

echo
echo "=== RocketStick Sync Complete ==="