import SwiftUI

final class AddToWatchlistModuleContainer: ModuleContainer  {
    struct ContainerView: View {
        @ObservedObject var state: AddToWatchlistViewState
        let interactor: AddToWatchlistInteractorInput

        var body: some View {
            AddToWatchlistView(
                    added: state.added,
                    onTap: interactor.toggleWatchlistForAddress
            )
            .onAppear(perform: interactor.updateIfNeeded)
        }
    }

    static func assemble(_ dependencies: AddToWatchlistDependencies) -> AddToWatchlistModuleContainer {
        let (view, router) = Self.assembleView(dependencies: dependencies)
        let viewController = HostingViewController(rootView: view)

        router.navigationControllerProvider = { [weak viewController] in
            viewController?.navigationController
        }
        router.presentingViewControllerProvider = { [weak viewController] in
            viewController
        }
        return AddToWatchlistModuleContainer(viewControllerToShow: viewController, router: router)
    }

    static func assembleView(dependencies: AddToWatchlistDependencies) -> (view: ContainerView, router: BaseRouter) {
        let state = AddToWatchlistViewState()
        let router = AddToWatchlistRouter(dependencies: dependencies)
        let interactor = AddToWatchlistInteractor(output: state, router: router, watchlistStorage: dependencies.watchlistStorage, address: dependencies.address)
        let view = ContainerView(state: state, interactor: interactor)
        return (view, router)
    }
}
