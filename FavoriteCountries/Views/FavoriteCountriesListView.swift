//
//  FavoriteCountriesListView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct FavoriteCountriesListView: View {
    @State private var viewModel: FavoriteCountriesListViewModel
    @State private var addSheetPresenting: Bool = false
    
    init(store: FavoritesStore) {
        _viewModel = State(initialValue: FavoriteCountriesListViewModel(store: store))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                List {
                    if viewModel.isEmpty {
                        EmptyListView()
                    }
                    ForEach(viewModel.countries) { item in
                        NavigationLink {
                            FavoriteCountryDetailsView(country: item)
                        } label: {
                            FavoriteCountryItemView(item: item)
                        }
                    }
                    .onMove {
                        viewModel.move(from: $0, to: $1)
                    }
                    .onDelete { indexes in
                        viewModel.delete(at: indexes)
                    }
                }
            }
            .background(alignment: .topTrailing) {
                HomeImageView()
                    .ignoresSafeArea()
            }
            .scrollContentBackground(.hidden)
            .sheet(isPresented: $addSheetPresenting, onDismiss: didDismiss) {
                CountrySearchView(showDismiss: true)
                    .ignoresSafeArea()
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
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: Button Actions
    private func didDismiss() { }
    
    // MARK: Helper Views
    private struct FavoriteCountryItemView: View {
        private let item: FavoriteCountry
        
        init(item: FavoriteCountry) {
            self.item = item
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(item.name)
                    .avenir(weight: .medium, size: .standard)
                    .foregroundStyle(.primary)
                
                if item.notes != "" {
                    Text(item.notes)
                        .avenir(weight: .roman, size: .subtitle)
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
                    .avenir(weight: .medium, size: .standard)
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
        }
    }
}

// MARK: Previews
#Preview {
    NavigationStack {
        let store = FavoritesStore(persistenceService: PersistenceService())
        FavoriteCountriesListView(store: store)
            .environment(store)
    }
}
