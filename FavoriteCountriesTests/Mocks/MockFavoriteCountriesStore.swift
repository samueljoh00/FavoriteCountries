//
//  MockFavoriteCountriesStore.swift
//  FavoriteCountriesTests
//
//  Created by Samuel Oh on 1/1/26.
//


import SwiftUI
@testable import FavoriteCountries

class MockFavoriteCountriesStore: FavoriteCountriesStoring {
    var isLoaded: Bool
    var countries: [FavoriteCountry]
    private var failAdd: Bool = false
    
    init(countries: [FavoriteCountry], isLoaded: Bool = false) {
        self.countries = countries
        self.isLoaded = isLoaded
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
    
    // MARK: Mock Data
    static var mockData: [FavoriteCountry] = [
        FavoriteCountry(name: "United States", capitalCity: "D.C", notes: "A country in North America"),
        FavoriteCountry(name: "France", capitalCity: "Paris", notes: "A country in Europe"),
        FavoriteCountry(name: "Japan", capitalCity: "Tokyo", notes: ""),
    ]
}
