import Foundation


public struct TONAddress: Hashable, Codable {
    
    private let value: String

    var isEmpty: Bool {
        self.value.isEmpty
    }
    
    public init(from decoder: Decoder) throws {
        self.value = try decoder.singleValueContainer().decode(String.self)
    }
    
    public func encode(to coder: Encoder) throws {
        var container = coder.singleValueContainer()
        try container.encode(self.value)
    }
}

extension TONAddress: ExpressibleByStringLiteral, CustomStringConvertible {
    public init(stringLiteral value: String) {
        self.value = value
    }
    
    public var description: String {
        self.value
    }
}

public struct GetTransactionRequest: Encodable {
    let address: String
    let limit: Int
    let lt: Int?
    let hash: String?
    let toLt: Int?
    let archival: Bool

    init(address: String, limit: Int, lt: Int? = nil, hash: String? = nil, toLt: Int? = nil, archival: Bool = false) {
        self.address = address
        self.limit = limit
        self.lt = lt
        self.hash = hash
        self.toLt = toLt
        self.archival = archival
    }
}

// MARK: - GetTransactionsResponse
public struct GetTransactionsResponse: Codable {
    let ok: Bool
    let result: [TxItem]

    public struct TxItem: Codable, Identifiable {
        public var id: String {
            self.transactionID.lt + self.transactionID.hash
        }

        let type: ResultType
        public let utime: Date
        public let data: String
        public let transactionID: TransactionID
        public let fee, storageFee, otherFee: String
        public let inMsg: Msg
        public let outMsgs: [Msg]

        enum CodingKeys: String, CodingKey {
            case type = "@type"
            case utime, data
            case transactionID = "transaction_id"
            case fee
            case storageFee = "storage_fee"
            case otherFee = "other_fee"
            case inMsg = "in_msg"
            case outMsgs = "out_msgs"
        }
    }

    public struct Msg: Codable, Hashable {
        let type: InMsgType
        public let value, fwdFee, ihrFee: Toncoin
        public let source, createdLt, bodyHash: String
        public let destination: String
        let msgData: MsgData
        public let message: String

        enum CodingKeys: String, CodingKey {
            case type = "@type"
            case source, destination, value
            case fwdFee = "fwd_fee"
            case ihrFee = "ihr_fee"
            case createdLt = "created_lt"
            case bodyHash = "body_hash"
            case msgData = "msg_data"
            case message
        }
    }

    struct MsgData: Codable, Hashable {
        let type: MsgDataType
        let body, initState, text: String?

        enum CodingKeys: String, CodingKey {
            case type = "@type"
            case body
            case initState = "init_state"
            case text
        }
    }

    enum MsgDataType: String, Codable {
        case msgDataRaw = "msg.dataRaw"
        case msgDataText = "msg.dataText"
    }

    enum InMsgType: String, Codable {
        case rawMessage = "raw.message"
    }
    
    enum ResultType: String, Codable {
        case rawTransaction = "raw.transaction"
    }
}

//public struct ElementID<Element>: Hashable, Decodable, Equatable {
//
//    public let value: String
//
//    public var asInt: Int {
//        Int(self.value) ?? unknownElementID
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case data
//    }
//
//    enum NestedCodingKeys: String, CodingKey {
//        case id
//    }
//
//    public init(from decoder: Decoder) throws {
//        if let value = try? decoder.singleValueContainer().decode(String.self) {
//            self.value = value
//        }
//        else if let value = try? decoder.singleValueContainer().decode(Int.self) {
//            self.value = String(value)
//        }
//        else if let container = try? decoder.container(keyedBy: CodingKeys.self),
//                let nestedContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .data) {
//            self.value = try nestedContainer.decode(String.self, forKey: .id)
//        }
//        else {
//            let container = try decoder.container(keyedBy: NestedCodingKeys.self)
//            self.value = try container.decode(String.self, forKey: .id)
//        }
//    }
//
//    public init(value: String) {
//        self.value = value
//    }
//
//    public init(value: Int) {
//        self.value = "\(value)"
//    }
//}
