//
//  ServiceLocator.swift
//  TonTransactions
//
//  Created by Dmitrii Chikovinskii on 09.08.2022.
//  Copyright © 2022 dmitri.space. All rights reserved.
//

import Foundation
import TTAPIService

final class ServiceLocator {
    
    let tonService: TonService
    let msgsStorage: MsgStorage
    let txnsStorage: TxnsStorage
    let watchlistStorage: WatchlistStorage

    init() {
        self.tonService = Self.makeTonService()
        self.msgsStorage = MsgsInMemoryStorage()
        self.txnsStorage = TxnsInMemoryStorage()
        self.watchlistStorage = WatchlistStorage()
    }
}

private extension ServiceLocator {
    static func makeTonService() -> TonService {
        let toncenterAPIKey: String = try! Configuration.value(for: "TONCENTER_API_KEY")
        let apiProvider = TONApiProvider.toncenter(apiKey: toncenterAPIKey)
        return TonService(apiProvider: apiProvider)
    }
}
