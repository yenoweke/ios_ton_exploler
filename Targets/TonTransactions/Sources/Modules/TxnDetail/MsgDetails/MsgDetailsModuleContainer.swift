import SwiftUI
import TonTransactionsUI

final class MsgDetailsModuleContainer: ModuleContainer  {
    struct ContainerView: View {
        @ObservedObject var state: MsgDetailsViewState
        let interactor: MsgDetailsInteractorInput

        var body: some View {
            Group {
                if let vm = self.state.viewModel {
                    MsgDetailsView(
                            vm: vm,
                            onTapAddress: { addr in
                                self.interactor.onTap(addr)
                            }
                    )
                }
                else {
                    Text("msg not found")
                }
            }
            .onAppear {
                self.interactor.load()
            }
        }
    }

    static func assemble(_ dependencies: MsgDetailsDependencies) -> MsgDetailsModuleContainer {
        let (view, router) = Self.assembleView(dependencies: dependencies)
        let viewController = HostingViewController(rootView: view)

        router.navigationControllerProvider = { [weak viewController] in
            viewController?.navigationController
        }
        router.presentingViewControllerProvider = { [weak viewController] in
            viewController
        }
        return MsgDetailsModuleContainer(viewControllerToShow: viewController, router: router)
    }

    static func assembleView(dependencies: MsgDetailsDependencies) -> (view: ContainerView, router: BaseRouter) {
        let state = MsgDetailsViewState()
        let router = MsgDetailsRouter(dependencies: dependencies)
        let interactor = MsgDetailsInteractor(
                output: state,
                router: router,
                msgStorage: dependencies.msgStorage,
                msgID: dependencies.msgID
        )
        let view = ContainerView(state: state, interactor: interactor)
        return (view, router)
    }
}
