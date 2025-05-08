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

    let sectionOrder = ["TOPS", "BOTTOMS", "SHOES", "ACCESSORIES"]

    var groupedItems: [String: [ClothingItem]] {
        Dictionary(grouping: viewModel.items) { $0.category }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(sectionOrder, id: \.self) { category in
                    if let items = groupedItems[category] {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(category.capitalized)
                                .textStyle(.sectionTitle)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 16) {
                                    ForEach(items) { item in
                                        CatalogItemCard(item: item, isPad: isPad)
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
    CatalogView()
}



import SwiftUI

struct CatalogItemCard: View {
    let item: ClothingItem
    let isPad: Bool

    var imageSize: CGSize {
        isPad ? CGSize(width: 234, height: 256) : CGSize(width: 198, height: 198)
    }

    var cardSize: CGSize {
        isPad ? CGSize(width: 234, height: 320) : CGSize(width: 198, height: 282)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: item.picture.url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageSize.width, height: imageSize.height)
                            .clipped()
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .accessibilityLabel(Text(item.picture.description))
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: imageSize.width, height: imageSize.height)
                    }
                }

                HStack(spacing: 6) {
                    Image("heartEmpty")
                        .resizable()
                        .frame(width: 14, height: 12)
                    Text("\(item.likes)")
                        .textStyle(.favoriteCount(isPad: isPad, isDetail: false))
                        .foregroundColor(.black)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.white)
                .cornerRadius(30)
                .padding(10)
            }

            HStack(alignment: .top) {
                Text(item.name)
                    .textStyle(.itemName(isPad: isPad, isDetail: false))
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer(minLength: 4)

                HStack(spacing: 4) {
                    Image("filledStar")
                        .resizable()
                        .frame(width: 14, height: 14)
                    Text("4.5")
                        .textStyle(.ratingAverage(isPad: isPad, isDetail: false))
                }
            }

            HStack {
                Text(String(format: "%.2f €", item.price))
                    .textStyle(.itemPrice(isPad: isPad, isDetail: false))

                Spacer()

                if item.isDiscounted {
                    Text(String(format: "%.2f €", item.originalPrice))
                        .textStyle(.itemPrice(isPad: isPad, isDetail: false))
                        .strikethrough()
                        .opacity(0.3)
                }
            }
        }
        .frame(width: cardSize.width, height: cardSize.height)
    }
}


