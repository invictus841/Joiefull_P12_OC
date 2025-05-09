//
//  CatalogView.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 08/05/2025.
//

import SwiftUI

struct CatalogView: View {
    @StateObject var viewModel = CatalogViewModel()
    @Environment(\.horizontalSizeClass) var sizeClass

    var isPad: Bool { sizeClass == .regular }

    var groupedItems: [ClothingCategory: [ClothingItem]] {
        Dictionary(grouping: viewModel.items) { $0.category }
    }

    let sectionOrder: [ClothingCategory] = [.tops, .bottoms, .shoes, .accessories]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(sectionOrder, id: \.self) { category in
                    if let items = groupedItems[category] {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(category.displayName)
                                .textStyle(.sectionTitle)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 16) {
                                    ForEach(items) { item in
                                        NavigationLink(destination: ItemDetailView(item: item, isPad: isPad)) {
                                            CatalogItemCard(item: item, isPad: isPad)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding(.top)
        }
        .background(Color.white.ignoresSafeArea())
        .task {
            await viewModel.loadItems()
        }
    }
}


#Preview {
    NavigationStack {
        CatalogView()
    }
}
