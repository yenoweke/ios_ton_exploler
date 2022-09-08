import Foundation

protocol MsgDetailsDependencies {
    var msgID: String { get }
    var msgStorage: MsgStorage { get }

    func makeMsgListDependencies(address: String) -> MsgListDependencies
}

struct MsgDetailsDependenciesImpl: MsgDetailsDependencies {
    private let serviceLocator: ServiceLocator
    let msgID: String

    var msgStorage: MsgStorage {
        self.serviceLocator.msgsStorage
    }

    init(serviceLocator: ServiceLocator, msgID: String) {
        self.serviceLocator = serviceLocator
        self.msgID = msgID
    }

    func makeMsgListDependencies(address: String) -> MsgListDependencies {
        TxListDependenciesImpl(serviceLocator: self.serviceLocator, address: address)
    }
}

protocol MsgDetailsInteractorInput {
    func onTap(_ address: String)
    func load()
}

protocol MsgDetailsInteractorOutput: AnyObject {
    func didLoad(_ message: Message)
    func gotError(_ error: MsgDetailsInteractorError)
}

protocol MsgDetailsRouterInput {
    func showTransactions(for address: String)
}
