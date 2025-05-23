//
//  CatalogViewModelTests.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 23/05/2025.
//

import XCTest
@testable import Joiefull_P12_OC

@MainActor
final class CatalogViewModelTests: XCTestCase {

    var mockDataService: MockDataService!
    var mockAPIService: MockAPIService!
    var viewModel: CatalogViewModel!

    override func setUp() {
        mockDataService = MockDataService()
        mockAPIService = MockAPIService()
        viewModel = CatalogViewModel(
            dataService: mockDataService,
            apiService: mockAPIService
        )
    }

    // MARK: - Favorites

    func test_givenFavoriteList_whenInit_thenFavoritesAreLoaded() {
        // Given
        mockDataService.favorites = [1, 2, 3]

        // When
        let vm = CatalogViewModel(dataService: mockDataService, apiService: mockAPIService)

        // Then
        XCTAssertEqual(vm.favoriteItemIDs, [1, 2, 3])
    }

    func test_givenNonFavoriteItem_whenToggled_thenItemIsAddedAndRemovedFromFavorites() {
        // Given
        let itemID = 42

        // When
        viewModel.toggleFavorite(for: itemID)

        // Then
        XCTAssertTrue(viewModel.isFavorite(itemID))

        // When
        viewModel.toggleFavorite(for: itemID)

        // Then
        XCTAssertFalse(viewModel.isFavorite(itemID))
    }

    // MARK: - Ratings

    func test_givenStoredRating_whenLoadingRatings_thenCorrectValuesAreSet() {
        // Given
        let itemID = 99
        mockDataService.userRatings = [itemID: 4]

        // When
        viewModel.loadRatings(for: itemID)

        // Then
        XCTAssertEqual(viewModel.selectedItemRating, 4)
        XCTAssertEqual(viewModel.selectedItemAverage, 3.5)
    }

    func test_givenNewRating_whenUpdated_thenValueIsStoredAndAverageUpdated() {
        // Given
        let itemID = 10

        // When
        viewModel.updateRating(for: itemID, rating: 5)

        // Then
        XCTAssertEqual(viewModel.selectedItemRating, 5)
        XCTAssertEqual(viewModel.selectedItemAverage, 4.0)
        XCTAssertEqual(mockDataService.userRatings[itemID], 5)
    }

    // MARK: - API

    func test_givenSuccessfulAPI_whenLoadingItems_thenItemsAreSet() async {
        // Given
        mockAPIService.result = .success([.sample])

        // When
        await viewModel.loadItems()

        // Then
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertNil(viewModel.error)
    }

    func test_givenFailingAPI_whenLoadingItems_thenErrorIsSet() async {
        // Given
        mockAPIService.result = .failure(NSError(domain: "", code: 1))

        // When
        await viewModel.loadItems()

        // Then
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertNotNil(viewModel.error)
    }
}

