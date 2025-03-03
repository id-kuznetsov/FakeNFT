//
//  CollectionUI.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 17.02.2025.
//

import Foundation

struct CollectionUI: Hashable {
    let createdAt: Date
    let name: String
    let cover: URL?
    let nfts: [String]
    let description: String
    let author: String
    let id: String
    let isPlaceholder: Bool
}

extension CollectionUI {
    static var placeholder: CollectionUI {
        return CollectionUI(
            createdAt: Date(),
            name: "Загрузка...",
            cover: nil,
            nfts: [],
            description: "Загрузка...",
            author: "Загрузка...",
            id: UUID().uuidString,
            isPlaceholder: true
        )
    }
}
