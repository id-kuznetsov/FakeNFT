//
//  UserRequest.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 17.02.2025.
//

import Foundation

struct UsersRequest: NetworkRequest {
    let page: Int
    let size: Int
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users?page=\(page)&size=\(size)")
    }
    
    var dto: Dto? { nil }
}
