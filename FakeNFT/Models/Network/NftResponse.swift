//
//  NftResponse.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 06.03.2025.
//

import Foundation

struct NftResponse: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}

extension NftResponse {
    func toUIModel() -> NftUI? {
        return NftUI(
            name: self.name,
            images: self.images.map { URL(string: $0) },
            rating: self.rating,
            description: self.description,
            formattedPrice: String(self.price),
            author: URL(string: self.author),
            id: self.id,
            isPlaceholder: false
        )
    }
}
