//
//  FavoriteCountryDetailsView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/30/25.
//

import SwiftUI

struct FavoriteCountryDetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(FavoritesStore.self) private var store
    
    @State private var notes: String
    private let country: FavoriteCountry
    
    init(country: FavoriteCountry) {
        self.country = country
        _notes = .init(initialValue: country.notes)
    }
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

            Section(header: Text("Notes")) {
                TextField("Add your notes…", text: $notes, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
            .onDisappear {
                updateNotes()
            }
        }
        .navigationTitle(country.name)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Remove") { removeCountry() }
            }
        }
    }
    
    func removeCountry() {
        store.remove(country)
        dismiss()
    }
    
    func updateNotes() {
        store.update(country, notes: notes)
    }
}

#Preview {
    let store = FavoritesStore()

    NavigationStack {
        FavoriteCountryDetailsView(
            country: FavoriteCountry(name: "United States", capitalCity: "D.C.", notes: "Nice place")
        )
    }
    .environment(store)
}
