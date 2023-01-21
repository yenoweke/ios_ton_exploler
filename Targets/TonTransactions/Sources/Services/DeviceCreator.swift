import Foundation
import TTAPIService
import TonTransactionsKit

protocol DeviceCreator {
    func create() async throws
}

final class DeviceCreatorImpl: DeviceCreator {
    @UserDefault(.deviceCreated, defaultValue: false)
    private var deviceCreated: Bool
    
    private let network: DeviceNetworkService
    
    init(network: DeviceNetworkService) {
        self.network = network
    }
    
    func create() async throws {
        try await network.create(deviceID: Device.identifier, signature: Device.signature)
    }
}

extension DeviceCreatorImpl: Preparer {
    func prepare() async throws -> PreparerResult {
        if self.deviceCreated {
            return .success
        }

        do {
            try await create()
            self.deviceCreated = true
            return .success
        }
        catch {
            throw PreparerError.retryRequired
        }
    }
}

private extension UserDefaultKey {
    static let deviceCreated: UserDefaultKey = "TT_DeviceCreated.Key"
}
