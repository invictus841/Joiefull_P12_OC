//
//  CatalogItemCard.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 08/05/2025.
//

import SwiftUI

struct CatalogItemCard: View {
    let item: ClothingItem
    let isPad: Bool
    let isFavorited: Bool
    let averageRating: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            imageSection
            headerSection
            priceSection
        }
        .frame(width: cardSize.width, height: cardSize.height)
    }
}


// MARK: - views
private extension CatalogItemCard {
    var imageSection: some View {
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

            FavoriteBubble(count: item.likes + (isFavorited ? 1 : 0), isPad: isPad, isDetail: false, isFavorited: isFavorited)
        }
    }
    
    var headerSection: some View {
        let formattedAverage = String(format: "%.1f", averageRating)
        
        return HStack(alignment: .top) {
            Text(item.name)
                .textStyle(.itemName(isPad: isPad, isDetail: false))
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer(minLength: 4)
            
            HStack(spacing: 4) {
                Image("filledStar")
                    .resizable()
                    .frame(width: 14, height: 14)
                
                Text(String(format: "%.1f", averageRating))
                    .textStyle(.ratingAverage(isPad: isPad, isDetail: false))
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Note moyenne \(formattedAverage) étoiles")
        }
    }

    var priceSection: some View {
        let formattedPrice = String(format: "%.2f", item.price)
        let formattedOriginal = String(format: "%.2f", item.originalPrice)
        
        return HStack {
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            item.isDiscounted ?
            "Prix actuel \(formattedPrice) euros, au lieu de \(formattedOriginal) euros" :
            "Prix \(formattedPrice) euros"
        )
    }
}

// MARK: - helpers
private extension CatalogItemCard {
    var imageSize: CGSize {
        isPad ? CGSize(width: 234, height: 256) : CGSize(width: 198, height: 198)
    }

    var cardSize: CGSize {
        isPad ? CGSize(width: 234, height: 320) : CGSize(width: 198, height: 282)
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    Group {
        VStack {
            Text("iPhone")
                .textStyle(.sectionTitle)
            CatalogItemCard(item: .sample, isPad: false, isFavorited: true, averageRating: 4.5)
                .padding()
        }
        
        VStack {
            Text("iPad")
                .textStyle(.sectionTitle)
            CatalogItemCard(item: .sample, isPad: true, isFavorited: true, averageRating: 4.2)
                .padding()
        }
    }
    .background(Color(.systemBackground))
}
