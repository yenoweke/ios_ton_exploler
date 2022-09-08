import Foundation
import SwiftUI

final class WalletCardViewState: ObservableObject {

    let placeholder: WalletCardItem
    @Published var wallet: LoadingViewState<WalletCardItem>
    
    init(address: String) {
        self.placeholder = WalletCardItem(address: address, balance: "", state: nil)
        self.wallet = .initial
    }
}

final class WalletCardStateModifier: WalletCardInteractorOutput {
    private let state: WalletCardViewState

    init(state: WalletCardViewState) {
        self.state = state
    }

    func loadingStarted() {
        withAnimation {
            self.state.wallet = .loading
        }
    }

    func didLoad(_ wallet: WalletCardItem) {
        withAnimation {
            self.state.wallet = .loaded(wallet)
        }
    }

    func gotError(_ error: Error, retry: VoidClosure?) {
        withAnimation {
            self.state.wallet = .error(
                    ErrorViewModel(
                            title: "не удалось загрузить",
                            description: "Повторите позде",
                            retry: retry
                    )
            )
        }
    }
}
