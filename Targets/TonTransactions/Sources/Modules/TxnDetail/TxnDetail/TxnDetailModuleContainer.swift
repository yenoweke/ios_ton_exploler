import SwiftUI

final class TxnDetailModuleContainer: ModuleContainer  {
    struct ContainerView: View {
        @ObservedObject var state: TxnDetailViewState
        let interactor: TxnDetailInteractorInput

        var body: some View {
            TxnDetailView(vm: MockTransactionDetailsViewModel())
        }
    }

    static func assemble(_ dependencies: TxnDetailDependencies) -> TxnDetailModuleContainer {
        let (view, router) = Self.assembleView(dependencies: dependencies)
        let viewController = HostingViewController(rootView: view)

        router.navigationControllerProvider = { [weak viewController] in
            viewController?.navigationController
        }
        router.presentingViewControllerProvider = { [weak viewController] in
            viewController
        }
        return TxnDetailModuleContainer(viewControllerToShow: viewController, router: router)
    }

    static func assembleView(dependencies: TxnDetailDependencies) -> (view: ContainerView, router: BaseRouter) {
        let state = TxnDetailViewState()
        let router = TxnDetailRouter(dependencies: dependencies)
        let interactor = TxnDetailInteractor(output: state, router: router)
        let view = ContainerView(state: state, interactor: interactor)
        return (view, router)
    }
}
