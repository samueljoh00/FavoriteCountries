//
//  ContentView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: BottomNavItem = .favorites

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Favorites", systemImage: "star", value: .favorites) {
                FavoriteCountriesListView()
            }
            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                CountrySearchView(showDismiss: false)
            }
        }
    }
    
    enum BottomNavItem {
        case favorites
        case search
        case about
    }
} 
#Preview {
    ContentView()
        .environment(FavoritesStore())
}

