import SwiftUI

final class WalletCardModuleContainer: ModuleContainer  {
    struct ContainerView: View {
        @ObservedObject var state: WalletCardViewState
        let interactor: WalletCardInteractorInput

        var body: some View {
            LoadingView(
                    state: self.$state.wallet,
                    startInitialLoading: self.interactor.loadWalletInfo,
                    placeholderView: {
                        WalletCardView(wallet: self.state.placeholder)
                                .redacted(reason: .placeholder)
                    },
                    loadedView: { wallet in
                        WalletCardView(wallet: wallet)
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

    static func assembleView(dependencies: WalletCardDependencies) -> (view: ContainerView, router: BaseRouter) {
        let state = WalletCardViewState(address: dependencies.address)
        let stateModifier = WalletCardStateModifier(state: state)
        let router = WalletCardRouter(dependencies: dependencies)
        let interactor = WalletCardInteractor(
                output: stateModifier,
                router: router,
                walletInfoProvider: dependencies.walletInfoProvider,
                address: dependencies.address
        )
        let view = ContainerView(state: state, interactor: interactor)
        return (view, router)
    }
}
