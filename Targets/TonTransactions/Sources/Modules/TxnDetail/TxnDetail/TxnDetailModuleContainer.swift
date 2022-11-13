import SwiftUI

final class TxnDetailModuleContainer: ModuleContainer  {
    struct ContainerView<MessageView: View>: View {
        @ObservedObject var state: TxnDetailViewState
        let interactor: TxnDetailInteractorInput
        let messageView: (_ messageID: String) -> MessageView

        var body: some View {
            if let vm = state.viewModel {
                TxnDetailView(
                        vm: vm,
                        messageView: messageView
                )
            } else {
                Color.clear
                        .onAppear {
                            self.interactor.load()
                        }
            }
        }
    }

    static func assemble(_ dependencies: TxnDetailDependencies) -> TxnDetailModuleContainer {
        let (view, router) = Self.assembleView(dependencies: dependencies)
        let viewController = HostingViewController(rootView: view)
        viewController.title = L10n.Transaction.Details.title
        router.set(rootViewController: viewController)
        return TxnDetailModuleContainer(viewControllerToShow: viewController, router: router)
    }

    static func assembleView(dependencies: TxnDetailDependencies) -> (view: ContainerView<MsgDetailsModuleContainer.ContainerView>, router: BaseRouter) {
        let state = TxnDetailViewState()
        let router = TxnDetailRouter(dependencies: dependencies)
        let interactor = TxnDetailInteractor(output: state, router: router, txnID: dependencies.txnID, txnsStorage: dependencies.txnsStorage)

        let view = ContainerView(state: state, interactor: interactor, messageView: { msgID -> MsgDetailsModuleContainer.ContainerView in
            let msgDetail = MsgDetailsModuleContainer.assembleView(dependencies: dependencies.makeMsgDetailsDependencies(for: msgID))
            router.addSubRouter(msgDetail.router)
            return msgDetail.view
        })
        return (view, router)
    }
}
