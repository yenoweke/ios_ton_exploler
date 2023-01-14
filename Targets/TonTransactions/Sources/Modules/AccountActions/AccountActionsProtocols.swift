import Foundation

protocol AccountActionsDependencies {
    var address: String { get }
    var watchlistStorage: WatchlistStorage { get }
    var accountSubsriptonManager: AccountSubsriptonManager { get }
    var pushManager: PushManager? { get }
}

struct AccountActionsDependenciesImpl: AccountActionsDependencies {
    private let serviceLocator: ServiceLocator

    let address: String

    var watchlistStorage: WatchlistStorage {
        self.serviceLocator.watchlistStorage
    }
    
    var accountSubsriptonManager: AccountSubsriptonManager {
        self.serviceLocator.accountSubsriptonManager
    }
    
    var pushManager: PushManager? {
        self.serviceLocator.pushManager
    }

    init(serviceLocator: ServiceLocator, address: String) {
        self.serviceLocator = serviceLocator
        self.address = address
    }
}

protocol AccountActionsInteractorInput {
    func updateIfNeeded()
    func toggleWatchlistForAddress()
    func toggleAccountSubscription()
    func needToEnablePushPermissions()
}

protocol AccountActionsInteractorOutput: AnyObject {
    func didLoadInitial()
    func itemAdded()
    func itemRemoved()
    func subsribed()
    func unsubsribed()
    func pushPermissionDinied()
}

protocol AccountActionsRouterInput {
    func showSystemSettings()
}
