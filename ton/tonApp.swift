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
            NavigationView {
                InputAddressComponent()
            }
            .environmentObject(self.serviceLocator)
        }
    }
}
