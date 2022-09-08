//
//  InputAddressModuleContainer.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 13.06.2022.
//

import SwiftUI

final class InputAddressModuleContainer: ModuleContainer {
    private struct ContainerView: View {
        @ObservedObject var state: InputAddressViewState
        let interactor: InputAddressInteractorInput

        var body: some View {
            InputAddressView(
                address: self.$state.address,
                onSubmit: {
                    self.interactor.onSubmit(self.state.address)
                }
            )
        }
    }
    
    static func assemble(_ dependencies: InputAddressDependencies) -> ModuleContainer {
        let state = InputAddressViewState()
        let router = InputAddressRouter(dependencies: dependencies)
        let interactor = InputAddressInteractor(output: state, router: router)
        let view = ContainerView(state: state, interactor: interactor)
        let viewController = HostingViewController(rootView: view)
        
        router.navigationControllerProvider = { [weak viewController] in
            viewController?.navigationController
        }
        router.presentingViewControllerProvider = { [weak viewController] in
            viewController
        }
        
        return InputAddressModuleContainer(viewControllerToShow: viewController, router: router)
    }
}
