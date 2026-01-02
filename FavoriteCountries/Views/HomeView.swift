//
//  HomeView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        FavoriteCountriesListView()
    }
} 
#Preview {
    HomeView()
        .environment(FavoritesStore(persistenceService: PersistenceService()))
}

