import Foundation
import Moya

public enum NetworkServiceFactory {
    public static func makeTonService(apiProvider: APIBaseInfoProvider) -> TonNetworkService {
        let plugins: [PluginType] = Self.makePlugins(with: apiProvider)
        return BaseService<TonEndpoints>(apiProvider: apiProvider, plugins: plugins)
    }

    public static func makePushSubscriptionService(apiProvider: APIBaseInfoProvider) -> PushSubscriptionNetworkService {
        let plugins: [PluginType] = Self.makePlugins(with: apiProvider, loggerEnabled: true)
        return BaseService<DeviceEndpoins>(apiProvider: apiProvider, plugins: plugins)
    }
    
    public static func makeAccountSubsriptonNetworkService(apiProvider: APIBaseInfoProvider) -> AccountSubsriptonNetworkService {
        let plugins: [PluginType] = Self.makePlugins(with: apiProvider)
        return BaseService<DeviceEndpoins>(apiProvider: apiProvider, plugins: plugins)
    }
    
    public static func makeDeviceNetworkService(apiProvider: APIBaseInfoProvider) -> DeviceNetworkService {
        let plugins: [PluginType] = Self.makePlugins(with: apiProvider)
        return BaseService<DeviceEndpoins>(apiProvider: apiProvider, plugins: plugins)
    }
}

private extension NetworkServiceFactory {
    static func makePlugins(with apiProvider: APIBaseInfoProvider, loggerEnabled: Bool = false) -> [PluginType] {
        var plugins: [PluginType] = [
            HeadersPlugin(headers: apiProvider.headers),
            ReplaceDomainPlugin(domain: { apiProvider.baseURL })
        ]
        if loggerEnabled {
            plugins.append(NetworkLoggerPlugin(configuration: .init(logOptions: .formatRequestAscURL)))
        }
        return plugins
    }
}
