import Foundation
import TTAPIService

final class ServiceLocator {
    
    let tonNetworkService: TonNetworkService
    let msgsStorage: MsgStorage
    let txnsStorage: TxnsStorage
    let watchlistStorage: WatchlistStorage
    let accountSubsriptonManager: AccountSubsriptonManager
    let pushManager: PushManager

    init(pushManager: PushManager) {
        self.pushManager = pushManager
        self.tonNetworkService = Self.makeTonService()
        self.msgsStorage = MsgsInMemoryStorage()
        self.txnsStorage = TxnsInMemoryStorage()
        self.watchlistStorage = WatchlistStorage()
        self.accountSubsriptonManager = AccountSubsriptonManagerImpl(networkService: Self.makeAccountSubsriptonNetworkService())
    }
    
    func makeDeviceNetworkService() -> DeviceNetworkService {
        let apiProvider = APIBaseInfoProvider.ttBackend(baseURL: Configuration.ttBackendURL, signature: nil)
        return NetworkServiceFactory.makeDeviceNetworkService(apiProvider: apiProvider)
    }
}

extension ServiceLocator {
    static func makePushSubsriptionService() -> PushSubscriptionNetworkService {
        let apiProvider = APIBaseInfoProvider.ttBackend(baseURL: Configuration.ttBackendURL, signature: Device.signature)
        return NetworkServiceFactory.makePushSubscriptionService(apiProvider: apiProvider)
    }
}

private extension ServiceLocator {
    static func makeTonService() -> TonNetworkService {
        let apiProvider = APIBaseInfoProvider.toncenter(apiKey: Configuration.toncenterAPIKey)
        return NetworkServiceFactory.makeTonService(apiProvider: apiProvider)
    }
    
    static func makeAccountSubsriptonNetworkService() -> AccountSubsriptonNetworkService {
        let apiProvider = APIBaseInfoProvider.ttBackend(baseURL: Configuration.ttBackendURL, signature: Device.signature)
        return NetworkServiceFactory.makeAccountSubsriptonNetworkService(apiProvider: apiProvider)
    }
}
