//
//  InputAddressComponent.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 13.06.2022.
//

import SwiftUI
import Combine

struct InputAddressComponent: Component {
    
    @StateObject var vm: InputAddressPresenter = InputAddressPresenter()
    
    @ViewBuilder
    func assemble(_ serviceLocator: ServiceLocator) -> some View {
        let view = InputAddressView(
            address: self.$vm.address,
            onSubmit: self.vm.onSubmit
        )
        
        let router = InputAddressRouter(
            error: self.$vm.error,
            showTransactions: self.$vm.showTransactions,
            address: self.vm.address
        )
        
        ZStack {
            router
            view
        }
    }
}

