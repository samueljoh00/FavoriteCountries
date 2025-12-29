//
//  FavoriteCountriesApp.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

@main
struct FavoriteCountriesApp: App {
    
    @State private var store: FavoritesStore = FavoritesStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.favoritesStore, store)
                .environment(\.dataManager, WorldBankAPIService())
        }
    }
    
    init() {
        /// Currently fetching data at launch.
        /// Could make this optional and allow/disallow preloading.
        /// Could also call fetchData when search view is presented,
        /// since that's the only time it matters.
//        let wbService = WorldBankAPIService()
    }
}

// Define a custom environment key
struct DataManager: EnvironmentKey {
    static let defaultValue = WorldBankAPIService()
}

// Extend EnvironmentValues
extension EnvironmentValues {
    var dataManager: WorldBankAPIService {
        get { self[DataManager.self] }
        set { self[DataManager.self] = newValue }
    }
}

// Define a custom environment key
struct FavoritesStoreKey: EnvironmentKey {
    static let defaultValue = FavoritesStore()
}

// Extend EnvironmentValues
extension EnvironmentValues {
    var favoritesStore: FavoritesStore {
        get { self[FavoritesStoreKey.self] }
        set { self[FavoritesStore.self] = newValue }
    }
}
