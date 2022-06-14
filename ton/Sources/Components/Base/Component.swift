//
//  Component.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 13.06.2022.
//

import SwiftUI

protocol Component: View {
    associatedtype Content: View
    func assemble(_ serviceLocator: ServiceLocator) -> Content
}


extension Component {
    var body: some View {
        Connector<Content>(assemble: self.assemble)
    }
}

fileprivate struct Connector<V: View>: View {
    @EnvironmentObject var serviceLocator: ServiceLocator
    
    let assemble: (_ serviceLocator: ServiceLocator) -> V
    
    init(assemble: @escaping (_ serviceLocator: ServiceLocator) -> V) {
        self.assemble = assemble
    }
    
    var body: V {
        self.assemble(self.serviceLocator)
    }
}
