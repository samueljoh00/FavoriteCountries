//
//  PersistenceService.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 1/1/26.
//

import Foundation

protocol PersistenceServicing {
    func writeToDisk(with countries: [FavoriteCountry]) async
    func readFromDisk() async -> [FavoriteCountry]?
}

actor PersistenceService: PersistenceServicing {
    private let fileURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("favoriteCountries.json")
    }()
    
    func writeToDisk(
        with countries: [FavoriteCountry]
    ) async {
        do {
            let jsonData = try JSONEncoder().encode(countries)
            try jsonData.write(to: fileURL)
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    func readFromDisk() async -> [FavoriteCountry]?{
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let readingData = try JSONDecoder().decode([FavoriteCountry].self, from: jsonData)
            return readingData
        } catch {
            print("Error decoding data: \(error)")
        }
        
        return nil
    }
    
    
}
