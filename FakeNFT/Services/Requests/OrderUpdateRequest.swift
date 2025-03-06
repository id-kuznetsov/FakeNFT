//
//  OrderUpdateRequest.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 06.03.2025.
//

import Foundation

struct OrderUpdateRequest: NetworkRequest {
    let orderItemIDs: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/\(RequestConstants.order)")
    }

    var httpMethod: HttpMethod { .put }

    var dto: Dto? {
        return OrderUpdateDTO(nfts: orderItemIDs)
    }
}
