import Foundation
import TTAPIService

protocol AccountSubsriptonManager {
    func isSubsribed(account: String) async throws -> Bool
    func subsribe(account: String) async throws
    func unsubsribe(account: String) async throws
}

final class AccountSubsriptonManagerImpl: AccountSubsriptonManager {
    
    private let networkService: AccountSubsriptonNetworkService
    
    private var subsriptionList: [String] = []
    private var didLoadList = false
    
    init(networkService: AccountSubsriptonNetworkService) {
        self.networkService = networkService
    }
    
    func isSubsribed(account: String) async throws -> Bool {
        if didLoadList {
            return self.subsriptionList.contains(account)
        }
        else {
            // TODO: handle error response
            let list = try? await networkService.list(deviceID: Device.identifier)
            self.subsriptionList = list?.items.map(\.account) ?? []
            self.didLoadList = true

            return try await self.isSubsribed(account: account)
        }
    }
    
    func subsribe(account: String) async throws {
        try await networkService.subscribe(deviceID: Device.identifier, account: account)
        subsriptionList.append(account)
    }
    
    func unsubsribe(account: String) async throws {
        try await networkService.unsubscribe(deviceID: Device.identifier, account: account)
        subsriptionList.removeAll(where: { $0 == account })
    }
}
