//
// Created by Dmitrii Chikovinskii on 13.06.2022.
//

import SwiftUI
import UIKit

typealias AppFont = Fonts.Mulish

fileprivate extension FontConvertible.Font {

    static func mappedFont(_ name: String, textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
        let fontStyle = self.mapToUIFontTextStyle(textStyle)
        let fontSize = UIFont.preferredFont(forTextStyle: fontStyle).pointSize
        return SwiftUI.Font.custom(name, size: fontSize, relativeTo: textStyle)
    }

    static func mapToUIFontTextStyle(_ textStyle: SwiftUI.Font.TextStyle) -> UIFont.TextStyle {
        switch textStyle {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title1
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .subheadline:
            return .subheadline
        case .callout:
            return .callout
        case .body:
            return .body
        case .caption:
            return .caption1
        case .caption2:
            return .caption2
        case .footnote:
            return .footnote
        @unknown default:
            fatalError("Missing a TextStyle mapping")
        }
    }
}

extension FontConvertible {
    func textStyle(_ textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
        Font.mappedFont(name, textStyle: textStyle)
    }
}
