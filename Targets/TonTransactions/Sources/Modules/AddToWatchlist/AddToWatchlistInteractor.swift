import Foundation

final class AddToWatchlistInteractor: AddToWatchlistInteractorInput {
    private weak var output: AddToWatchlistInteractorOutput?
    private let router: AddToWatchlistRouterInput
    private let watchlistStorage: WatchlistStorage
    private let address: String
    private var itemAlreadyInStorage: Bool?

    init(output: AddToWatchlistInteractorOutput, router: AddToWatchlistRouterInput, watchlistStorage: WatchlistStorage, address: String) {
        self.output = output
        self.router = router
        self.watchlistStorage = watchlistStorage
        self.address = address
    }

    func updateIfNeeded() {
        let inStorage = watchlistStorage.isAdded(self.address)
        if inStorage == self.itemAlreadyInStorage { return }

        if inStorage {
            self.output?.itemAdded()
        }
        else {
            self.output?.itemRemoved()
        }
        self.itemAlreadyInStorage = inStorage
    }

    func toggleWatchlistForAddress() {
        if watchlistStorage.isAdded(self.address) {
            self.watchlistStorage.remove(self.address)
        }
        else {
            self.watchlistStorage.add(self.address)
        }
        self.updateIfNeeded()
    }
}
