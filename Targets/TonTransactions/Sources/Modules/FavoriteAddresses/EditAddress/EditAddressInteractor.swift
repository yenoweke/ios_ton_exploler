import Foundation

final class EditAddressInteractor: EditAddressInteractorInput {
    private weak var output: EditAddressInteractorOutput?
    private weak var moduleOutput: EditAddressModuleOutput?

    private let router: EditAddressRouterInput
    private let storage: WatchlistStorage
    private let fullAddress: String
    private var editAddress: String = ""

    init(output: EditAddressInteractorOutput, router: EditAddressRouterInput, fullAddress: String, storage: WatchlistStorage, moduleOutput: EditAddressModuleOutput?) {
        self.output = output
        self.router = router
        self.storage = storage
        self.fullAddress = fullAddress
        self.moduleOutput = moduleOutput
        output.didUpdate(storage.shortName(for: fullAddress))
    }

    func update(_ address: String) {
        self.editAddress = address
        self.output?.didUpdate(address)
    }

    func save() {
        if editAddress.isEmpty, editAddress.count  >= 3 { return } // TODO: Show error
        self.storage.set(shortName: self.editAddress, for: self.fullAddress)
        self.moduleOutput?.didFinish()
    }
}
