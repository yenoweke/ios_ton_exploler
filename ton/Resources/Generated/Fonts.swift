// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum Fonts {
  internal enum Mulish {
    internal static let black = FontConvertible(name: "Mulish-Black", family: "Mulish", path: "Mulish-Black.ttf")
    internal static let blackItalic = FontConvertible(name: "Mulish-BlackItalic", family: "Mulish", path: "Mulish-BlackItalic.ttf")
    internal static let bold = FontConvertible(name: "Mulish-Bold", family: "Mulish", path: "Mulish-Bold.ttf")
    internal static let boldItalic = FontConvertible(name: "Mulish-BoldItalic", family: "Mulish", path: "Mulish-BoldItalic.ttf")
    internal static let extraBold = FontConvertible(name: "Mulish-ExtraBold", family: "Mulish", path: "Mulish-ExtraBold.ttf")
    internal static let extraBoldItalic = FontConvertible(name: "Mulish-ExtraBoldItalic", family: "Mulish", path: "Mulish-ExtraBoldItalic.ttf")
    internal static let extraLight = FontConvertible(name: "Mulish-ExtraLight", family: "Mulish", path: "Mulish-ExtraLight.ttf")
    internal static let extraLightItalic = FontConvertible(name: "Mulish-ExtraLightItalic", family: "Mulish", path: "Mulish-ExtraLightItalic.ttf")
    internal static let italic = FontConvertible(name: "Mulish-Italic", family: "Mulish", path: "Mulish-Italic.ttf")
    internal static let light = FontConvertible(name: "Mulish-Light", family: "Mulish", path: "Mulish-Light.ttf")
    internal static let lightItalic = FontConvertible(name: "Mulish-LightItalic", family: "Mulish", path: "Mulish-LightItalic.ttf")
    internal static let medium = FontConvertible(name: "Mulish-Medium", family: "Mulish", path: "Mulish-Medium.ttf")
    internal static let mediumItalic = FontConvertible(name: "Mulish-MediumItalic", family: "Mulish", path: "Mulish-MediumItalic.ttf")
    internal static let regular = FontConvertible(name: "Mulish-Regular", family: "Mulish", path: "Mulish-Regular.ttf")
    internal static let semiBold = FontConvertible(name: "Mulish-SemiBold", family: "Mulish", path: "Mulish-SemiBold.ttf")
    internal static let semiBoldItalic = FontConvertible(name: "Mulish-SemiBoldItalic", family: "Mulish", path: "Mulish-SemiBoldItalic.ttf")
    internal static let all: [FontConvertible] = [black, blackItalic, bold, boldItalic, extraBold, extraBoldItalic, extraLight, extraLightItalic, italic, light, lightItalic, medium, mediumItalic, regular, semiBold, semiBoldItalic]
  }
  internal static let allCustomFonts: [FontConvertible] = [Mulish.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
