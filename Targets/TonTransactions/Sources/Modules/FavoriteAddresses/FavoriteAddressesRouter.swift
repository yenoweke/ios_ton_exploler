import Foundation

final class FavoriteAddressesRouter: BaseRouter, FavoriteAddressesRouterInput {
    private let dependencies: FavoriteAddressesDependencies

    init(dependencies: FavoriteAddressesDependencies) {
        self.dependencies = dependencies
    }

    func showEdit(_ address: String) {

    }

    func showTransactions(for address: String) {
        let container = MsgListModuleContainer.assemble(self.dependencies.makeMsgListDependencies(address: address))
        self.push(container)
    }
}
