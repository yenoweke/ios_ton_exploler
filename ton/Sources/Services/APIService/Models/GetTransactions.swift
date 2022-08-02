import Foundation


struct TONAddress: Hashable, Codable {
    
    private let value: String

    var isEmpty: Bool {
        self.value.isEmpty
    }
    
    init(from decoder: Decoder) throws {
        self.value = try decoder.singleValueContainer().decode(String.self)
    }
    
    func encode(to coder: Encoder) throws {
        var container = coder.singleValueContainer()
        try container.encode(self.value)
    }
}

extension TONAddress: ExpressibleByStringLiteral, CustomStringConvertible {
    init(stringLiteral value: String) {
        self.value = value
    }
    
    var description: String {
        self.value
    }
}

struct GetTransactionRequest: Encodable {
    let address: TONAddress
    let limit: Int
    let lt: Int?
    let hash: String?
    let toLt: Int?
    let archival: Bool

    init(address: TONAddress, limit: Int, lt: Int? = nil, hash: String? = nil, toLt: Int? = nil, archival: Bool = false) {
        self.address = address
        self.limit = limit
        self.lt = lt
        self.hash = hash
        self.toLt = toLt
        self.archival = archival
    }
}

// MARK: - GetTransactionsResponse
struct GetTransactionsResponse: Codable {
    let ok: Bool
    let result: [Result]

    struct Result: Codable, Identifiable {
        var id: String {
            self.transactionID.lt + self.transactionID.hash
        }

        let type: ResultType
        let utime: Date
        let data: String
        let transactionID: TransactionID
        let fee, storageFee, otherFee: String
        let inMsg: Msg
        let outMsgs: [Msg]

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

    struct Msg: Codable {
        let type: InMsgType
        let value, fwdFee, ihrFee: Toncoin
        let source, createdLt, bodyHash: String
        let destination: String
        let msgData: MsgData
        let message: String

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

    struct MsgData: Codable {
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
