import SwiftUI

final class MsgListModuleContainer: ModuleContainer  {
    struct ContainerView<TopView: View>: View {
        @ObservedObject var state: MsgListViewState
        let interactor: MsgListInteractorInput
        let topView: () -> TopView

        @State private var appearedOnce: Bool = false

        var body: some View {
            ScrollView {
                LazyVStack(spacing: 16.0) {
                    self.topView()
                    MsgListView(
                            initialLoading: self.state.listState.initialLoading,
                            items: self.state.listState.elements,
                            hasNextPage: self.state.listState.hasNextPage,
                            loadingNextPage: self.state.listState.loadingNextPage,
                            error: nil,
                            onShowLastElement: self.interactor.loadNextPage,
                            onTap: { vm in
                                self.interactor.onTap(vm.id)
                            })
                }
                .onAppear {
                    if self.appearedOnce { return }
                    self.interactor.initialLoad()
                    self.appearedOnce = true
                }
            }
        }
    }

    static func assemble(_ dependencies: MsgListDependencies) -> MsgListModuleContainer {
        let (view, router) = Self.assembleView(dependencies: dependencies)
        let viewController = HostingViewController(rootView: view)

        router.navigationControllerProvider = { [weak viewController] in
            viewController?.navigationController
        }
        router.presentingViewControllerProvider = { [weak viewController] in
            viewController
        }
        return MsgListModuleContainer(viewControllerToShow: viewController, router: router)
    }

    static func assembleView(dependencies: MsgListDependencies) -> (view: some View, router: BaseRouter) {
        let state = MsgListViewState()
        let stateModifier = MsgListViewStateModifier(state: state)
        let router = MsgListRouter(dependencies: dependencies)
        let interactor = MsgListInteractor(
                output: stateModifier,
                router: router,
                itemsProvider: dependencies.itemsProvider
        )

        let (topView, _) = WalletCardModuleContainer.assembleView(dependencies: dependencies.makeWalletCardDependencies())

//        wallRouter.navigationControllerProvider = { [weak router] in
//            routere4§qe4  ?.navigationController
//        }
//        wallRouter.presentingViewControllerProvider = { [weak router] in
//            router?.presentingViewControllerProvider
//        }

        let view = ContainerView(state: state, interactor: interactor) {
            topView
        }
        return (view, router)
    }
}
