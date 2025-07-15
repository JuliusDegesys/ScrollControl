import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("App launched")
        setupStatusItem()
        setupPopover()
        
        print("Checking accessibility permissions...")
        if AXIsProcessTrusted() {
            print("Accessibility permissions granted")
            ScrollEventHandler.shared.startMonitoring()
        } else {
            print("Requesting accessibility permissions...")
            requestAccessibilityPermissions()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        ScrollEventHandler.shared.stopMonitoring()
    }
    
    func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button {
            // Use a simple text-based icon since systemSymbolName might not work
            button.title = "⚙️"
            button.action = #selector(togglePopover)
            button.target = self
        }
        
        print("Status item created: \(statusItem != nil)")
    }
    
    func setupPopover() {
        popover = NSPopover()
        popover.contentViewController = ViewController()
        popover.behavior = .transient
    }
    
    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
    
    func requestAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if accessEnabled {
            ScrollEventHandler.shared.startMonitoring()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.requestAccessibilityPermissions()
            }
        }
    }
}