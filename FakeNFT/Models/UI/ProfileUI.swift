//
//  ProfileUI.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 07.03.2025.
//

import Foundation

struct ProfileUI: Codable, Hashable {
    let name: String
    let avatar: URL?
    let description: String
    let website: URL?
    let nfts: [String]
    let likes: [String]
    let id: String
}

extension ProfileUI {
    static var placeholder: ProfileUI {
        return ProfileUI(
            name: "",
            avatar: nil,
            description: "",
            website: nil,
            nfts: [],
            likes: [],
            id: UUID().uuidString
        )
    }
}
