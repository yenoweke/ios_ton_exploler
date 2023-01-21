import Foundation
import UIKit

final class AccountActionsRouter: BaseRouter, AccountActionsRouterInput {
    private let dependencies: AccountActionsDependencies

    init(dependencies: AccountActionsDependencies) {
        self.dependencies = dependencies
    }

    func showSystemSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
        }
    }
}
