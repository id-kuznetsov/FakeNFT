//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 16.02.2025.
//

import Foundation

struct OrderRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/\(RequestConstants.order)")
    }
    
    var dto: (any Dto)? = nil
}
