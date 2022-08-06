//
//  WatchlistStorage.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 22.06.2022.
//

import Foundation

final class WatchlistStorage: ObservableObject {

    private let knownNamesStorage: KnownNamesStorage
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
    
    init(knownNamesStorage: KnownNamesStorage) {
        self.knownNamesStorage = knownNamesStorage
        self.addresses = self.storage
        self.shortNames = self.shortNameByAddress
    }
    
    func isAdded(_ address: TONAddress) -> Bool {
        self.storage.contains(address.description)
    }
    
    func add(_ address: TONAddress) {
        var stor = self.storage
        stor.append(address.description)
        self.storage = stor
    }
    
    func remove(_ address: TONAddress) {
        self.storage.removeAll(where: { $0 == address.description})
    }
    
    func shortName(for address: String) -> String {
        if let name = self.knownNamesStorage.name(for: address) {
            return name
        }
        return self.shortNames[address, default: address.prefix(4) + "..." + address.suffix(4) ]
    }
    
    func set(shortName: String, for address: String) {
        self.shortNameByAddress[address] = shortName
    }
}

private extension UserDefaultKey {
    static let watchlist: UserDefaultKey = "WatchlistStorage.Key"
    static let shortNameByAddress: UserDefaultKey = "ShortNameByAddress.Key"
}
