import Foundation

final class FavoriteAddressesViewState: ObservableObject {
    @Published var viewModels: [FavoriteAddressesItemViewModel] = []

    init() {
        viewModels = [
            .mock(addr: "first"),
            .mock(addr: "second"),
            .mock(addr: "third"),
            .mock(addr: "fourth")
        ]
    }
}

extension FavoriteAddressesViewState: FavoriteAddressesInteractorOutput {
    func didUpdate(_ items: [WatchlistItem]) {
        self.viewModels = items.map { item -> FavoriteAddressesItemViewModel in
            FavoriteAddressesItemViewModel(
                    address: item.address,
                    shortName: item.shortName
            )
        }
    }
}
