//
//  WatchlistView.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 22.06.2022.
//

import SwiftUI

struct WatchlistView: View {
    
    let viewModels: [WatchlistItemViewModel]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(self.viewModels, id: \.address) { (vm: WatchlistItemViewModel) in
                    WatchlistItemView(vm: vm)
                        .id(vm.address)
                }
                .padding(.horizontal)
            }
            .navigationTitle(L10n.Watchlist.title)
        }
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WatchlistView(viewModels: MockWatchlistPresenter().address)
                .environmentObject(MockWatchlistPresenter())
        }
    }
    
    final class MockWatchlistPresenter: ObservableObject {
        @Published var address: [WatchlistItemViewModel] = [
            WatchlistItemViewModel(address: "EQCD39VS5jcptHL8vMjEXrzGaRcCVYto7HUn4bpAOg8xqB2N", shortName: "Some Short Name", onTap: {}, onTapCopy: {},onTapEdit: {}, onTapRemove: {}),
            WatchlistItemViewModel(address: "EQAhE3sLxHZpsyZ_HecMuwzvXHKLjYx4kEUehhOy2JmCcHCT", shortName: "", onTap: {}, onTapCopy: {}, onTapEdit: {}, onTapRemove: {}),
            WatchlistItemViewModel(address: "Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF", shortName: "", onTap: {}, onTapCopy: {}, onTapEdit: {}, onTapRemove: {}),
            WatchlistItemViewModel(address: "Ef80UXx731GHxVr0-LYf3DIViMerdo3uJLAG3ykQZFjXz2kW", shortName: "", onTap: {}, onTapCopy: {}, onTapEdit: {}, onTapRemove: {})
        ]
        
        func remove(_ address: WatchlistItemViewModel) {
            self.address.removeAll(where: { address == $0 })
        }
        
        func edit(_ address: WatchlistItemViewModel, newShortName: String) {
            guard let idx = self.address.firstIndex(where: { $0 == address }) else { return }
            self.address[idx] = address.shortName(newShortName)
        }
    }
}

//"EQCD39VS5jcptHL8vMjEXrzGaRcCVYto7HUn4bpAOg8xqB2N": "TON Foundation",
//"EQAhE3sLxHZpsyZ_HecMuwzvXHKLjYx4kEUehhOy2JmCcHCT": "TON Ecosystem Reserve",
//"Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF": "Elector Contract",
//"Ef9VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVbxn": "Config Contract",
//"Ef8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAU": "System",
//"Ef80UXx731GHxVr0-LYf3DIViMerdo3uJLAG3ykQZFjXz2kW": "Log tests Contract",
//"Ef-kkdY_B7p-77TLn2hUhM6QidWrrsl8FYWCIvBMpZKprKDH": "PoW Giver 1",
//"Ef8SYc83pm5JkGt0p3TQRkuiM58O9Cr3waUtR9OoFq716uj0": "PoW Giver 2",
