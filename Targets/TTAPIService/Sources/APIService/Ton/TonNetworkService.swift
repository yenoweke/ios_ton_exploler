import Foundation
import Moya

public protocol TonNetworkService {
    func fetchTransactions(address: String, from transaction: TransactionID?) async throws -> [GetTransactionsResponse.TxItem]
    func fetchWalletInformation(_ address: String) async throws  -> GetWalletInformationResponse
//    func fetchAddressInformation(_ address: TONAddress) async throws  -> GetAddressInfoResponse
}

extension BaseService<TonEndpoints>: TonNetworkService {
    public func fetchTransactions(address: String, from transaction: TransactionID? = nil) async throws -> [GetTransactionsResponse.TxItem] {
        let logicalTime: Int? = transaction.map({ Int($0.lt) ?? 0 })
        let request = GetTransactionRequest(
                address: address,
                limit: 50,
                lt: logicalTime,
                hash: transaction?.hash
        )

        let response: GetTransactionsResponse = try await self.request(TonEndpoints.getTransactions(request))
        return response.result
    }

    public func fetchWalletInformation(_ address: String) async throws  -> GetWalletInformationResponse {
        let endpoint = TonEndpoints.getWalletInformation(address: address)
        return try await self.request(endpoint)
    }
        
//    func fetchAddressInformation(_ address: TONAddress) async throws  -> GetAddressInfoResponse {
//        let endpoint = TonEndpoints.getAddressInformation(address: address)
//        return try await self.request(endpoint)
//    }
}
