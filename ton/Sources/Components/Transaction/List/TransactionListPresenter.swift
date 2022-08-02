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
    @MainActor @Published var errorLoading: TransactionListView.ErrorType? = nil

    private var filter: TransactionsFilter?
    
    private(set) var initialized = false
    
    @MainActor
    func initialize(address: TONAddress, interactor: TransactionListInteractor) {
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
        guard self.listState.hasNextPage || self.listState.isLoadingNextPageError else { return }
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
            await self.loadInitialTransactions()
            guard let response = try? await self.interactor.information() else {
                // TODO: handle error, add retry
                await MainActor.run(body: { self.loadingAddressInfo = false })
                return
            }
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
                    self.updateErrorIfNeeded()
                }
            }
        }
    }
    
    @MainActor
    func loadNextTransactions()  {
        self.listState.nextPageLoading()
        
        Task.detached {
            do {
                let result = try await self.interactor.nextItems()
                await self.handle(result, initial: false)
            }
            catch {
                await MainActor.run(body: {
                    self.listState.nextPageLoadingError(error)
                    self.updateErrorIfNeeded()
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
    
    @MainActor
    func updateErrorIfNeeded() {
        self.errorLoading = {
            switch self.listState {
            case .initialLoadingError:
                return .initial("Transaction list is not available now, please retry or come back later", retry: { [weak self] in
                    self?.errorLoading = nil
                    self?.loadInitialTransactions()
                })
                
            case .loadNextPageError:
                return .nextPage("Error while loading next page, please try later", retry: { [weak self] in
                    self?.errorLoading = nil
                    self?.loadNextPage()
                })
                
            default: return nil
            }
        }()
    }
}
