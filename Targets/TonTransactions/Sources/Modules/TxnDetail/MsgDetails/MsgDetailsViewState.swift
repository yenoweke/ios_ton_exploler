import Foundation

final class MsgDetailsViewState: ObservableObject {
    @Published var viewModel: MsgDetailViewModel? = nil

    init() {
    }
}

extension MsgDetailsViewState: MsgDetailsInteractorOutput {
    func didLoad(_ message: Message) {
        self.viewModel = MsgDetailViewModel(msg: message)
    }

    func gotError(_ error: MsgDetailsInteractorError) {
        // TODO: handle
    }
}
