//
//  FavoriteCountriesApp.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

@main
struct FavoriteCountriesApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(FavoritesStore())
                .environment(\.dataManager, WorldBankAPIService())
        }
    }
    
    init() {
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
