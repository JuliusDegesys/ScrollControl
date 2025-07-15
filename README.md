# ScrollControl - macOS Scroll Direction Manager

A simple macOS app that allows you to configure different scroll directions for trackpad and mouse wheel independently.

## Features

- **Independent scroll direction control**: Configure trackpad and mouse wheel scroll directions separately
- **Menu bar integration**: Easy access via system menu bar
- **Persistent settings**: Your preferences are saved automatically
- **macOS Sequoia 15.5 compatible**: Built for modern macOS versions

## Default Behavior

- **Trackpad**: Natural scroll direction (enabled by default)
- **Mouse Wheel**: Reverse of natural scroll direction (disabled by default)

This means trackpad scrolling works as expected with natural scroll, while mouse wheel scrolling works in the opposite direction.

## Installation

### Quick Install (Recommended)

1. Build and install:
   ```bash
   ./build.sh
   ./install.sh
   ```

2. Grant accessibility permissions when prompted (required for scroll event monitoring)

The app will now start automatically at login!

### Manual Installation

1. Build the app:
   ```bash
   ./build.sh
   ```

2. Run the app:
   ```bash
   ./build/ScrollControl
   ```

3. Grant accessibility permissions when prompted (required for scroll event monitoring)

### Auto-Startup Setup

To set up automatic startup at login:
```bash
./install.sh
```

This will:
- Install the app to `~/Applications/ScrollControl`
- Create a LaunchAgent to start the app automatically
- Configure logging to `~/Library/Logs/ScrollControl.log`

### Managing Auto-Startup

- **Start**: `launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.scrollcontrol.app.plist`
- **Stop**: `launchctl bootout gui/$(id -u)/com.scrollcontrol.app`
- **Restart**: `launchctl kickstart -k gui/$(id -u)/com.scrollcontrol.app`
- **View logs**: `tail -f ~/Library/Logs/ScrollControl.log`

### Uninstallation

To completely remove the app:
```bash
./uninstall.sh
```

## Usage

1. Once running, you'll see a scroll control icon in your menu bar
2. **Click** the icon to open the settings panel
3. Configure your preferred scroll directions:
   - **Trackpad Natural Scroll**: Enable for natural trackpad scrolling
   - **Mouse Wheel Natural Scroll**: Enable for natural mouse wheel scrolling
4. Changes apply immediately
5. Use the **"Quit ScrollControl"** button at the bottom of the settings panel to close the application

## Technical Details

The app uses:
- Core Graphics Event Taps to intercept scroll events
- IOKit to differentiate between trackpad and mouse wheel input
- Cocoa for the user interface
- UserDefaults for persistent settings storage

## Permissions

This app requires **Accessibility** permissions to monitor and modify scroll events system-wide. You'll be prompted to grant these permissions when first running the app.

## Building from Source

Requirements:
- macOS 12.0 or later
- Xcode Command Line Tools
- Swift 5.9 or later

### Modern Swift Package Manager Build (Recommended)

```bash
# Build using Swift Package Manager
swift build -c release

# Or use the build script
./build.sh
```

### Direct Swift Package Manager commands

```bash
# Build for development
swift build

# Build for release
swift build -c release

# Run directly (development)
swift run

# Run tests (if any)
swift test
```

The compiled app will be available at:
- Development: `.build/debug/ScrollControl`
- Release: `.build/release/ScrollControl` (also copied to `./build/ScrollControl`)