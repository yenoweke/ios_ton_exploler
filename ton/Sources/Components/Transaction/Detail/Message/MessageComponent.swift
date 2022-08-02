//
//  MessageComponent.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 14.06.2022.
//

import SwiftUI

struct MessageComponent: Component {
    
    @State var selectedAddress: TONAddress?
    let vm: MessageViewModel
    
    @ViewBuilder
    func assemble(_ serviceLocator: ServiceLocator) -> some View {
        let router = MessageRouter(selectedAddress: self.$selectedAddress)
        let view = MessageView(vm: self.vm, onTapAddress: { self.selectedAddress = TONAddress(stringLiteral: $0) })
        
        ZStack {
            router
            view
        }
    }
}
