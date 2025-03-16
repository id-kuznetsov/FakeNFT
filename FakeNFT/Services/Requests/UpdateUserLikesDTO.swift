//
//  UpdateUserLikesDTO.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 06.03.2025.
//

import Foundation

struct UpdateUserLikesDTO: Dto {
    let likes: [String]

    func asDictionary() -> [String: String] {
        [
            "likes": likes.joined(separator: ",")
        ]
    }
}
