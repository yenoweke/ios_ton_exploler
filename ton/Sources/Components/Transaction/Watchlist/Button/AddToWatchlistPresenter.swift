//
//  AddToWatchlistPresenter.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 22.06.2022.
//

import Foundation
import Combine

final class AddToWatchlistPresenter: ObservableObject {
    private var storage: WatchlistStorage!
    private var initialized: Bool = false
    private var cancallebale: Set<AnyCancellable> = []
    
    init() {
        
    }
    
    func initialize(storage: WatchlistStorage) {
        if self.initialized { return }
        
        self.initialized = true
        self.storage = storage
        
        self.storage.$addresses
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &self.cancallebale)
    }
    
    func added(_ address: TONAddress) -> Bool {
        self.storage.isAdded(address)
    }
    
    func onTap(_ address: TONAddress) {
        if self.added(address) {
            self.storage.remove(address)
        }
        else {
            self.storage.add(address)
        }
    }
}
