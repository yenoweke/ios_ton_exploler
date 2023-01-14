import UIKit
import TonTransactionsKit
import TonTransactionsUI
import TTAPIService

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AppDelegateHandlerOwner {

    private var handlers = NSHashTable<AppDelegateHandler>.weakObjects()
    private var appCoordinator: AppCoordinator?

    func add(handler: AppDelegateHandler) {
        self.handlers.add(handler)
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        self.appCoordinator = AppCoordinator(appDelegate: self)
        self.appCoordinator?.start()

        self.enumerateHandlers { handler in
            handler.didFinishLaunchingHandler?(application, launchOptions)
        }

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        self.enumerateHandlers { handler in
            handler.openURLHandler?(app, url, options)
        }
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        self.enumerateHandlers { handler in
            handler.continueActivityHandler?(application, userActivity)
        }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.enumerateHandlers { handler in
            handler.didRegisterForRemoteNotificationsHandler?(application, deviceToken)
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.enumerateHandlers { handler in
            handler.willEnterForegroundHandler?(application)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.enumerateHandlers { handler in
            handler.didBecomeActiveHandler?(application)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func enumerateHandlers(_ action: (AppDelegateHandler) -> Void) {
        self.handlers.allObjects.forEach(action)
    }
}

protocol AppDelegateHandlerOwner: AnyObject {
    func add(handler: AppDelegateHandler)
}

final class AppDelegateHandler {
    var didFinishLaunchingHandler: ((UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Void)?
    var openURLHandler: ((UIApplication, URL, [UIApplication.OpenURLOptionsKey: Any]) -> Void)?
    var continueActivityHandler: ((UIApplication, NSUserActivity) -> Void)?
    var willEnterForegroundHandler: ((UIApplication) -> Void)?
    var didBecomeActiveHandler: ((UIApplication) -> Void)?
    var didRegisterForRemoteNotificationsHandler: ((UIApplication, Data) -> Void)?
}

enum Configuration {
    
    static let toncenterAPIKey: String = try! Configuration.value(for: "TONCENTER_API_KEY")
    static let ttBackendURL: String = {
        let string: String = try! Configuration.value(for: "TT_BACKEND_URL")
        return string.replacingOccurrences(of: "\\/", with: "/")
    }()

    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    private static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}
