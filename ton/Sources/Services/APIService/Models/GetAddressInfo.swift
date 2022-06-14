//
// Created by Dmitrii Chikovinskii on 06.06.2022.
//

import Foundation

struct GetAddressInfoResponse: Codable {
    let ok: Bool
    let result: Result

    struct Result: Codable {
        let type, code, data: String
        let balance: Toncoin
        let lastTransactionID: TransactionID
        let blockID: BlockID
        let frozenHash: String
        let syncUtime: Int
        let extra, state: String

        enum CodingKeys: String, CodingKey {
            case type = "@type"
            case balance, code, data
            case lastTransactionID = "last_transaction_id"
            case blockID = "block_id"
            case frozenHash = "frozen_hash"
            case syncUtime = "sync_utime"
            case extra = "@extra"
            case state
        }
    }

    // MARK: - BlockID
    struct BlockID: Codable {
        let type: String
        let workchain: Int
        let shard: String
        let seqno: Int
        let rootHash, fileHash: String

        enum CodingKeys: String, CodingKey {
            case type = "@type"
            case workchain, shard, seqno
            case rootHash = "root_hash"
            case fileHash = "file_hash"
        }
    }
}
