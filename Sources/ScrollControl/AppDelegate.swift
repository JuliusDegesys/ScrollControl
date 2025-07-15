import Cocoa

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var menu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("App launched")
        setupStatusItem()
        setupMenu()
        
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
            // Create a simple scroll icon using NSImage drawing
            let image = NSImage(size: NSSize(width: 16, height: 16))
            image.lockFocus()
            
            // Draw mouse outline
            let mousePath = NSBezierPath(roundedRect: NSRect(x: 3, y: 2, width: 10, height: 12), xRadius: 5, yRadius: 5)
            mousePath.lineWidth = 1.5
            NSColor.controlAccentColor.setStroke()
            mousePath.stroke()
            
            // Draw scroll wheel line
            let wheelPath = NSBezierPath()
            wheelPath.move(to: NSPoint(x: 8, y: 5))
            wheelPath.line(to: NSPoint(x: 8, y: 8))
            wheelPath.lineWidth = 1.5
            wheelPath.lineCapStyle = .round
            NSColor.controlAccentColor.setStroke()
            wheelPath.stroke()
            
            image.unlockFocus()
            image.isTemplate = true
            button.image = image
            
            // Don't set action - let the menu handle clicks automatically
        }
        
        print("Status item created: \(statusItem != nil)")
    }
    
    func setupMenu() {
        menu = NSMenu()
        
        // Add checkboxes
        let trackpadItem = NSMenuItem(title: "Trackpad Natural Scroll", action: #selector(toggleTrackpadNatural), keyEquivalent: "")
        trackpadItem.target = self
        menu.addItem(trackpadItem)
        
        let mouseWheelItem = NSMenuItem(title: "Mouse Wheel Natural Scroll", action: #selector(toggleMouseWheelNatural), keyEquivalent: "")
        mouseWheelItem.target = self
        menu.addItem(mouseWheelItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Add quit button
        let quitItem = NSMenuItem(title: "Quit ScrollControl", action: #selector(quitApp), keyEquivalent: "")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
        updateMenuCheckboxes()
    }
    
    @objc func toggleTrackpadNatural() {
        let settings = ScrollEventHandler.shared.getSettings()
        ScrollEventHandler.shared.updateSettings(
            trackpadNatural: !settings.trackpadNatural,
            mouseWheelNatural: settings.mouseWheelNatural
        )
        updateMenuCheckboxes()
    }
    
    @objc func toggleMouseWheelNatural() {
        let settings = ScrollEventHandler.shared.getSettings()
        ScrollEventHandler.shared.updateSettings(
            trackpadNatural: settings.trackpadNatural,
            mouseWheelNatural: !settings.mouseWheelNatural
        )
        updateMenuCheckboxes()
    }
    
    func updateMenuCheckboxes() {
        let settings = ScrollEventHandler.shared.getSettings()
        
        // Update trackpad checkbox (index 0)
        if let trackpadItem = menu.items[safe: 0] {
            trackpadItem.state = settings.trackpadNatural ? .on : .off
        }
        
        // Update mouse wheel checkbox (index 1)
        if let mouseWheelItem = menu.items[safe: 1] {
            mouseWheelItem.state = settings.mouseWheelNatural ? .on : .off
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