//
//  CatalogViewModel.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 16/05/2025.
//

import Foundation

@MainActor
final class CatalogViewModel: ObservableObject {
    @Published var items: [ClothingItem] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var favoriteItemIDs: [Int] = []
    @Published var averageRatings: [Int: Double] = [:]

    @Published var selectedItemRating: Int? = nil
    @Published var selectedItemAverage: Double = 3.0
    
    private let dataService: DataServiceProtocol

    init(dataService: DataServiceProtocol = DataService.shared) {
        self.dataService = dataService
        self.favoriteItemIDs = dataService.loadFavorites()
    }

    func loadItems() async {
        isLoading = true
        do {
            let data = try await APIService.shared.fetchClothingItems()
            self.items = data
            self.error = nil

            // Preload average ratings for catalog display
            var newRatings: [Int: Double] = [:]
            for item in data {
                newRatings[item.id] = dataService.getAverageRating(for: item.id)
            }
            self.averageRatings = newRatings

        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Favorites
    func isFavorite(_ id: Int) -> Bool {
        favoriteItemIDs.contains(id)
    }

    func toggleFavorite(for id: Int) {
        if let index = favoriteItemIDs.firstIndex(of: id) {
            favoriteItemIDs.remove(at: index)
        } else {
            favoriteItemIDs.append(id)
        }
        dataService.saveFavorites(favoriteItemIDs)
    }
    
    // MARK: - Detail View Ratings
    func loadRatings(for itemID: Int) {
        selectedItemRating = dataService.getUserRating(for: itemID)
        selectedItemAverage = dataService.getAverageRating(for: itemID)
    }

    func updateRating(for itemID: Int, rating: Int) {
        dataService.saveUserRating(for: itemID, rating: rating)
        selectedItemRating = rating
        selectedItemAverage = dataService.getAverageRating(for: itemID)
        
        // Update catalog display rating
        averageRatings[itemID] = selectedItemAverage
    }
}

