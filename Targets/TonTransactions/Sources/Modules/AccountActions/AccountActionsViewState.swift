import Foundation

final class AccountActionsViewState: ObservableObject {
    @Published private(set) var added: Bool = false
    @Published private(set) var accountSubsribed: Bool = false
    @Published private(set) var loading: Bool = true
    
    @Published var showPushPermissionDiniedAlert: Bool = false
    
    init() {
    }
}

extension AccountActionsViewState: AccountActionsInteractorOutput {
    func itemAdded() {
        self.added = true
    }

    func itemRemoved() {
        self.added = false
    }
    
    func subsribed() {
        self.accountSubsribed = true
    }
    
    func unsubsribed() {
        self.accountSubsribed = false
    }
    
    func didLoadInitial() {
        self.loading = false
    }
    
    func pushPermissionDinied() {
        self.showPushPermissionDiniedAlert = true
    }
}
