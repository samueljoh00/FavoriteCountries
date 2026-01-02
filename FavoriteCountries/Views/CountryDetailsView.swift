//
//  CountryDetailsView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct CountryDetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(FavoritesStore.self) private var store
    
    @State private var notes: String = ""
    @State private var showingAlert: Bool = false
    let country: Country
    
    var body: some View {
        Form {
            Section(header: Text("Country")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(country.name)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Capital")
                    Spacer()
                    Text(country.capitalCity)
                        .foregroundStyle(.secondary)
                }
            }

            Section(header: Text("My favorite things about \(country.name)")) {
                TextField("Add your notes…", text: $notes, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
        }
        .navigationTitle(country.name)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") { addCountry() }
            }
        }
        .alert("Country already favorited!", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    func addCountry() {
        guard store.add(FavoriteCountry(name: country.name, capitalCity: country.capitalCity, notes: notes)) else {
            showingAlert.toggle()
            return
        }
        dismiss()
    }
}

#Preview {
    let store = FavoritesStore(persistenceService: PersistenceService())

    NavigationStack {
        CountryDetailsView(
            country: .init(id: "USA", name: "United States", capitalCity: "D.C.")
        )
    }
    .environment(store)
}
