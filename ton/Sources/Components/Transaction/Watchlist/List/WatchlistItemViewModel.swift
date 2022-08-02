//
// Created by Dmitrii Chikovinskii on 22.06.2022.
//

import Foundation

struct WatchlistItemViewModel: Equatable {
    let address: String
    let shortName: String
    let onTap: VoidClosure
    let onTapCopy: VoidClosure
    let onTapEdit: VoidClosure
    let onTapRemove: VoidClosure

    init(address: String, shortName: String, onTap: @escaping VoidClosure, onTapCopy: @escaping VoidClosure, onTapEdit: @escaping VoidClosure, onTapRemove: @escaping VoidClosure) {
        self.address = address

        // TODO: Add validation
        if shortName.isEmpty {
            self.shortName = address.count > 8 ? address.prefix(3) + "..." + address.suffix(3) : address
        }
        else {
            self.shortName = shortName
        }
        self.onTap = onTap
        self.onTapCopy = onTapCopy
        self.onTapEdit = onTapEdit
        self.onTapRemove = onTapRemove
    }

    func shortName(_ text: String) -> WatchlistItemViewModel {
        WatchlistItemViewModel(
                address: self.address,
                shortName: text,
                onTap: self.onTap,
                onTapCopy: self.onTapCopy,
                onTapEdit: self.onTapEdit,
                onTapRemove: self.onTapRemove
        )
    }

    static func ==(lhs: WatchlistItemViewModel, rhs: WatchlistItemViewModel) -> Bool {
        guard lhs.address == rhs.address else { return false }
        guard lhs.shortName == rhs.shortName else { return false }
        return true
    }
}
