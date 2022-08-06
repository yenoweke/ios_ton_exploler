//
//  ServiceLocator.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 13.06.2022.
//

import Foundation

class ServiceLocator: ObservableObject {
    let tonService = TonService()
    let watchlistStorage: WatchlistStorage

    let knownNamesStorage = KnownNamesStorage()

    init() {
        self.watchlistStorage = WatchlistStorage(knownNamesStorage: self.knownNamesStorage)
    }
}

