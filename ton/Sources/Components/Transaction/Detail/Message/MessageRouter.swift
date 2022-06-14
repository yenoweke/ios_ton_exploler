//
//  MessageRouter.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 14.06.2022.
//

import SwiftUI

struct MessageRouter: View {
    @Binding var selectedAddress: String?
    
    var body: some View {
        NavigationLink(
            isActive: Binding(
                get: { self.selectedAddress != nil },
                set: { if $0 == false { self.selectedAddress = nil } }
            ),
            destination: {
                if let selected = self.selectedAddress {
                    TransactionListComponent(address: selected)
                }
                else {
                    EmptyView()
                }
            },
            label: { EmptyView() })
        .frame(width: 1.0, height: 1.0)
    }
}

