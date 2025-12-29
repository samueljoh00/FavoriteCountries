//
//  CountrySearchView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct CountrySearchView: View {
    
    // Need to load in data from API
    @State private var countries: [Country] = []
    // Binding property to represent search text.
    @State private var searchText: String = ""
    let showDismiss: Bool
    @State private var dataLoaded: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dataManager) private var dataManager
    // Computed var to display filtered search results.
    private var searchResults: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            if !dataLoaded {
                Text("Loading data...")
            } else {
                List {
                    ForEach(searchResults, id: \.self) { country in
                        NavigationLink(destination: CountryDetailsView(country: country)) {
                            Text(country.name)
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

#Preview {
    CountrySearchView(showDismiss: false)
}
