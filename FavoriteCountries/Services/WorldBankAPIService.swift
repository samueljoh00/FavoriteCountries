//
//  WorldBankAPIService.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import Foundation

protocol WorldBankAPIServicing {
    func fetchData() async throws -> [Country]
}

actor WorldBankAPIService: WorldBankAPIServicing {
    final let apiPath = "https://api.worldbank.org/v2/countries?format=json"
    
    private var countries: [Country] = []
    private var hasFetched: Bool = false
    
    func fetchData() async throws -> [Country] {
        if !hasFetched {
            for page in 1...6 {
                do {
                    try await fetchData(forPage: page)
                } catch {
                    throw(error)
                }
            }
            hasFetched = true
        }
        return countries
    }
    
    private func fetchData(
        forPage page: Int
    ) async throws {
        let paginatedUrl = "\(apiPath)&page=\(page)"
        guard let url = URL(string: paginatedUrl) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response: WorldBankAPIResponse = try await MainActor.run {
                try JSONDecoder().decode(WorldBankAPIResponse.self, from: data)
            }
            self.countries.append(contentsOf: response.countries.filter { $0.capitalCity != "" })
        } catch {
            throw(error)
        }
    }
}

