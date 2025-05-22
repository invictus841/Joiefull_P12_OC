//
//  SharingService.swift
//  Joiefull_P12_OC
//
//  Created by Alexandre Talatinian on 22/05/2025.
//


import UIKit
import SwiftUI

struct SharingService {
    static func share(item: ClothingItem, userComment: String) {
        let message = userComment.isEmpty
            ? "\(item.name) – \(String(format: "%.2f €", item.price))\nDécouvrez cette pièce sur l’app Joiefull!"
            : "\(userComment)\n\n\(item.name) – \(String(format: "%.2f €", item.price))\nDécouvrez cette pièce sur l’app Joiefull!"

        let url = item.picture.url
        let activityVC = UIActivityViewController(activityItems: [message, url], applicationActivities: nil)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = rootVC.view
                popover.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: 100, width: 0, height: 0)
                popover.permittedArrowDirections = .up
            }
            rootVC.present(activityVC, animated: true)
        }
    }
}
