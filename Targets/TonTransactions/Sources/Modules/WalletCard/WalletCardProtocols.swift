import Foundation

protocol WalletCardDependencies {
    var address: String { get }
    var walletInfoProvider: WalletInfoProvider { get }
    func makeAddToWatchlistDependencies() -> AddToWatchlistDependencies
}

struct WalletCardDependenciesImpl: WalletCardDependencies {
    private let serviceLocator: ServiceLocator

    let address: String

    var walletInfoProvider: WalletInfoProvider {
        self.serviceLocator.tonService
    }

    init(serviceLocator: ServiceLocator, address: String) {
        self.serviceLocator = serviceLocator
        self.address = address
    }

    func makeAddToWatchlistDependencies() -> AddToWatchlistDependencies {
        AddToWatchlistDependenciesImpl(serviceLocator: self.serviceLocator, address: self.address)
    }
}

protocol WalletCardInteractorInput {
    func loadWalletInfo()
}

protocol WalletCardInteractorOutput {
    func loadingStarted()
    func didLoad(_ wallet: WalletCardItem)
    func gotError(_ error: Error, retry: VoidClosure?)
}

protocol WalletCardRouterInput {

}
