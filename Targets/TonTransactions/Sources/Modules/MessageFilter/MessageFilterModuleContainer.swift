import SwiftUI

final class MessageFilterModuleContainer: ModuleContainer  {
    private struct ContainerView: View {
        @ObservedObject var state: MessageFilterViewState
        let interactor: MessageFilterInteractorInput

        var body: some View {
            MessageFilterView(onTapApply: {_ in }, onTapReset: {})
        }
    }

    static func assemble(_ dependencies: MessageFilterDependencies) -> MessageFilterModuleContainer {
        let (view, router) = Self.assembleView(dependencies: dependencies)
        let viewController = HostingViewController(rootView: view)
        router.set(rootViewController: viewController)
        return MessageFilterModuleContainer(viewControllerToShow: viewController, router: router)
    }

    private static func assembleView(dependencies: MessageFilterDependencies) -> (view: ContainerView, router: BaseRouter) {
        let state = MessageFilterViewState()
        let router = MessageFilterRouter(dependencies: dependencies)
        let interactor = MessageFilterInteractor(output: state, router: router)
        let view = ContainerView(state: state, interactor: interactor)
        return (view, router)
    }
}
