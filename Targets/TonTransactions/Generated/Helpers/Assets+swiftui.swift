import TonTransactionsUI
#if canImport(SwiftUI)
import SwiftUI
#endif

typealias AppColor = Asset.Colors
typealias AppImage = Asset.Images

extension ImageAsset {
    var swiftUI: SwiftUI.Image {
        SwiftUI.Image(self.name, bundle: BundleToken.bundle)
    }
}

private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
