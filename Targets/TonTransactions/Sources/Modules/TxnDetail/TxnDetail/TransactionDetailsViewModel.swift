import Foundation
import TTAPIService
import TonTransactionsKit

protocol TransactionDetailsViewModel {
    var address: String { get }
    var logicalTime: AddressDetailItemViewModel { get }
    var timeStamp: AddressDetailItemViewModel { get }
    var fee: FeeViewModel { get }
    var messagesCount: AddressDetailItemViewModel { get }
    var messageIDs: [String] { get }
}

struct FeeViewModel {
    let total: AddressDetailItemViewModel
    let storage: AddressDetailItemViewModel
    let other: AddressDetailItemViewModel
}

struct TransactionDetailsViewModelImpl: TransactionDetailsViewModel {
    let address: String
    let logicalTime: AddressDetailItemViewModel
    let timeStamp: AddressDetailItemViewModel
    let fee: FeeViewModel
    let messagesCount: AddressDetailItemViewModel
    let messageIDs: [String]

    init(transaction: GetTransactionsResponse.TxItem) {
        self.address = transaction.inMsg.destination
        self.logicalTime = AddressDetailItemViewModel(
                title: L10n.Transaction.Details.logicalTime,
                descr: transaction.transactionID.lt)
        self.timeStamp = AddressDetailItemViewModel(
                title: L10n.Transaction.Details.timeStamp,
                descr: Formatters.date.full(from: transaction.date))

        self.fee = FeeViewModel(
                total: AddressDetailItemViewModel(
                        title: L10n.Transaction.Details.totalFee,
                        descr: Formatters.ton.formatFull(transaction.fee),
                        copy: false
                ),
                storage: AddressDetailItemViewModel(
                        title: L10n.Transaction.Details.storageFee,
                        descr: Formatters.ton.formatFull(transaction.storageFee),
                        copy: false
                ),
                other: AddressDetailItemViewModel(
                        title: L10n.Transaction.Details.otherFee,
                        descr: Formatters.ton.formatFull(transaction.otherFee),
                        copy: false
                )
        )

        self.messagesCount = AddressDetailItemViewModel(
                title: L10n.Transaction.Details.messages,
                descr: L10n.Transaction.Details.messagesInfo(1, transaction.outMsgs.count),
                copy: false
        )

        let inMsg = "incoming_message_" + transaction.id
        let outMsgs = transaction.outMsgs.enumerated().map { idx, msg in
            "out_msg_\(idx)_" + transaction.id
        }

        self.messageIDs = [inMsg] + outMsgs
    }
}
