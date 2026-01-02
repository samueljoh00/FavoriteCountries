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
            HomeView()
                .environment(store)
                .environment(\.dataManager, apiService)
        }
    }
    
    private let persistence: PersistenceService
    private let store: FavoritesStore
    private let apiService: WorldBankAPIService
    
    init() {
        self.persistence = PersistenceService()
        self.store = FavoritesStore(persistenceService: persistence)
        self.apiService = WorldBankAPIService()
    }
}

struct DataManagerKey: EnvironmentKey {
    static let defaultValue = WorldBankAPIService()
}

extension EnvironmentValues {
    var dataManager: WorldBankAPIService {
        get { self[DataManagerKey.self] }
        set { self[DataManagerKey.self] = newValue }
    }
}


