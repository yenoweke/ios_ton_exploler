//
//  TransactionsResponseItemViewModel.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 06.06.2022.
//

import Foundation

struct TransactionListItemViewModel: Identifiable {
    let id: String
    let incoming: Bool
    let direction: String
    let fee: String
    let transactionTime: String
    let amount: String
    let address: String
    let message: String
    let onTap: @MainActor () -> Void
    let amountDecimal: Decimal
    
    init(msg: GetTransactionsResponse.Msg, incoming: Bool, utime: Date, onTap: @escaping @MainActor () -> Void) {
        self.id = msg.bodyHash + "_" + msg.createdLt + "_" + msg.source + "_" + msg.destination
        self.incoming = incoming
        self.direction = incoming ? L10n.Message.in : L10n.Message.out
        self.fee = Formatters.ton.formatSignificant(msg.fwdFee)
        self.transactionTime = Formatters.date.full(from: utime)

        if incoming {
            self.amount = "+" + Formatters.ton.formatSignificant(msg.value)
        }
        else {
            self.amount = "-" + Formatters.ton.formatSignificant(msg.value)
        }
        self.amountDecimal = msg.value.decimal

        self.address = msg.destination
        self.message = msg.message
        self.onTap = onTap
    }
    
    init(id: String, incoming: Bool, fee: String, transactionTime: String, amount: String, amountDecimal: Decimal, address: String, message: String, onTap: @escaping VoidClosure) {
        self.id = id
        self.incoming = incoming
        self.direction = incoming ? L10n.Message.in : L10n.Message.out
        self.fee = fee
        self.transactionTime = transactionTime
        self.amount = amount
        self.address = address
        self.message = message
        self.onTap = onTap
        self.amountDecimal = amountDecimal
    }

    static func mock(incoming: Bool) -> TransactionListItemViewModel {
        let random = Int.random(in: 0...10000)
        return TransactionListItemViewModel(
            id: UUID().uuidString,
            incoming: incoming,
            fee: "0.00012 TON",
            transactionTime: "123123",
            amount: "\(random) TON",
            amountDecimal: Decimal(random),
            address: "EQAKJSIvjslkdfjasdiufsd",
            message: "Comment message",
            onTap: {}
        )
    }
}
