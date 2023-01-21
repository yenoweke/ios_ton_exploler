//
//  Assets+swiftui.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 13.06.2022.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

typealias AppColor = Asset.Colors
typealias AppImage = Asset.Images

extension  ColorAsset {
    var swiftUI: SwiftUI.Color {
        SwiftUI.Color(self.name)
    }
}


extension ImageAsset {
    var swiftUI: SwiftUI.Image {
        SwiftUI.Image(self.name)
    }
}
