import Foundation
import UIKit

final class Navigator {
    enum Tab {
        case inputAddress
        case favorites
    }
    
    private var activeTab: Tab {
        switch self.tabBarControllerDelegateAdapter.selected {
        case 0:
            return .inputAddress
        case 1:
            return .favorites
        default:
            assertionFailure("need to support tab")
            return .inputAddress
        }
    }
    
    private let tabBarController = UITabBarController()
    private let inputAddressRouter: Router
    private let watchlistRouter: Router

    private lazy var tabBarControllerDelegateAdapter = TabBarControllerDelegateAdapter()
    
    var activeRouter: Router? {
        switch activeTab {
        case .inputAddress:
            return inputAddressRouter
        case .favorites:
            return watchlistRouter
        }
    }

    init(serviceLocator: ServiceLocator) {
        let inputAddressContainer = InputAddressModuleContainer.assemble(
            InputAddressDependenciesImpl(serviceLocator: serviceLocator)
        )
        self.inputAddressRouter = inputAddressContainer.router

        inputAddressContainer.viewControllerToShow.tabBarItem = UITabBarItem(
            title: L10n.Tab.Search.title,
            image: UIImage(systemName: "magnifyingglass.circle.fill"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
        let inputAddressNavController = UINavigationController(rootViewController: inputAddressContainer.viewControllerToShow)

        let favoriteContainer = FavoriteAddressesModuleContainer.assemble(
            FavoriteAddressesDependenciesImpl(serviceLocator: serviceLocator)
        )
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
    
    @MainActor
    func showTabBar(from window: UIWindow) async {
        window.rootViewController = self.tabBarController
    }
}

private final class TabBarControllerDelegateAdapter: NSObject, UITabBarControllerDelegate {
    private(set) var selected: Int = 0
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.selected = tabBarController.viewControllers?.firstIndex(of: viewController) ?? self.selected
    }
}
