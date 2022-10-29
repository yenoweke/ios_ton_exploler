import Foundation

final class TxnDetailViewState: ObservableObject {
    @Published var viewModel: TransactionDetailsViewModel? = nil

    init() {
    }
}

extension TxnDetailViewState: TxnDetailInteractorOutput {
    func didLoad(_ txnItem: TxnItem) {
        self.viewModel = TransactionDetailsViewModelImpl(transaction: txnItem)
    }

    func gotError(_ error: TxnDetailInteractorError) {
        // TODO: handle
    }
}
