//
//  FavoriteCountriesStore.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import Foundation
import SwiftUI

@MainActor
@Observable class FavoritesStore {
    
    var countries: [FavoriteCountry] = mockData
    
    func add(_ country: FavoriteCountry) {
        print("XXDEBUG: Adding country \(country.name) to store...")
        countries.append(country)
    }
    
    func remove(_ country: FavoriteCountry) {
        print("XXDEBUG: Removing country \(country.name) to store...")
        countries.removeAll { $0.name == country.name }
    }
    
    func update(_ country: FavoriteCountry, notes: String) {
        print("XXDEBUG: Updating country \(country.name) notes...")
        guard let index = countries.firstIndex(where: { $0.id == country.id }) else { return }
        countries[index].notes = notes
    }
    
    static var mockData: [FavoriteCountry] = [
        FavoriteCountry(name: "United States", capitalCity: "D.C", notes: "A country in North America"),
        FavoriteCountry(name: "France", capitalCity: "Paris", notes: "A country in Europe"),
        FavoriteCountry(name: "Japan", capitalCity: "Tokyo", notes: ""),
    ]
}
