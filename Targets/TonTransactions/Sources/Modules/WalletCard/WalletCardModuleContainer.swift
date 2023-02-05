import SwiftUI
import TonTransactionsUI

final class WalletCardModuleContainer: ModuleContainer  {
    struct ContainerView<AddToWatchlistView: View>: View {
        @ObservedObject var state: WalletCardViewState
        let interactor: WalletCardInteractorInput
        let addToWatchlistView: () -> AddToWatchlistView

        var body: some View {
            LoadingView(
                    state: self.$state.wallet,
                    startInitialLoading: self.interactor.loadWalletInfo,
                    placeholderView: {
                        WalletCardView(wallet: self.state.placeholder, addToWatchlistView: { EmptyView() })
                                .redacted(reason: .placeholder)
                    },
                    loadedView: { wallet in
                        WalletCardView(wallet: wallet, addToWatchlistView: addToWatchlistView)
                    },
                    errorView: { errorViewModel in
                        Text(errorViewModel.title)
                    }
            )
        }
    }

    static func assemble(_ dependencies: WalletCardDependencies) -> ModuleContainer {
        let (view, router) = Self.assembleView(dependencies: dependencies)
        let viewController = HostingViewController(rootView: view)

        router.navigationControllerProvider = { [weak viewController] in
            viewController?.navigationController
        }
        router.presentingViewControllerProvider = { [weak viewController] in
            viewController
        }
        return WalletCardModuleContainer(viewControllerToShow: viewController, router: router)
    }

    static func assembleView(dependencies: WalletCardDependencies) -> (view: ContainerView<some View>, router: BaseRouter) {
        let state = WalletCardViewState(address: dependencies.address)
        let stateModifier = WalletCardStateModifier(state: state)
        let router = WalletCardRouter(dependencies: dependencies)
        let interactor = WalletCardInteractor(
                output: stateModifier,
                router: router,
                walletInfoProvider: dependencies.makeWalletInfoProvider(),
                address: dependencies.address
        )

        let view = ContainerView(state: state, interactor: interactor) {
            EmptyView()
        }
        return (view, router)
    }
}
