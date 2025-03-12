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
    let authorUrl: URL
    let id: String
    let isPlaceholder: Bool
}

extension Collection {
    static var placeholder: Collection? {
        guard
            let coverImageUrl = URL(string: "https://example.com"),
            let authorUrl = URL(string: "https://nikolaidev.ru")
        else {
            return nil
        }

        return Collection(
            name: "",
            coverImageUrl: coverImageUrl,
            nfts: [],
            description: "",
            author: "",
            authorUrl: authorUrl,
            id: UUID().uuidString,
            isPlaceholder: true
        )
    }
}
