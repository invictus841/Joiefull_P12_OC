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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                imageSection
                    .padding(.bottom, 16)
                headerSection
                priceSection
                descriptionSection
                ratingSection
                
                if viewModel.userCommentSaved {
                    Text("Les avis des clients:")
                        .textStyle(.itemName(isPad: isPad, isDetail: true))
                        .padding(.top)

                    Text(viewModel.userComment)
                        .textStyle(.description(isPad: isPad))
                        .transition(.opacity)
                } else {
                    commentSection
                        .transition(.opacity)
                    submitCommentButton
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: imageSize.width)
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onAppear {
            viewModel.loadRatings(for: item.id)
            viewModel.loadComment(for: item.id)
        }
        .navigationBarBackButtonHidden()
        .sheet(item: $viewModel.shareSheetData) { data in
            ActivityView(activityItems: [data.message, data.item.picture.url])
        }

    }
}

// MARK: - Views
private extension ItemDetailView {
    var imageSection: some View {
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
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(.primary)
                            .frame(width: 16, height: 16)
                    }
                    .accessibilityLabel("Retour à la liste")
                }

                Spacer()

                Button(action: {
                    viewModel.requestShare(for: item)
                }) {
                    Image("shareIcon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.primary)
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
    
     var headerSection: some View {
         let formattedAverage = String(format: "%.1f", viewModel.selectedItemAverage)
         
        return HStack(alignment: .top) {
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
            .accessibilityLabel("Note moyenne \(formattedAverage) étoiles")
        }
    }

    var priceSection: some View {
        let formattedPrice = String(format: "%.2f €", item.price)
        let formattedOriginal = String(format: "%.2f €", item.originalPrice)

        return HStack {
            Text(formattedPrice)
                .textStyle(.itemPrice(isPad: isPad, isDetail: true))

            Spacer()

            if item.isDiscounted {
                Text(formattedOriginal)
                    .textStyle(.itemPrice(isPad: isPad, isDetail: true))
                    .strikethrough()
                    .opacity(0.3)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(item.isDiscounted
            ? "Prix actuel \(formattedPrice), au lieu de \(formattedOriginal)"
            : "Prix \(formattedPrice)"
        )
    }



     var descriptionSection: some View {
        Text(item.picture.description)
            .textStyle(.description(isPad: isPad))
            .padding(.top, 8)
    }

     var ratingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 14) {
                Image("userPic")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 39, height: 39)
                    .clipShape(Circle())

                HStack(spacing: 14) {
                    ForEach(1...5, id: \.self) { star in
                        let starLabel = star == 1 ? "1 étoile" : "\(star) étoiles"
                        
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
                        
                        .accessibilityLabel(starLabel)
                            .accessibilityAddTraits(star == viewModel.selectedItemRating ? .isSelected : .isButton)
                    }
                }
            }
        }
        .padding(.top, 16)
    }

     var commentSection: some View {
        TextField("Partagez ici vos impressions sur cette pièce", text: $viewModel.userComment)
            .frame(height: isPad ? 69 : 53)
            .padding(.horizontal, 8)
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
    
     var submitCommentButton: some View {
        let isDisabled = viewModel.userComment.trimmingCharacters(in: .whitespacesAndNewlines).count < 2

        return Button(action: {
            viewModel.saveComment(for: item.id)
        }) {
            Text("Laisser un avis")
                .textStyle(.itemName(isPad: isPad, isDetail: true))
                .frame(maxWidth: .infinity)
                .padding()
                .background(isDisabled ? Color.gray.opacity(0.3) : Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .disabled(isDisabled)
        .accessibilityLabel("Laisser un avis pour cet article")
        .accessibilityHint("Appuyez pour enregistrer votre commentaire")
    }
}

// MARK: - Helpers
private extension ItemDetailView {
    private var isFavorited: Bool {
        viewModel.isFavorite(item.id)
    }

    var isPad: Bool {
        sizeClass == .regular
    }
    
    var imageSize: CGSize {
        isPad ? CGSize(width: 451, height: 408) : CGSize(width: 328, height: 431)
    }
}

#Preview {
    VStack {
        ItemDetailView(viewModel: CatalogViewModel(dataService: DataService(), apiService: APIService()), item: .sample)
    }
}
