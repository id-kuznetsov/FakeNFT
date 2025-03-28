//
//  UserDetailRequest.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 24.02.2025.
//

import Foundation

struct UserDetailRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/\(RequestConstants.users)/\(id)")
    }

    var dto: Dto? { nil }
}
