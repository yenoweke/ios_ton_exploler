import Foundation

protocol WalletCardDependencies {
    var address: String { get }
    func makeWalletInfoProvider() -> WalletInfoProvider
}

struct WalletCardDependenciesImpl: WalletCardDependencies {
    private let serviceLocator: ServiceLocator

    let address: String

    init(serviceLocator: ServiceLocator, address: String) {
        self.serviceLocator = serviceLocator
        self.address = address
    }
    
    func makeWalletInfoProvider() -> WalletInfoProvider {
        WalletInfoProviderImpl(service: self.serviceLocator.tonNetworkService)
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
