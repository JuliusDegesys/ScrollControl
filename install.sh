#!/bin/bash

# Installation script for ScrollControl

APP_NAME="ScrollControl"
BUILD_PATH=".build/release/ScrollControl"
INSTALL_DIR="$HOME/Applications"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_NAME="com.scrollcontrol.app.plist"

echo "Installing ScrollControl..."

# Create Applications directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Copy the app to Applications
cp "$BUILD_PATH" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/ScrollControl"

echo "✅ App installed to $INSTALL_DIR/ScrollControl"

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
        <string>$INSTALL_DIR/ScrollControl</string>
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

# Load the LaunchAgent (try bootstrap first, fall back to load)
if ! launchctl bootstrap gui/$(id -u) "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null; then
    launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null || true
fi

echo "✅ Auto-startup configured"
echo ""
echo "ScrollControl is now installed and will start automatically at login."
echo ""
echo "Manual controls:"
echo "  Start:    launchctl bootstrap gui/\$(id -u) ~/Library/LaunchAgents/$PLIST_NAME"
echo "  Stop:     launchctl bootout gui/\$(id -u)/com.scrollcontrol.app"
echo "  Restart:  launchctl kickstart -k gui/\$(id -u)/com.scrollcontrol.app"
echo "  Logs:     tail -f ~/Library/Logs/ScrollControl.log"
echo ""
echo "To uninstall:"
echo "  ./uninstall.sh"
