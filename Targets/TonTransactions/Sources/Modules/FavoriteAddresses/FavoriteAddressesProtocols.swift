import Foundation

protocol FavoriteAddressesDependencies {
    var watchlistStorage: WatchlistStorage { get }
    func makeMsgListDependencies(address: String) -> MsgListDependencies
}

struct FavoriteAddressesDependenciesImpl: FavoriteAddressesDependencies {
    private let serviceLocator: ServiceLocator

    var watchlistStorage: WatchlistStorage { self.serviceLocator.watchlistStorage }

    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }

    func makeMsgListDependencies(address: String) -> MsgListDependencies {
        TxListDependenciesImpl(serviceLocator: self.serviceLocator, address: address)
    }
}

protocol FavoriteAddressesInteractorInput {
    func prepareList()
    func show(_ address: String)
    func edit(_ address: String)
    func remove(_ address: String)
}

protocol FavoriteAddressesInteractorOutput: AnyObject {
    func didUpdate(_ items: [WatchlistItem])
}

protocol FavoriteAddressesRouterInput {
    func showEdit(_ address: String)
    func showTransactions(for address: String)
}
