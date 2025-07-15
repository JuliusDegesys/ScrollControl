#!/bin/bash

echo "Building ScrollControl app..."

# Kill any existing instances
pkill -f ScrollControl 2>/dev/null || true

# Build using Swift Package Manager
swift build -c release

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "Run: .build/release/ScrollControl"
else
    echo "❌ Build failed!"
    exit 1
fi
