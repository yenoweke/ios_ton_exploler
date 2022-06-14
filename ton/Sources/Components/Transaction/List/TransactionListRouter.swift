//
//  TransactionListRouter.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 14.06.2022.
//

import SwiftUI

struct TransactionListRouter: View {
    @Binding var selected: GetTransactionsResponse.Result?
    @Binding var showFilter: Bool
    
    let onTapApplyFilter: (TransactionsFilter) -> Void
    let onTapResetFilter: VoidClosure
    
    var body: some View {
            NavigationLink(
                isActive: Binding(
                    get: { self.selected != nil },
                    set: { if $0 == false { self.selected = nil } }
                ),
                destination: {
                    if let selected = self.selected {
                        let detailsViewModel = TransactionDetailsViewModelImpl(transaction: selected)
                        TransactionDetailsView(vm: detailsViewModel)
                            .navigationTitle(L10n.Transaction.Details.title)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    else {
                        EmptyView()
                    }
                },
                label: { EmptyView() })
        
            .frame(width: 1.0, height: 1.0)
            .sheet(
                isPresented: self.$showFilter,
                content: {
                    NavigationView {
                        TransactionsFilterView(
                            onTapApply: self.onTapApplyFilter,
                            onTapReset: self.onTapResetFilter
                        )
                    }
                }
            )
    }
}
