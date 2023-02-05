#if canImport(SwiftUI)
import SwiftUI
#endif

typealias KitColor = Asset.Colors
typealias KitImage = Asset.Images

public extension  ColorAsset {
    var swiftUI: SwiftUI.Color {
        SwiftUI.Color(self.name, bundle: BundleToken.bundle)
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
