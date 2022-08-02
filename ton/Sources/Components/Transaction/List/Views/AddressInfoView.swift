//
//  AddressInfoView.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 10.06.2022.
//

import SwiftUI

struct AddressInfoView: View {
    let vm: AddressInfoViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(self.vm.address.description)
                    .font(AppFont.regular.textStyle(.title3))
                    .contextCopy(text: self.vm.address.description)
                    .unredacted()
                
                Spacer()
                
                AddToWatchlistComponent(address: self.vm.address)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(L10n.Transaction.List.addressBalance)
                        .font(AppFont.regular.textStyle(.caption2))
                        .opacity(0.7)
                    
                    Text(self.vm.balance)
                        .font(AppFont.bold.textStyle(.title2))
                        .foregroundColor(AppColor.Palette.emerland.swiftUI)
                }
                
                Spacer()
                
                Text(self.vm.state)
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                .fill(AppColor.Ton.background.swiftUI)
        )
    }
}

struct AddressInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddressInfoView(
            vm: AddressInfoViewModel(
                address: "EQCtiv7PrMJImWiF2L5oJCgPnzp-VML2CAt5cbn1VsKAxLiE",
                balance: "52.5 TON",
                state: "active"
            )
        )
        .environmentObject(ServiceLocator())
    }
}
