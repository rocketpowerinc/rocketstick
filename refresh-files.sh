#!/usr/bin/env bash

set -e

if [ ! -d ".git" ]; then
    echo "❌ Not inside a Git repository."
    read -n 1 -s -r -p "Press any key to exit..."
    echo
    exit 1
fi

echo "🔄 Pulling latest changes..."
git pull --ff-only

echo "✅ Done."
echo
read -n 1 -s -r -p "Press any key to exit..."
echo