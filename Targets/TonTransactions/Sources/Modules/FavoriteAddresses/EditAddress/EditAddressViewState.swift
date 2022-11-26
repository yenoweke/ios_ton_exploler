import Foundation

final class EditAddressViewState: ObservableObject {
    let fullAddress: String
    @Published var address: String = ""

    init(fullAddress: String) {
        self.fullAddress = fullAddress
    }
}

extension EditAddressViewState: EditAddressInteractorOutput {
    func didUpdate(_ address: String) {
        self.address = address
    }
}
