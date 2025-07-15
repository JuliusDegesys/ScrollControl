#!/bin/bash

# Uninstallation script for ScrollControl

APP_NAME="ScrollControl"
INSTALL_DIR="$HOME/Applications"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_NAME="com.scrollcontrol.app.plist"

echo "Uninstalling ScrollControl..."

# Stop and unload the LaunchAgent (try bootout first, fall back to unload)
launchctl bootout gui/$(id -u)/com.scrollcontrol.app 2>/dev/null || launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null || true

# Remove the LaunchAgent plist
rm -f "$LAUNCH_AGENTS_DIR/$PLIST_NAME"

# Remove the app
rm -f "$INSTALL_DIR/ScrollControl"

# Remove log file
rm -f "$HOME/Library/Logs/ScrollControl.log"

echo "✅ ScrollControl uninstalled"
echo "Note: You may need to manually remove accessibility permissions given to ScrollControl from System Settings > Privacy & Security > Privacy > Accessibility"
