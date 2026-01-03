//
//  CountrySearchView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct CountrySearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dataManager) private var dataManager
    @Environment(FavoritesStore.self) private var store
    
    @State private var countries: [Country] = []
    @State private var searchText: String = ""
    @State private var dataLoaded: Bool = false
    
    private let showDismiss: Bool
    private var searchResults: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    init(showDismiss: Bool = false) {
        self.showDismiss = showDismiss
    }
    
    var body: some View {
        NavigationStack {
            if !dataLoaded {
                Text("Loading data...")
            } else {
                List {
                    ForEach(searchResults, id: \.id) { country in
                        let currentFavorites = store.get()
                        let favorited = currentFavorites.first(where: { $0.name == country.name })
                        HStack {
                            if let favorited {
                                Button(
                                    action: {
                                        store.remove(favorited)
                                    },
                                    label: {
                                        Image(systemName: "star.fill")
                                    })
                                .foregroundStyle(Color.blue)
                                .buttonStyle(.plain)
                            } else {
                                Button(
                                    action: {
                                        _ = store.add(.init(name: country.name, capitalCity: country.capitalCity, notes: ""))
                                    },
                                    label: {
                                        Image(systemName: "star")
                                    })
                                .foregroundStyle(Color.blue)
                                .buttonStyle(.plain)
                            }
                            Spacer()
                            NavigationLink(destination: CountryDetailsView(country: country)) {
                                Text(country.name)
                                    .font(.title3)
                            }
                        }
                    }
                }
                .navigationTitle("Country Search")
                .toolbar {
                    if showDismiss {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search a country...")
        .onAppear {
            Task {
                let fetched = await dataManager.fetchData()
                await MainActor.run {
                    self.countries = fetched
                    self.dataLoaded = true
                }
            }
        }
    }
}

// MARK: Previews
#Preview {
    CountrySearchView(showDismiss: false)
        .environment(FavoritesStore(persistenceService: PersistenceService()))
}
