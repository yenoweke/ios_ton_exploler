//
//  Toncoin.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 14.06.2022.
//

import Foundation

public struct Toncoin: Codable, Hashable {
    public let value: String
    public let decimal: Decimal

    public init(from decoder: Decoder) throws {
        self.value = try decoder.singleValueContainer().decode(String.self)
        if let decimal = Decimal(string: value) {
            self.decimal = decimal / 1_000_000_000
        }
        else {
            assertionFailure()
            self.decimal = 0
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
}
