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
    private let apiService: WorldBankAPIServicing
    private let store: FavoritesStore
    
    init() {
        self.persistence = PersistenceService()
        self.apiService = WorldBankAPIService()
        self.store = FavoritesStore(persistenceService: persistence)
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
    static let defaultValue: WorldBankAPIServicing = WorldBankAPIService()
}

extension EnvironmentValues {
    var dataManager: WorldBankAPIServicing {
        get { self[DataManagerKey.self] as WorldBankAPIServicing }
        set { self[DataManagerKey.self] = newValue }
    }
}

