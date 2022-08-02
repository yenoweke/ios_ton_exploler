//
//  WatchlistPresenter.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 19.07.2022.
//

import Foundation
import UIKit
import Combine

final class WatchlistPresenter: ObservableObject {
    @Published private(set) var viewModels: [WatchlistItemViewModel] = []
    
    @Published var editAddress: String? = nil
    @Published var selected: TONAddress? = nil
    
    private var storage: WatchlistStorage!
    
    private var initialized = false
    private var cancallebale: Set<AnyCancellable> = []
    
    init() {}
    
    func initialize(storage: WatchlistStorage) {
        if self.initialized { return }
        self.initialized = true
        self.storage = storage
        
        self.storage.$shortNames
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateVM()
            }
            .store(in: &self.cancallebale)
    }
    
    func onAppear() {
        self.updateVM()
    }
}

private extension WatchlistPresenter {
    func makeVM(adresses: [String]) -> [WatchlistItemViewModel] {
        adresses.map { adr in
            WatchlistItemViewModel(
                address: adr,
                shortName: self.storage.shortName(for: adr),
                onTap: { [weak self] in
                    self?.selected = TONAddress(stringLiteral: adr)
                },
                onTapCopy: {
                    UIPasteboard.general.string = adr
                },
                onTapEdit: { [weak self] in
                    self?.editAddress = adr
                },
                onTapRemove: { [weak self] in
                    self?.storage.remove(TONAddress(stringLiteral: adr))
                    self?.viewModels.removeAll(where: { $0.address == adr })
                }
            )
        }
    }
    
    func updateVM() {
        self.viewModels = self.makeVM(adresses: self.storage.addresses)
    }
}
