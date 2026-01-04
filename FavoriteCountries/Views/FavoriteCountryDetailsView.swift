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
    
    @State private var randomPaintingNum: Int = Int.random(in: 1...8)
    private let country: FavoriteCountry
    
    init(country: FavoriteCountry) {
        self.country = country
        _notes = .init(initialValue: country.notes)
        CustomNavigationBarStyle.applySecondaryTitleFont()
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HeaderView(randomNumber: randomPaintingNum)
                FavoriteCountryDetailsSection(country: country)
                    .padding(.horizontal, 20)
                FavoriteCountryNotesSection(country: country, notes: $notes, isEditing: isEditing)
                    .padding(.horizontal, 20)
            }
        }
        .ignoresSafeArea()
        .toolbar { toolbarContent }
        .alert("Warning! Notes for a deleted country are unrecoverable.", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove \(country.name)", role: .destructive) { removeCountry() }
        }
        .navigationTitle(country.name)
    }
    
    // MARK: Button Actions
    func removeCountry() {
        store.remove(country)
        dismiss()
    }
    
    func updateNotes() {
        store.update(country, notes: notes)
    }
    
    // MARK: Helper Views
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            editButton
        }
        ToolbarItem(placement: .destructiveAction) {
            deleteButton
        }
    }
    
    private var editButton: some View {
        Button {
            if isEditing {
                updateNotes()
            }
            isEditing.toggle()
        } label: {
            if isEditing {
                Text("Done")
            } else {
                Image(systemName: "pencil")
            }
        }
    }

    private var deleteButton: some View {
        Button {
            showAlert.toggle()
        } label: {
            Image(systemName: "trash")
        }
    }
    
    private struct FavoriteCountryDetailsSection: View {
        let country: FavoriteCountry
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text("Country")
                    .avenir(weight: .medium, size: .standard)
                    .bold()
                    .foregroundStyle(.secondary)
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
    
    private struct FavoriteCountryNotesSection: View {
        let country: FavoriteCountry
        @Binding var notes: String
        let isEditing: Bool
        
        init(country: FavoriteCountry, notes: Binding<String>, isEditing: Bool) {
            self.country = country
            self._notes = notes
            self.isEditing = isEditing
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text("My favorite things about \(country.name)")
                    .avenir(weight: .medium, size: .standard)
                    .foregroundStyle(.secondary)
                    .bold()
                if isEditing {
                    TextEditor(text: $notes)
                        .avenir(weight: .roman, size: .subtitle)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 120, alignment: .leading)
                        .padding(6)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.quaternary)
                        )
                } else {
                    Text(notes.isEmpty ? "Enter any notes..." : notes)
                        .avenir(weight: .roman, size: .subtitle)
                        .textSelection(.enabled)
                        .foregroundStyle(notes.isEmpty ? .secondary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.quaternary)
                        )
                }
            }
        }
    }
}

// MARK: Previews
#Preview {
    let store = FavoritesStore(persistenceService: PersistenceService())
    
    NavigationStack {
        FavoriteCountryDetailsView(
            country: FavoriteCountry(name: "United States", capitalCity: "D.C.", notes: "Nice place")
        )
    }
    .environment(store)
}
