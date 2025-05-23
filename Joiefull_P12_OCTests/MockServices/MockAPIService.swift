//
//  MockAPIService.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 23/05/2025.
//


import Foundation
@testable import Joiefull_P12_OC

final class MockAPIService: APIServiceProtocol {
    var result: Result<[ClothingItem], Error> = .success([.sample])

    func fetchClothingItems() async throws -> [ClothingItem] {
        switch result {
        case .success(let items): return items
        case .failure(let error): throw error
        }
    }
}
