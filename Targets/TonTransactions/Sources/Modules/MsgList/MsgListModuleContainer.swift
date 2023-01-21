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
                            self.interactor.onTap(vm.txnID)
                        })
                }
                .onAppear {
                    if self.appearedOnce { return }
                    self.interactor.initialLoad()
                    self.appearedOnce = true
                }
                .sheet(
                    isPresented: self.$state.showFilter,
                    content: {
                        MessageFilterView(
                            selectedMsgType: self.state.filter.selectedMsgType,
                            minValue: self.state.filter.minValue,
                            maxValue: self.state.filter.maxValue,
                            onTapApply: { filter in
                                interactor.apply(filter: filter)
                            },
                            onTapReset: {
                                interactor.apply(filter: nil)
                            }
                        )
                    })
            }
        }
    }
    
    static func assemble(_ dependencies: MsgListDependencies) -> MsgListModuleContainer {
        let (view, router, barItem) = Self.assembleView(dependencies: dependencies)
        let viewController = HostingViewController(rootView: view)
        viewController.title = L10n.Transaction.List.title
        viewController.navigationItem.rightBarButtonItem = barItem
        router.set(rootViewController: viewController)
        return MsgListModuleContainer(viewControllerToShow: viewController, router: router)
    }
    
    static func assembleView(dependencies: MsgListDependencies) -> (view: some View, router: BaseRouter, barItem: UIBarButtonItem?) {
        let state = MsgListViewState()
        let stateModifier = MsgListViewStateModifier(state: state)
        let router = MsgListRouter(dependencies: dependencies)
        let interactor = MsgListInteractor(
            output: stateModifier,
            router: router,
            itemsProvider: dependencies.itemsProvider
        )
        
        let (walletCardView, walletCardRouter) = WalletCardModuleContainer.assembleView(dependencies: dependencies.makeWalletCardDependencies())
        router.addSubRouter(walletCardRouter)
        
        let (actionsView, _) = AccountActionsModuleContainer.assembleView(dependencies: dependencies.makeAccountActionsDependencies())
        
        let view = ContainerView(state: state, interactor: interactor) {
            VStack {
                walletCardView
                actionsView
            }
        }
        
        let barItem: UIBarButtonItem?
        if let filterImage = UIImage(systemName: "line.3.horizontal.decrease.circle") {
            barItem = BlockBarButtonItem.item(with: filterImage, handler: { [weak state] in
                state?.showFilter = true
            })
        }
        else {
            assertionFailure("why image not found? investigate")
            barItem = nil
        }
        return (view, router, barItem)
    }
}
