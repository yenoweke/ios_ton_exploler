//
//  Formatters.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 06.06.2022.
//

import Foundation

struct Formatters {
    static let ton = Ton()
    static let date = AppDateFormatter()

    struct AppDateFormatter {

        func full(from date: Date) -> String {
            self.dateFormatter.string(from: date)
        }

        private let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .medium
            return dateFormatter
        }()
    }

    struct Ton {
        func formatSignificant(_ value: Toncoin) -> String {
            self.formatterSignificant.string(for: value.decimal) ?? "Unknown"
        }

        func formatFull(_ value: Toncoin) -> String {
            self.formatterFull.string(for: value.decimal) ?? "Unknown"
        }

        func formatFull(_ value: String) -> String {
            guard let number = self.formatterReader.number(from: value) else { return "Unknown" }
            return (self.formatterFull.string(from: number) ?? "Unknown")
        }

        private let formatterReader: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.multiplier = NSNumber(value: 1_000_000_000)
            return formatter
        }()

        private let formatterSignificant: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.usesSignificantDigits = true
            formatter.usesGroupingSeparator = true
            formatter.numberStyle = .currency
            formatter.locale = Locale.current
            formatter.currencyCode = "TON"
            return formatter
        }()

        private let formatterFull: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.usesGroupingSeparator = true
            formatter.maximumFractionDigits = 10
            formatter.numberStyle = .currency
            formatter.locale = Locale.current
            formatter.currencyCode = "TON"
            return formatter
        }()

    }
}
