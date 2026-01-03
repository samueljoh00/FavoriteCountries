//
//  WorldBankAPIResponse.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/26/25.
//

struct WorldBankAPIResponse: Decodable {
    let metadata: Metadata
    let countries: [Country]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        // Currently parsing metadata, but not being used.
        metadata = try container.decode(Metadata.self)
        countries = try container.decode([Country].self)
    }
}

struct Metadata: Codable {
    var page: Int
    var pages: Int
    var total: Int
}

struct Country: Codable, Hashable {
    let id: String
    let name: String
    let capitalCity: String
}
