import SwiftUI
import TonTransactionsKit

struct MsgListView: View {
    enum ErrorType {
        // TODO: add retry here
        case address(String, retry: VoidClosure)
        case initial(String, retry: VoidClosure)
        case nextPage(String, retry: VoidClosure)
    }

    let initialLoading: Bool
    let items: [MessageListItemViewModel]
    let hasNextPage: Bool
    let loadingNextPage: Bool

    let error: ErrorType?

    let onAppear: VoidClosure
    let onShowLastElement: VoidClosure
    let onTap: (MessageListItemViewModel) -> Void

    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 16.0) {
                if let error = self.error,
                   case ErrorType.initial(let text, let retry) = error {

                    ErrorView(
                            title: L10n.Common.error,
                            description: text,
                            retry: retry
                    )
                }
                else {
                    ForEach(self.items, content: { vm in
                        MessageListItemView(vm: vm)
                                .onTapGesture(perform: {
                                    self.onTap(vm)
                                })
                    })
                }

                if let error = self.error, case ErrorType.nextPage(let text, let retry) = error {
                    ErrorView(
                            title: L10n.Common.error,
                            description: text,
                            retry: retry
                    )
                }

                if self.loadingNextPage {
                    ProgressView()
                            .padding()
                }

                if self.hasNextPage {
                    Color.clear
                            .onAppear(perform: self.onShowLastElement)
                }
//            }
//            .frame(maxWidth: .infinity)
//            .onAppear(perform: self.onAppear)
//        }
    }
}

struct TxListView_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationView {
        MsgListView(
                initialLoading: false,
                items: [],
                hasNextPage: false,
                loadingNextPage: true,
                error: .initial("Transaction list is not available now, please retry or come back later", retry: {}),
                onAppear: {},
                onShowLastElement: {},
                onTap: { _ in }
        )
                .navigationBarTitleDisplayMode(.inline)
//        }
    }
}
