//
//  ClothingItem.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 08/05/2025.
//

import Foundation

struct ClothingItem: Identifiable, Codable, Equatable {
    struct Picture: Codable, Equatable {
        let url: URL
        let description: String
    }

    let id: Int
    let picture: Picture
    let name: String
    let category: String
    let likes: Int
    let price: Double
    let originalPrice: Double

    var isDiscounted: Bool {
        price < originalPrice
    }

    enum CodingKeys: String, CodingKey {
        case id, picture, name, category, likes, price
        case originalPrice = "original_price"
    }
}


@MainActor
final class CatalogViewModel: ObservableObject {
    @Published var items: [ClothingItem] = []
    @Published var isLoading = false
    @Published var error: String?

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
}

