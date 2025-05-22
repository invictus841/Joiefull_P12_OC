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

    private let favoritesKey = "favoriteItemIDs"

    init() {
        if let saved = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
            self.favoriteItemIDs = saved
        }
    }

    func loadItems() async {
        isLoading = true
        do {
            let data = try await APIService.shared.fetchClothingItems()
            self.items = data
            self.error = nil
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
    
    func isFavorite(_ id: Int) -> Bool {
        favoriteItemIDs.contains(id)
    }

    func toggleFavorite(for id: Int) {
        if let index = favoriteItemIDs.firstIndex(of: id) {
            favoriteItemIDs.remove(at: index)
        } else {
            favoriteItemIDs.append(id)
        }
        saveFavorites()
    }

    private func saveFavorites() {
        UserDefaults.standard.set(favoriteItemIDs, forKey: favoritesKey)
    }

}
