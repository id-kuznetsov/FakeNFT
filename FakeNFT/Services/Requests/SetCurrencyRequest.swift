//
//  SetCurrencyRequest.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 01.03.2025.
//

import Foundation

struct SetCurrencyRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(id)")
    }
    
    var dto: (any Dto)?
}

