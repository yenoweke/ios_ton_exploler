//
//  InputAddressView.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 11.06.2022.
//

import SwiftUI
import Combine
import TonTransactionsKit

struct InputAddressView: View {
    
    @Binding var address: String
    let onSubmit: VoidClosure
    
    var body: some View {
        VStack {
            Spacer()
            
            AppImage.Logo.tonLogo.swiftUI
            
            Spacer()
            
            TextField(
                L10n.InputAddress.input,
                text: self.$address
            )
            .onSubmit(self.onSubmit)
            .font(AppFont.regular.textStyle(.body))
            
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
