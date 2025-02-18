//
//  UserStatistics.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 17.02.2025.
//

import UIKit

struct User: Decodable {
    let id: String
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    let rating: String
}
