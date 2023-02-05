import Foundation
import UserNotifications

public protocol DeeplinkManager {
    func handle(_ url: URL) -> Bool
    func handle(_ urlString: String) -> Bool
    
    func add(handler: DeeplinkHandler)
    func remove(handler: DeeplinkHandler)
}

final class DeeplinkManagerImpl: DeeplinkManager {
    
    private let parser: DeeplinkParser
    
    private var handlers = NSHashTable<AnyObject>.weakObjects()
    
    init(parser: DeeplinkParser) {
        self.parser = parser
    }

    @discardableResult
    func handle(_ url: URL) -> Bool {
        guard let deeplink = parser.parse(url) else { return false }
        
        var handled = false

        for handler in (self.handlers.allObjects as? [DeeplinkHandler] ?? []) {
            if handled { return handled }
            handled = handler.handle(deeplink)
        }
        return handled
    }
    
    func handle(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return self.handle(url)
    }
    
    func add(handler: DeeplinkHandler) {
        self.handlers.add(handler)
    }
    
    func remove(handler: DeeplinkHandler) {
        self.handlers.remove(handler)
    }
}
