import SwiftUI
import TonTransactionsUI

struct EditAddressView: View {
    let fullAddress: String
    @Binding var address: String
    let onSubmit: VoidClosure

    @FocusState var focused: Bool

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 0.0) {
                Text(L10n.Edit.fullAddress)
                        .font(AppFont.regular.textStyle(.title3))
                        .padding(.bottom, 4.0)

                Text(self.fullAddress)
                        .frame(maxWidth: .infinity, alignment: .leading)
            }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 16.0)

            SeparatorView()
            HStack {
                TextField(
                        L10n.Edit.placeholder,
                        text: self.$address
                )
                        .focused(self.$focused)
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
                        Text(L10n.Common.save)
                                .frame(maxWidth: .infinity)
                                .font(AppFont.regular.textStyle(.body))
                    })
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .tint(AppColor.Ton.main.swiftUI)
        }
                .padding()
                .font(AppFont.regular.textStyle(.body))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.focused = true
                    }
                }
                .font(Fonts.Mulish.regular.textStyle(.body))
    }
}

struct EditAddressView_Previews: PreviewProvider {
    static var previews: some View {
        EditAddressView(
                fullAddress: "JAKSdadasdva389fshdgakjlsdfb3ifhdu",
                address: Binding(get: { "" }, set: {_ in }),
                onSubmit: {})
    }
}
