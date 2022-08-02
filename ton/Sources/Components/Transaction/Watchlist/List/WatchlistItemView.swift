//
//  WatchlistItemView.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 22.06.2022.
//

import SwiftUI

struct WatchlistItemView: View {
    let vm: WatchlistItemViewModel
    
    @State private var showEdit = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading) {
                HStack {
                    Text(vm.shortName)
                        .font(AppFont.bold.textStyle(.title2))
                    
                    Spacer()
                }
                Text(vm.address)
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
                self.vm.onTap()
            }
            .contextMenu(menuItems: {
                Button {
                    self.vm.onTapCopy()
                } label: {
                    Label(L10n.Watchlist.copyFullAddress, systemImage: "doc.on.doc")
                }
                
                Button {
                    self.vm.onTapEdit()
                } label: {
                    Label(L10n.Watchlist.editShortName, systemImage: "square.and.pencil")
                }
                
                Button(role: .destructive) {
                    withAnimation {
                        self.vm.onTapRemove()
                    }
                } label: {
                    Label(L10n.Common.remove, systemImage: "trash")
                }

            })
            
            
            Button {
                self.vm.onTapEdit()
            } label: {
                Image(systemName: "square.and.pencil")
                    .tint(Color.accentColor)
            }
            .padding()
        }
    }
}

struct WatchlistItemView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistItemView(
            vm: WatchlistItemViewModel(
                address: "EQCD39VS5jcptHL8vMjEXrzGaRcCVYto7HUn4bpAOg8xqB2N",
                shortName: "Some Short Name",
                onTap: {},
                onTapCopy: {},
                onTapEdit: {},
                onTapRemove: {}
            )
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
