//
//  ContentView.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 08/05/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CatalogViewModel()

        var body: some View {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.error {
                    Text("Error: \(error)")
                } else {
                    List(viewModel.items) { item in
                        Text(item.name)
                    }
                }
            }
            .task {
                await viewModel.loadItems()
            }
        }
}

#Preview {
    ContentView()
}
