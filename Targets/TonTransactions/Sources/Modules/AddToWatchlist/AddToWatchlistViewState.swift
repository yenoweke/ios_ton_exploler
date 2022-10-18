import Foundation

final class AddToWatchlistViewState: ObservableObject {
    @Published private(set) var added: Bool = false
    init() {
    }
}

extension AddToWatchlistViewState: AddToWatchlistInteractorOutput {
    func itemAdded() {
        self.added = true
    }

    func itemRemoved() {
        self.added = false
    }
}
