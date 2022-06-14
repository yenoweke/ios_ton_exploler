//
//  AddressInfoViewModel.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 14.06.2022.
//

import Foundation

struct AddressInfoViewModel {
    let address: String
    let balance: String
    let state: String

    init(address: String, balance: String, state: String) {
        self.address = address
        self.balance = balance
        self.state = state
    }

    init(address: String, response: GetAddressInfoResponse.Result) {
        self.address = address
        self.balance = Formatters.ton.formatSignificant(response.balance)
        self.state = response.state
    }
}
