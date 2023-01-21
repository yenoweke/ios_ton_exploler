import Foundation
import UserNotifications

protocol DeeplinkManager {
    func handle(_ url: URL) -> Bool
    func handle(_ urlString: String) -> Bool
    
    func add(handler: DeeplinkHandler)
    func remove(handler: DeeplinkHandler)
}

final class DeeplinkManagerImpl: DeeplinkManager {
    
    private let parser: DeeplinkParser
    
    private var handlers = NSHashTable<AnyObject>.weakObjects()
    
    let appDelegateHandler = AppDelegateHandler()

    var defaultHandler: DeeplinkHandler?
    
    init(parser: DeeplinkParser) {
        self.parser = parser
        self.appDelegateHandler.openURLHandler = { [weak self] _, url, _ in
            self?.handle(url)
        }
        self.appDelegateHandler.didReceiveRemoteNotification = { [weak self] _, userInfo, completion in
            guard let url = userInfo["url"] as? URL else { return }
            self?.handle(url)
            completion(.newData)
        }
    }

    @discardableResult
    func handle(_ url: URL) -> Bool {
        guard let deeplink = parser.parse(url) else { return false }
        
        var handled = false

        for handler in (self.handlers.allObjects as? [DeeplinkHandler] ?? []) {
            if handled { return handled }
            handled = handler.handle(deeplink)
        }
        if handled == false {
            handled = self.defaultHandler?.handle(deeplink) ?? false
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

extension DeeplinkManagerImpl: PushManagerNotificationListener {
    func pushManagerDidReceive(url: URL) {
        self.handle(url)
    }
}

protocol DeeplinkHandler: AnyObject {
    func handle(_ deeplink: Deeplink) -> Bool
}

final class DefaultDeeplinkHandler: DeeplinkHandler {
    
    private let rootRouter: () -> Router?
    
    weak var serviceLocator: ServiceLocator!

    init(serviceLocator: ServiceLocator, rootRouter: @escaping () -> Router?) {
        self.serviceLocator = serviceLocator
        self.rootRouter = rootRouter
    }
    
    func handle(_ deeplink: Deeplink) -> Bool {
        switch deeplink.path {
        case .account(let account):
            self.showTransactions(for: account)
            return true
        case .unkonwn:
            // TODO: may be show alert or log it
            return false
        }
    }
    
    private func showTransactions(for address: String) {
        guard let router = self.rootRouter()?.topRouter else { assertionFailure(); return }
        let container = MsgListModuleContainer.assemble(self.makeMsgListDependencies(address: address))
        router.push(container)
    }

    private func makeMsgListDependencies(address: String) -> MsgListDependencies {
        MsgListDependenciesImpl(serviceLocator: self.serviceLocator, address: address)
    }
}
