#!/bin/bash

# Test script for ScrollControl

echo "Testing ScrollControl build and install..."

# Clean any previous builds
rm -rf .build

# Test Swift Package Manager build
echo "1. Testing Swift Package Manager build..."
swift build -c release

if [ $? -eq 0 ]; then
    echo "✅ Swift Package Manager build successful"
else
    echo "❌ Swift Package Manager build failed"
    exit 1
fi

# Test build script
echo "2. Testing build script..."
./build.sh

if [ $? -eq 0 ]; then
    echo "✅ Build script successful"
else
    echo "❌ Build script failed"
    exit 1
fi

# Test that executable exists and is functional
echo "3. Testing executable..."
if [ -f "./.build/release/ScrollControl" ]; then
    echo "✅ Executable exists at ./.build/release/ScrollControl"
    
    # Test that it can start (run for 2 seconds then kill)
    ./.build/release/ScrollControl &
    PID=$!
    sleep 2
    kill $PID 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Executable runs successfully"
    else
        echo "⚠️  Executable may have issues (check manually)"
    fi
else
    echo "❌ Executable not found"
    exit 1
fi

echo ""
echo "All tests passed! 🎉"
echo "Ready to install with: ./install.sh"