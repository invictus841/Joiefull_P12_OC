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
    
    @Published var shareSheetData: ShareSheetData?
    @Published var userComment: String = ""
    @Published var userCommentSaved: Bool = false
    
    private let apiService: APIServiceProtocol
    private let dataService: DataServiceProtocol

    init(dataService: DataServiceProtocol, apiService: APIServiceProtocol) {
            self.dataService = dataService
            self.apiService = apiService
            self.favoriteItemIDs = dataService.loadFavorites()
    }

    func loadItems() async {
        isLoading = true
        do {
            let data = try await apiService.fetchClothingItems()
            self.items = data
            self.error = nil
            
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
        
        averageRatings[itemID] = selectedItemAverage
    }
    
    // MARK: - Sharing
    func requestShare(for item: ClothingItem) {
        shareSheetData = ShareSheetData(item: item)
    }
    
    // MARK: - Review / Comments
    func loadComment(for itemID: Int) {
        let saved = dataService.getComment(for: itemID) ?? ""
        userComment = saved
        userCommentSaved = !saved.isEmpty
    }

    func saveComment(for itemID: Int) {
        let trimmed = userComment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        dataService.saveComment(trimmed, for: itemID)
        userComment = trimmed
        userCommentSaved = true
    }
}

