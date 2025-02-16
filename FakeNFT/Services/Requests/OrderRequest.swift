//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 16.02.2025.
//

import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var dto: (any Dto)?
}
