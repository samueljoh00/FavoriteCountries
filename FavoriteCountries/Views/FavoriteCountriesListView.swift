//
//  FavoriteCountriesListView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct FavoriteCountriesListView: View {
    
    @Environment(FavoritesStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var addSheetPresenting: Bool = false
    
    var body: some View {
        let countries = store.get()

        NavigationStack {
            List {
                if countries.isEmpty {
                    EmptyListView()
                }
                ForEach(countries) { item in
                    NavigationLink {
                        FavoriteCountryDetailsView(country: item)
                    } label: {
                        FavoriteCountryItemView(item: item)
                    }
                }
                .onDelete { indexes in
                    deleteItems(at: indexes)
                }
            }
            .sheet(isPresented: $addSheetPresenting, onDismiss: didDismiss) {
                CountrySearchView(showDismiss: true)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        addSheetPresenting.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Favorite Countries")
        }
    }
    
    private func didDismiss() {
        dismiss()
    }
    
    private func deleteItems(at offsets: IndexSet) {
        store.remove(at: offsets)
    }
}

struct FavoriteCountryItemView: View {
    private let item: FavoriteCountry
    
    init(item: FavoriteCountry) {
        self.item = item
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.title3)
                .bold()
            
            if item.notes != "" {
                Text(item.notes)
                    .lineLimit(5, reservesSpace: false)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct EmptyListView: View {
    var body: some View {
        ZStack {
            Text("No favorite countries found.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    FavoriteCountriesListView()
        .environment(FavoritesStore(persistenceService: PersistenceService()))
}
