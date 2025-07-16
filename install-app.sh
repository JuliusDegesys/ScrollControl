#!/bin/bash

# Installation script for ScrollControl.app

APP_NAME="ScrollControl.app"
INSTALL_DIR="/Applications"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_NAME="com.scrollcontrol.app.plist"

echo "Installing ScrollControl.app..."

# Check if app bundle exists
if [ ! -d "./$APP_NAME" ]; then
    echo "❌ $APP_NAME not found. Please run ./build-app.sh first."
    exit 1
fi

# Copy the app to Applications
sudo cp -R "./$APP_NAME" "$INSTALL_DIR/"

echo "✅ App installed to $INSTALL_DIR/$APP_NAME"

# Create LaunchAgent plist for auto-startup
mkdir -p "$LAUNCH_AGENTS_DIR"

cat > "$LAUNCH_AGENTS_DIR/$PLIST_NAME" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.scrollcontrol.app</string>
    <key>ProgramArguments</key>
    <array>
        <string>open</string>
        <string>-a</string>
        <string>$INSTALL_DIR/$APP_NAME</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/ScrollControl.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/ScrollControl.log</string>
</dict>
</plist>
EOF

# Load the LaunchAgent
if ! launchctl bootstrap gui/$(id -u) "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null; then
    launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null || true
fi

echo "✅ Auto-startup configured"
echo ""
echo "ScrollControl.app is now installed and will start automatically at login."
echo ""
echo "Manual controls:"
echo "  Open app: open -a ScrollControl"
echo "  Start:    launchctl bootstrap gui/\$(id -u) ~/Library/LaunchAgents/$PLIST_NAME"
echo "  Stop:     launchctl bootout gui/\$(id -u)/com.scrollcontrol.app"
echo "  Restart:  launchctl kickstart -k gui/\$(id -u)/com.scrollcontrol.app"
echo "  Logs:     tail -f ~/Library/Logs/ScrollControl.log"
echo ""
echo "You may need to grant accessibility permissions in System Settings."
echo ""
echo "To uninstall:"
echo "  ./uninstall-app.sh"