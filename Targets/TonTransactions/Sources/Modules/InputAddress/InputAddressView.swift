import SwiftUI
import Combine
import TonTransactionsKit
import TonTransactionsUI

struct InputAddressView: View {
    
    @Binding var address: String
    let onSubmit: VoidClosure
    
    var body: some View {
        VStack {
            Spacer()
            
            AppImage.Logo.tonLogo.swiftUI
            
            Spacer()

            SeparatorView()
            HStack {
                TextField(
                        L10n.InputAddress.input,
                        text: self.$address
                )
                        .onSubmit(self.onSubmit)
                        .font(AppFont.regular.textStyle(.body))

                Button(action: {
                    self.address = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.secondary)
                }
            }.padding(.vertical, 6.0)
            SeparatorView()

            Spacer()
            
            Button(
                action: self.onSubmit,
                label: {
                    Text(L10n.InputAddress.go)
                        .frame(maxWidth: .infinity)
                        .font(AppFont.regular.textStyle(.body))
                })
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .tint(AppColor.Ton.main.swiftUI)
        }
        .padding()
        .font(Fonts.Mulish.regular.textStyle(.body))
        .navigationBarHidden(true)
    }
}

struct InputAddressView_Previews: PreviewProvider {
    static var previews: some View {
        InputAddressView(
            address: State(initialValue: "").projectedValue,
            onSubmit: {}
        )
    }
}
