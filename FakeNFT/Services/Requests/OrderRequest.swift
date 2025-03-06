//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 06.03.2025.
//

import Foundation

struct OrderRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/\(RequestConstants.order)")
    }
    
    var httpMethod: HttpMethod { .get }
    
    var dto: Dto? { nil }
}
