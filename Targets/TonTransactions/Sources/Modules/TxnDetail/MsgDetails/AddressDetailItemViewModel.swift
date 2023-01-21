import Foundation

struct AddressDetailItemViewModel: Hashable {
    
    let title: String
    let descr: String
    let copy: Bool
    
    init(title: String, descr: String, copy: Bool = true) {
        self.title = title
        self.descr = descr
        self.copy = copy
    }
}
