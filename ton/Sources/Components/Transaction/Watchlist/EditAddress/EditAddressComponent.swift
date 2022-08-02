//
//  EditAddressComponent.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 29.07.2022.
//

import SwiftUI

struct EditAddressComponent: Component {
    let editAddress: String
    
    @StateObject var presenter = EditAddressPresenter()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ViewBuilder
    func assemble(_ serviceLocator: ServiceLocator) -> some View {
        let _ = self.presenter.initialize(storage: serviceLocator.watchlistStorage, editAddress: self.editAddress)
        
        EditAddressView(
            fullAddress: self.editAddress,
            address: self.$presenter.shortName,
            onSubmit: {
                guard self.presenter.save() else { return }
                self.presentationMode.wrappedValue.dismiss()
            }
        )
    }
}
