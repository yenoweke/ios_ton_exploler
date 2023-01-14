import SwiftUI

struct MessageFilterView: View {
    @State var selectedMsgType: FilterMessageType = .all
    @State var minValue: Decimal?
    @State var maxValue: Decimal?
    
    let onTapApply: (MessagesFilter) -> Void
    let onTapReset: VoidClosure
    
    var body: some View {
        NavigationView {
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
                        let filter = MessagesFilter(
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
        }
        .navigationTitle(L10n.Transaction.Filter.title)
        .navigationBarTitleDisplayMode(.inline)
        .font(Fonts.Mulish.regular.textStyle(.body))
    }
}

struct MessageFilterView_Previews: PreviewProvider {
    static var previews: some View {
        MessageFilterView(
            onTapApply: { _ in },
            onTapReset: {}
        )
    }
}

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

struct MessagesFilter {
    let selectedMsgType: FilterMessageType
    let minValue: Decimal?
    let maxValue: Decimal?
    
    static let `default` = MessagesFilter(
        selectedMsgType: .all,
        minValue: nil,
        maxValue: nil
    )
}
