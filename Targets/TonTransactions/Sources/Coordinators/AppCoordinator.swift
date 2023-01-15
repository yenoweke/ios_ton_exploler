import Foundation
import UIKit
import TonTransactionsUI

final class AppCoordinator {
    private let serviceLocator: ServiceLocator

    private let tabBarController = UITabBarController()
    
    private lazy var tabBarControllerDelegateAdapter = TabBarControllerDelegateAdapter()
    private var inputAddressRouter: Router?
    private var watchlistRouter: Router?

    private weak var appDelegate: AppDelegateHandlerOwner?
    private var window: UIWindow?
    private let preparer: Preparer
    
    init(appDelegate: AppDelegateHandlerOwner) {
        self.appDelegate = appDelegate
        let pushManagerImpl = PushManagerImpl(networkService: ServiceLocator.makePushSubsriptionService())
        let deeplinkManager = DeeplinkManagerImpl(parser: DeeplinkParserImpl())
        self.serviceLocator = ServiceLocator(pushManager: pushManagerImpl, deeplinkManager: deeplinkManager)
        appDelegate.add(handler: pushManagerImpl.appDelegateHandler)
        
        self.preparer = PreparerAggregate(items: [
            DeviceCreatorImpl(network: serviceLocator.makeDeviceNetworkService())
        ])
        
        let defaultDeeplinkHandler = DefaultDeeplinkHandler(serviceLocator: self.serviceLocator, rootRouter: { [weak self] in
            if self?.tabBarControllerDelegateAdapter.selected == 1 {
                return self?.watchlistRouter
            }
            return self?.inputAddressRouter
        })
        deeplinkManager.defaultHandler = defaultDeeplinkHandler
        appDelegate.add(handler: deeplinkManager.appDelegateHandler)
        pushManagerImpl.add(listener: deeplinkManager)
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
}

final class TabBarControllerDelegateAdapter: NSObject, UITabBarControllerDelegate {
    private(set) var selected: Int = 0
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.selected = tabBarController.viewControllers?.firstIndex(of: viewController) ?? self.selected
    }
}
