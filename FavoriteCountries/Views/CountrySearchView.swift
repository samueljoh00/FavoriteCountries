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
    @State private var showAlert: Bool = false
    
    private let showDismiss: Bool
    private var searchResults: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private var fetchFlow: Void {
        Task {
            do {
                let fetched = try await dataManager.fetchData()
                await MainActor.run {
                    self.countries = fetched
                    self.dataLoaded = true
                }
            } catch {
                showAlert.toggle()
            }
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
                        let currentFavorites = store.countries
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
                                    .avenir(weight: .medium, size: .standard)
                            }
                        }
                    }
                }
                .toolbar {
                    if showDismiss {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                dismiss()
                            }
                        }
                    }
                }
                .navigationTitle("Country Search")
            }
        }
        .searchable(text: $searchText, prompt: "Search a country...")
        .alert("Failed to fetch countries.", isPresented: $showAlert) {
            Button("Retry", role: .confirm) {
                showAlert.toggle()
                fetchFlow }
            Button("Cancel", role: .close) { dismiss() }
        }
        .onAppear {
            fetchFlow
        }
    }
}

// MARK: Previews
#Preview("Happy Path") {
    CountrySearchView(showDismiss: false)
        .environment(FavoritesStore(persistenceService: PersistenceService()))
}

#Preview("API Failure") {
    NavigationStack {
        CountrySearchView(showDismiss: true)
            .environment(FavoritesStore(persistenceService: PersistenceService()))
            .environment(\.dataManager, MockAPIService(shouldFail: true))
    }
}
