//
//  NftDTO.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 06.03.2025.
//

import Foundation

struct NftDTO: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}

extension NftDTO {
    func toDomainModel() -> Nft? {
        guard let authorURL = URL(string: self.author) else { return nil }

        let imageUrls = self.images.compactMap { URL(string: $0) }
        guard imageUrls.count == self.images.count else { return nil }

        return Nft(
            name: self.name,
            images: self.images.compactMap { URL(string: $0) },
            rating: self.rating,
            description: self.description,
            price: self.price,
            authorUrl: authorURL,
            id: self.id,
            isLiked: false,
            isInCart: false,
            isPlaceholder: false
        )
    }
}
