//
//  ProfileResponse.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 07.03.2025.
//

import Foundation

struct ProfileResponse: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

extension ProfileResponse {
    func toUIModel() -> ProfileUI? {
        return ProfileUI(
            name: self.name,
            avatar: URL(string: self.avatar),
            description: self.description,
            website: URL(string: self.website),
            nfts: self.nfts,
            likes: self.likes,
            id: self.id
        )
    }
}
