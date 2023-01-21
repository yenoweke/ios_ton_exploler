import Foundation

final class MsgDetailsRouter: BaseRouter, MsgDetailsRouterInput {
    private let dependencies: MsgDetailsDependencies

    init(dependencies: MsgDetailsDependencies) {
        self.dependencies = dependencies
    }

    func showTransactions(for address: String) {
        let container = MsgListModuleContainer.assemble(self.dependencies.makeMsgListDependencies(address: address))
        self.push(container)
    }
}
