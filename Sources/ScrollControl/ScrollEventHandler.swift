import Cocoa
import IOKit.hid

class ScrollEventHandler: NSObject {
    static let shared = ScrollEventHandler()
    
    private var trackpadNaturalScroll = true
    private var mouseWheelNaturalScroll = false
    private var eventTap: CFMachPort?
    
    private override init() {
        super.init()
        loadSettings()
    }
    
    func startMonitoring() {
        let eventMask = (1 << CGEventType.scrollWheel.rawValue)
        
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                let handler = Unmanaged<ScrollEventHandler>.fromOpaque(refcon!).takeUnretainedValue()
                return handler.handleScrollEvent(event: event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )
        
        guard let eventTap = eventTap else {
            print("Failed to create event tap")
            return
        }
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }
    
    func stopMonitoring() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFMachPortInvalidate(eventTap)
            self.eventTap = nil
        }
    }
    
    private func handleScrollEvent(event: CGEvent) -> Unmanaged<CGEvent>? {
        let deltaY = event.getDoubleValueField(.scrollWheelEventDeltaAxis1)
        let deltaX = event.getDoubleValueField(.scrollWheelEventDeltaAxis2)
        
        let isTrackpad = event.getDoubleValueField(.scrollWheelEventScrollPhase) != 0 ||
                        event.getDoubleValueField(.scrollWheelEventMomentumPhase) != 0
        
        let shouldInvert = isTrackpad ? !trackpadNaturalScroll : !mouseWheelNaturalScroll
        
        if shouldInvert {
            event.setDoubleValueField(.scrollWheelEventDeltaAxis1, value: -deltaY)
            event.setDoubleValueField(.scrollWheelEventDeltaAxis2, value: -deltaX)
        }
        
        return Unmanaged.passRetained(event)
    }
    
    func updateSettings(trackpadNatural: Bool, mouseWheelNatural: Bool) {
        trackpadNaturalScroll = trackpadNatural
        mouseWheelNaturalScroll = mouseWheelNatural
        saveSettings()
    }
    
    private func loadSettings() {
        let defaults = UserDefaults.standard
        trackpadNaturalScroll = defaults.object(forKey: "trackpadNaturalScroll") as? Bool ?? true
        mouseWheelNaturalScroll = defaults.object(forKey: "mouseWheelNaturalScroll") as? Bool ?? false
    }
    
    private func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(trackpadNaturalScroll, forKey: "trackpadNaturalScroll")
        defaults.set(mouseWheelNaturalScroll, forKey: "mouseWheelNaturalScroll")
    }
    
    func getSettings() -> (trackpadNatural: Bool, mouseWheelNatural: Bool) {
        return (trackpadNaturalScroll, mouseWheelNaturalScroll)
    }
}