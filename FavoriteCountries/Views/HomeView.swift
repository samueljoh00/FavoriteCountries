//
//  HomeView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(FavoritesStore.self) private var store
    @State private var showLaunchOverlay = true

    private let launchBackgroundImageName = "painting_home"

    init() {
        NavigationBarStyle.applyDefault()
    }

    var body: some View {
        ZStack {
            FavoriteCountriesListView(store: store)
            if showLaunchOverlay {
                ZStack {
                    Image(launchBackgroundImageName)
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
                withAnimation(.easeOut(duration: 0.50)) {
                    showLaunchOverlay = false
                }
            }
        }
    }
}

// MARK: Previews
#Preview("Happy Path") {
    HomeView()
        .environment(FavoritesStore(persistenceService: PersistenceService()))
}

#Preview("API Failure") {
    HomeView()
        .environment(FavoritesStore(persistenceService: PersistenceService()))
        .environment(\.dataManager, MockAPIService(shouldFail: true))
}


