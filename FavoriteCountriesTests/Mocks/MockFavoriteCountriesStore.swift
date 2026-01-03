//
//  MockFavoriteCountriesStore.swift
//  FavoriteCountriesTests
//
//  Created by Samuel Oh on 1/1/26.
//

import SwiftUI
@testable import FavoriteCountries

class MockFavoriteCountriesStore: FavoriteCountriesStoring {
    
    private var countries: [FavoriteCountry]
    private var failAdd: Bool = false
    
    init(countries: [FavoriteCountry]) {
        self.countries = countries
    }
    
    func toggleFailAdd() {
        failAdd.toggle()
    }
    
    func add(_ country: FavoriteCountries.FavoriteCountry) -> Bool {
        if failAdd { return false }
        countries.append(country)
        return true
    }
    
    func remove(_ country: FavoriteCountries.FavoriteCountry) {
        countries.removeAll { $0.id == country.id }
    }
    
    func remove(at offsets: IndexSet) {
        countries.remove(atOffsets: offsets)
    }
    
    func move(fromOffsets: IndexSet, toOffset: Int) {
        countries.move(fromOffsets: fromOffsets, toOffset: toOffset)
    }
    
    func update(_ country: FavoriteCountries.FavoriteCountry, notes: String) {
        guard let index = countries.firstIndex(where: { $0.id == country.id }) else { return }
        countries[index].notes = notes
    }
    
    
}
