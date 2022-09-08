import Foundation

final class TxnDetailRouter: BaseRouter, TxnDetailRouterInput {
    private let dependencies: TxnDetailDependencies

    init(dependencies: TxnDetailDependencies) {
        self.dependencies = dependencies
    }
}
