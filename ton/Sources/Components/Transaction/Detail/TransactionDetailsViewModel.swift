//
// Created by Dmitrii Chikovinskii on 10.06.2022.
//

import Foundation

protocol TransactionDetailsViewModel {
    var address: String { get }
    var logicalTime: AddressDetailItemViewModel { get }
    var timeStamp: AddressDetailItemViewModel { get }
    var fee: FeeViewModel { get }
    var messagesCount: AddressDetailItemViewModel { get }
    var messageItems: [MessageViewModel] { get }
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
    let messageItems: [MessageViewModel]

    init(transaction: GetTransactionsResponse.Result) {
        self.address = transaction.inMsg.destination
        self.logicalTime = AddressDetailItemViewModel(
                title: L10n.Transaction.Details.logicalTime,
                descr: transaction.transactionID.lt)
        self.timeStamp = AddressDetailItemViewModel(
                title: L10n.Transaction.Details.timeStamp,
                descr: Formatters.date.full(from: transaction.utime))

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

        let inMsg = MessageViewModel(msg: transaction.inMsg, incoming: true)
        let outMsgs = transaction.outMsgs.map {
            MessageViewModel(msg: $0, incoming: false)
        }
        self.messageItems = [inMsg] + outMsgs
    }
}
