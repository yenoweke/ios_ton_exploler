import Foundation

protocol TxnDetailDependencies {
    var txnID: TxnItem.ID { get }
}

struct TxnDetailDependenciesImpl: TxnDetailDependencies {
    private let serviceLocator: ServiceLocator

    let txnID: TxnItem.ID

    init(serviceLocator: ServiceLocator, txnID: TxnItem.ID) {
        self.serviceLocator = serviceLocator
        self.txnID = txnID
    }
}

protocol TxnDetailInteractorInput {

}

protocol TxnDetailInteractorOutput: AnyObject {

}

protocol TxnDetailRouterInput {

}
