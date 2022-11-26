import Foundation

protocol EditAddressDependencies {
    var address: String { get }
    var storage: WatchlistStorage { get }
    var moduleOutput: EditAddressModuleOutput? { get }
}

struct EditAddressDependenciesImpl: EditAddressDependencies {
    private let serviceLocator: ServiceLocator

    let address: String
    let moduleOutput: EditAddressModuleOutput?
    var storage: WatchlistStorage { serviceLocator.watchlistStorage }

    init(serviceLocator: ServiceLocator, address: String, moduleOutput: EditAddressModuleOutput?) {
        self.serviceLocator = serviceLocator
        self.moduleOutput = moduleOutput
        self.address = address
    }
}

protocol EditAddressModuleOutput: AnyObject {
    func didFinish()
}

protocol EditAddressInteractorInput {
    func update(_ address: String)
    func save()
}

protocol EditAddressInteractorOutput: AnyObject {
    func didUpdate(_ address: String)
}

protocol EditAddressRouterInput {
}
