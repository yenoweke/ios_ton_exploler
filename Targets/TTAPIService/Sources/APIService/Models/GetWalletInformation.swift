// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getWalletInformationResponse = try? newJSONDecoder().decode(GetWalletInformationResponse.self, from: jsonData)

import Foundation

// MARK: - GetWalletInformationResponse
public struct GetWalletInformationResponse: Codable {
    let ok: Bool
    public let result: Result
}

extension GetWalletInformationResponse {
    // MARK: - Result
    public struct Result: Codable {
        public let wallet: Bool
        public let balance: Toncoin
        public let accountState: String
        public let lastTransactionID: TransactionID

        enum CodingKeys: String, CodingKey {
            case wallet, balance
            case accountState = "account_state"
            case lastTransactionID = "last_transaction_id"
        }
    }
}
