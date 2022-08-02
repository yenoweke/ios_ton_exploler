//
//  tonApp.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 06.06.2022.
//

import SwiftUI

@main
struct tonApp: App {
    
    @StateObject var serviceLocator: ServiceLocator = ServiceLocator()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    InputAddressComponent()
                }
                .tabItem {
                    Label(L10n.Tab.Search.title, systemImage: "magnifyingglass.circle")
                }
                
                NavigationView {
                    WatchlistComponent()
                }
                .tabItem {
                    Label(L10n.Tab.Watchlist.title, systemImage: "star")
                }
            }
            .environmentObject(self.serviceLocator)
        }
    }
}
