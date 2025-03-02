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
}
