import Cocoa

// Create the application and app delegate
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// Ensure we don't terminate when the last window closes
app.setActivationPolicy(.accessory)

print("Starting ScrollControl...")

// Run the application
app.run()