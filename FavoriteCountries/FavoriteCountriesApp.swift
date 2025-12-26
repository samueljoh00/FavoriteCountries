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
        // parse JSON into data models
        // initialize store
        // load data into store
    }
}
