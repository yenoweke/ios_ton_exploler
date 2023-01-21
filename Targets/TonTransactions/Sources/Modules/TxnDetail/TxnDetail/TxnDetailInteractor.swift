import Foundation

final class TxnDetailInteractor: TxnDetailInteractorInput {
    private weak var output: TxnDetailInteractorOutput?
    private let router: TxnDetailRouterInput
    private let txnID: String
    private let txnsStorage: TxnsStorage

    init(output: TxnDetailInteractorOutput, router: TxnDetailRouterInput, txnID: String, txnsStorage: TxnsStorage) {
        self.output = output
        self.router = router
        self.txnID = txnID
        self.txnsStorage = txnsStorage
    }

    func load() {
        guard let txn = self.txnsStorage.get(by: self.txnID) else {
            self.output?.gotError(TxnDetailInteractorError.txnNotFound)
            return
        }
        self.output?.didLoad(txn)
    }
}

enum TxnDetailInteractorError: Error {
    case txnNotFound
}
