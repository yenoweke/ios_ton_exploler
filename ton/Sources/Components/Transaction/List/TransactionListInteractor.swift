//
// Created by Dmitrii Chikovinskii on 14.06.2022.
//

import Foundation

class TransactionListInteractor {
    
    private let service: TonService
    
    private var lastTransaction: TransactionID? = nil
    
    private(set) var rawItems: [GetTransactionsResponse.Result] = []
    
    let address: TONAddress
    
    init(address: TONAddress, service: TonService) {
        self.address = address
        self.service = service
    }

    func initialItems() async throws -> [GetTransactionsResponse.Result] {
        let items = try await self.service.fetchTransactions(address: self.address, from: self.lastTransaction)
        self.rawItems = items
        self.lastTransaction = items.last?.transactionID
        return items
    }

    func nextItems() async throws -> [GetTransactionsResponse.Result] {
        guard let last = self.lastTransaction else { return [] }

        var items = try await self.service.fetchTransactions(address: self.address, from: last)
        if items.first?.transactionID == last {
            items.removeFirst()
        }
        self.rawItems += items
        self.lastTransaction = items.last?.transactionID
        return items
    }

    func information() async throws -> GetWalletInformationResponse {
        let info = try await self.service.fetchWalletInformation(self.address)
        self.lastTransaction = info.result.lastTransactionID
        return info
    }
}
