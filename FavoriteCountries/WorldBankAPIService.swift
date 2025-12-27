//
//  WorldBankAPIService.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import Foundation

class WorldBankAPIService {
    /// What does this need to do?
    /// 1. Be able to fetch data from API
    /// 2. Parse data and pass into models
    /// 3. Expose models to be consumed
    ///
    /// Currently this is thread-safe as we only fetch the first page.
    /// If we were to introduce pagination, we would want to make this an
    /// actor probably to support internal state.
    ///
    
    /// This is the given API URL. Instead of doing pagination logic and making multiple calls,
    /// we could configure this API URL with specific query parameters. This could be an
    /// optimization.
    final let apiPath = "https://api.worldbank.org/v2/countries?format=json"
    
    var countries: [Country] = []
    
    func fetchData() async {
        guard let url = URL(string: apiPath) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(WorldBankAPIResponse.self, from: data)
            self.countries = response.countries.filter { $0.capitalCity != "" }
        } catch {
            print("Error: \(error)")
        }
    }
}
