import Foundation

public protocol DeviceNetworkService {
    func create(deviceID: UUID, signature: String) async throws
}

extension BaseService<DeviceEndpoins>: DeviceNetworkService {
    func create(deviceID: UUID, signature: String) async throws {
        let endpoint = DeviceEndpoins.create(deviceID: deviceID, signature: signature)
        try await self.request(endpoint)
    }
}
