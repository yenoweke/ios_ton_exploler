import Foundation
import TTAPIService

typealias TxnItem = GetTransactionsResponse.TxItem

struct Message: Identifiable {
    let id: String
    let incoming: Bool
    let fee: Toncoin
    let transactionTime: Date
    let amount: Toncoin
    let source: String
    let destination: String
    let message: String
    let bodyHash: String
    let value: String
    let fwdFee: String
    let ihrFee: String
    let createdLt: String
    let txnID: TxnItem.ID
}

protocol MsgsProvider {
    func fetchInitial() async throws -> [Message]
    func fetchNext() async throws -> [Message]
}

final class MsgsProviderImpl: MsgsProvider {
    private let service: TonService
    private let msgStorage: MsgStorage
    private let txnsStorage: TxnsStorage
    private let address: String
    private var lastTransactionID: TransactionID? = nil

    init(service: TonService, msgStorage: MsgStorage, txnsStorage: TxnsStorage, address: String) {
        self.service = service
        self.txnsStorage = txnsStorage
        self.msgStorage = msgStorage
        self.address = address
    }

    func fetchInitial() async throws -> [Message] {
        self.lastTransactionID = nil
        let response = try await self.service.fetchTransactions(address: self.address)
        self.txnsStorage.put(response)
        self.lastTransactionID = response.last?.transactionID

        let msgs = response.flatMap(Self.makeMsgs)
        self.msgStorage.put(msgs)
        return msgs
    }

    func fetchNext() async throws -> [Message] {
        guard let lastTransactionID = self.lastTransactionID else {
            return []
        }

        var response = try await self.service.fetchTransactions(address: self.address, from: lastTransactionID)
        self.txnsStorage.put(response)
        while response.isEmpty == false, response.first?.transactionID == self.lastTransactionID {
            response.removeFirst()
        }

        self.lastTransactionID = response
                .last { item in
                    item.transactionID != lastTransactionID
                }
                .map(\.transactionID)

        let msgs = response.flatMap(Self.makeMsgs)
        self.msgStorage.put(msgs)
        return msgs
    }

    private static func makeMsgs(from item: TxnItem) -> [Message] {
        let msgs: [Message]
        if let msg = Self.makeInMsgs(from: item) {
            msgs = Self.makeOutMsgs(from: item) + [msg]
        }
        else {
            msgs = Self.makeOutMsgs(from: item)
        }
        return msgs
    }

    private static func makeInMsgs(from item: TxnItem) -> Message? {
        Self.makeMessage(
                id: "incoming_message_" + item.id,
                msg: item.inMsg,
                incoming: true,
                utime: item.date,
                txnID: item.id
        )
    }

    private static func makeOutMsgs(from item: TxnItem) -> [Message] {
        item.outMsgs.enumerated().map { idx, msg -> Message in
            Self.makeMessage(
                    id: "out_msg_\(idx)_" + item.id,
                    msg: msg,
                    incoming: false,
                    utime: item.date,
                    txnID: item.id
            )
        }
    }

    private static func makeMessage(id: String, msg: GetTransactionsResponse.Msg, incoming: Bool, utime: Date, txnID: TxnItem.ID) -> Message {
        Message(
                id: id,
                incoming: incoming,
                fee: msg.fwdFee,
                transactionTime: utime,
                amount: msg.value,
                source: msg.source,
                destination: msg.destination,
                message: msg.message,
                bodyHash: msg.bodyHash,
                value: msg.value.value,
                fwdFee: msg.fwdFee.value,
                ihrFee: msg.ihrFee.value,
                createdLt: msg.createdLt,
                txnID: txnID
        )
    }
}
