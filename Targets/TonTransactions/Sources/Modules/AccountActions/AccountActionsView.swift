import SwiftUI

struct AccountActionsView: View {
    
    let added: Bool
    let subsribed: Bool
    let loading: Bool
    let onTapAdd: VoidClosure
    let onTapSubsribe: VoidClosure
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Button {
                self.onTapAdd()
            } label: {
                Label(
                    self.added ? L10n.Account.Action.deleteFromWatchList : L10n.Account.Action.addToWatchList,
                    systemImage: self.added ? "star.fill" : "star"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
                .frame(maxWidth: .infinity)
                .frame(height: 1.0)
                .background(AppColor.Palette.silver.swiftUI.opacity(0.25))
            
            Button(
                action: onTapSubsribe,
                label: {
                    Label(
                        self.subsribed ? L10n.Account.Action.unsubsribeOnUpdates : L10n.Account.Action.subsribeOnUpdates,
                        systemImage: self.subsribed ? "bell.fill" : "bell"
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .foregroundColor(AppColor.Ton.main.swiftUI)
        .background(
            RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                .fill(AppColor.Ton.background.swiftUI)
        )
        .font(Fonts.Mulish.regular.textStyle(.body))
        .conditional(self.loading) { view in
            view.redacted(reason: .placeholder)
        }
    }
}

struct AccountActionsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountActionsView(
            added: false,
            subsribed: false,
            loading: false,
            onTapAdd: { },
            onTapSubsribe: {}
        )
        .padding()
        .previewLayout(.sizeThatFits)
        
        AccountActionsView(
            added: true,
            subsribed: true,
            loading: false,
            onTapAdd: {},
            onTapSubsribe: {}
        )
        .padding()
        .previewLayout(.sizeThatFits)
        
        AccountActionsView(
            added: true,
            subsribed: true,
            loading: true,
            onTapAdd: {},
            onTapSubsribe: {}
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
