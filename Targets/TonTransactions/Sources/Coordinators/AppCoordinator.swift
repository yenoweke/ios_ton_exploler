import Foundation
import UIKit

final class AppCoordinator {
    private let serviceLocator: ServiceLocator
    
    private let tabBarController = UITabBarController()
    
    private var window: UIWindow?
    
    init() {
        self.serviceLocator = ServiceLocator()
    }
    
    func start() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.setupTabBar()
        
        self.window?.rootViewController = self.tabBarController
        self.window?.makeKeyAndVisible()
    }
    
}

private extension AppCoordinator {
    func setupTabBar() {
        let inputAddressVC = InputAddressModuleContainer.assemble(InputAddressDependenciesImpl(serviceLocator: self.serviceLocator))
        
        inputAddressVC.viewControllerToShow.tabBarItem = UITabBarItem(
            title: "one",
            image: UIImage(systemName: "pencil.circle"),
            selectedImage: UIImage(systemName: "pencil.circle.fill")
        )
        let inputAddressNavController = UINavigationController(rootViewController: inputAddressVC.viewControllerToShow)
        
        let viewController2 = UIViewController()
        viewController2.view.backgroundColor = .red
        viewController2.tabBarItem = UITabBarItem(
            title: "second",
            image: UIImage(systemName: "calendar.circle"),
            selectedImage: UIImage(systemName: "calendar.circle.fill")
        )
        
        self.tabBarController.viewControllers = [inputAddressNavController, viewController2]
        
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}
