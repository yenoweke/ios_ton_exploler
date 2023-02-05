import TonTransactionsUI
#if canImport(SwiftUI)
import SwiftUI
#endif

typealias AppColor = Asset.Colors
typealias AppImage = Asset.Images

extension ImageAsset {
    var swiftUI: SwiftUI.Image {
        SwiftUI.Image(self.name)
    }
}
