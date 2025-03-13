//
//  CollectionDTO.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 28.02.2025.
//

import Foundation

struct CollectionDTO: Decodable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}

extension CollectionDTO {
    func toDomainModel() -> Collection? {
        guard
            let coverImageUrl = URL(string: self.cover),
            /// API Bug. Add stub
            let authorUrl = URL(string: "https://nikolaidev.ru")
        else {
            return nil
        }

        return Collection(
            name: self.name,
            coverImageUrl: coverImageUrl,
            nfts: self.nfts,
            description: self.description,
            author: self.author,
            authorUrl: authorUrl,
            id: self.id,
            isPlaceholder: false
        )
    }
}
