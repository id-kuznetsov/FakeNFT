//
//  NftUI.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import Foundation

struct NftUI: Decodable {
    let createdAt: Date
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let formattedPrice: String
    let author: URL
    let id: String
}
