//
//  FavoriteCountriesStoring.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 1/1/26.
//

import Foundation

@MainActor
protocol FavoriteCountriesStoring {
    func get() -> [FavoriteCountry]
    
    func add(_ country: FavoriteCountry) -> Bool
    
    func remove(_ country: FavoriteCountry)
    
    func remove(at offsets: IndexSet)
    
    func update(_ country: FavoriteCountry, notes: String)
}
