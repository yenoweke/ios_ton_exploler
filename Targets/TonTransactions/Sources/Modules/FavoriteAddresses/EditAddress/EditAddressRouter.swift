import Foundation

final class EditAddressRouter: BaseRouter, EditAddressRouterInput {
    private let dependencies: EditAddressDependencies

    init(dependencies: EditAddressDependencies) {
        self.dependencies = dependencies
    }
}
