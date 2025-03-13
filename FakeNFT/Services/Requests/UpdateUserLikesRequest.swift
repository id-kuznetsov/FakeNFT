//
//  UpdateUserLikesRequest.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 05.03.2025.
//

import Foundation

struct UpdateUserLikesRequest: NetworkRequest {
    let likes: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/\(RequestConstants.profile)")
    }

    var httpMethod: HttpMethod { .put }

    var dto: Dto? {
        return UpdateUserLikesDTO(likes: likes)
    }
}
