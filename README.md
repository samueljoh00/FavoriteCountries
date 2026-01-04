# FavoriteCountries

=======
An iOS application built to track user-inputted notes for favorite countries. This was built for the purposes of a take-home assignment.

---

## Main Features
- Add and manage a list of favorite countries
- Edit notes associated with a favorited country
- Searchable list of world countries provided by the World Bank API
- Persistent storage of favorited countries between app sessions

---

## Additional Features
- Utilization of iOS 26 Liquid Glass design language
- Custom typography and graphical elements
- Polished navigation UI
- App launch animation


## Architecture
The app is intentionally designed to be **simple, explicit, and testable**.

- **SwiftUI** for declarative UI
- **Single source of truth** via a central store
- **@Observable** models for UI-driven state updates
- **Environment-based dependency injection**
- **Usage of Actors** and async/await patterns for concurrency
- **ViewModels used selectively** where they improve readability or separation of concerns
- Clear separation between:
  - UI layer
  - State / domain logic
  - Persistence layer

Heavier solutions such as CoreData/SwiftData were deliberately avoided in favor of clarity and approachability, given the scope of the assignment.

---

## Data & Persistence
- Lightweight JSON persistence using `FileManager`
- Stored in `favoriteCountries.json` in the app Documents directory
- Asynchronous disk IO to avoid blocking the main thread
- Mock persistence services used for testing
- Data loaded on launch and saved on mutation

## Testing
- Unit tests covering core store behavior:
  - Add
  - Remove
  - Update
  - Reorder
- Deterministic async testing using continuations
- Utilizes SwiftTesting suite and practices

## Screenshots
| Home | Edit / Reorder | Details |
|------|---------------|---------|
| ![](Screenshots/home.gif) | ![](Screenshots/reorder.gif) | ![](Screenshots/details.gif) |

> Screenshots are included to highlight UI structure, navigation behavior, and state transitions.

---

## Resources & References
Development was guided by:
- Apple SwiftUI & Concurrency documentation
- Swift Evolution proposals (Observation, structured concurrency)
Resources:
- World Bank API: `https://api.worldbank.org/v2/countries?format=json`
- Free images: National Gallery of Art Public Archive (https://www.nga.gov/)
- Stretchy header functionality (https://medium.com/@thomasostlyng/stretchy-headers-in-swiftui-with-visualeffect-fff973568323)

---

## Getting Started
1. Clone the repository
2. Open `FavoriteCountries.xcodeproj`
3. Run on iOS Simulator or device (iOS 26+)

---

## Potential Enhancements
- Dark mode implementation
- Filter features for favorited countries list and search (alphabetical vs chronological)
- Additional input types for favorite country (images, voice notes)
- Accessibility and uniform experience across different device sizes
- Dedicated and enhanced network layer
  - Caching mechanism
  - Detailed pagination logic
  - Fallback behavior to internal countries JSON file
 
## Additional Notes
- JSON persistence was chosen over CoreData/SwiftData to reduce complexity and improve transparency
- ViewModels are used only where they improve clarity. With increase of app functionality, ViewModel patterns will become more justifiable.
- UIKit appearance APIs are used sparingly where SwiftUI does not yet provide full control (e.g. navigation bar typography)



These decisions were made intentionally to balance correctness, readability, and scope.
