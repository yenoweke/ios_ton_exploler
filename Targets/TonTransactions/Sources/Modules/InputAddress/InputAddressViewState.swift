//
//  InputAddressViewState.swift
//  TonTransactions
//
//  Created by Dmitrii Chikovinskii on 10.08.2022.
//  Copyright © 2022 dmitri.space. All rights reserved.
//

import Foundation

final class InputAddressViewState: ObservableObject {
    #if DEBUG
    @Published var address: String = "EQCtiv7PrMJImWiF2L5oJCgPnzp-VML2CAt5cbn1VsKAxLiE"
    #else
    @Published var address: String = ""
    #endif
    
    init() {
   
    }
}

extension InputAddressViewState: InputAddressInteractorOutput {
    func didUpdate(address: String) {
        self.address = address
    }
}
