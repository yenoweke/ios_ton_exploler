import SwiftUI

final class AccountActionsModuleContainer: ModuleContainer  {
    struct ContainerView: View {
        @ObservedObject var state: AccountActionsViewState
        let interactor: AccountActionsInteractorInput

        var body: some View {
            AccountActionsView(
                    added: state.added,
                    subsribed: state.accountSubsribed,
                    loading: state.loading,
                    onTapAdd: interactor.toggleWatchlistForAddress,
                    onTapSubsribe: interactor.toggleAccountSubscription
            )
            .onAppear(perform: interactor.updateIfNeeded)
            .alert(isPresented: self.$state.showPushPermissionDiniedAlert) {
                Alert(
                    title: Text(L10n.Account.PushPermission.ToSettings.title),
                    message: Text(L10n.Account.PushPermission.ToSettings.message),
                    primaryButton: .default(Text(L10n.Account.PushPermission.ToSettings.button)) {
                        self.interactor.needToEnablePushPermissions()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    static func assembleView(dependencies: AccountActionsDependencies) -> (view: ContainerView, router: BaseRouter) {
        let state = AccountActionsViewState()
        let router = AccountActionsRouter(dependencies: dependencies)
        let interactor = AccountActionsInteractor(
            output: state,
            router: router,
            watchlistStorage: dependencies.watchlistStorage,
            accountSubsriptonManager: dependencies.accountSubsriptonManager,
            pushManager: dependencies.pushManager,
            address: dependencies.address
        )
        let view = ContainerView(state: state, interactor: interactor)
        return (view, router)
    }
}
