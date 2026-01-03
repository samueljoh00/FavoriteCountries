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
    private(set) var countries: [FavoriteCountry] = []
    private(set) var isLoaded: Bool = false
    private var persistenceService: PersistenceService
    
    init(
        persistenceService: PersistenceService
    ) {
        self.persistenceService = persistenceService
    }
    
    func loadIfNeeded() {
        guard !isLoaded else { return }
        Task { @MainActor in
            self.countries = await persistenceService.readFromDisk() ?? []
            self.isLoaded = true
        }
    }
    
    func get() -> [FavoriteCountry] { countries }
    
    func add(
        _ country: FavoriteCountry
    ) -> Bool {
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
        countries.removeAll { $0.id == country.id }
        Task { await persistenceService.writeToDisk(with: countries) }
    }
    
    func remove(
        at offsets: IndexSet
    ) {
        countries.remove(atOffsets: offsets)
        Task { await persistenceService.writeToDisk(with: countries) }
    }
    
    func update(
        _ country: FavoriteCountry,
        notes: String
    ) {
        guard let index = countries.firstIndex(where: { $0.id == country.id }) else { return }
        countries[index].notes = notes
        Task { await persistenceService.writeToDisk(with: countries) }
    }
    
    // MARK: Mock Data
    static var mockData: [FavoriteCountry] = [
        FavoriteCountry(name: "United States", capitalCity: "D.C", notes: "A country in North America"),
        FavoriteCountry(name: "France", capitalCity: "Paris", notes: "A country in Europe"),
        FavoriteCountry(name: "Japan", capitalCity: "Tokyo", notes: ""),
    ]
}

