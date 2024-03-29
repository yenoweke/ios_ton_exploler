import Foundation

protocol MsgListDependencies {
    var itemsProvider: MsgsProvider { get }

    func makeWalletCardDependencies() -> WalletCardDependencies
    func makeTxnDetailDependencies(txnID: TxnItem.ID) -> TxnDetailDependencies
    func makeAccountActionsDependencies() -> AccountActionsDependencies
}

struct MsgListDependenciesImpl: MsgListDependencies {
    private let serviceLocator: ServiceLocator
    private let address: String

    var itemsProvider: MsgsProvider {
        MsgsProviderImpl(
                service: self.serviceLocator.tonNetworkService,
                msgStorage: self.serviceLocator.msgsStorage,
                txnsStorage: self.serviceLocator.txnsStorage,
                address: self.address
        )
    }

    init(serviceLocator: ServiceLocator, address: String) {
        self.serviceLocator = serviceLocator
        self.address = address
    }

    func makeWalletCardDependencies() -> WalletCardDependencies {
        WalletCardDependenciesImpl(serviceLocator: self.serviceLocator, address: self.address)
    }

    func makeTxnDetailDependencies(txnID: TxnItem.ID) -> TxnDetailDependencies {
        TxnDetailDependenciesImpl(serviceLocator: self.serviceLocator, txnID: txnID)
    }

    func makeAccountActionsDependencies() -> AccountActionsDependencies {
        AccountActionsDependenciesImpl(serviceLocator: self.serviceLocator, address: self.address)
    }
    
}

protocol MsgListInteractorInput {
    func initialLoad()
    func loadNextPage()
    func onTap(_ txnID: String)
    func apply(filter: MessagesFilter?)
}

protocol MsgListInteractorOutput: AnyObject {
    func gotInitialError(_ error: Error)
    func gotNextPageError(_ error: Error)
    func initialLoadStarted()
    func didLoad(_ items: [Message], initial: Bool)
    func nextPageLoadingStarted()
    func filterApplied(_ filter: MessagesFilter?)
}

protocol MsgListRouterInput {
    func showTxnDetails(_ txnId: String)
}
