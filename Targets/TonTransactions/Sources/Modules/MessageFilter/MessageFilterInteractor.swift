import Foundation

final class MessageFilterInteractor: MessageFilterInteractorInput {
    private weak var output: MessageFilterInteractorOutput?
    private let router: MessageFilterRouterInput

    init(output: MessageFilterInteractorOutput, router: MessageFilterRouterInput) {
        self.output = output
        self.router = router
    }
}
