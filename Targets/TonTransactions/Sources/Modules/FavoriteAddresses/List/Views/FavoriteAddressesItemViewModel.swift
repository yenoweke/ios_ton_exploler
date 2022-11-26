import Foundation

struct FavoriteAddressesItemViewModel: Equatable {
    let address: String
    let shortName: String

    init(address: String, shortName: String) {
        self.address = address

        // TODO: Add validation
        if shortName.isEmpty {
            self.shortName = address.count > 8 ? address.prefix(3) + "..." + address.suffix(3) : address
        }
        else {
            self.shortName = shortName
        }
    }

    func shortName(_ text: String) -> FavoriteAddressesItemViewModel {
        FavoriteAddressesItemViewModel(
                address: self.address,
                shortName: text
        )
    }

    static func mock(addr: String) -> Self {
        FavoriteAddressesItemViewModel(
                address: addr,
                shortName: "shortName"
        )
    }
}
