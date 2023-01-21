import Foundation
import Moya

public protocol AccountSubsriptonNetworkService {
    func subscribe(deviceID: UUID, account: String) async throws
    func unsubscribe(deviceID: UUID, account: String) async throws
    func list(deviceID: UUID) async throws -> AccountSubsriptonResponse.List
}

extension BaseService<DeviceEndpoins>: AccountSubsriptonNetworkService {
    func subscribe(deviceID: UUID, account: String) async throws {
        let endpoint = DeviceEndpoins.accountSubscribe(deviceID: deviceID, account: account)
        try await request(endpoint)
    }
    
    func unsubscribe(deviceID: UUID, account: String) async throws {
        let endpoint = DeviceEndpoins.accountUnsubscribe(deviceID: deviceID, account: account)
        try await request(endpoint)
    }
    
    func list(deviceID: UUID) async throws -> AccountSubsriptonResponse.List {
        let endpoint = DeviceEndpoins.accountsSubscribed(deviceID: deviceID)
        return try await request(endpoint)
    }
}

public enum AccountSubsriptonResponse {
    public struct List: Decodable {
        public struct Item: Decodable {
            public let account: String
        }

        public let items: [Item]
    }
}
