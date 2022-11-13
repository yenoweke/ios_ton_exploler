import SwiftUI

struct FavoriteAddressesView: View {

    let viewModels: [FavoriteAddressesItemViewModel]
    let actions: FavoriteAddressActions

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(self.viewModels, id: \.address) { (vm: FavoriteAddressesItemViewModel) in
                    FavoriteAddressesItemView(
                            vm: vm,
                            actions: actions
                            )
                            .id(vm.address)
                }
                .padding(.horizontal)
            }
            .navigationTitle(L10n.Watchlist.title)
        }
    }
}

struct FavoriteAddressesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteAddressesView(
                viewModels: [],
                actions: FavoriteAddressActions(
                        onTap: { _ in },
                        onTapCopy: { _ in },
                        onTapEdit: { _ in },
                        onTapRemove: { _ in }
                )
        )
    }
}
