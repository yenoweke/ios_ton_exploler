//
// Created by Dmitrii Chikovinskii on 06.06.2022.
//

import Foundation
import Moya

final class TonService {
    private let provider = MoyaProvider<APIService>(
            plugins: [
//                NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)),
                APIHeadersPlugin(),
                TransactionsDomainPlugin()
            ]
    )
    
    func fetchTransactions(address: TONAddress, from transaction: TransactionID? = nil) async throws -> [GetTransactionsResponse.Result] {
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

    func fetchWalletInformation(_ address: TONAddress) async throws  -> GetWalletInformationResponse {
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
