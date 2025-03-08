//
//  ProfileDTO.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 07.03.2025.
//

import Foundation

struct ProfileDTO: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

extension ProfileDTO {
    func toUIModel() -> Profile? {
        guard
            let avatar = URL(string: self.avatar),
            let website = URL(string: self.website)
        else {
            return nil
        }

        return Profile(
            name: self.name,
            avatar: avatar,
            description: self.description,
            website: website,
            nfts: self.nfts,
            likes: self.likes,
            id: self.id
        )
    }
}
