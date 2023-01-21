import Foundation

protocol TxnDetailDependencies {
    var txnID: TxnItem.ID { get }
    var txnsStorage: TxnsStorage { get }

    func makeMsgDetailsDependencies(for msgID: String) -> MsgDetailsDependencies
}

struct TxnDetailDependenciesImpl: TxnDetailDependencies {
    private let serviceLocator: ServiceLocator

    let txnID: TxnItem.ID
    var txnsStorage: TxnsStorage {
        self.serviceLocator.txnsStorage
    }

    init(serviceLocator: ServiceLocator, txnID: TxnItem.ID) {
        self.serviceLocator = serviceLocator
        self.txnID = txnID
    }

    func makeMsgDetailsDependencies(for msgID: String) -> MsgDetailsDependencies {
        MsgDetailsDependenciesImpl(serviceLocator: self.serviceLocator, msgID: msgID)
    }
}

protocol TxnDetailInteractorInput {
    func load()
}

protocol TxnDetailInteractorOutput: AnyObject {
    func didLoad(_ txnItem: TxnItem)
    func gotError(_ error: TxnDetailInteractorError)
}

protocol TxnDetailRouterInput {

}
