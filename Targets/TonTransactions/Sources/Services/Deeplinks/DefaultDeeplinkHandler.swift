import Foundation
import TTDeeplinks

final class DefaultDeeplinkHandler: DeeplinkHandler {
    
    private let rootRouter: () -> Router?
    
    weak var serviceLocator: ServiceLocator!

    init(serviceLocator: ServiceLocator, rootRouter: @escaping () -> Router?) {
        self.serviceLocator = serviceLocator
        self.rootRouter = rootRouter
    }
    
    func handle(_ deeplink: Deeplink) -> Bool {
        switch deeplink.path {
        case .account(let account):
            self.showTransactions(for: account)
            return true
        case .unkonwn:
            // TODO: may be show alert or log it
            return false
        }
    }
    
    private func showTransactions(for address: String) {
        guard let router = self.rootRouter()?.topRouter else { assertionFailure(); return }
        let container = MsgListModuleContainer.assemble(self.makeMsgListDependencies(address: address))
        router.push(container)
    }

    private func makeMsgListDependencies(address: String) -> MsgListDependencies {
        MsgListDependenciesImpl(serviceLocator: self.serviceLocator, address: address)
    }
}
