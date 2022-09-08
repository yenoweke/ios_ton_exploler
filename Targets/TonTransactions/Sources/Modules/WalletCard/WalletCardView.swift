import SwiftUI

struct WalletCardView: View {
    let wallet: WalletCardItem
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(self.wallet.address)
                    .font(AppFont.regular.textStyle(.title3))
                    .contextCopy(text: self.wallet.address)
                    .unredacted()
                
                Spacer()
                
//                AddToWatchlistComponent(address: self.vm.address)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(L10n.Transaction.List.addressBalance)
                        .font(AppFont.regular.textStyle(.caption2))
                        .opacity(0.7)
                    
                    Text(self.wallet.balance)
                        .font(AppFont.bold.textStyle(.title2))
                        .foregroundColor(AppColor.Palette.emerland.swiftUI)
                        .conditional(self.wallet.balance.isEmpty, transform: {
                            $0.redacted(reason: .placeholder)
                        })
                }
                
                Spacer()
                
                if let state = self.wallet.state {
                    Text(state)
                }
                else {
                    Text("some balance text")
                        .redacted(reason: .placeholder)
                }
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                .fill(AppColor.Ton.background.swiftUI)
        )
    }
}

extension WalletCardView {
    struct Error: View {
        let address: String
        
        let title: String
        let retry: VoidClosure?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8.0) {
                HStack {
                    Text(self.address)
                        .font(AppFont.regular.textStyle(.title3))
                        .contextCopy(text: self.address)
                        .unredacted()
                    
                    Spacer()
                }
                
                HStack(spacing: 32.0) {
                    Text(self.title)
                        .font(AppFont.bold.textStyle(.body))
                        .foregroundColor(AppColor.Palette.alizarin.swiftUI)
                    
                    if let retry = retry {
                        Button(action: retry) {
                            Text(L10n.Common.retry)
                        }
                    }
                }
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                    .fill(AppColor.Ton.background.swiftUI)
            )
        }
    }
}

struct WalletCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WalletCardView(wallet: Self.wallet)
            
            WalletCardView(wallet: Self.wallet)
                .redacted(reason: .placeholder)
            
            WalletCardView.Error(
                address: Self.wallet.address,
                title: "Ошибка загрузки",
                retry: { }
            )
        }
    }
    
    static let wallet = WalletCardItem(
        address: "EQCtiv7PrMJImWiF2L5oJCgPnzp-VML2CAt5cbn1VsKAxLiE",
        balance: "52.5 TON",
        state: "active"
    )
}
