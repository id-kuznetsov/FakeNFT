//
//  OrderUpdateDTO.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 06.03.2025.
//

import Foundation

struct OrderUpdateDTO: Dto {
    let nfts: [String]

    func asDictionary() -> [String: String] {
        ["nfts": nfts.joined(separator: ",")]
    }
}
