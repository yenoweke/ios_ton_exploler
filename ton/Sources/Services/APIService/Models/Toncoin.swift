//
//  Toncoin.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 14.06.2022.
//

import Foundation

struct Toncoin: Codable {
    private let value: String
    let decimal: Decimal

    init(from decoder: Decoder) throws {
        self.value = try decoder.singleValueContainer().decode(String.self)
        if let decimal = Decimal(string: value) {
            self.decimal = decimal / 1_000_000_000
        }
        else {
            assertionFailure()
            self.decimal = 0
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
}
