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
}

protocol MsgsProvider {
    func fetchInitial() async throws -> [Message]
    func fetchNext() async throws -> [Message]
}

final class MsgsProviderImpl: MsgsProvider {
    private let service: TonService
    private let msgStorage: MsgStorage
    private let address: String
    private var lastTransactionID: TransactionID? = nil

    init(service: TonService, msgStorage: MsgStorage, address: String) {
        self.service = service
        self.address = address
        self.msgStorage = msgStorage
    }

    func fetchInitial() async throws -> [Message] {
        self.lastTransactionID = nil
        let response = try await self.service.fetchTransactions(address: self.address)
        self.lastTransactionID = response.last?.transactionID

        let msgs = response.flatMap(Self.makeMsgs)
        self.msgStorage.put(msgs)
        return msgs
    }

    func fetchNext() async throws -> [Message] {
        guard let lastTransactionID = self.lastTransactionID else {
            return []
        }

        let response = try await self.service.fetchTransactions(address: self.address, from: lastTransactionID)
        self.lastTransactionID = response.first { item in
            item.transactionID != lastTransactionID
        }.map(\.transactionID)

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
        if item.inMsg.source.isEmpty { return nil }

        let msg = item.inMsg
        return Self.makeMessage(
                id: msg.hashValue.description,
                msg: msg,
                incoming: true,
                utime: item.utime
        )
    }

    private static func makeOutMsgs(from item: TxnItem) -> [Message] {
        var idx = 0
        return item.outMsgs.map { msg -> Message in
            idx += 1
            return Self.makeMessage(
                    id: msg.hashValue.description + "_\(idx)",
                    msg: msg,
                    incoming: false,
                    utime: item.utime
            )
        }
    }

    private static func makeMessage(id: String, msg: GetTransactionsResponse.Msg, incoming: Bool , utime: Date) -> Message {
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
                createdLt: msg.createdLt
        )
    }
}
