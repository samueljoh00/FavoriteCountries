//
//  WorldBankAPIService.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import Foundation

actor WorldBankAPIService {
    final let apiPath = "https://api.worldbank.org/v2/countries?format=json"
    
    private var countries: [Country] = []
    private var hasFetched: Bool = false
    
    func fetchData() async -> [Country] {
        if !hasFetched {
            for page in 1...6 {
                await fetchData(forPage: page)
            }
            print("XXDEBUG: Fetched all data!")
            hasFetched = true
        }
        return countries
    }
    
    private func fetchData(
        forPage page: Int
    ) async {
        let paginatedUrl = "\(apiPath)&page=\(page)"
        guard let url = URL(string: paginatedUrl) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response: WorldBankAPIResponse = try await MainActor.run {
                try JSONDecoder().decode(WorldBankAPIResponse.self, from: data)
            }
            self.countries.append(contentsOf: response.countries.filter { $0.capitalCity != "" })
        } catch {
            print("XXDEBUG: Error: \(error)")
        }
    }
}

