import Foundation
import Combine

struct WatchlistItem {
    let address: String
    let shortName: String
}

final class FavoriteAddressesInteractor {
    private weak var output: FavoriteAddressesInteractorOutput?
    private let router: FavoriteAddressesRouterInput
    private let watchlistStorage: WatchlistStorage
    private var cancellable: Set<AnyCancellable> = []

    init(output: FavoriteAddressesInteractorOutput, router: FavoriteAddressesRouterInput, watchlistStorage: WatchlistStorage) {
        self.output = output
        self.router = router
        self.watchlistStorage = watchlistStorage

        watchlistStorage.$shortNames
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    self?.prepareList()
                }
                .store(in: &self.cancellable)
    }
}

extension FavoriteAddressesInteractor: FavoriteAddressesInteractorInput {
    func prepareList() {
        let list = watchlistStorage.addresses.map { addr in
            WatchlistItem(address: addr, shortName: watchlistStorage.shortName(for: addr))
        }
        self.output?.didUpdate(list)
    }

    func show(_ address: String) {
        self.router.showTransactions(for: address)
    }

    func edit(_ address: String) {
        self.router.showEdit(address)
    }

    func remove(_ address: String) {
        self.watchlistStorage.remove(address)
        self.prepareList()
    }
}
