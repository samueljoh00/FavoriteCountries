//
//  PersistenceService.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 1/1/26.
//

import Foundation

/**
 
 */
actor PersistenceService {
    
    static var fileURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("favoriteCountries.json")
    }()
    
    func writeToDisk(
        with countries: [FavoriteCountry]
    ) {
        do {
            let jsonData = try JSONEncoder().encode(countries)
            try jsonData.write(to: PersistenceService.fileURL)
            print("XXDEBUG: Wrote to disk...")
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    func readFromDisk() -> [FavoriteCountry]? {
        do {
            let jsonData = try Data(contentsOf: PersistenceService.fileURL)
            let readingData = try JSONDecoder().decode([FavoriteCountry].self, from: jsonData)
            print("XXDEBUG: Read from disk...")
            return readingData
        } catch {
            print("Error decoding data: \(error)")
        }
        
        return nil
    }
    
    
}
