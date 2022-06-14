//
//  TransactionListComponent.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 13.06.2022.
//

import SwiftUI

struct TransactionListComponent: Component {
    @StateObject var presenter: TransactionListPresenter = TransactionListPresenter()
    let address: String
    
    @ViewBuilder
    func assemble(_ serviceLocator: ServiceLocator) -> some View {
        if presenter.initialized == false {
            let interactor = TransactionListInteractor(address: self.address, service: serviceLocator.tonService)
            let _ = self.presenter.initialize(address: self.address, interactor: interactor)
        }
        
        let error: TransactionListView.ErrorType? = {
            switch self.presenter.listState {
            case .initialLoadingError:
                return .initial("Transaction list is not available now, please retry or come back later")
                
            case .loadNextPageError:
                return .nextPage("Error while loading next page, please try later")
                
            default: return nil
            }
            
        }()
        
        ZStack {
            TransactionListView(
                initialLoading: self.presenter.listState.initialLoading,
                addressInfoLoading: self.presenter.loadingAddressInfo,
                addressInfo: self.presenter.addressInfo,
                items: self.presenter.listState.elements,
                hasNextPage: self.presenter.listState.hasNextPage,
                loadingNextPage: self.presenter.listState.loadingNextPage,
                error: error,
                onAppear: self.presenter.onAppear,
                onShowLastElement: self.presenter.loadNextPage
            )
            .toolbar {
                Button {
                    self.presenter.onTapFilter()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
            TransactionListRouter(
                selected: self.$presenter.selected,
                showFilter: self.$presenter.showFilter,
                onTapApplyFilter: { filter in
                    self.presenter.filter(apply: filter)
                },
                onTapResetFilter: {
                    self.presenter.filter(apply: nil)
                }
            )
        }
        .navigationTitle(L10n.Transaction.List.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
