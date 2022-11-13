import Foundation

final class MessageFilterRouter: BaseRouter, MessageFilterRouterInput {
    private let dependencies: MessageFilterDependencies

    init(dependencies: MessageFilterDependencies) {
        self.dependencies = dependencies
    }
}
