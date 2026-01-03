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
        .navigationBarTitleDisplayMode(.large)
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
            VStack(alignment: .leading) {
                Text("Country")
                    .bold()
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
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
            VStack(alignment: .leading, spacing: 8) {
                Text("My favorite things about \(country.name)")
                    .bold()
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
                if isEditing {
                    TextEditor(text: $notes)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 120)
                        .padding(8)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.quaternary)
                        )
                } else {
                    Text(notes.isEmpty ? "Enter any notes..." : notes)
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

// MARK: Custom Header
/// Helper modifier for hero header effect.
/// Found here: https://medium.com/@thomasostlyng/stretchy-headers-in-swiftui-with-visualeffect-fff973568323
extension View {
    func stretchyHeader() -> some View {
        visualEffect { effect, geometry in
            let currentHeight = geometry.size.height
            let scrollOffset = geometry.frame(in: .scrollView).minY
            let positiveOffset = max(0, scrollOffset)
            
            let scaleFactor = (currentHeight + positiveOffset) / currentHeight
            
            return effect
                .scaleEffect(x: scaleFactor, y: scaleFactor, anchor: .bottom)
        }
    }
}

struct HeaderView: View {
    let randomNumber: Int
    
    var body: some View {
        ZStack {
            Image("painting_\(randomNumber)")
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 180)
                .clipped()
                .stretchyHeader()
            LinearGradient(
                colors: [
                    .clear,
                    .white.opacity(0.30)
                ],
                startPoint: .top,
                endPoint: .bottom)
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
