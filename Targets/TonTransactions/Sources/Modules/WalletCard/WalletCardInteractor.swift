import Foundation

struct WalletCardItem: Codable {
    let address: String
    let balance: String
    let state: String?
}

final class WalletCardInteractor: WalletCardInteractorInput {
    private let output: WalletCardInteractorOutput
    private let router: WalletCardRouterInput
    private let walletInfoProvider: WalletInfoProvider
    private let address: String

    init(
            output: WalletCardInteractorOutput,
            router: WalletCardRouterInput,
            walletInfoProvider: WalletInfoProvider,
            address: String
    ) {
        self.output = output
        self.router = router
        self.walletInfoProvider = walletInfoProvider
        self.address = address
    }

    func loadWalletInfo() {
        self.output.loadingStarted()

        Task {
            do {
                let wallet = try await self.walletInfoProvider.fetchWalletInformation(self.address)
                await MainActor.run {
                    self.output.didLoad(wallet)
                }
            }
            catch {
                await MainActor.run {
                    self.output.gotError(error, retry: { [weak self] in
                        self?.loadWalletInfo()
                    })
                }
            }
        }
    }
}
