//
//  InputAddressPresenter.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 13.06.2022.
//

import Foundation

final class InputAddressPresenter: ObservableObject {
    
    @Published var address: String = ""
    @Published var showTransactions: Bool = false
    @Published var error: InputAddressError?
    
    func onSubmit() {
        if self.isValid(self.address) {
            self.showTransactions = true
        }
        else {
            self.show(InputAddressError.addressIsNotValid)
        }
    }
    
    private func isValid(_ address: String) -> Bool {
        // TODO: Validate address
        return !address.isEmpty
    }
    
    private func show(_ error: InputAddressError) {
        self.error = error
    }
}
