import Cocoa

class ViewController: NSViewController {
    var trackpadNaturalCheckbox: NSButton!
    var mouseWheelNaturalCheckbox: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSettings()
    }
    
    func setupUI() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 180))
        
        let titleLabel = NSTextField(labelWithString: "Scroll Direction Settings")
        titleLabel.frame = NSRect(x: 20, y: 140, width: 260, height: 20)
        titleLabel.font = NSFont.boldSystemFont(ofSize: 14)
        view.addSubview(titleLabel)
        
        trackpadNaturalCheckbox = NSButton(checkboxWithTitle: "Trackpad Natural Scroll", target: self, action: #selector(trackpadSettingChanged))
        trackpadNaturalCheckbox.frame = NSRect(x: 20, y: 110, width: 260, height: 20)
        view.addSubview(trackpadNaturalCheckbox)
        
        mouseWheelNaturalCheckbox = NSButton(checkboxWithTitle: "Mouse Wheel Natural Scroll", target: self, action: #selector(mouseWheelSettingChanged))
        mouseWheelNaturalCheckbox.frame = NSRect(x: 20, y: 80, width: 260, height: 20)
        view.addSubview(mouseWheelNaturalCheckbox)
        
        let infoLabel = NSTextField(labelWithString: "Changes apply immediately")
        infoLabel.frame = NSRect(x: 20, y: 55, width: 260, height: 20)
        infoLabel.font = NSFont.systemFont(ofSize: 11)
        infoLabel.textColor = NSColor.secondaryLabelColor
        view.addSubview(infoLabel)
        
        // Add separator line
        let separatorLine = NSBox()
        separatorLine.boxType = .separator
        separatorLine.frame = NSRect(x: 20, y: 40, width: 260, height: 1)
        view.addSubview(separatorLine)
        
        // Add Quit button
        let quitButton = NSButton(title: "Quit ScrollControl", target: self, action: #selector(quitApp))
        quitButton.frame = NSRect(x: 20, y: 10, width: 260, height: 25)
        quitButton.bezelStyle = .rounded
        view.addSubview(quitButton)
    }
    
    func loadSettings() {
        let settings = ScrollEventHandler.shared.getSettings()
        
        trackpadNaturalCheckbox.state = settings.trackpadNatural ? .on : .off
        mouseWheelNaturalCheckbox.state = settings.mouseWheelNatural ? .on : .off
    }
    
    @objc func trackpadSettingChanged() {
        let trackpadNatural = trackpadNaturalCheckbox.state == .on
        let mouseWheelNatural = mouseWheelNaturalCheckbox.state == .on
        
        ScrollEventHandler.shared.updateSettings(
            trackpadNatural: trackpadNatural,
            mouseWheelNatural: mouseWheelNatural
        )
    }
    
    @objc func mouseWheelSettingChanged() {
        let trackpadNatural = trackpadNaturalCheckbox.state == .on
        let mouseWheelNatural = mouseWheelNaturalCheckbox.state == .on
        
        ScrollEventHandler.shared.updateSettings(
            trackpadNatural: trackpadNatural,
            mouseWheelNatural: mouseWheelNatural
        )
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}