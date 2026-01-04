//
//  CustomFonts.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 1/3/26.
//

import SwiftUI

extension View {
    func avenir(weight: CustomFontWeight, size: CustomFontSize) -> some View {
        modifier(AvenirFont(weight: weight, size: size))
    }
}

struct AvenirFont: ViewModifier {
    var weight: CustomFontWeight
    var size: CustomFontSize

    func body(content: Content) -> some View {
        content.font(.custom("Avenir-\(weight.rawValue)", size: size.rawValue))
    }
}

enum CustomFontWeight: String {
    case book = "Book"
    case roman = "Roman"
    case medium = "Medium"
    case heavy = "Heavy"
    case black = "Black"
}

enum CustomFontSize: CGFloat {
    case largeTitle = 36
    case mediumTitle = 30
    case title = 24
    case standard = 22
    case subtitle = 20
}
