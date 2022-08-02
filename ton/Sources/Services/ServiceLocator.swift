//
//  ServiceLocator.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 13.06.2022.
//

import Foundation

class ServiceLocator: ObservableObject {
    let tonService = TonService()
    let watchlistStorage = WatchlistStorage()
}

