import Foundation

final class TxnDetailInteractor: TxnDetailInteractorInput {
    private weak var output: TxnDetailInteractorOutput?
    private let router: TxnDetailRouterInput

    init(output: TxnDetailInteractorOutput, router: TxnDetailRouterInput) {
        self.output = output
        self.router = router
    }
}
