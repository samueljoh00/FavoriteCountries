//
//  HomeImageView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 1/3/26.
//

import SwiftUI

struct HomeImageView: View {
    var body: some View {
        Image("painting_home")
            .resizable()
            .scaledToFill()
    }
}

struct HomeImageGradientView: View {
    var body: some View {
        ZStack {
            HomeImageView()
            LinearGradient(
                colors: [
                    .white.opacity(0.30),
                    .black.opacity(0.60)
                ],
                startPoint: .top,
                endPoint: .bottom)
        }
    }
}
