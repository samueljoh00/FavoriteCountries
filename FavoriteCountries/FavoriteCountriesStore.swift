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
        countries.append(country)
    }
    
    func remove(_ country: FavoriteCountry) {
        countries.removeAll { $0.name == country.name }
    }
    
    static var mockData: [FavoriteCountry] = [
        FavoriteCountry(name: "United States", notes: "A country in North America"),
        FavoriteCountry(name: "France", notes: "A country in Europe"),
        FavoriteCountry(name: "Japan", notes: "A country in Asia"),
    ]
}
