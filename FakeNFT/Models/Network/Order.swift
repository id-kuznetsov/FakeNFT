//
//  Order.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 16.02.2025.
//

import Foundation

struct Order: Decodable {
    let nfts: [String]
    let id: String
}
