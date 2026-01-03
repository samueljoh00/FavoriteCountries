//
//  MockAPIService.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 1/3/26.
//

class MockAPIService: WorldBankAPIServicing {
    
    private var shouldFail = false
    
    // MARK: Mock Data
    static var mockData: [Country] = [
        .init(id: "USA", name: "United States", capitalCity: "D.C."),
        .init(id: "FRA", name: "France", capitalCity: "Paris"),
        .init(id: "JAP", name: "Japan", capitalCity: "Tokyo")
    ]
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func fetchData() async throws -> [Country] {
        if shouldFail {
            throw MockAPIError.forcedFailure
        }
        
        return MockAPIService.mockData
    }
    
    enum MockAPIError: Error {
        case forcedFailure
    }
}
