//
//  InputAddressRouter.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 13.06.2022.
//

import SwiftUI

struct InputAddressRouter: View {
    
    @Binding var error: InputAddressError?
    @Binding var showTransactions: Bool
    let address: String
    
    var body: some View {
        NavigationLink(
            isActive: self.$showTransactions,
            destination: {
                TransactionListComponent(address: .init(stringLiteral: self.address))
                    .navigationTitle("Ton Exploler")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(false)
            },
            label: {
                Color.clear
                    .alert(
                        isPresented: Binding(
                            get: { self.error != nil },
                            set: { if $0 == false { self.error = nil } }
                        ),
                        error: self.error,
                        actions: {
                            Button("OK", role: .cancel) { }
                        }
                    )
            })
        .frame(width: 1.0, height: 1.0)
    }
}


struct InputAddressRouter_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InputAddressRouter(
                error: State(initialValue: nil).projectedValue,
                showTransactions: State.init(initialValue: true).projectedValue,
                address: "EQCtiv7PrMJImWiF2L5oJCgPnzp-VML2CAt5cbn1VsKAxLiE"
            )
        }
    }
}
