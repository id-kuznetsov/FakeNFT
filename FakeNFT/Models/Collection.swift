//
//  Collection.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 17.02.2025.
//

import Foundation

struct Collection: Codable, Hashable {
    let name: String
    let coverImageUrl: URL
    let nfts: [String]
    let description: String
    let author: String
    let id: String
    let isPlaceholder: Bool
}

extension Collection {
    static var placeholder: Collection? {
        guard let coverImageUrl = URL(string: "https://example.com") else { return nil }

        return Collection(
            name: "",
            coverImageUrl: coverImageUrl,
            nfts: [],
            description: "",
            author: "",
            id: UUID().uuidString,
            isPlaceholder: true
        )
    }
}
