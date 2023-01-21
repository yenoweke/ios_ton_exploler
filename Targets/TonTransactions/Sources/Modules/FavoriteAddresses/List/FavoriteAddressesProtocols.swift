import Foundation

protocol FavoriteAddressesDependencies {
    var watchlistStorage: WatchlistStorage { get }
    func makeMsgListDependencies(address: String) -> MsgListDependencies
    func makeEditAddressDependencies(address: String, moduleOutput: EditAddressModuleOutput?) -> EditAddressDependencies
}

struct FavoriteAddressesDependenciesImpl: FavoriteAddressesDependencies {
    private let serviceLocator: ServiceLocator
    var watchlistStorage: WatchlistStorage { self.serviceLocator.watchlistStorage }

    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }

    func makeMsgListDependencies(address: String) -> MsgListDependencies {
        MsgListDependenciesImpl(serviceLocator: self.serviceLocator, address: address)
    }

    func makeEditAddressDependencies(address: String, moduleOutput: EditAddressModuleOutput?) -> EditAddressDependencies {
        EditAddressDependenciesImpl(serviceLocator: self.serviceLocator, address: address, moduleOutput: moduleOutput)
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
