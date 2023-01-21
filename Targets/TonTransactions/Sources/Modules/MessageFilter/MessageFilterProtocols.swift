import Foundation

protocol MessageFilterDependencies {

}

struct MessageFilterDependenciesImpl: MessageFilterDependencies {
    private let serviceLocator: ServiceLocator
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }
}

protocol MessageFilterInteractorInput {

}

protocol MessageFilterInteractorOutput: AnyObject {

}

protocol MessageFilterRouterInput {

}
