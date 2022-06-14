//
//  TransactionID.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 14.06.2022.
//

import Foundation

struct TransactionID: Codable, Equatable {
    let type: TransactionIDType
    let lt, hash: String

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case lt, hash
    }
}

enum TransactionIDType: String, Codable {
    case internalTransactionID = "internal.transactionId"
}
