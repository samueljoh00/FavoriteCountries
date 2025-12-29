//
//  CountryDetailsView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct CountryDetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.favoritesStore) private var store
    
    let country: Country
    
    var body: some View {
        VStack {
            Button(action: {
                addCountry()
            }) {
                Text("Add")
            }
            Text("Country Name")
            Text("Notes")
        }
    }
    
    func addCountry() {
        store.add(FavoriteCountry(name: country.name, notes: "notes"))
        dismiss()
    }
}

#Preview {
    CountryDetailsView(country: .init(id: "USA", name: "United States", capitalCity: "D.C."))
}
