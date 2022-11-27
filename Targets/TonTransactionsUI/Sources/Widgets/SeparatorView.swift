import SwiftUI

public struct SeparatorView: View {
    public init() {}

    public var body: some View {
        Rectangle()
                .background(Color.gray)
                .frame(height: 1.0)
                .opacity(0.1)
    }
}
