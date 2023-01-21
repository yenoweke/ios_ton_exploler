import Foundation
import TTAPIService

final class MsgListInteractor {
    private let output: MsgListInteractorOutput
    private let router: MsgListRouterInput
    private let itemsProvider: MsgsProvider

    private var items: [Message] = []
    private var filters: [MsgFilter] = []
    private var filteredItems: [Message] {
        var items = self.items
        for filter in filters {
            items = filter.filter(items)
        }
        return items
    }

    private var loadingInProgress = false

    init(output: MsgListInteractorOutput, router: MsgListRouterInput, itemsProvider: MsgsProvider) {
        self.output = output
        self.router = router
        self.itemsProvider = itemsProvider
    }
}

extension MsgListInteractor: MsgListInteractorInput {
    func initialLoad() {
        guard self.loadingInProgress == false else { return }
        self.loadingInProgress = true

        self.items = []
        self.output.initialLoadStarted()
        Task {
            defer {
                self.loadingInProgress = false
            }
            do {
                let items = try await self.itemsProvider.fetchInitial()
                self.items = items
                await MainActor.run {
                    self.output.didLoad(self.filteredItems, initial: true)
                }
            }
            catch {
                await MainActor.run {
                    self.output.gotInitialError(error)
                }
            }
        }
    }

    func loadNextPage() {
        guard self.loadingInProgress == false else { return }
        self.loadingInProgress = true

        self.output.nextPageLoadingStarted()
        Task {
            defer {
                self.loadingInProgress = false
            }
            do {
                let items = try await self.itemsProvider.fetchNext()
                self.items += items
                await MainActor.run {
                    self.output.didLoad(self.filteredItems, initial: true)
                }
            }
            catch  {
                await MainActor.run {
                    self.output.gotNextPageError(error)
                }
            }
        }
    }

    func onTap(_ txnID: String) {
        self.router.showTxnDetails(txnID)
    }
    
    func apply(filter: MessagesFilter?) {
        self.filters.removeAll()
        if filter?.minValue != nil || filter?.maxValue != nil {
            self.filters.append(MinMaxFilter(minValue: filter?.minValue, maxValue: filter?.maxValue))
        }
        if let type = filter?.selectedMsgType, type != .all {
            self.filters.append(TypeFilter(type: type))
        }
        self.output.didLoad(self.filteredItems, initial: false)
        self.output.filterApplied(filter)
    }
}

protocol MsgFilter {
    func filter(_ msgs: [Message]) -> [Message]
}

struct MinMaxFilter: MsgFilter {
    private let minValue: Decimal
    private let maxValue: Decimal
    
    init(minValue: Decimal?, maxValue: Decimal?) {
        self.minValue = minValue ?? .zero
        if let maxValue {
            self.maxValue = (minValue ?? .zero) > maxValue ? .greatestFiniteMagnitude : maxValue
        }
        else {
            self.maxValue = .greatestFiniteMagnitude
        }
    }

    func filter(_ msgs: [Message]) -> [Message] {
        msgs.filter { msg in
            (minValue...maxValue).contains(msg.amount.decimal)
        }
    }
}

struct TypeFilter: MsgFilter {
    private let incoming: Bool
    
    init(type: FilterMessageType) {
        self.incoming = type == .onlyIn
    }

    func filter(_ msgs: [Message]) -> [Message] {
        msgs.filter { msg in
            msg.incoming == incoming
        }
    }
}
