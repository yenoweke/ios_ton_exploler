import Foundation
import UIKit
import TonTransactionsUI
import TTDeeplinks

final class AppCoordinator {
    private let serviceLocator: ServiceLocator
    private let preparer: Preparer
    
    private weak var appDelegate: AppDelegateHandlerOwner?
    private var navigator: Navigator?
    private var strongReferences: [Any] = []
    private var window: UIWindow?
    
    init(appDelegate: AppDelegateHandlerOwner) {
        self.appDelegate = appDelegate
        let pushManagerImpl = PushManagerImpl(networkService: ServiceLocator.makePushSubsriptionService())
        let deeplinkManager = DeeplinkManagerFactory.make()
        
        self.serviceLocator = ServiceLocator(pushManager: pushManagerImpl, deeplinkManager: deeplinkManager)
        appDelegate.add(handler: pushManagerImpl.appDelegateHandler)
        
        self.preparer = PreparerAggregate(items: [
            DeviceCreatorImpl(network: serviceLocator.makeDeviceNetworkService())
        ])
        
        self.setupDeeplinkManager(deeplinkManager)
    }
    
    func start() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        self.navigator = Navigator(serviceLocator: self.serviceLocator)
        
        self.window?.rootViewController = HostingViewController(rootView: LaunchView())
        self.window?.makeKeyAndVisible()

        Task {
            _ = try? await self.preparer.prepare()
            await self.navigator?.showTabBar(from: window)
        }
    }
}

private extension AppCoordinator {
    
    func setupDeeplinkManager(_ deeplinkManager: DeeplinkManager) {
        let defaultDeeplinkHandler = DefaultDeeplinkHandler(serviceLocator: self.serviceLocator, rootRouter: { [navigator] in
            navigator?.activeRouter
        })
        deeplinkManager.add(handler: defaultDeeplinkHandler)
        self.strongReferences.append(defaultDeeplinkHandler)
        
        let deeplinkManagerAppDelegateHandler = AppDelegateHandler()
        
        deeplinkManagerAppDelegateHandler.openURLHandler = { _, url, _ in
            _ = deeplinkManager.handle(url)
        }
        deeplinkManagerAppDelegateHandler.didReceiveRemoteNotification = { _, userInfo, completion in
            guard let url = userInfo["url"] as? URL else { return }
            _ = deeplinkManager.handle(url)
            completion(.newData)
        }
        
        self.strongReferences.append(deeplinkManagerAppDelegateHandler)
        self.appDelegate?.add(handler: deeplinkManagerAppDelegateHandler)
    }
}

extension AppCoordinator: PushManagerNotificationListener {
    func pushManagerDidReceive(url: URL) {
        _ = self.serviceLocator.deeplinkManager.handle(url)
    }
}
