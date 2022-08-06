//
//  TransactionListItemView.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 06.06.2022.
//

import SwiftUI

struct TransactionListItemView: View {
    
    let vm: TransactionListItemViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HStack {
                Text(vm.fee)
                Spacer()
                Text(vm.transactionTime)
            }
            .font(.caption2)
            HStack {
                Text(vm.amount)
                    .font(.title2)
                    .bold()
                    .conditional(self.vm.incoming) { view in
                        view.foregroundColor(AppColor.Palette.emerland.swiftUI)
                    }
                
                Spacer()
                
                Text(self.vm.direction)
                    .font(.callout)
                
                Text(vm.address)
                    .frame(minWidth: 72.0, maxWidth: 108.0)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .truncationMode(.middle)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                .fill(AppColor.Ton.background.swiftUI)
        )
        .frame(maxWidth: .infinity)
        .onTapGesture(perform: { self.vm.onTap() })
    }
}

struct TransactionListItemView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListItemView(vm: .mock(incoming: true))
            .padding()
            .previewLayout(.sizeThatFits)
            .background(AppColor.Palette.silver.swiftUI)
        
        TransactionListItemView(vm: .mock(incoming: false))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
