#!/bin/bash

# Uninstallation script for ScrollControl.app

APP_NAME="ScrollControl.app"
INSTALL_DIR="/Applications"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_NAME="com.scrollcontrol.app.plist"

echo "Uninstalling ScrollControl.app..."

# Stop and unload the LaunchAgent
launchctl bootout gui/$(id -u)/com.scrollcontrol.app 2>/dev/null || launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null || true

# Remove the LaunchAgent plist
rm -f "$LAUNCH_AGENTS_DIR/$PLIST_NAME"

# Remove the app
sudo rm -rf "$INSTALL_DIR/$APP_NAME"

# Remove log file
rm -f "$HOME/Library/Logs/ScrollControl.log"

echo "✅ ScrollControl.app uninstalled"
echo "Note: You may need to manually remove accessibility permissions from System Settings > Privacy & Security > Privacy > Accessibility"