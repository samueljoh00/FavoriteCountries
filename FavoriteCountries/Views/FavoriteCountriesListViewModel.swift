//
//  FavoriteCountryDetailsViewModel.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 1/1/26.
//

import SwiftUI

@MainActor
@Observable
final class FavoriteCountriesListViewModel {
    var countries: [FavoriteCountry] { store.countries }
    var isLoaded: Bool { store.isLoaded }
    var isEmpty: Bool { store.countries.isEmpty }
    
    private let store: FavoriteCountriesStoring
    
    init(store: FavoriteCountriesStoring) {
        self.store = store
    }
    
    // MARK: Actions
    func delete(at offsets: IndexSet) {
        store.remove(at: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        store.move(fromOffsets: source, toOffset: destination)
    }
}
