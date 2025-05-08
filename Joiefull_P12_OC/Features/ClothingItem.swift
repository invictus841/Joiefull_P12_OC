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
    let category: ClothingCategory
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
    
    static var sample: ClothingItem {
        ClothingItem(
            id: 1,
            picture: Picture(
                url: URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/1.jpg")!,
                description: "Homme en costume et veste de blazer qui regarde la caméra"
            ),
            name: "Blazer en laine stylé",
            category: .tops,
            likes: 42,
            price: 89.99,
            originalPrice: 129.99
        )
    }
}

enum ClothingCategory: String, CaseIterable, Codable {
    case tops = "TOPS"
    case bottoms = "BOTTOMS"
    case shoes = "SHOES"
    case accessories = "ACCESSORIES"

    var displayName: String {
        switch self {
        case .tops: return "Tops"
        case .bottoms: return "Bottoms"
        case .shoes: return "Shoes"
        case .accessories: return "Accessories"
        }
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

