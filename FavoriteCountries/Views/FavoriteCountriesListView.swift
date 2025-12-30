//
//  FavoriteCountriesListView.swift
//  FavoriteCountries
//
//  Created by Samuel Oh on 12/25/25.
//

import SwiftUI

struct FavoriteCountriesListView: View {

    @Environment(FavoritesStore.self) private var store
    @State private var isPresenting: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.countries) { item in
                    NavigationLink {
                        FavoriteCountryDetailsView(country: item)
                    } label: {
                        FavoriteCountryItemView(item: item)
                    }
                }
            }
            .sheet(isPresented: $isPresenting, onDismiss: didDismiss) {
                CountrySearchView(showDismiss: true)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        isPresenting.toggle()
                    }) {
                        Text("Add Country")
                    }
                }
            }
            .navigationTitle("Favorite Countries")
        }
    }

    private func didDismiss() {

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
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    FavoriteCountriesListView()
        .environment(FavoritesStore())
}
