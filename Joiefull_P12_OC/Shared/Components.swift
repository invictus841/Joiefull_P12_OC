//
//  Components.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 09/05/2025.
//

import SwiftUI

struct FavoriteBubble: View {
    let count: Int
    let isPad: Bool
    let isDetail: Bool

    var body: some View {
        let size = IconSize.heart(isPad: isPad, isDetail: isDetail).size

        HStack(spacing: 6) {
            Image("heartEmpty")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.primary)
                .frame(width: size.width, height: size.height)

            Text("\(count)")
                .textStyle(.favoriteCount(isPad: isPad, isDetail: isDetail))
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color(.systemBackground))
        .cornerRadius(30)
        .padding(10)
    }
}

#Preview {
    FavoriteBubble(count: 23, isPad: false, isDetail: false)
}
