import Foundation

protocol AddToWatchlistDependencies {
    var address: String { get }
    var watchlistStorage: WatchlistStorage { get }
}

struct AddToWatchlistDependenciesImpl: AddToWatchlistDependencies {
    private let serviceLocator: ServiceLocator

    let address: String
    var watchlistStorage: WatchlistStorage {
        self.serviceLocator.watchlistStorage
    }

    init(serviceLocator: ServiceLocator, address: String) {
        self.serviceLocator = serviceLocator
        self.address = address
    }
}

protocol AddToWatchlistInteractorInput {
    func updateIfNeeded()
    func toggleWatchlistForAddress()
}

protocol AddToWatchlistInteractorOutput: AnyObject {
    func itemAdded()
    func itemRemoved()
}

protocol AddToWatchlistRouterInput {

}
