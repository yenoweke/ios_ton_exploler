import SwiftUI
import TonTransactionsUI

final class EditAddressModuleContainer: ModuleContainer  {
    private struct ContainerView: View {
        @ObservedObject var state: EditAddressViewState
        let interactor: EditAddressInteractorInput

        var body: some View {
            EditAddressView(
                    fullAddress: state.fullAddress,
                    address: Binding(get: { state.address }, set: interactor.update),
                    onSubmit: interactor.save
            )
        }
    }

    static func assemble(_ dependencies: EditAddressDependencies) -> EditAddressModuleContainer {
        let (view, router) = Self.assembleView(dependencies: dependencies)
        let viewController = HostingViewController(rootView: view)
        router.set(rootViewController: viewController)
        return EditAddressModuleContainer(viewControllerToShow: viewController, router: router)
    }

    private static func assembleView(dependencies: EditAddressDependencies) -> (view: ContainerView, router: BaseRouter) {
        let state = EditAddressViewState(fullAddress: dependencies.address)
        let router = EditAddressRouter(dependencies: dependencies)
        let interactor = EditAddressInteractor(output: state, router: router, fullAddress: dependencies.address, storage: dependencies.storage, moduleOutput: dependencies.moduleOutput)
        let view = ContainerView(state: state, interactor: interactor)
        return (view, router)
    }
}
