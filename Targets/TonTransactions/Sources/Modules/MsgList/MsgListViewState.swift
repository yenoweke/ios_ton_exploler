import Foundation
import TonTransactionsKit
import TonTransactionsUI

final class MsgListViewState: ObservableObject {
    @Published var listState = ListState<MessageListItemViewModel>.idle
    @Published var showFilter: Bool = false
    var filter: MessagesFilter = MessagesFilter.default

    init() {
    }
}

extension MsgListViewState {
    struct Filter {
        let msgType: FilterMessageType
        let minValue: Decimal?
        let maxValue: Decimal?
    }
}

final class MsgListViewStateModifier: MsgListInteractorOutput {
    
    private let state: MsgListViewState

    init(state: MsgListViewState) {
        self.state = state
    }

    func initialLoadStarted() {
        self.state.listState = .initialLoading
    }

    func gotInitialError(_ error: Error) {
        self.state.listState.initiallLoadError(error)
    }

    func gotNextPageError(_ error: Error) {
        self.state.listState.nextPageLoadingError(error)
    }

    func didLoad(_ items: [Message], initial: Bool) {
        Task {
            let viewModel: [MessageListItemViewModel] = items.compactMap(Self.makeViewModel)
            await MainActor.run {
                self.handleViewModels(initial: initial, viewModel: viewModel)
            }
        }
    }

    func nextPageLoadingStarted() {
        self.state.listState.nextPageLoading()
    }
    
    func filterApplied(_ filter: MessagesFilter?) {
        self.state.filter = filter ?? MessagesFilter.default
        self.state.showFilter = false
    }
}

private extension MsgListViewStateModifier {
    func handleViewModels(initial: Bool, viewModel: [MessageListItemViewModel]) {
        let hasNextPage = viewModel.isEmpty == false
        if initial {
            self.state.listState.initiallyLoaded(
                    viewModel,
                    hasNextPage: hasNextPage
            )
        }
        else {
            self.state.listState.nextPageLoaded(
                    viewModel,
                    hasNextPage: hasNextPage
            )
        }
    }

    static func makeViewModel(_ msg: Message) -> MessageListItemViewModel? {
        if msg.source.isEmpty { return nil }

        let amount: String = {
            let formatted = Formatters.ton.formatSignificant(msg.amount.decimal)
            let sign = msg.incoming ? "+" : "-"
            return sign + formatted
        }()
        return MessageListItemViewModel(
                id: msg.id,
                incoming: msg.incoming,
                fee: Formatters.ton.formatSignificant(msg.fee.decimal),
                transactionTime: Formatters.date.full(from: msg.transactionTime),
                amount: amount,
                address: msg.source,
                message: msg.message,
                txnID: msg.txnID
        )
    }
}
