import Foundation

public protocol PushSubscriptionNetworkService {
    func subscribe(deviceID: UUID, with token: String) async throws
    func unsubscribe(deviceID: UUID) async throws
    func pushDisabled(deviceID: UUID) async throws
}

extension BaseService<DeviceEndpoins>: PushSubscriptionNetworkService {
    func subscribe(deviceID: UUID, with token: String) async throws {
        let endpoint = DeviceEndpoins.pushSubsribe(deviceID: deviceID, token: token)
        try await self.request(endpoint)
    }
    
    func unsubscribe(deviceID: UUID) async throws {
        let endpoint = DeviceEndpoins.pushUnsubsribe(deviceID: deviceID)
        try await self.request(endpoint)
    }
    
    func pushDisabled(deviceID: UUID) async throws {
        let endpoint = DeviceEndpoins.pushDisabled(deviceID: deviceID)
        try await self.request(endpoint)
    }
}
