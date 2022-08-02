//
//  WatchlistRouter.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 25.07.2022.
//

import SwiftUI

struct WatchlistRouter: View {
    
    @Binding var selected: TONAddress?
    @Binding var editAddress: String?
    
    var body: some View {
        NavigationLink(
            isActive: Binding(
                get: { self.selected != nil },
                set: { if $0 == false { self.selected = nil } }
            ),
            destination: {
                if let selected = self.selected {
                    TransactionListComponent(address: selected)
                }
                else {
                    EmptyView()
                }
            },
            label: { EmptyView() })
        .sheet(
            isPresented: Binding(
                get: { self.editAddress != nil },
                set: { if $0 == false { self.editAddress = nil } }
            ),
            content: {
                if let editAddress = self.editAddress {
                    EditAddressComponent(editAddress: editAddress)
                }
                else {
                    EmptyView()
                }
            })
    
        .frame(width: 1.0, height: 1.0)
    }
}
