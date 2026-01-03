//
//  FavoriteCountriesListView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct FavoriteCountriesListView: View {
    @Environment(FavoritesStore.self) private var store
    
    @State private var addSheetPresenting: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                let countries = store.countries
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
            }
            .background(alignment: .topLeading) {
                HomeImageView()
            }
            .scrollContentBackground(.hidden)
            .sheet(isPresented: $addSheetPresenting, onDismiss: didDismiss) {
                CountrySearchView(showDismiss: true)
                    .ignoresSafeArea()
            }
            .toolbar {
                if store.isLoaded && !store.get().isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
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
            .task {
                store.loadIfNeeded()
            }
        }
    }
    
    // MARK: Button Actions
    private func didDismiss() { }
    
    private func deleteItems(at offsets: IndexSet) {
        store.remove(at: offsets)
    }
    
    // MARK: Helper Views
    private struct FavoriteCountryItemView: View {
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
    
    private struct EmptyListView: View {
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
    
    private struct HomeImageView: View {
        var body: some View {
            ZStack {
                Image("painting_home")
                    .resizable()
                    .scaledToFill()
                LinearGradient(
                    colors: [
                        .white.opacity(0.30),
                        .black.opacity(0.60)
                    ],
                    startPoint: .top,
                    endPoint: .bottom)
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: Previews
#Preview {
    FavoriteCountriesListView()
        .environment(FavoritesStore(persistenceService: PersistenceService()))
}
