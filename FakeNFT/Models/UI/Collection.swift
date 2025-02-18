//
//  Collection.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 17.02.2025.
//

import Foundation

struct Collection: Decodable {
    let name: String
    let cover: URL
    let nfts: [String]
    let id: String
}
