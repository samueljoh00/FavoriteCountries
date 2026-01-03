//
//  FavoriteCountriesStoreTests.swift
//  FavoriteCountriesTests
//
//  Created by Samuel Oh on 12/26/25.
//

import Testing
@testable import FavoriteCountries

@MainActor
struct FavoriteCountriesStoreTests {
    
    // Used for duplicate UUIDs
    static let ids: [UUID] = [
        UUID(),
        UUID(),
        UUID()
    ]
    
    static let mockCountries: [FavoriteCountry] = [
        .init(
            id: ids[0],
            name: "USA",
            capitalCity: "D.C.",
            notes: ""
        ),
        .init(
            id: ids[1],
            name: "Japan",
            capitalCity: "Tokyo",
            notes: ""
        ),
        .init(
            id: ids[2],
            name: "USA",
            capitalCity: "Tokyo",
            notes: ""
        ),
        .init(
            id: ids[0],
            name: "Japan",
            capitalCity: "Tokyo",
            notes: ""
        )
    ]
    
    @Test(
        "add() testing",
        arguments: [
            AddScenario(
                testDescription: "Add - happy path",
                country: mockCountries[0],
                expectedPersistenceCount: 1,
                expectedAddResult: true
            ),
            AddScenario(
                testDescription: "Add - fail, duplicate id",
                country: mockCountries[0],
                persistedCountries: [
                    mockCountries[3]
                ],
                expectedPersistenceCount: 1,
                expectedAddResult: false
            ),
            AddScenario(
                testDescription: "Add - fail, duplicate name",
                country: mockCountries[0],
                persistedCountries: [
                    mockCountries[2]
                ],
                expectedPersistenceCount: 1,
                expectedAddResult: false
            ),
        ])
    func testAdd(scenario: AddScenario) async {
        let mockPersistence = MockPersistenceService()
        let sut = FavoritesStore(persistenceService: mockPersistence)
        if let persistedCountries = scenario.persistedCountries {
            await mockPersistence.writeToDisk(with: persistedCountries)
        }
        await sut.loadIfNeeded()
        
        let actual: Bool
        if scenario.expectedAddResult {
            async let wrote: Void = mockPersistence.waitForNextWrite()
            actual = sut.add(scenario.country)
            await wrote
        } else {
            actual = sut.add(scenario.country)
        }

        
        #expect(actual == scenario.expectedAddResult)
        #expect(mockPersistence.countries.count == scenario.expectedPersistenceCount)
    }
    
    
    @Test(
        "remove() testing",
        arguments: [
            RemoveScenario(
                testDescription: "Remove - by FavoriteCountry",
                persistedCountries: [
                    mockCountries[0],
                    mockCountries[1]
                ],
                removeParameter: .country(mockCountries[0]),
                expectedStoreCount: 1,
                expectedPersistenceCount: 1
            ),
            RemoveScenario(
                testDescription: "Remove - by IndexSet",
                persistedCountries: [
                    mockCountries[0],
                    mockCountries[1]
                ],
                removeParameter: .indexSet(IndexSet([0])),
                expectedStoreCount: 1,
                expectedPersistenceCount: 1
            ),
        ]
    )
    func testRemove(scenario: RemoveScenario) async {
        let mockPersistence = MockPersistenceService()
        let sut = FavoritesStore(persistenceService: mockPersistence)
        await mockPersistence.writeToDisk(with: scenario.persistedCountries)
        await sut.loadIfNeeded()
        
        async let wrote: Void = mockPersistence.waitForNextWrite()
        switch scenario.removeParameter {
        case .country(let favoriteCountry):
            sut.remove(favoriteCountry)
        case .indexSet(let indexSet):
            sut.remove(at: indexSet)
        }
        await wrote
        
        #expect(sut.countries.count == scenario.expectedStoreCount)
        #expect(mockPersistence.countries.count == scenario.expectedPersistenceCount)
    }
    
    @Test(
        "move() testing",
        arguments: [
            MoveScenario(
                testDescription: "Move - Happy path",
                persistedCountries: [
                    mockCountries[0],
                    mockCountries[1]
                ],
                indexSet: .init([1]),
                offset: 0,
                expectedPosition: 0,
                expectedCountry: mockCountries[1]
            )
        ]
    )
    func testMove(scenario: MoveScenario) async {
        let mockPersistence = MockPersistenceService()
        let sut = FavoritesStore(persistenceService: mockPersistence)
        await mockPersistence.writeToDisk(with: scenario.persistedCountries)
        await sut.loadIfNeeded()
        
        async let wrote: Void = mockPersistence.waitForNextWrite()
        sut.move(fromOffsets: scenario.indexSet, toOffset: scenario.offset)
        await wrote
        
        #expect(sut.countries[0].id == scenario.expectedCountry.id)
    }
    
    @Test(
        "update() testing",
        arguments: [
            UpdateScenario(
                testDescription: "Update - happy path",
                persistedCountries: [
                    mockCountries[0]
                ],
                country: mockCountries[0],
                expectedNotes: "New notes"
            ),
            UpdateScenario(
                testDescription: "Update - No update",
                persistedCountries: [
                    mockCountries[0]
                ],
                country: mockCountries[1],
                expectedNotes: ""
            )
        ]
    )
    func testUpdate(scenario: UpdateScenario) async {
        let mockPersistence = MockPersistenceService()
        let sut = FavoritesStore(persistenceService: mockPersistence)
        await mockPersistence.writeToDisk(with: scenario.persistedCountries)
        await sut.loadIfNeeded()
        
        let shouldWrite = scenario.persistedCountries.contains(where: { $0.id == scenario.country.id })
        if shouldWrite {
            async let wrote: Void = mockPersistence.waitForNextWrite()
            sut.update(scenario.country, notes: scenario.expectedNotes)
            await wrote
        } else {
            sut.update(scenario.country, notes: scenario.expectedNotes)
        }
        
        if shouldWrite {
            #expect(mockPersistence.countries.first?.notes == scenario.expectedNotes)
        } else {
            #expect(mockPersistence.countries.first?.notes == scenario.persistedCountries.first?.notes)
        }
    }
}

// MARK: Scenarios
struct AddScenario: CustomTestStringConvertible {
    var testDescription: String
    var country: FavoriteCountry
    var persistedCountries: [FavoriteCountry]?
    var expectedPersistenceCount: Int
    var expectedAddResult: Bool
}

struct RemoveScenario: CustomTestStringConvertible {
    var testDescription: String
    var persistedCountries: [FavoriteCountry]
    var removeParameter: RemoveParameterType
    var expectedStoreCount: Int
    var expectedPersistenceCount: Int
    
    enum RemoveParameterType {
        case country(FavoriteCountry)
        case indexSet(IndexSet)
    }
}

struct MoveScenario: CustomTestStringConvertible {
    var testDescription: String
    var persistedCountries: [FavoriteCountry]
    var indexSet: IndexSet
    var offset: Int
    var expectedPosition: Int
    var expectedCountry: FavoriteCountry
}

struct UpdateScenario: CustomTestStringConvertible {
    var testDescription: String
    var persistedCountries: [FavoriteCountry]
    var country: FavoriteCountry
    var expectedNotes: String
}
