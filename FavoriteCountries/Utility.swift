//
//  Utility.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 1/1/26.
//

import SwiftUI

// MARK: Custom Hero Header
/// Helper modifier for hero header effect.
/// Source: https://medium.com/@thomasostlyng/stretchy-headers-in-swiftui-with-visualeffect-fff973568323
extension View {
    func stretchyHeader() -> some View {
        visualEffect { effect, geometry in
            let currentHeight = geometry.size.height
            let scrollOffset = geometry.frame(in: .scrollView).minY
            let positiveOffset = max(0, scrollOffset)
            
            let scaleFactor = (currentHeight + positiveOffset) / currentHeight
            
            return effect
                .scaleEffect(x: scaleFactor, y: scaleFactor, anchor: .bottom)
        }
    }
}

struct HeaderView: View {
    let randomNumber: Int
    
    var body: some View {
        ZStack {
            Image("painting_\(randomNumber)")
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 180)
                .clipped()
                .stretchyHeader()
            LinearGradient(
                colors: [
                    .clear,
                    .white.opacity(0.30)
                ],
                startPoint: .top,
                endPoint: .bottom)
        }
    }
}

// MARK: Custom Fonts
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

// MARK: Custom Navigation Titles
enum NavigationBarStyle {
    static func applyDefault() {
        let largeTitleFont = UIFont(
            name: "Avenir-Heavy",
            size: CustomFontSize.largeTitle.rawValue
        ) ?? .systemFont(ofSize: CustomFontSize.largeTitle.rawValue)
        let titleFont = UIFont(
            name: "Avenir-Heavy",
            size: CustomFontSize.subtitle.rawValue
        ) ?? .systemFont(ofSize: CustomFontSize.subtitle.rawValue)

        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: largeTitleFont,
            .foregroundColor: UIColor.black
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
    }
    
    static func applySecondaryTitleFont() {
        let mediumTitleFont = UIFont(
            name: "Avenir-Heavy",
            size: CustomFontSize.mediumTitle.rawValue
        ) ?? .systemFont(ofSize: CustomFontSize.mediumTitle.rawValue)
        let titleFont = UIFont(
            name: "Avenir-Heavy",
            size: CustomFontSize.subtitle.rawValue
        ) ?? .systemFont(ofSize: CustomFontSize.subtitle.rawValue)

        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: mediumTitleFont,
            .foregroundColor: UIColor.black
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
    }
}
