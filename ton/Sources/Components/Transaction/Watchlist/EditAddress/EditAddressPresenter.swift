//
//  EditAddressPresenter.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 29.07.2022.
//

import Foundation

final class EditAddressPresenter: ObservableObject {
    
    @Published var shortName: String = ""
    private var editAddress: String!
    private var storage: WatchlistStorage!
    
    private var initialized = false
    
    init() {}
    
    func initialize(storage: WatchlistStorage, editAddress: String) {
        if self.initialized { return }
        self.initialized = true
        self.shortName = storage.shortName(for: editAddress)
        self.editAddress = editAddress
        self.storage = storage
    }
    
    func save() -> Bool {
        if self.shortName.count < 3 { return false } // TODO: Show error
        self.storage.set(shortName: self.shortName, for: self.editAddress)
        return true
    }
}
