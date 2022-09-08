//
//  InputAddressInteractor.swift
//  TonTransactions
//
//  Created by Dmitrii Chikovinskii on 10.08.2022.
//  Copyright © 2022 dmitri.space. All rights reserved.
//

import Foundation

class InputAddressInteractor: InputAddressInteractorInput {
    
    private weak var output: InputAddressInteractorOutput?
    private let router: InputAddressRouterInput
    
    init(output: InputAddressInteractorOutput, router: InputAddressRouterInput) {
        self.output = output
        self.router = router
    }
    
    func onSubmit(_ address: String) {
        if self.isValid(address) {
            self.router.showTransactions(for: address)
        }
        else {
//            self.show(InputAddressError.addressIsNotValid)
        }
        //self.output?.didUpdate(address: Int.random(in: 0...100000).description)
    }
    
    private func isValid(_ address: String) -> Bool {
        // TODO: Validate address
        return !address.isEmpty
    }
}
