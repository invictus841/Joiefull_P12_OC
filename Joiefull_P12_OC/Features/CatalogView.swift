//
//  CatalogView.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 08/05/2025.
//

import SwiftUI

struct CatalogView: View {
    @StateObject var viewModel: CatalogViewModel
    @Environment(\.horizontalSizeClass) var sizeClass
    @Binding var selectedItem: ClothingItem?
    
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
                                        if isPad {
                                            Button {
                                                selectedItem = item
                                            } label: {
                                                CatalogItemCard(
                                                    item: item,
                                                    isPad: isPad,
                                                    isFavorited: viewModel.isFavorite(item.id),
                                                    averageRating: viewModel.averageRatings[item.id] ?? 3.0
                                                )
                                            }
                                            .buttonStyle(.plain)
                                        } else {
                                            NavigationLink(destination: ItemDetailView(viewModel: viewModel, item: item)) {
                                                CatalogItemCard(
                                                    item: item,
                                                    isPad: isPad,
                                                    isFavorited: viewModel.isFavorite(item.id),
                                                    averageRating: viewModel.averageRatings[item.id] ?? 3.0
                                                )
                                            }
                                            .buttonStyle(.plain)
                                            .accessibilityLabel("Voir les détails de \(item.name)")
                                        }
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
        .background(Color(.systemBackground).ignoresSafeArea())
        .task {
            await viewModel.loadItems()
        }
    }
}


#Preview {
    NavigationStack {
        CatalogView(viewModel: CatalogViewModel(dataService: DataService()), selectedItem: .constant(ClothingItem.sample))
    }
}
