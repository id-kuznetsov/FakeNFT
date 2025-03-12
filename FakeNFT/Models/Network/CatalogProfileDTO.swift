//
//  ProfileDTO.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 07.03.2025.
//

import Foundation

struct CatalogProfileDTO: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

extension CatalogProfileDTO {
    func toDomainModel() -> CatalogProfile? {
        guard
            let avatar = URL(string: self.avatar),
            let website = URL(string: self.website)
        else {
            return nil
        }

        return CatalogProfile(
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
