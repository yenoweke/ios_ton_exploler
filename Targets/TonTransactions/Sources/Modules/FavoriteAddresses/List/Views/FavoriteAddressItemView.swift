import SwiftUI

struct FavoriteAddressActions {
    let onTap: (String) -> Void
    let onTapCopy: (String) -> Void
    let onTapEdit: (String) -> Void
    let onTapRemove: (String) -> Void
}

struct FavoriteAddressesItemView: View {
    let vm: FavoriteAddressesItemViewModel
    let actions: FavoriteAddressActions

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading) {
                HStack {
                    Text(self.vm.shortName)
                            .font(AppFont.bold.textStyle(.title2))

                    Spacer()
                }
                Text(self.vm.address)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(AppFont.regular.textStyle(.caption2))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                            .fill(AppColor.Ton.background.swiftUI)
            )
            .onTapGesture {
                self.actions.onTap(vm.address)
            }
            .contextMenu(menuItems: {
                Button {
                    self.actions.onTapCopy(vm.address)
                } label: {
                    Label(L10n.Watchlist.copyFullAddress, systemImage: "doc.on.doc")
                }

                Button {
                    self.actions.onTapEdit(vm.address)
                } label: {
                    Label(L10n.Watchlist.editShortName, systemImage: "square.and.pencil")
                }

                Button(role: .destructive) {
                    withAnimation {
                        self.actions.onTapRemove(vm.address)
                    }
                } label: {
                    Label(L10n.Common.remove, systemImage: "trash")
                }
            })

            Button {
                self.actions.onTapEdit(vm.address)
            } label: {
                Image(systemName: "square.and.pencil")
                        .tint(Color.accentColor)
            }
                    .padding()
        }
        .font(Fonts.Mulish.regular.textStyle(.body))
    }
}

struct FavoriteAddressesItemView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteAddressesItemView(
                vm: .mock(addr: "asd"),
                actions: FavoriteAddressActions(
                        onTap: { _ in },
                        onTapCopy: { _ in },
                        onTapEdit: { _ in },
                        onTapRemove: { _ in }
                )

        )
    }
}
