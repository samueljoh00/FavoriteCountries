//
//  StretchyHeader.swift
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
