import SwiftUI

public extension View {
    func contextCopy(text: String) -> some View {
        self.contextMenu(menuItems: {
            Button("L10n.Common.copy", action: {
                UIPasteboard.general.string = text
            })
        })
    }
}

public extension View {
    @ViewBuilder func conditional<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
