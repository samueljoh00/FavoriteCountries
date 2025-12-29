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
                        CountryDetailsView(country: .init(id: item.name, name: item.name, capitalCity: item.name))
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

    private func addItem() {
        withAnimation {
            let newItem = FavoriteCountry(
                name: "New Country",
                notes: ""
            )
            store.add(newItem)
        }
    }
}

struct FavoriteCountryItemView: View {
    private let item: FavoriteCountry

    init(item: FavoriteCountry) {
        self.item = item
    }

    var body: some View {
        Text("Name: \(item.name)\nNotes: \(item.notes)")
    }
}

#Preview {
    FavoriteCountriesListView()
        .environment(FavoritesStore())
}
