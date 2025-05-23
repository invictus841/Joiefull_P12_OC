//
//  ItemDetailView.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 09/05/2025.
//

import SwiftUI

struct ItemDetailView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel: CatalogViewModel
    let item: ClothingItem
    
    @State private var userComment: String = ""
    
    private var isFavorited: Bool {
        viewModel.isFavorite(item.id)
    }

    var isPad: Bool {
        sizeClass == .regular
    }
    
    var imageSize: CGSize {
        isPad ? CGSize(width: 451, height: 408) : CGSize(width: 328, height: 431)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                imageSection
                    .padding(.bottom, 16)
                headerSection
                priceSection
                descriptionSection
                ratingSection
                commentSection
            }
            .frame(maxWidth: imageSize.width)
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onAppear {
            viewModel.loadRatings(for: item.id)
        }
        .navigationBarBackButtonHidden()
    }

    private var imageSection: some View {
        ZStack(alignment: .top) {
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

            HStack {
                if !isPad {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("backSymbol")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .accessibilityLabel("Retour à la liste")
                }

                Spacer()

                Button(action: {
                    SharingService.share(item: item, userComment: userComment)
                }) {
                    Image("shareIcon")
                        .resizable()
                        .frame(width: 16, height: 18)
                }
                .accessibilityLabel("Partager cet article")
            }
            .padding()

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FavoriteBubble(
                        count: item.likes + (isFavorited ? 1 : 0),
                        isPad: isPad,
                        isDetail: true,
                        isFavorited: isFavorited
                    )
                    .onTapGesture {
                        viewModel.toggleFavorite(for: item.id)
                    }
                    .accessibilityLabel(isFavorited ? "Retirer des favoris" : "Ajouter aux favoris")
                }
            }
        }
    }

    private var headerSection: some View {
        HStack(alignment: .top) {
            Text(item.name)
                .textStyle(.itemName(isPad: isPad, isDetail: true))

            Spacer()

            HStack(spacing: 4) {
                Image("filledStar")
                    .resizable()
                    .frame(width: 14, height: 14)
                
                Text(String(format: "%.1f", viewModel.selectedItemAverage))
                    .textStyle(.ratingAverage(isPad: isPad, isDetail: true))
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Note moyenne \(viewModel.selectedItemAverage) étoiles")
        }
    }

    private var priceSection: some View {
        HStack {
            Text(String(format: "%.2f €", item.price))
                .textStyle(.itemPrice(isPad: isPad, isDetail: true))

            Spacer()

            if item.isDiscounted {
                Text(String(format: "%.2f €", item.originalPrice))
                    .textStyle(.itemPrice(isPad: isPad, isDetail: true))
                    .strikethrough()
                    .opacity(0.3)
            }
        }
    }

    private var descriptionSection: some View {
        Text(item.picture.description)
            .textStyle(.description(isPad: isPad))
            .padding(.top, 8)
    }

    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 14) {
                Image("userPic")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 39, height: 39)
                    .clipShape(Circle())

                HStack(spacing: 14) {
                    ForEach(1...5, id: \.self) { star in
                        Image(star <= (viewModel.selectedItemRating ?? 0) ? "filledStar" : "emptyStar")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.orange)
                            .frame(width: 25, height: 24)
                            .onTapGesture {
                                if viewModel.selectedItemRating == star {
                                    viewModel.selectedItemRating = nil
                                } else {
                                    viewModel.updateRating(for: item.id, rating: star)
                                }
                            }
                            .accessibilityLabel("\(star) étoile\(star > 1 ? "s" : "")")
                            .accessibilityAddTraits(star == viewModel.selectedItemRating ? .isSelected : .isButton)
                    }
                }
            }
        }
        .padding(.top, 16)
    }

    private var commentSection: some View {
        TextField("Partagez ici vos impressions sur cette pièce", text: $userComment)
            .frame(height: isPad ? 69 : 53)
            .padding(.trailing, 12)
            .padding(.leading, 8)
            .padding(.top, 0)
            .padding(.bottom, 18)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .font(.custom("OpenSans-Regular", size: isPad ? 18 : 14))
            .accessibilityLabel("Zone de texte pour vos impressions")
            .accessibilityHint("Tapez pour écrire un commentaire")
            .padding(.vertical)
    }
}


#Preview {
    VStack {
        ItemDetailView(viewModel: CatalogViewModel(dataService: DataService(), apiService: APIService()), item: .sample)
    }
}
