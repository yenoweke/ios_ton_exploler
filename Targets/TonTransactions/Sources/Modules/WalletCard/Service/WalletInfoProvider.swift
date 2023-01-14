//
//  WalletInfoProvider.swift
//  TonTransactions
//
//  Created by Dmitrii Chikovinskii on 12.08.2022.
//  Copyright © 2022 dmitri.space. All rights reserved.
//

import Foundation
import TTAPIService
import TonTransactionsKit

protocol WalletInfoProvider {
    func fetchWalletInformation(_ address: String) async throws  -> WalletCardItem
}

final class WalletInfoProviderImpl: WalletInfoProvider {
    private let service: TonNetworkService
    
    init(service: TonNetworkService) {
        self.service = service
    }
    
    func fetchWalletInformation(_ address: String) async throws -> WalletCardItem {
        let response: GetWalletInformationResponse = try await self.service.fetchWalletInformation(address)
        let formattedBalance = Formatters.ton.formatSignificant(response.result.balance.decimal)
        return WalletCardItem(address: address, balance: formattedBalance, state: response.result.accountState)
    }
}
