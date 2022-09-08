import Foundation

final class InputAddressRouter: BaseRouter, InputAddressRouterInput {
    private let dependencies: InputAddressDependencies
    
    init(dependencies: InputAddressDependencies) {
        self.dependencies = dependencies
    }
    
    func show(_ error: Error) {
        
    }
    
    func showTransactions(for address: String) {
        let container = MsgListModuleContainer.assemble(self.dependencies.makeMsgListDependencies(address: address))
        self.push(container)
    }
}
