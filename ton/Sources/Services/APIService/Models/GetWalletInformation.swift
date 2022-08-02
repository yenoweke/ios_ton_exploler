// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getWalletInformationResponse = try? newJSONDecoder().decode(GetWalletInformationResponse.self, from: jsonData)

import Foundation

// MARK: - GetWalletInformationResponse
struct GetWalletInformationResponse: Codable {
    let ok: Bool
    let result: Result
}

extension GetWalletInformationResponse {
    // MARK: - Result
    struct Result: Codable {
        let wallet: Bool
        let balance: Toncoin
        let accountState: String
        let lastTransactionID: TransactionID

        enum CodingKeys: String, CodingKey {
            case wallet, balance
            case accountState = "account_state"
            case lastTransactionID = "last_transaction_id"
        }
    }
}
