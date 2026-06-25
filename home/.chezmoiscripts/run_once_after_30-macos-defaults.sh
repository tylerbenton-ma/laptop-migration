#!/usr/bin/env bash
# macOS system defaults — safe, reversible tweaks for dev machines.
# Re-run manually: make macos
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "macOS defaults skipped (not Darwin)."
  exit 0
fi

echo "==> Applying macOS defaults..."

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Avoid creating .DS_Store on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Keyboard: fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# Dock: auto-hide
defaults write com.apple.dock autohide -bool true

# Dock: no recent apps
defaults write com.apple.dock show-recents -bool false

# Screenshots: save to Desktop (default location, explicit)
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
defaults write com.apple.screencapture type -string "png"

# Restart affected apps
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true

echo "==> macOS defaults applied."
