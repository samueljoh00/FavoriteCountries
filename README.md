# FavoriteCountries

FavoriteCountries is a SwiftUI app for browsing countries from the World Bank API and saving a personal list of favorites. The app supports adding, removing, reordering, and adding notes for favorite countries, with local JSON persistence.

## Features
- Search countries from the World Bank API
- Add or remove favorites from the search list
- View and edit notes for each favorite country
- Reorder and delete favorites in the list
- Local JSON persistence for offline access

## Architecture
- **SwiftUI** views for the UI layer
- **FavoritesStore** (`FavoriteCountries/FavoriteCountriesStore.swift`) for in-memory state and persistence writes
- **PersistenceService** (`FavoriteCountries/Services/PersistenceService.swift`) for JSON file storage in Documents
- **WorldBankAPIService** (`FavoriteCountries/Services/WorldBankAPIService.swift`) for remote country data
- **FavoriteCountriesListViewModel** (`FavoriteCountries/Views/FavoriteCountriesListViewModel.swift`) for list-specific actions

## Project Structure
- `FavoriteCountries/` app source
- `FavoriteCountries/Views/` SwiftUI views
- `FavoriteCountries/Models/` data models
- `FavoriteCountries/Services/` API and persistence services
- `FavoriteCountriesTests/` unit tests and mocks

## Running
1. Open `FavoriteCountries.xcodeproj` in Xcode.
2. Select the `FavoriteCountries` scheme.
3. Run on a simulator or device.

## Notes
- Country data is fetched from: `https://api.worldbank.org/v2/countries?format=json`
- Favorites are stored in `favoriteCountries.json` in the app Documents directory.

## Tests
Run tests in Xcode with `Product > Test`.

