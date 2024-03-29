import Foundation
import TonTransactionsKit

final class WatchlistStorage: ObservableObject {

    @UserDefault(.watchlist, defaultValue: [])
    private var storage: [String] {
        didSet {
            self.addresses = self.storage
        }
    }

    @UserDefault(.shortNameByAddress, defaultValue: [:])
    private var shortNameByAddress: [String: String] {
        didSet {
            self.shortNames = self.shortNameByAddress
        }
    }

    @Published private(set) var addresses: [String] = []
    @Published private(set) var shortNames: [String: String] = [:]

    init() {
        self.addresses = self.storage
        self.shortNames = self.shortNameByAddress
    }

    func isAdded(_ address: String) -> Bool {
        self.storage.contains(address.description)
    }

    func add(_ address: String) {
        var stor = self.storage
        stor.append(address.description)
        self.storage = stor
    }

    func remove(_ address: String) {
        self.storage.removeAll(where: { $0 == address.description})
    }

    func shortName(for address: String) -> String {
        self.shortNames[address, default: address.prefix(4) + "..." + address.suffix(4) ]
    }

    func set(shortName: String, for address: String) {
        self.shortNameByAddress[address] = shortName
    }
}

private extension UserDefaultKey {
    static let watchlist: UserDefaultKey = "WatchlistStorage.Key"
    static let shortNameByAddress: UserDefaultKey = "ShortNameByAddress.Key"
}
