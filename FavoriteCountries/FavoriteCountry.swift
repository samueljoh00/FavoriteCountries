//
//  FavoriteCountry.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import Foundation

/**
 This serves as the data model for a FavoriteCountry item.
 */
struct FavoriteCountry: Identifiable {
    let id: UUID = UUID()
    let name: String
    let notes: String
}
