//
//  DataService.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 22/05/2025.
//

import Foundation

// MARK: - Protocol
protocol DataServiceProtocol {
    func loadFavorites() -> [Int]
    func saveFavorites(_ ids: [Int])

    func getUserRating(for itemID: Int) -> Int?
    func saveUserRating(for itemID: Int, rating: Int)
    func getAverageRating(for itemID: Int) -> Double
}

// MARK: - DataService
final class DataService: DataServiceProtocol {

    private let favoritesKey = "favoriteItemIDs"
    private let ratingPrefix = "userRating_"

    // MARK: - Favorites
    func loadFavorites() -> [Int] {
        UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }

    func saveFavorites(_ ids: [Int]) {
        UserDefaults.standard.set(ids, forKey: favoritesKey)
    }

    // MARK: - Ratings
    func getUserRating(for itemID: Int) -> Int? {
        let rating = UserDefaults.standard.integer(forKey: ratingPrefix + "\(itemID)")
        return rating == 0 ? nil : rating
    }

    func saveUserRating(for itemID: Int, rating: Int) {
        UserDefaults.standard.set(rating, forKey: ratingPrefix + "\(itemID)")
    }

    func getAverageRating(for itemID: Int) -> Double {
        let base = 3.0
        let user = Double(getUserRating(for: itemID) ?? 3)
        return (base + user) / 2.0
    }
}

