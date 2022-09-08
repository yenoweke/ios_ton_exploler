import Foundation

final class WalletCardRouter: BaseRouter, WalletCardRouterInput {
    private let dependencies: WalletCardDependencies

    init(dependencies: WalletCardDependencies) {
        self.dependencies = dependencies
    }
}
