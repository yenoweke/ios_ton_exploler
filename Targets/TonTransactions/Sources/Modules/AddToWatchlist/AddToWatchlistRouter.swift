import Foundation

final class AddToWatchlistRouter: BaseRouter, AddToWatchlistRouterInput {
    private let dependencies: AddToWatchlistDependencies

    init(dependencies: AddToWatchlistDependencies) {
        self.dependencies = dependencies
    }
}
