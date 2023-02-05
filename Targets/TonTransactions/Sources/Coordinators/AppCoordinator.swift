import Foundation
import UIKit
import TonTransactionsUI
import TTDeeplinks

final class AppCoordinator {
    private let serviceLocator: ServiceLocator
    private let tabBarController = UITabBarController()
    private let preparer: Preparer
    
    private lazy var tabBarControllerDelegateAdapter = TabBarControllerDelegateAdapter()
    private var inputAddressRouter: Router?
    private var watchlistRouter: Router?

    private weak var appDelegate: AppDelegateHandlerOwner?
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
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.setupTabBar()
        
        self.window?.rootViewController = HostingViewController(rootView: LaunchView())
        self.window?.makeKeyAndVisible()

        Task {
            _ = try? await self.preparer.prepare()
            await showTabBar()
        }
    }
}

private extension AppCoordinator {
    @MainActor
    func showTabBar() async {
        self.window?.rootViewController = self.tabBarController
    }

    func setupTabBar() {
        let inputAddressContainer = InputAddressModuleContainer.assemble(InputAddressDependenciesImpl(serviceLocator: self.serviceLocator))
        self.inputAddressRouter = inputAddressContainer.router

        inputAddressContainer.viewControllerToShow.tabBarItem = UITabBarItem(
            title: L10n.Tab.Search.title,
            image: UIImage(systemName: "magnifyingglass.circle.fill"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
        let inputAddressNavController = UINavigationController(rootViewController: inputAddressContainer.viewControllerToShow)

        let favoriteContainer = FavoriteAddressesModuleContainer.assemble(FavoriteAddressesDependenciesImpl(serviceLocator: self.serviceLocator))
        self.watchlistRouter = favoriteContainer.router
        
        favoriteContainer.viewControllerToShow.tabBarItem = UITabBarItem(
            title: L10n.Tab.Watchlist.title,
            image: UIImage(systemName: "star.fill"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        let favoriteContainerNavController = UINavigationController(rootViewController: favoriteContainer.viewControllerToShow)

        self.tabBarController.viewControllers = [inputAddressNavController, favoriteContainerNavController]
        self.tabBarController.delegate = self.tabBarControllerDelegateAdapter
        
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    func setupDeeplinkManager(_ deeplinkManager: DeeplinkManager) {
        let defaultDeeplinkHandler = DefaultDeeplinkHandler(serviceLocator: self.serviceLocator, rootRouter: { [weak self] in
            if self?.tabBarControllerDelegateAdapter.selected == 1 {
                return self?.watchlistRouter
            }
            return self?.inputAddressRouter
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

final class TabBarControllerDelegateAdapter: NSObject, UITabBarControllerDelegate {
    private(set) var selected: Int = 0
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.selected = tabBarController.viewControllers?.firstIndex(of: viewController) ?? self.selected
    }
}
