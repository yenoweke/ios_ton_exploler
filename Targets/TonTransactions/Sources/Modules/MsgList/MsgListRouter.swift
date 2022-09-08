import Foundation

final class MsgListRouter: BaseRouter, MsgListRouterInput {
    private let dependencies: MsgListDependencies

    init(dependencies: MsgListDependencies) {
        self.dependencies = dependencies
    }

    func showTxnDetails(_ txnID: TxnItem.ID) {
        let container = TxnDetailModuleContainer.assemble(self.dependencies.makeTxnDetailDependencies(txnID: txnID))
        self.push(container)
    }
}
