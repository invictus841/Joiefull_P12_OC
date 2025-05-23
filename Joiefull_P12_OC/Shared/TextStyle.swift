//
//  TextStyle.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 08/05/2025.
//

import Foundation
import SwiftUI

enum TextStyle {
    case sectionTitle
    case itemName(isPad: Bool, isDetail: Bool)
    case itemPrice(isPad: Bool, isDetail: Bool)
    case ratingAverage(isPad: Bool, isDetail: Bool)
    case favoriteCount(isPad: Bool, isDetail: Bool)
    case description(isPad: Bool)

    var font: Font {
        switch self {
        case .sectionTitle:
            return .custom("OpenSans-SemiBold", size: 22, relativeTo: .title2)

        case .itemName(let isPad, let isDetail):
            let size = isDetail ? (isPad ? 22 : 18) : (isPad ? 18 : 14)
            return .custom("OpenSans-SemiBold", size: CGFloat(size), relativeTo: .body)

        case .itemPrice(let isPad, let isDetail),
             .ratingAverage(let isPad, let isDetail):
            let size = isDetail ? (isPad ? 22 : 18) : (isPad ? 18 : 14)
            return .custom("OpenSans-Regular", size: CGFloat(size), relativeTo: .body)

        case .favoriteCount(let isPad, let isDetail):
            let size = isDetail ? (isPad ? 22 : 18) : (isPad ? 14 : 14)
            return .custom("OpenSans-SemiBold", size: CGFloat(size), relativeTo: .caption)

        case .description(let isPad):
            return .custom("OpenSans-Regular", size: isPad ? 18 : 14, relativeTo: .body)
        }
    }
}

extension Text {
    func textStyle(_ style: TextStyle) -> some View {
        self.font(style.font)
    }
}


enum IconSize {
    case heart(isPad: Bool, isDetail: Bool)

    var size: CGSize {
        switch self {
        case .heart(let isPad, let isDetail):
            switch (isPad, isDetail) {
            case (false, false): return CGSize(width: 14, height: 12) // iPhone - Catalog
            case (false, true):  return CGSize(width: 19, height: 16) // iPhone - Detail
            case (true, false):  return CGSize(width: 14, height: 12) // iPad - Catalog
            case (true, true):   return CGSize(width: 24, height: 20) // iPad - Detail
            }
        }
    }
}
