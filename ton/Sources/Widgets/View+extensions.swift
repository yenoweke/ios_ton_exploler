//
// Created by Dmitrii Chikovinskii on 10.06.2022.
//

import SwiftUI

extension View {
    func contextCopy(text: String) -> some View {
        self.contextMenu(menuItems: {
            Button("Скопировать", action: {
                UIPasteboard.general.string = text
            })
        })
    }
}

extension View {
    @ViewBuilder func conditional<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
