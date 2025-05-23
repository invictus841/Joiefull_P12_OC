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

    var isPad: Bool { sizeClass == .regular }

    var body: some View {
        if isPad {
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
        } else {
            NavigationStack {
                CatalogView(viewModel: viewModel, selectedItem: .constant(nil))
            }
        }
    }
}



#Preview {
    ContentView(viewModel: CatalogViewModel(dataService: DataService(), apiService: APIService()))
}
