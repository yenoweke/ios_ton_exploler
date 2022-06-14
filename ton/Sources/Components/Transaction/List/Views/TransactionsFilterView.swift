//
//  TransactionsFilterView.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 11.06.2022.
//

import SwiftUI

enum FilterMessageType: String, CaseIterable, Identifiable {
    case all
    case onlyIn
    case onlyOut
    var id: Self { self }

    var description: String {
        switch self {
        case .all: return L10n.Transaction.Filter.all
        case .onlyIn: return L10n.Transaction.Filter.onlyIn
        case .onlyOut: return L10n.Transaction.Filter.onlyOut
        }
    }
}

struct TransactionsFilter {
    let selectedMsgType: FilterMessageType
    let minValue: Decimal?
    let maxValue: Decimal?
}

struct TransactionsFilterView: View {
    
    @State var selectedMsgType: FilterMessageType = .all
    @State var minValue: Decimal?
    @State var maxValue: Decimal?
    
    let onTapApply: (TransactionsFilter) -> Void
    let onTapReset: VoidClosure
    
    var body: some View {
        List {
            Section {
                Picker(L10n.Transaction.Filter.messageTypes, selection: self.$selectedMsgType) {
                    ForEach(FilterMessageType.allCases) { type in
                        Text(type.description)
                            .tag(type)
                    }
                }
                
                HStack {
                    Text(L10n.Transaction.Filter.minValue + ":")
                        .frame(width: 84.0, alignment: .leading)
                    TextField(
                        L10n.Transaction.Filter.minValue,
                        value: self.$minValue,
                        format: .number
                    )
                }
                
                HStack {
                    Text(L10n.Transaction.Filter.maxValue + ":")
                        .frame(width: 84.0, alignment: .leading)
                    
                    TextField(
                        L10n.Transaction.Filter.maxValue,
                        value: self.$maxValue,
                        format: .number
                    )
                }
            }
            Section {
                Button {
                    let filter = TransactionsFilter(
                        selectedMsgType: self.selectedMsgType,
                        minValue: self.minValue,
                        maxValue: self.maxValue
                    )
                    self.onTapApply(filter)
                } label: {
                    Text(L10n.Common.apply)
                        .foregroundColor(AppColor.Ton.main.swiftUI)
                }
                
                Button {
                    self.onTapReset()
                } label: {
                    Text(L10n.Common.reset)
                        .foregroundColor(AppColor.Palette.alizarin.swiftUI)
                }

            }

        }
        .navigationTitle(L10n.Transaction.Filter.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransactionsFilterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionsFilterView(
//                selectedMsgType: Binding(get: { .all }, set: { _ in }),
//                minValue: Binding(get: { nil }, set: { _ in }),
//                maxValue: Binding(get: { nil }, set: { _ in }),
                onTapApply: { _ in },
                onTapReset: {}
            )
        }
    }
}
