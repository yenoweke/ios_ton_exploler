import Foundation


final class MsgDetailsInteractor {
    private weak var output: MsgDetailsInteractorOutput?
    private let router: MsgDetailsRouterInput
    private let msgStorage: MsgStorage
    private let msgID: String

    init(
            output: MsgDetailsInteractorOutput,
            router: MsgDetailsRouterInput,
            msgStorage: MsgStorage,
            msgID: String) {

        self.output = output
        self.router = router
        self.msgStorage = msgStorage
        self.msgID = msgID
    }
}

extension MsgDetailsInteractor: MsgDetailsInteractorInput {
    func load() {
        guard let msg = self.msgStorage.get(by: self.msgID) else {
            self.output?.gotError(MsgDetailsInteractorError.messageNotFound)
            return
        }
        self.output?.didLoad(msg)
    }

    func onTap(_ address: String) {
        self.router.showTransactions(for: address)
    }
}

enum MsgDetailsInteractorError: Error {
    case messageNotFound
}