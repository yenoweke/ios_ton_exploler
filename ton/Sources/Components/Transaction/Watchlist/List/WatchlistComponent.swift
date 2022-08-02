//
//  WatchlistComponent.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 19.07.2022.
//

import Foundation
import SwiftUI

struct WatchlistComponent: Component {
    
    @StateObject var presenter = WatchlistPresenter()
    
    @ViewBuilder
    func assemble(_ serviceLocator: ServiceLocator) -> some View {
        let _ = self.presenter.initialize(storage: serviceLocator.watchlistStorage)
        
        ZStack {
            WatchlistView(viewModels: self.presenter.viewModels)
                .onAppear(perform: self.presenter.onAppear)
            
            WatchlistRouter(
                selected: Binding(
                    get: { self.presenter.selected },
                    set: { val in if val == nil { self.presenter.selected = nil }  }
                ),
                editAddress: Binding(
                    get: { self.presenter.editAddress },
                    set: { val in if val == nil { self.presenter.editAddress = nil }  }
                )
            )
        }
    }
}
