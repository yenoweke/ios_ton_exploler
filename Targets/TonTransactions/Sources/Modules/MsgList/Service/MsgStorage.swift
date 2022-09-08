import Foundation

protocol MsgStorage {
    func get(by messageID: Message.ID) -> Message?
    func put(_ msgs: [Message])
}

typealias MsgsInMemoryStorage = InMemoryStorage<Message>
extension InMemoryStorage: MsgStorage where Element == Message {}

protocol TxnsStorage {
    func get(by txnID: String) -> TxnItem?
    func put(_ txns: [TxnItem])
}
typealias TxnsInMemoryStorage = InMemoryStorage<TxnItem>
extension InMemoryStorage: TxnsStorage where Element == TxnItem {}


final class InMemoryStorage<Element: Identifiable> {
    private let queue = DispatchQueue(
            label: "inmemory.storage.processing.\(String(describing: Element.self))",
            attributes: .concurrent
    )

    private var elementsByID: [Element.ID: Element] = [:]

    func get(by identifier: Element.ID) -> Element? {
        self.queue.sync {
            self.elementsByID[identifier]
        }
    }

    func put(_ elements: [Element]) {
        self.queue.async(flags: .barrier) {
            for element in elements {
                self.elementsByID[element.id] = element
            }
        }
    }
}

//final class MsgStorageImpl: MsgStorage {
//    private let queue = DispatchQueue(label: "msg.storage.processing", attributes: .concurrent)
//    private var msgs: [String: Message] = [:]
//
//    func get(by messageID: String) -> Message? {
//        self.queue.sync {
//            self.msgs[messageID]
//        }
//    }
//
//    func put(_ msgs: [Message]) {
//        self.queue.async(flags: .barrier) {
//            for message in msgs {
//                self.msgs[message.id] = message
//            }
//        }
//    }
//}
