//
//  MockDataService.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 23/05/2025.
//


import Foundation
@testable import Joiefull_P12_OC

final class MockDataService: DataServiceProtocol {
    var favorites: [Int] = []
    var userRatings: [Int: Int] = [:]
    var comments: [Int: String] = [:]

    func loadFavorites() -> [Int] {
        return favorites
    }

    func saveFavorites(_ ids: [Int]) {
        favorites = ids
    }

    func getUserRating(for itemID: Int) -> Int? {
        return userRatings[itemID]
    }

    func saveUserRating(for itemID: Int, rating: Int) {
        userRatings[itemID] = rating
    }

    func getAverageRating(for itemID: Int) -> Double {
        let base = 3.0
        let user = Double(userRatings[itemID] ?? 3)
        return (base + user) / 2.0
    }
    
    func saveComment(_ comment: String, for itemID: Int) {
        comments[itemID] = comment
    }

    func getComment(for itemID: Int) -> String? {
        comments[itemID]
    }
}
