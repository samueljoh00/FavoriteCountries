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
    
    init(country: Country) {
        self.country = country
        NavigationBarStyle.applySecondaryTitleFont()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CountryDetailsSection(country: country)
                    .padding(.horizontal, 20)
                CountryNotesSection(country: country, notes: $notes)
                    .padding(.horizontal, 20)
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
    
    // MARK: Button Actions
    func addCountry() {
        guard store.add(FavoriteCountry(name: country.name, capitalCity: country.capitalCity, notes: notes)) else {
            showingAlert.toggle()
            return
        }
        dismiss()
    }
    
    // MARK: Helper Views
    private struct CountryDetailsSection: View {
        let country: Country
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Country")
                    .bold()
                    .foregroundStyle(.secondary)
                    .avenir(weight: .medium, size: .standard)
                VStack(spacing: 0) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(country.name)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 12)
                    Divider()
                    HStack {
                        Text("Capital")
                        Spacer()
                        Text(country.capitalCity)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 12)
                }
                .avenir(weight: .roman, size: .subtitle)
                .padding(.horizontal, 12)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.quaternary)
                )
            }
        }
    }
    
    private struct CountryNotesSection: View {
        let country: Country
        @Binding var notes: String
        
        init(country: Country, notes: Binding<String>) {
            self.country = country
            self._notes = notes
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("My favorite things about \(country.name)")
                    .bold()
                    .foregroundStyle(.secondary)
                    .avenir(weight: .medium, size: .standard)
                TextEditor(text: $notes)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 120)
                    .padding(8)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.quaternary))
                    .avenir(weight: .roman, size: .subtitle)
            }
        }
    }
}

// MARK: Previews
#Preview {
    let store = FavoritesStore(persistenceService: PersistenceService())

    NavigationStack {
        CountryDetailsView(
            country: .init(id: "USA", name: "United States", capitalCity: "D.C.")
        )
    }
    .environment(store)
}
