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
    @State private var showAlert: Bool = false
    @State private var isEditing: Bool = false
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

            Section(header: Text("My favorite things about \(country.name)")) {
                if isEditing {
                    TextField("Add your notes…", text: $notes, axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
                } else {
                    Text(notes)
                        .lineLimit(5, reservesSpace: false)
                }
            }
            .onDisappear {
                updateNotes()
            }
        }
        .navigationTitle(country.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if isEditing {
                    Button(
                        action: {
                            isEditing.toggle()
                        },
                        label: {
                            Text("Done")
                        })
                } else {
                    Button(
                        action: {
                            isEditing.toggle()
                        },
                        label: {
                            Image(systemName: "pencil")
                        })
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(
                    action: {
                        showAlert.toggle()
                    },
                    label: {
                        Image(systemName: "trash")
                    })
            }
        }
        .alert("Warning! Notes for a deleted country are unrecoverable.", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) { removeCountry() }
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
    let store = FavoritesStore(persistenceService: PersistenceService())

    NavigationStack {
        FavoriteCountryDetailsView(
            country: FavoriteCountry(name: "United States", capitalCity: "D.C.", notes: "Nice place")
        )
    }
    .environment(store)
}
