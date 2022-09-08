//
// Created by Dmitrii Chikovinskii on 06.06.2022.
//

import Foundation
import Moya

public struct TONApiProvider {
    let baseURL: String
    let headers: [String: String]
    
    init(baseURL: String, headers: [String: String]) {
        self.baseURL = baseURL
        self.headers = headers
    }
}

public extension TONApiProvider {
    static func toncenter(apiKey: String) -> TONApiProvider {
        TONApiProvider(
            baseURL: "https://toncenter.com/api/v2/",
            headers: ["X-API-Key": apiKey]
        )
    }
}

public final class TonService {
    private let provider: MoyaProvider<APIService>
    
    public init(apiProvider: TONApiProvider) {
        let plugins: [PluginType] = [
//            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)),
            HeadersPlugin(headers: apiProvider.headers),
            TransactionsDomainPlugin(domain: { apiProvider.baseURL })
        ]
        self.provider = MoyaProvider<APIService>(plugins: plugins)
    }
    
    public func fetchTransactions(address: String, from transaction: TransactionID? = nil) async throws -> [GetTransactionsResponse.TxItem] {
        let logicalTime: Int? = transaction.map({ Int($0.lt) ?? 0 })
        let request = GetTransactionRequest(
                address: address,
                limit: 50,
                lt: logicalTime,
                hash: transaction?.hash
        )

        let response: GetTransactionsResponse = try await self.request(APIService.getTransactions(request))
        return response.result
    }

    public func fetchWalletInformation(_ address: String) async throws  -> GetWalletInformationResponse {
        let endpoint = APIService.getWalletInformation(address: address)
        return try await self.request(endpoint)
    }
        
    func fetchAddressInformation(_ address: TONAddress) async throws  -> GetAddressInfoResponse {
        let endpoint = APIService.getAddressInformation(address: address)
        return try await self.request(endpoint)
    }

    private func request<Response: Decodable>(_ endpoint: APIService) async throws -> Response {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Response, Error>) in
            self.provider.request(endpoint) { result in
                switch result {
                case let .success(moyaResponse):
                    do {
                        let response = try moyaResponse.filterSuccessfulStatusCodes()
                        let data = try response.map(Response.self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
