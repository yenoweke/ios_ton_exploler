import Foundation

final class FavoriteAddressesRouter: BaseRouter, FavoriteAddressesRouterInput {
    private let dependencies: FavoriteAddressesDependencies

    init(dependencies: FavoriteAddressesDependencies) {
        self.dependencies = dependencies
    }

    func showEdit(_ address: String) {
        let container = EditAddressModuleContainer.assemble(self.dependencies.makeEditAddressDependencies(address: address, moduleOutput: self))
        self.present(container)
    }

    func showTransactions(for address: String) {
        let container = MsgListModuleContainer.assemble(self.dependencies.makeMsgListDependencies(address: address))
        self.push(container)
    }
}

extension FavoriteAddressesRouter: EditAddressModuleOutput {
    func didFinish() {
        self.dismissActiveItem(animated: true, completion: nil)
    }
}