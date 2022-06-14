import Foundation

struct GetTransactionRequest: Encodable {
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
