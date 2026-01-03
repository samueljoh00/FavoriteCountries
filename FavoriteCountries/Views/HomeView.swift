//
//  HomeView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct HomeView: View {

    @State private var showLaunchOverlay = true

    // Use the same image name here and in LaunchScreen.storyboard to match visuals.
    private let launchBackgroundImageName = "painting_home"

    init() {
        NavigationBarStyle.applyDefault()
    }

    var body: some View {
        ZStack {
            Image("painting_home")
                .resizable()
                .scaledToFit()
            FavoriteCountriesListView()
            if showLaunchOverlay {
                ZStack {
                    Image("painting_home")
                        .resizable()
                        .scaledToFit()
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation(.easeOut(duration: 0.70)) {
                    showLaunchOverlay = false
                }
            }
        }
    }
}

// MARK: Previews
#Preview {
    HomeView()
        .environment(FavoritesStore(persistenceService: PersistenceService()))
}

