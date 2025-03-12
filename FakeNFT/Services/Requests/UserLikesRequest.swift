//
//  UserLikesRequest.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 05.03.2025.
//

import Foundation

struct UserLikesRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/\(RequestConstants.profile)")
    }
    
    var httpMethod: HttpMethod { .get }
    
    var dto: Dto? { nil }
}
