//
//  TransactionDetailsView.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 09.06.2022.
//

import SwiftUI

struct TransactionDetailsView: View {
    let vm: TransactionDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(self.vm.address)
                    .textSelection(.enabled)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .font(AppFont.regular.textStyle(.headline))
                    .padding(.vertical)
                    .contextCopy(text: self.vm.address)
                
                AddressDetailItemView(vm: self.vm.logicalTime)
                
                AddressDetailItemView(vm: self.vm.timeStamp)
                
                HStack {
                    AddressDetailItemView(vm: self.vm.fee.total, textStyle: .caption)
                        .padding(.trailing)

                    AddressDetailItemView(vm: self.vm.fee.storage, textStyle: .caption)
                        .padding(.trailing)

                    AddressDetailItemView(vm: self.vm.fee.other, textStyle: .caption)
                }
                
                AddressDetailItemView(vm: self.vm.messagesCount)
                
                ForEach(self.vm.messageItems, id: \.self) { item in
                    MessageComponent(vm: item)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct TransactionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailsView(vm: MockTransactionDetailsViewModel())
            .preferredColorScheme(.light)
            .environmentObject(ServiceLocator())

        TransactionDetailsView(vm: MockTransactionDetailsViewModel())
            .preferredColorScheme(.dark)
            .environmentObject(ServiceLocator())
    }
}

struct MockTransactionDetailsViewModel: TransactionDetailsViewModel {
    private(set) var address: String = "EQCtiv7PrMJImWiF2L5oJCgPnzp-VML2CAt5cbn1VsKAxLiE"
    private(set) var logicalTime = AddressDetailItemViewModel(title: "Logical time:", descr: "28615968000003")
    private(set) var timeStamp = AddressDetailItemViewModel(title: "TimeStamp", descr: "6/9/2022, 5:54:46 PM – 15 minutes ago")
    let fee = FeeViewModel(
            total: AddressDetailItemViewModel(title: "Total fee:", descr: "0.035846088", copy: false),
            storage: AddressDetailItemViewModel(title: "Storage fee:", descr: "0.000107088", copy: false),
            other: AddressDetailItemViewModel(title: "Other fee:", descr: "0.035739", copy: false))
    private(set) var messagesCount = AddressDetailItemViewModel(title: "Messages:", descr: "1 input, 1 output", copy: false)
    private(set) var messageItems: [MessageViewModel] = [.mock(), .mock()]
}
