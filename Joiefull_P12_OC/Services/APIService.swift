//
//  APIService.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 08/05/2025.
//

import Foundation

protocol APIServiceProtocol {
    func fetchClothingItems() async throws -> [ClothingItem]
}

final class APIService: APIServiceProtocol {

    private let urlString = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json"

    func fetchClothingItems() async throws -> [ClothingItem] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([ClothingItem].self, from: data)
    }
}
