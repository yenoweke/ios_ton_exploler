//
//  AddToWatchlist.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 22.06.2022.
//

import Foundation
import SwiftUI

struct AddToWatchlistComponent: Component {
    let address: TONAddress
    @StateObject var presenter = AddToWatchlistPresenter()
    
    @ViewBuilder
    func assemble(_ serviceLocator: ServiceLocator) -> some View {
        let _ = self.presenter.initialize(storage: serviceLocator.watchlistStorage)
        
        AddToWatchlistButton(
            added: self.presenter.added(address),
            onTap: { self.presenter.onTap(address) }
        )
    }
}
