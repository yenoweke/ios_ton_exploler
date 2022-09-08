import Foundation
import TTAPIService

final class MsgListInteractor {
    private let output: MsgListInteractorOutput
    private let router: MsgListRouterInput
    private let itemsProvider: MsgsProvider

    private var items: [Message] = []

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
                    self.output.didLoad(self.items, initial: true)
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
                    self.output.didLoad(self.items, initial: true)
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
}