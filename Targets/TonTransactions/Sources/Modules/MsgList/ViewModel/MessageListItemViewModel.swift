import Foundation
import TTAPIService
import TonTransactionsKit

struct MessageListItemViewModel: Identifiable {
    let id: String
    let incoming: Bool
    let direction: String
    let fee: String
    let transactionTime: String
    let amount: String
    let address: String
    let message: String

    init(id: String, incoming: Bool, fee: String, transactionTime: String, amount: String, address: String, message: String) {
        self.id = id
        self.incoming = incoming
        self.direction = incoming ? L10n.Message.in : L10n.Message.out
        self.fee = fee
        self.transactionTime = transactionTime
        self.amount = amount
        self.address = address
        self.message = message
    }

    static func mock(incoming: Bool) -> MessageListItemViewModel {
        let random = Int.random(in: 0...10000)
        return MessageListItemViewModel(
                id: UUID().uuidString,
                incoming: incoming,
                fee: "0.00012 TON",
                transactionTime: "123123",
                amount: "\(random) TON",
                address: "EQAKJSIvjslkdfjasdiufsd",
                message: "Comment message"
        )
    }
}
