//
//  TransactionsViewModel.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 06.06.2022.
//

import Foundation

class TransactionListPresenter: ObservableObject {
    private var interactor: TransactionListInteractor! // TODO: find better way to implement injection
    
    @MainActor @Published var listState = ListState<TransactionListItemViewModel>.idle
    @MainActor @Published var selected: GetTransactionsResponse.Result?
    @MainActor @Published var loadingAddressInfo = false
    @MainActor @Published var addressInfo = AddressInfoViewModel(address: "", balance: "", state: "")
    @MainActor @Published var showFilter: Bool = false
    
    private var filter: TransactionsFilter?
    
    private(set) var initialized = false
    
    @MainActor
    func initialize(address: String, interactor: TransactionListInteractor) {
        if self.initialized { return }
        self.interactor = interactor
        self.initialized = true
        self.addressInfo = AddressInfoViewModel(address: address, balance: "BALANCE", state: "State")
    }
    
    @MainActor
    func onAppear() {
        guard self.listState.isIdle || self.listState.isInitialLoadingError else { return }
        
        self.listState = .idle
        self.loadAddressInfo()
    }
    
    @MainActor
    func loadNextPage() {
        guard self.listState.hasNextPage else { return }
        if self.listState.loadingNextPage { return }
        self.loadNextTransactions()
    }
    
    @MainActor
    func onTapFilter() {
        self.showFilter = true
    }
    
    func filter(apply filter: TransactionsFilter?) {
        self.filter = filter
        Task {
            await self.handle(self.interactor.rawItems, initial: true)
        }
        Task { @MainActor in
            self.showFilter = false
        }
    }
}

private extension TransactionListPresenter {
    @MainActor
    func loadAddressInfo() {
        self.loadingAddressInfo = true
        Task.detached {
            guard let response = try? await self.interactor.information() else { return }
            let vm = AddressInfoViewModel(address: self.interactor.address, response: response.result)
            await MainActor.run {
                self.addressInfo = vm
                self.loadInitialTransactions()
                self.loadingAddressInfo = false
            }
        }
    }
    
    @MainActor
    func loadInitialTransactions() {
        self.listState = .initialLoading
        Task.detached {
            do {
                let result = try await self.interactor.initialItems()
                await self.handle(result, initial: true)
            }
            catch {
                await MainActor.run {
                    self.listState.initiallLoadError(error)
                }
            }
        }
    }
    
    @MainActor
    func loadNextTransactions()  {
        guard self.listState.hasNextPage else { return }
        self.listState.nextPageLoading()
        
        Task.detached {
            do {
                let result = try await self.interactor.nextItems()
                await self.handle(result, initial: false)
            }
            catch {
                await MainActor.run(body: {
                    self.listState.nextPageLoadingError(error)
                })
            }
        }
    }
    
    func handle(_ result: [GetTransactionsResponse.Result], initial: Bool) async {
        let onTap: @MainActor (GetTransactionsResponse.Result) -> Void = { item in
            self.selected = item
        }
        let items = TransactionsMapper.map(result, onTap: onTap, filter: self.filter)
        await MainActor.run(body: {
            if initial {
                self.listState.initiallyLoaded(items, hasNextPage: !result.isEmpty)
            }
            else {
                self.listState.nextPageLoaded(items, hasNextPage: !result.isEmpty)
            }
        })
    }
}
