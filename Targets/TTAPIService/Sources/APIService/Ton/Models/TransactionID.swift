//
//  TransactionID.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 14.06.2022.
//

import Foundation

public struct TransactionID: Codable, Equatable, Hashable {
    public let type: TransactionIDType
    public let lt, hash: String

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case lt, hash
    }
}

public enum TransactionIDType: String, Codable {
    case internalTransactionID = "internal.transactionId"
}
