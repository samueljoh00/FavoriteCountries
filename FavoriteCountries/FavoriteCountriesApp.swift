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
                .environment(store)
        }
    }
    
    init() {
        /// Currently fetching data at launch.
        /// Could make this optional and allow/disallow preloading.
        /// We could preload the first page, and then have subsequent pages
        /// call the API.
        let wbService = WorldBankAPIService()
        Task { await wbService.fetchData() }
    }
}
