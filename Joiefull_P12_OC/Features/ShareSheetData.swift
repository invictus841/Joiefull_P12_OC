//
//  ShareSheetData.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 29/05/2025.
//

import SwiftUI

struct ShareSheetData: Identifiable {
    let item: ClothingItem

    var id: Int { item.id }

    var message: String {
        "\(item.name) – \(String(format: "%.2f €", item.price))\nDécouvrez cette pièce sur l’app Joiefull!"
    }
}
