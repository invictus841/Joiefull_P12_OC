//
//  Joiefull_P12_OCApp.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 08/05/2025.
//

import SwiftUI

@main
struct Joiefull_P12_OCApp: App {
    let dataService: DataServiceProtocol = DataService()
    let apiService: APIServiceProtocol = APIService()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: CatalogViewModel(
                    dataService: dataService,
                    apiService: apiService
                )
            )
        }
    }
}
