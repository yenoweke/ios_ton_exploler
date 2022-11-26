import SwiftUI

final class FavoriteAddressesModuleContainer: ModuleContainer  {
    private struct ContainerView: View {
        @ObservedObject var state: FavoriteAddressesViewState
        let interactor: FavoriteAddressesInteractorInput

        var body: some View {
            FavoriteAddressesView(
                    viewModels: self.state.viewModels,
                    actions: actions
            )
            .onAppear(perform: interactor.prepareList)
        }

        private var actions: FavoriteAddressActions {
            FavoriteAddressActions(
                    onTap: { addr in
                        interactor.show(addr)
                    },
                    onTapCopy: { addr in
                        UIPasteboard.general.string = addr
                    },
                    onTapEdit: { addr in
                        interactor.edit(addr)
                    },
                    onTapRemove: { addr in
                        interactor.remove(addr)
                    }
            )
        }
    }

    static func assemble(_ dependencies: FavoriteAddressesDependencies) -> FavoriteAddressesModuleContainer {
        let (view, router) = Self.assembleView(dependencies: dependencies)
        let viewController = HostingViewController(rootView: view)
        router.set(rootViewController: viewController)
        viewController.title = L10n.Watchlist.title
        return FavoriteAddressesModuleContainer(viewControllerToShow: viewController, router: router)
    }

    private static func assembleView(dependencies: FavoriteAddressesDependencies) -> (view: ContainerView, router: BaseRouter) {
        let state = FavoriteAddressesViewState()
        let router = FavoriteAddressesRouter(dependencies: dependencies)
        let interactor = FavoriteAddressesInteractor(output: state, router: router, watchlistStorage: dependencies.watchlistStorage)
        let view = ContainerView(state: state, interactor: interactor)
        return (view, router)
    }
}
