//
//  NftUI.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import Foundation

struct NftUI: Codable, Hashable {
    let name: String
    let images: [URL?]
    let rating: Int
    let description: String
    let formattedPrice: String
    let author: URL?
    let id: String
    var isLiked: Bool
    var isInCart: Bool
    let isPlaceholder: Bool
}

extension NftUI {
    static var placeholder: NftUI {
        return NftUI(
            name: "",
            images: [],
            rating: 0,
            description: "",
            formattedPrice: "",
            author: URL(string: ""),
            id: UUID().uuidString,
            isLiked: false,
            isInCart: false,
            isPlaceholder: true
        )
    }
}
