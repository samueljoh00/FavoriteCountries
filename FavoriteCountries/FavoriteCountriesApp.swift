//
//  FavoriteCountriesApp.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

@main
struct FavoriteCountriesApp: App {
    @State private var isReady = false
    
    private let persistence: PersistenceServicing
    private let store: FavoritesStore
    private let apiService: WorldBankAPIService
    
    init() {
        self.persistence = PersistenceService()
        self.store = FavoritesStore(persistenceService: persistence)
        self.apiService = WorldBankAPIService()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isReady {
                    HomeView()
                        .environment(store)
                        .environment(\.dataManager, apiService)
                } else {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                }
            }
            .task {
                await store.loadIfNeeded()
                isReady = true
            }
        }
    }
}

// MARK: Custom Environment Keys
struct DataManagerKey: EnvironmentKey {
    static let defaultValue = WorldBankAPIService()
}

extension EnvironmentValues {
    var dataManager: WorldBankAPIService {
        get { self[DataManagerKey.self] }
        set { self[DataManagerKey.self] = newValue }
    }
}


