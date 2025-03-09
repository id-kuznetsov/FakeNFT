//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 07.03.2025.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var profile: Profile?

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod = .put

    var dto: Dto? {
        guard
            let profile,
            let profileDTO = profile.toResponse()
        else {
            return nil
        }

        return UpdateProfileDto(profile: profileDTO)
    }
}

struct UpdateProfileDto: Dto {
    let profile: ProfileDTO

    enum CodingKeys: String, CodingKey {
        case likes
        case avatar
        case name
    }

    func asDictionary() -> [String: String] {
        [
            CodingKeys.likes.rawValue: profile.likes.joined(separator: ","),
            CodingKeys.avatar.rawValue: profile.avatar,
            CodingKeys.name.rawValue: profile.name
        ]
    }
}
