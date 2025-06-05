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
    var sut: CatalogViewModel!

    override func setUp() {
        mockDataService = MockDataService()
        mockAPIService = MockAPIService()
        sut = CatalogViewModel(
            dataService: mockDataService,
            apiService: mockAPIService
        )
    }

    func test_init_startsWithEmptyState() {
        // Given & When
        let viewModel = CatalogViewModel(
            dataService: mockDataService,
            apiService: mockAPIService
        )

        // Then
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.favoriteItemIDs, [])
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
        sut.toggleFavorite(for: itemID)

        // Then
        XCTAssertTrue(sut.isFavorite(itemID))

        // When
        sut.toggleFavorite(for: itemID)

        // Then
        XCTAssertFalse(sut.isFavorite(itemID))
    }

    // MARK: - Ratings

    func test_givenStoredRating_whenLoadingRatings_thenCorrectValuesAreSet() {
        // Given
        let itemID = 99
        mockDataService.userRatings = [itemID: 4]

        // When
        sut.loadRatings(for: itemID)

        // Then
        XCTAssertEqual(sut.selectedItemRating, 4)
        XCTAssertEqual(sut.selectedItemAverage, 3.5)
    }
    
    // MARK: - Sharing

    func test_givenItem_whenRequestShare_thenShareSheetDataIsSet() {
        // Given
        let item = ClothingItem.sample

        // When
        sut.requestShare(for: item)

        // Then
        XCTAssertNotNil(sut.shareSheetData)
        XCTAssertEqual(sut.shareSheetData?.item, item)
        XCTAssertTrue(sut.shareSheetData?.message.contains(item.name) ?? false)
        XCTAssertTrue(sut.shareSheetData?.message.contains(String(format: "%.2f €", item.price)) ?? false)
    }

    
    // MARK: - Comments

    func test_givenNoComment_whenLoadingComment_thenUserCommentIsEmpty() {
        // Given
        let itemID = 1
        mockDataService.comments = [:]

        // When
        sut.loadComment(for: itemID)

        // Then
        XCTAssertEqual(sut.userComment, "")
        XCTAssertFalse(sut.userCommentSaved)
    }

    func test_givenSavedComment_whenLoadingComment_thenUserCommentIsSet() {
        // Given
        let itemID = 1
        mockDataService.comments[itemID] = "Très beau produit !"

        // When
        sut.loadComment(for: itemID)

        // Then
        XCTAssertEqual(sut.userComment, "Très beau produit !")
        XCTAssertTrue(sut.userCommentSaved)
    }

    func test_givenValidComment_whenSavingComment_thenItIsStoredAndFlagIsSet() {
        // Given
        let itemID = 1
        sut.userComment = "Parfait!"

        // When
        sut.saveComment(for: itemID)

        // Then
        XCTAssertEqual(mockDataService.comments[itemID], "Parfait!")
        XCTAssertTrue(sut.userCommentSaved)
    }

    func test_givenEmptyComment_whenSavingComment_thenItIsIgnored() {
        // Given
        let itemID = 1
        sut.userComment = "   "  // Only spaces

        // When
        sut.saveComment(for: itemID)

        // Then
        XCTAssertNil(mockDataService.comments[itemID])
        XCTAssertFalse(sut.userCommentSaved)
    }


    func test_givenNewRating_whenUpdated_thenValueIsStoredAndAverageUpdated() {
        // Given
        let itemID = 10

        // When
        sut.updateRating(for: itemID, rating: 5)

        // Then
        XCTAssertEqual(sut.selectedItemRating, 5)
        XCTAssertEqual(sut.selectedItemAverage, 4.0)
        XCTAssertEqual(mockDataService.userRatings[itemID], 5)
    }

    // MARK: - API

    func test_givenSuccessfulAPI_whenLoadingItems_thenItemsAreSet() async {
        // Given
        mockAPIService.result = .success([.sample])

        // When
        await sut.loadItems()

        // Then
        XCTAssertEqual(sut.items.count, 1)
        XCTAssertNil(sut.error)
    }

    func test_givenFailingAPI_whenLoadingItems_thenErrorIsSet() async {
        // Given
        mockAPIService.result = .failure(NSError(domain: "", code: 1))

        // When
        await sut.loadItems()

        // Then
        XCTAssertTrue(sut.items.isEmpty)
        XCTAssertNotNil(sut.error)
    }
}

