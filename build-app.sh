#!/bin/bash

echo "Building ScrollControl.app..."

# Kill any existing instances
pkill -f ScrollControl 2>/dev/null || true

# Convert SVG to PNG if rsvg-convert is available
if command -v rsvg-convert >/dev/null 2>&1; then
    echo "Converting SVG icon to PNG..."
    rsvg-convert -a -w 1024 -h 1024 -f png -o Sources/ScrollControl/Resources/AppIcon.png Sources/ScrollControl/Resources/AppIcon.svg
else
    echo "⚠️  rsvg-convert not found - using existing PNG or will skip icon conversion"
fi

# Build using Swift Package Manager
swift build -c release

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

# Create app bundle structure
APP_NAME="ScrollControl"
APP_DIR="$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

# Clean and create directories
rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy executable
cp .build/release/ScrollControl "$MACOS_DIR/"

# Copy icon if it exists
if [ -f "Sources/ScrollControl/Resources/AppIcon.png" ]; then
    cp "Sources/ScrollControl/Resources/AppIcon.png" "$RESOURCES_DIR/"
fi

# Create Info.plist
cat > "$CONTENTS_DIR/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>ScrollControl</string>
    <key>CFBundleDisplayName</key>
    <string>ScrollControl</string>
    <key>CFBundleIdentifier</key>
    <string>com.scrollcontrol.app</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleExecutable</key>
    <string>ScrollControl</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2024. All rights reserved.</string>
</dict>
</plist>
EOF

echo "✅ Build successful!"
echo "Created: $APP_DIR"
echo "Run: open $APP_DIR"