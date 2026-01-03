//
//  MockPersistenceService.swift
//  FavoriteCountriesTests
//
//  Created by Samuel Oh on 1/1/26.
//

import Foundation
@testable import FavoriteCountries

final class MockPersistenceService: PersistenceServicing {
    private(set) var countries: [FavoriteCountry] = []
    private var continuation: CheckedContinuation<Void, Never>?

    func readFromDisk() async -> [FavoriteCountry]? { countries }

    func writeToDisk(with countries: [FavoriteCountry]) async {
        self.countries = countries
        continuation?.resume()
        continuation = nil
    }

    func waitForNextWrite() async {
        await withCheckedContinuation { continuation = $0 }
    }
}
