//
//  Collection.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 17.02.2025.
//

import Foundation

struct Collection: Codable, Hashable {
    let name: String
    let cover: URL?
    let nfts: [String]
    let description: String
    let author: String
    let id: String
    let isPlaceholder: Bool
}

extension Collection {
    static var placeholder: Collection {
        return Collection(
            name: "",
            cover: URL(string: ""),
            nfts: [],
            description: "",
            author: "",
            id: UUID().uuidString,
            isPlaceholder: true
        )
    }
}
