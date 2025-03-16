//
//  CurrenciesRequest.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 21.02.2025.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }

    var dto: (any Dto)?
}
