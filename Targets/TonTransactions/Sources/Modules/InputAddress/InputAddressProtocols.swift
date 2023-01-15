//
//  InputAddressProtocols.swift
//  TonTransactions
//
//  Created by Dmitrii Chikovinskii on 10.08.2022.
//  Copyright © 2022 dmitri.space. All rights reserved.
//

import Foundation

protocol InputAddressDependencies {
    func makeMsgListDependencies(address: String) -> MsgListDependencies
    func makeWalletCardDependencies(address: String) -> WalletCardDependencies
}

struct InputAddressDependenciesImpl: InputAddressDependencies {
    private let serviceLocator: ServiceLocator
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }
    
    func makeMsgListDependencies(address: String) -> MsgListDependencies {
        MsgListDependenciesImpl(serviceLocator: self.serviceLocator, address: address)
    }

    func makeWalletCardDependencies(address: String) -> WalletCardDependencies {
        WalletCardDependenciesImpl(serviceLocator: self.serviceLocator, address: address)
    }
}

protocol InputAddressInteractorOutput: AnyObject {
    func didUpdate(address: String)
}

protocol InputAddressInteractorInput {
    func onSubmit(_ address: String)
}

protocol InputAddressRouterInput {
    func show(_ error: Error)
    func showTransactions(for address: String)
}

enum InputAddressError: LocalizedError {
    case addressIsNotValid
    
    var errorDescription: String? {
        switch self {
        case .addressIsNotValid:
            return L10n.InputAddress.Error.isNotValid
        }
    }
}
