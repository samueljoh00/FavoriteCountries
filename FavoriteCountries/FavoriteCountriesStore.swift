//
//  FavoriteCountriesStore.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import Foundation
import SwiftUI

@MainActor
@Observable final class FavoritesStore: FavoriteCountriesStoring {
    private var countries: [FavoriteCountry] = []
    private var persistenceService: PersistenceService
    
    func get() -> [FavoriteCountry] { countries }
    
    func add(
        _ country: FavoriteCountry
    ) -> Bool {
        print("XXDEBUG: Attempting to add country \(country.name) to store...")
        guard !countries.contains(where: { $0.id == country.id || $0.name == country.name }) else {
            return false
        }
        countries.append(country)
        Task { await persistenceService.writeToDisk(with: countries) }
        return true
    }
    
    func remove(
        _ country: FavoriteCountry
    ) {
        print("XXDEBUG: Removing country \(country.name) to store...")
        countries.removeAll { $0.id == country.id }
        Task { await persistenceService.writeToDisk(with: countries) }
    }
    
    func remove(
        at offsets: IndexSet
    ) {
        print("XXDEBUG: Removing countries from store...")
        countries.remove(atOffsets: offsets)
        Task { await persistenceService.writeToDisk(with: countries) }
    }
    
    func update(
        _ country: FavoriteCountry,
        notes: String
    ) {
        print("XXDEBUG: Updating country \(country.name) notes...")
        guard let index = countries.firstIndex(where: { $0.id == country.id }) else { return }
        countries[index].notes = notes
        Task { await persistenceService.writeToDisk(with: countries) }
    }
    
    init(
        persistenceService: PersistenceService
    ) {
        self.persistenceService = persistenceService
        Task { @MainActor in self.countries = await persistenceService.readFromDisk() ?? [] }
    }
    
    static var mockData: [FavoriteCountry] = [
        FavoriteCountry(name: "United States", capitalCity: "D.C", notes: "A country in North America"),
        FavoriteCountry(name: "France", capitalCity: "Paris", notes: "A country in Europe"),
        FavoriteCountry(name: "Japan", capitalCity: "Tokyo", notes: ""),
    ]
}

