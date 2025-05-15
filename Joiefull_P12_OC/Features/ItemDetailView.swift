//
//  ItemDetailView.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 09/05/2025.
//

import SwiftUI

struct ItemDetailView: View {
    @Environment(\.presentationMode) var presentationMode

    let item: ClothingItem
    let isPad: Bool
    
    @State private var userComment: String = ""

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
        .navigationBarBackButtonHidden()
    }
}

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
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                }

                Spacer()

                Button(action: {
                    shareItem()
                }) {
                    Image("shareIcon")
                        .resizable()
                        .frame(width: 16, height: 18)
                }
            }
            .padding()
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FavoriteBubble(count: item.likes, isPad: isPad, isDetail: true)
                }
            }
        }

    }
    
    var headerSection: some View {
        HStack(alignment: .top) {
            HStack(spacing: 8) {
                Text(item.name)
                    .textStyle(.itemName(isPad: isPad, isDetail: true))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image("filledStar")
                        .resizable()
                        .frame(width: 14, height: 14)
                    Text("4.5")
                        .textStyle(.ratingAverage(isPad: isPad, isDetail: true))
                }
            }
            
        }
    }

    var priceSection: some View {
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

    var descriptionSection: some View {
        Text(item.picture.description)
            .textStyle(.description(isPad: isPad))
            .padding(.top, 8)
    }

    var ratingSection: some View {
        HStack(spacing: 14) {
            Image("userPic")
                .resizable()
                .scaledToFill()
                .frame(width: 39, height: 39)
                .clipShape(Circle())

            HStack(spacing: 14) {
                ForEach(0..<5, id: \.self) { _ in
                    Image("emptyStar")
                        .resizable()
                        .frame(width: 25, height: 24)
                }
            }
        }
        .padding(.top, 16)
    }
    
    var commentSection: some View {
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
                .accessibilityLabel(Text("Zone de texte pour vos impressions"))
                .padding(.vertical)
        }
}

// MARK: - helpers
private extension ItemDetailView {
    func shareItem() {
        let text = """
        \(item.name) – \(String(format: "%.2f €", item.price))
        Découvrez cette pièce sur l’app Joiefull!
        """
        let url = item.picture.url
        let activityVC = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)

        // Present the share sheet
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}



#Preview {
    VStack {
// MARK: - iPhone
        ItemDetailView(item: .sample, isPad: false)
    }
}

#Preview {
    VStack {
// MARK: - iPad
        ItemDetailView(item: .sample, isPad: true)
    }
}
