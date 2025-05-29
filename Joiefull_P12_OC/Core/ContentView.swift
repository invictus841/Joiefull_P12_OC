//
//  ContentView.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 08/05/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject var viewModel: CatalogViewModel
    @State private var selectedItem: ClothingItem?
    @State private var showSplash = true

    var isPad: Bool { sizeClass == .regular }

    var body: some View {
        ZStack {
            if isPad {
                iPadLayout
            } else {
                NavigationStack {
                    CatalogView(viewModel: viewModel, selectedItem: $selectedItem)
                }
            }

            if showSplash {
                splashScreen
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear {
            Task { await viewModel.loadItems() }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }

    private var iPadLayout: some View {
        GeometryReader { geo in
            let width = geo.size.width

            HStack(spacing: 0) {
                CatalogView(viewModel: viewModel, selectedItem: $selectedItem)
                    .frame(width: width * 0.6)

                Divider()

                VStack {
                    if let item = selectedItem {
                        ItemDetailView(viewModel: viewModel, item: item)
                            .frame(width: 451)
                            .id(item.id)
                    } else {
                        Spacer()
                        Image(systemName: "arrow.left")
                            .font(.system(size: 36))
                            .foregroundColor(.secondary)
                        Text("Sélectionnez un article")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                .frame(width: width * 0.4)
                .background(Color(.systemBackground))
            }
        }
    }

    private var splashScreen: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image("appName")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220)
                    .accessibilityHidden(true)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .accessibilityHidden(true)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Joiefull démarre")
            .accessibilityHint("Chargement de l’application")
        }
    }
}




#Preview {
    ContentView(viewModel: CatalogViewModel(dataService: DataService(), apiService: APIService()))
}
