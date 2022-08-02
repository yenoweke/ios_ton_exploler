//
//  ContentView.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 06.06.2022.
//

import SwiftUI

struct TransactionListView: View {
    enum ErrorType {
        // TODO: add retry here
        case address(String, retry: VoidClosure)
        case initial(String, retry: VoidClosure)
        case nextPage(String, retry: VoidClosure)
    }
    
    let initialLoading: Bool
    let addressInfoLoading: Bool
    let addressInfo: AddressInfoViewModel // TODO: move logic to separate component
    let items: [TransactionListItemViewModel]
    let hasNextPage: Bool
    let loadingNextPage: Bool
    
    let error: ErrorType?
    
    let onAppear: @MainActor () -> Void
    let onShowLastElement: @MainActor () -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16.0) {
                AddressInfoView(vm: self.addressInfo)
                    .conditional(self.addressInfoLoading) { view in
                        view.redacted(reason: .placeholder)
                    }

                if self.addressInfoLoading || self.initialLoading {
                    ProgressView()
                }

                if let error = self.error,
                   case ErrorType.initial(let text, let retry) = error {
                    ErrorView(
                        title: L10n.Common.error,
                        description: text,
                        retry: { retry() }
                    )
                }
                else {
                    ForEach(self.items, content: TransactionListItemView.init)
                }
                
                if let error = self.error, case ErrorType.nextPage(let text, let retry) = error {
                    ErrorView(
                        title: L10n.Common.error,
                        description: text,
                        retry: { retry() }
                    )
                }
                
                if self.loadingNextPage {
                    ProgressView()
                        .padding()
                }
                
                if self.hasNextPage {
                    Color.clear
                        .onAppear(perform: {
                            self.onShowLastElement()
                        })
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .onAppear(perform: { self.onAppear() })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionListView(
                initialLoading: false,
                addressInfoLoading: false,
                addressInfo: AddressInfoViewModel(
                    address: "Address",
                    balance: "52 TON",
                    state: "Active"
                ),
                items: [],
                hasNextPage: false,
                loadingNextPage: true,
                error: .initial("Transaction list is not available now, please retry or come back later", retry: {}),
                onAppear: {},
                onShowLastElement: {}
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
